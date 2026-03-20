import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongtory_diary/application/providers/app_providers.dart';
import 'package:mongtory_diary/domain/models/diary_summary.dart';
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
          const SectionCard(
            title: '빠른 작성',
            description: '오늘 감정과 짧은 기록을 바로 남기는 영역',
          ),
          const SizedBox(height: 16),
          diaryList.when(
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
          const SizedBox(height: 16),
          const SectionCard(
            title: '사진 첨부',
            description: '사진 메타데이터와 업로드 흐름이 들어갈 영역',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit_note),
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
        ],
      ),
    );
  }
}

String _formatDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}
