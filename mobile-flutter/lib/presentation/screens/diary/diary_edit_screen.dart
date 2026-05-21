import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mongtory_diary/application/providers/app_providers.dart';
import 'package:mongtory_diary/domain/models/diary_detail.dart';
import 'package:mongtory_diary/domain/models/diary_upsert.dart';
import 'package:mongtory_diary/domain/models/emotion_type.dart';

class DiaryEditScreen extends ConsumerStatefulWidget {
  const DiaryEditScreen({super.key, this.initial, this.initialDate});

  final DiaryDetail? initial;
  final DateTime? initialDate;

  @override
  ConsumerState<DiaryEditScreen> createState() => _DiaryEditScreenState();
}

class _DiaryEditScreenState extends ConsumerState<DiaryEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _entryDateController;
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _emotionCodeController;
  late final TextEditingController _tagController;
  late final TextEditingController _locationNameController;
  late final TextEditingController _weatherSummaryController;
  late final TextEditingController _pendingImageUrlController;
  late final String _initialEntryDate;
  late final String _initialTitle;
  late final String _initialContent;
  late final String _initialEmotionCode;
  late final String _initialTagsText;
  late final String _initialLocationName;
  late final String _initialWeatherSummary;
  late final List<String> _initialImageUrls;
  late final List<String> _imageUrls;
  bool _isSaving = false;
  bool _isUploadingImages = false;
  String? _errorMessage;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    final entryDate = _formatDate(
      initial?.entryDate ?? widget.initialDate ?? DateTime.now(),
    );
    _initialEntryDate = entryDate;
    _initialTitle = initial?.title ?? '';
    _initialContent = initial?.content ?? '';
    _initialEmotionCode = (initial?.emotionCode ?? 'CALM').toUpperCase();
    _initialTagsText = (initial?.tags ?? []).join(', ');
    _initialLocationName = initial?.locationName ?? '';
    _initialWeatherSummary = initial?.weatherSummary ?? '';
    _initialImageUrls = List.unmodifiable(initial?.imageUrls ?? []);
    _imageUrls = [..._initialImageUrls];
    _entryDateController = TextEditingController(text: entryDate);
    _titleController = TextEditingController(text: _initialTitle);
    _contentController = TextEditingController(text: _initialContent);
    _emotionCodeController = TextEditingController(text: _initialEmotionCode);
    _tagController = TextEditingController(text: _initialTagsText);
    _locationNameController = TextEditingController(text: _initialLocationName);
    _weatherSummaryController = TextEditingController(
      text: _initialWeatherSummary,
    );
    _pendingImageUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _entryDateController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _emotionCodeController.dispose();
    _tagController.dispose();
    _locationNameController.dispose();
    _weatherSummaryController.dispose();
    _pendingImageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEditing ? '일기 수정' : '일기 작성';
    final emotions = ref.watch(emotionListProvider);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: _requestClose),
        title: Text(title),
      ),
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
                        suffixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      readOnly: true,
                      onTap: _pickEntryDate,
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
                    _EmotionSelector(
                      emotions: emotions,
                      controller: _emotionCodeController,
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _tagController,
                      decoration: const InputDecoration(
                        labelText: '태그',
                        hintText: '산책, 회고',
                        prefixIcon: Icon(Icons.tag_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationNameController,
                      decoration: const InputDecoration(
                        labelText: '장소',
                        hintText: '동네 공원',
                        prefixIcon: Icon(Icons.place_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _weatherSummaryController,
                      decoration: const InputDecoration(
                        labelText: '날씨',
                        hintText: '맑음',
                        prefixIcon: Icon(Icons.wb_sunny_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    _ImageAttachmentEditor(
                      controller: _pendingImageUrlController,
                      imageUrls: _imageUrls,
                      isUploading: _isUploadingImages,
                      onPickImages: _pickAndUploadImages,
                      onAdd: _addImageUrls,
                      onRemove: _removeImageUrl,
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      _ErrorMessage(message: _errorMessage!),
                    ],
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _isSaving || _isUploadingImages
                          ? null
                          : _submit,
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

  Future<void> _pickAndUploadImages() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    setState(() {
      _isUploadingImages = true;
      _errorMessage = null;
    });

    try {
      final repository = ref.read(diaryRepositoryProvider);
      final uploadedUrls = <String>[];
      for (final file in result.files) {
        final bytes = file.bytes;
        if (bytes == null) {
          throw StateError('선택한 사진 데이터를 읽지 못했습니다.');
        }

        final url = await repository.uploadDiaryImage(
          fileName: file.name,
          bytes: bytes,
        );
        uploadedUrls.add(url);
      }

      if (!mounted) {
        return;
      }

      setState(() {
        for (final url in uploadedUrls) {
          if (!_imageUrls.contains(url)) {
            _imageUrls.add(url);
          }
        }
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = error.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImages = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    _addImageUrls(rebuild: false);

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
        imageUrls: _imageUrls,
        locationName: _optionalText(_locationNameController.text),
        weatherSummary: _optionalText(_weatherSummaryController.text),
        tags: _parseTags(_tagController.text),
      );
      final initial = widget.initial;

      if (initial == null) {
        await repository.createDiary(input);
      } else {
        await repository.updateDiary(initial.id, input);
        ref.invalidate(diaryDetailProvider(initial.id));
      }

      ref.invalidate(diaryListProvider);
      ref.invalidate(diaryHomeListProvider);
      ref.invalidate(diaryTodayMemoriesProvider);

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

  Future<void> _pickEntryDate() async {
    final current = DateTime.tryParse(_entryDateController.text.trim());
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _entryDateController.text = _formatDate(picked);
    });
  }

  Future<void> _requestClose() async {
    if (!_hasUnsavedChanges) {
      Navigator.of(context).maybePop();
      return;
    }

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('변경사항을 버릴까요?'),
        content: const Text('저장하지 않은 내용은 사라집니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('계속 작성'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('버리기'),
          ),
        ],
      ),
    );

    if (shouldDiscard == true && mounted) {
      Navigator.of(context).maybePop();
    }
  }

  void _addImageUrls({bool rebuild = true}) {
    final values = _parseImageUrls(_pendingImageUrlController.text);
    if (values.isEmpty) {
      return;
    }

    void addValues() {
      for (final value in values) {
        if (!_imageUrls.contains(value)) {
          _imageUrls.add(value);
        }
      }
      _pendingImageUrlController.clear();
    }

    if (rebuild) {
      setState(addValues);
      return;
    }

    addValues();
  }

  void _removeImageUrl(String value) {
    setState(() {
      _imageUrls.remove(value);
    });
  }

  bool get _hasUnsavedChanges {
    return _entryDateController.text.trim() != _initialEntryDate ||
        _titleController.text != _initialTitle ||
        _contentController.text != _initialContent ||
        _emotionCodeController.text.trim().toUpperCase() !=
            _initialEmotionCode ||
        _tagController.text.trim() != _initialTagsText ||
        _locationNameController.text.trim() != _initialLocationName ||
        _weatherSummaryController.text.trim() != _initialWeatherSummary ||
        _pendingImageUrlController.text.trim().isNotEmpty ||
        !_listEquals(_imageUrls, _initialImageUrls);
  }
}

class _ImageAttachmentEditor extends StatelessWidget {
  const _ImageAttachmentEditor({
    required this.controller,
    required this.imageUrls,
    required this.isUploading,
    required this.onPickImages,
    required this.onAdd,
    required this.onRemove,
  });

  final TextEditingController controller;
  final List<String> imageUrls;
  final bool isUploading;
  final VoidCallback onPickImages;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: isUploading ? null : onPickImages,
          icon: isUploading
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add_photo_alternate_outlined),
          label: Text(isUploading ? '사진 업로드 중' : '사진 선택'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: '사진 URL 추가',
            hintText: 'https://example.com/photo.jpg',
            suffixIcon: IconButton(
              tooltip: '사진 URL 추가',
              onPressed: onAdd,
              icon: const Icon(Icons.add_link_outlined),
            ),
          ),
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => onAdd(),
        ),
        const SizedBox(height: 8),
        if (imageUrls.isEmpty)
          Text('첨부된 사진이 없습니다.', style: Theme.of(context).textTheme.bodySmall)
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in imageUrls)
                InputChip(label: Text(item), onDeleted: () => onRemove(item)),
            ],
          ),
      ],
    );
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

class _EmotionSelector extends StatelessWidget {
  const _EmotionSelector({
    required this.emotions,
    required this.controller,
    required this.onChanged,
  });

  final AsyncValue<List<EmotionType>> emotions;
  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return emotions.when(
      data: (items) {
        if (items.isEmpty) {
          return _EmotionCodeField(controller: controller);
        }

        final currentCode = controller.text.trim().toUpperCase();
        final containsCurrent = items.any((item) => item.code == currentCode);
        final options = containsCurrent || currentCode.isEmpty
            ? items
            : [
                EmotionType(
                  code: currentCode,
                  label: currentCode,
                  iconKey: 'custom',
                ),
                ...items,
              ];

        return DropdownButtonFormField<String>(
          initialValue: currentCode.isEmpty ? null : currentCode,
          decoration: const InputDecoration(labelText: '감정'),
          items: options
              .map(
                (item) => DropdownMenuItem(
                  value: item.code,
                  child: Text('${item.label} (${item.code})'),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) {
              return;
            }

            controller.text = value;
            onChanged();
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '감정을 선택해주세요.';
            }

            return null;
          },
        );
      },
      loading: () => DropdownButtonFormField<String>(
        initialValue: controller.text.trim().isEmpty
            ? null
            : controller.text.trim().toUpperCase(),
        decoration: const InputDecoration(labelText: '감정'),
        items: [
          if (controller.text.trim().isNotEmpty)
            DropdownMenuItem(
              value: controller.text.trim().toUpperCase(),
              child: Text(controller.text.trim().toUpperCase()),
            ),
        ],
        onChanged: null,
      ),
      error: (error, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _EmotionCodeField(controller: controller),
          const SizedBox(height: 8),
          Text(
            '감정 목록을 불러오지 못해 코드 입력으로 저장합니다.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmotionCodeField extends StatelessWidget {
  const _EmotionCodeField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: '감정 코드', hintText: 'CALM'),
      textCapitalization: TextCapitalization.characters,
      validator: _required('감정 코드를 입력해주세요.'),
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

List<String> _parseTags(String value) {
  final tags = <String>[];
  for (final item in value.split(',')) {
    final tag = item.trim().replaceFirst(RegExp('^#+'), '').trim();
    if (tag.isEmpty || tags.contains(tag)) {
      continue;
    }

    tags.add(tag);
  }
  return tags;
}

String? _optionalText(String value) {
  final normalizedValue = value.trim();
  return normalizedValue.isEmpty ? null : normalizedValue;
}

String _formatDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

bool _listEquals(List<String> first, List<String> second) {
  if (first.length != second.length) {
    return false;
  }

  for (var index = 0; index < first.length; index += 1) {
    if (first[index] != second[index]) {
      return false;
    }
  }

  return true;
}
