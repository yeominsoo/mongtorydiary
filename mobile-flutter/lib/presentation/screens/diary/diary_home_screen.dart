import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongtory_diary/application/providers/app_providers.dart';
import 'package:mongtory_diary/domain/models/diary_summary.dart';
import 'package:mongtory_diary/presentation/screens/diary/diary_detail_screen.dart';
import 'package:mongtory_diary/presentation/screens/diary/diary_edit_screen.dart';
import 'package:mongtory_diary/presentation/widgets/section_card.dart';

class DiaryHomeScreen extends ConsumerWidget {
  const DiaryHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diaryList = ref.watch(diaryListProvider);
    final dataSourceModeLabel = ref.watch(dataSourceModeLabelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('오늘의 일기')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const _ContentWidth(
            child: SectionCard(
              title: '빠른 작성',
              description: '오늘 감정과 기록을 바로 남깁니다.',
              child: _WritePreparationNotice(),
            ),
          ),
          const SizedBox(height: 16),
          _ContentWidth(
            child: diaryList.when(
              data: (items) => SectionCard(
                title: '최근 일기',
                description:
                    '$dataSourceModeLabel 데이터 소스 기준 ${items.length}건이 로드된 상태입니다.',
                child: items.isEmpty
                    ? const Text('표시할 일기가 아직 없습니다.')
                    : Column(
                        children: items
                            .take(3)
                            .map((item) => _DiarySummaryTile(item: item))
                            .toList(),
                      ),
              ),
              loading: () => const SectionCard(
                title: '최근 일기',
                description: '일기 목록을 불러오는 중입니다.',
              ),
              error: (error, _) => SectionCard(
                title: '최근 일기',
                description: '일기 목록을 불러오지 못했습니다. $error',
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _ContentWidth(
            child: SectionCard(
              title: '사진 첨부',
              description: '사진 업로드와 메타데이터 표시는 작성 플로우와 함께 연결됩니다.',
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '일기 작성',
        onPressed: () async {
          final didSave = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (context) => const DiaryEditScreen()),
          );

          if (didSave == true) {
            ref.invalidate(diaryListProvider);
          }
        },
        child: const Icon(Icons.edit_note),
      ),
    );
  }
}

class _ContentWidth extends StatelessWidget {
  const _ContentWidth({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: child,
      ),
    );
  }
}

class _WritePreparationNotice extends StatelessWidget {
  const _WritePreparationNotice();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_clock_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '작성한 일기는 저장 후 최근 일기 목록에 반영됩니다.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiarySummaryTile extends StatelessWidget {
  const _DiarySummaryTile({required this.item});

  final DiarySummary item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => DiaryDetailScreen(diaryId: item.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  child: Text(item.emotionCode.substring(0, 1)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatDate(item.entryDate)} · ${item.emotionCode}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}
