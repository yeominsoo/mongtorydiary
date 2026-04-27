import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongtory_diary/application/providers/app_providers.dart';
import 'package:mongtory_diary/domain/models/diary_detail.dart';
import 'package:mongtory_diary/domain/models/diary_upsert.dart';

class DiaryEditScreen extends ConsumerStatefulWidget {
  const DiaryEditScreen({super.key, this.initial});

  final DiaryDetail? initial;

  @override
  ConsumerState<DiaryEditScreen> createState() => _DiaryEditScreenState();
}

class _DiaryEditScreenState extends ConsumerState<DiaryEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _entryDateController;
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _emotionCodeController;
  late final TextEditingController _imageUrlsController;
  bool _isSaving = false;
  String? _errorMessage;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _entryDateController = TextEditingController(
      text: _formatDate(initial?.entryDate ?? DateTime.now()),
    );
    _titleController = TextEditingController(text: initial?.title ?? '');
    _contentController = TextEditingController(text: initial?.content ?? '');
    _emotionCodeController = TextEditingController(
      text: initial?.emotionCode ?? 'CALM',
    );
    _imageUrlsController = TextEditingController(
      text: initial?.imageUrls.join(', ') ?? '',
    );
  }

  @override
  void dispose() {
    _entryDateController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _emotionCodeController.dispose();
    _imageUrlsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEditing ? '일기 수정' : '일기 작성';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _entryDateController,
                      decoration: const InputDecoration(
                        labelText: '날짜',
                        hintText: 'YYYY-MM-DD',
                      ),
                      keyboardType: TextInputType.datetime,
                      validator: _validateDate,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: '제목'),
                      textInputAction: TextInputAction.next,
                      validator: _required('제목을 입력해주세요.'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(labelText: '본문'),
                      minLines: 6,
                      maxLines: 10,
                      validator: _required('본문을 입력해주세요.'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emotionCodeController,
                      decoration: const InputDecoration(
                        labelText: '감정 코드',
                        hintText: 'CALM',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: _required('감정 코드를 입력해주세요.'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _imageUrlsController,
                      decoration: const InputDecoration(
                        labelText: '사진 URL',
                        hintText: '여러 개는 쉼표로 구분',
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      _ErrorMessage(message: _errorMessage!),
                    ],
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _isSaving ? null : _submit,
                      icon: _isSaving
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(_isSaving ? '저장 중' : '저장'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final repository = ref.read(diaryRepositoryProvider);
      final input = DiaryUpsert(
        entryDate: DateTime.parse(_entryDateController.text.trim()),
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        emotionCode: _emotionCodeController.text.trim().toUpperCase(),
        imageUrls: _parseImageUrls(_imageUrlsController.text),
      );
      final initial = widget.initial;

      if (initial == null) {
        await repository.createDiary(input);
      } else {
        await repository.updateDiary(initial.id, input);
        ref.invalidate(diaryDetailProvider(initial.id));
      }

      ref.invalidate(diaryListProvider);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
    );
  }
}

String? Function(String?) _required(String message) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }

    return null;
  };
}

String? _validateDate(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) {
    return '날짜를 입력해주세요.';
  }

  final parsed = DateTime.tryParse(text);
  if (parsed == null || _formatDate(parsed) != text) {
    return 'YYYY-MM-DD 형식으로 입력해주세요.';
  }

  return null;
}

List<String> _parseImageUrls(String value) {
  return value
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();
}

String _formatDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}
