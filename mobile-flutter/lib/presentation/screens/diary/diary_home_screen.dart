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
          _ContentWidth(
            child: _DailyPromptCard(
              onStartWriting: () => _openCreateDiary(context, ref),
            ),
          ),
          const SizedBox(height: 16),
          _ContentWidth(
            child: diaryList.when(
              data: (items) => _DiaryInsightSection(
                items: items,
                dataSourceModeLabel: dataSourceModeLabel,
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '일기 작성',
        onPressed: () => _openCreateDiary(context, ref),
        child: const Icon(Icons.edit_note),
      ),
    );
  }

  Future<void> _openCreateDiary(BuildContext context, WidgetRef ref) async {
    final didSave = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (context) => const DiaryEditScreen()),
    );

    if (didSave == true) {
      ref.invalidate(diaryListProvider);
    }
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

class _DailyPromptCard extends StatelessWidget {
  const _DailyPromptCard({required this.onStartWriting});

  final VoidCallback onStartWriting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prompt = _promptForToday(DateTime.now());

    return SectionCard(
      title: '오늘의 회고',
      description: _formatKoreanDate(DateTime.now()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.auto_stories_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    prompt,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _PromptChip(icon: Icons.mood_outlined, label: '감정'),
              _PromptChip(icon: Icons.photo_camera_outlined, label: '사진'),
              _PromptChip(icon: Icons.place_outlined, label: '장소'),
              _PromptChip(icon: Icons.lock_outline, label: '비공개'),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: onStartWriting,
              icon: const Icon(Icons.edit_note),
              label: const Text('작성 시작'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromptChip extends StatelessWidget {
  const _PromptChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _DiaryInsightSection extends StatelessWidget {
  const _DiaryInsightSection({
    required this.items,
    required this.dataSourceModeLabel,
  });

  final List<DiarySummary> items;
  final String dataSourceModeLabel;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final thisMonthCount = items.where((item) {
      return item.entryDate.year == today.year &&
          item.entryDate.month == today.month;
    }).length;
    final emotionCount = items.map((item) => item.emotionCode).toSet().length;
    final latestDate = items.isEmpty ? null : items.first.entryDate;
    final memoryItems = items.where((item) {
      return item.entryDate.month == today.month &&
          item.entryDate.day == today.day &&
          item.entryDate.year != today.year;
    }).toList();

    return Column(
      children: [
        SectionCard(
          title: '기록 흐름',
          description:
              '$dataSourceModeLabel 데이터 소스 기준 ${items.length}건이 로드된 상태입니다.',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InsightTile(
                icon: Icons.menu_book_outlined,
                label: '전체 기록',
                value: '${items.length}건',
              ),
              _InsightTile(
                icon: Icons.calendar_month_outlined,
                label: '이번 달',
                value: '$thisMonthCount건',
              ),
              _InsightTile(
                icon: Icons.palette_outlined,
                label: '감정 폭',
                value: '$emotionCount종',
              ),
              _InsightTile(
                icon: Icons.history_outlined,
                label: '최근 기록',
                value: latestDate == null ? '-' : _formatDate(latestDate),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: '지난 오늘',
          description: memoryItems.isEmpty
              ? '같은 날짜의 기록이 쌓이면 다시 보여줍니다.'
              : '${memoryItems.length}개의 과거 기록',
          child: memoryItems.isEmpty
              ? const Text('오늘 남기는 기록이 내년의 돌아보기가 됩니다.')
              : Column(
                  children: memoryItems
                      .take(3)
                      .map((item) => _DiarySummaryTile(item: item))
                      .toList(),
                ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: '최근 일기',
          description: items.isEmpty ? '아직 작성된 기록이 없습니다.' : '최근 작성한 기록입니다.',
          child: items.isEmpty
              ? const Text('표시할 일기가 아직 없습니다.')
              : Column(
                  children: items
                      .take(3)
                      .map((item) => _DiarySummaryTile(item: item))
                      .toList(),
                ),
        ),
      ],
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 145,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelMedium),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
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

String _formatKoreanDate(DateTime value) {
  final weekday = ['월', '화', '수', '목', '금', '토', '일'][value.weekday - 1];
  return '${value.year}년 ${value.month}월 ${value.day}일 $weekday요일';
}

String _promptForToday(DateTime value) {
  const prompts = [
    '오늘 가장 오래 마음에 남은 장면은 무엇이었나요?',
    '오늘의 감정을 한 단어로 고르면 무엇인가요?',
    '내일의 나에게 꼭 남기고 싶은 한 문장은 무엇인가요?',
    '오늘 고마웠던 사람이나 순간을 적어보세요.',
    '오늘의 루틴 중 계속 가져가고 싶은 것은 무엇인가요?',
    '사진으로 남기고 싶은 순간이 있었다면 어떤 장면인가요?',
    '이번 주의 나에게 필요한 휴식은 무엇인가요?',
  ];

  return prompts[value.weekday - 1];
}
