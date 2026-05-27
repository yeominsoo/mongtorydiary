import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongtory_diary/application/providers/app_providers.dart';
import 'package:mongtory_diary/domain/models/diary_summary.dart';
import 'package:mongtory_diary/presentation/screens/diary/diary_detail_screen.dart';
import 'package:mongtory_diary/presentation/screens/diary/diary_edit_screen.dart';

class DiaryHomeScreen extends ConsumerWidget {
  const DiaryHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diaryList = ref.watch(diaryListProvider);
    final homeDiaryList = ref.watch(diaryHomeListProvider);
    final memoryList = ref.watch(diaryTodayMemoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('오늘의 일기')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        children: [
          _ContentWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DailyJournalComposer(
                  onStartWriting: () => _openCreateDiary(context, ref),
                ),
                const SizedBox(height: 14),
                diaryList.when(
                  data: (allItems) => homeDiaryList.when(
                    data: (items) => _DiaryWorkspace(
                      allItems: allItems,
                      items: items,
                      memoryItems: memoryList,
                    ),
                    loading: () => const _DiaryLoadingSurface(title: '최근 일기'),
                    error: (error, _) => _DiaryErrorSurface(
                      title: '최근 일기',
                      message: '일기 목록을 불러오지 못했습니다. $error',
                    ),
                  ),
                  loading: () => const _DiaryLoadingSurface(title: '최근 일기'),
                  error: (error, _) => _DiaryErrorSurface(
                    title: '최근 일기',
                    message: '일기 목록을 불러오지 못했습니다. $error',
                  ),
                ),
              ],
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
      ref.invalidate(diaryHomeListProvider);
      ref.invalidate(diaryTodayMemoriesProvider);
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
        constraints: const BoxConstraints(maxWidth: 960),
        child: child,
      ),
    );
  }
}

class _DailyJournalComposer extends StatelessWidget {
  const _DailyJournalComposer({required this.onStartWriting});

  final VoidCallback onStartWriting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final today = DateTime.now();
    final prompt = _promptForToday(today);

    return _SurfaceFrame(
      padding: const EdgeInsets.all(0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 720;
          final headline = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatKoreanDate(today),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '오늘 남길 장면을 정리해요',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                prompt,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ],
          );
          final form = _ComposerPanel(
            prompt: prompt,
            onStartWriting: onStartWriting,
          );

          return Padding(
            padding: const EdgeInsets.all(22),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: headline),
                      const SizedBox(width: 24),
                      SizedBox(width: 320, child: form),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [headline, const SizedBox(height: 18), form],
                  ),
          );
        },
      ),
    );
  }
}

class _ComposerPanel extends StatelessWidget {
  const _ComposerPanel({required this.prompt, required this.onStartWriting});

  final String prompt;
  final VoidCallback onStartWriting;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ComposerLine(
              icon: Icons.calendar_today_outlined,
              label: '날짜',
              value: _formatDate(DateTime.now()),
            ),
            const SizedBox(height: 10),
            _ComposerLine(
              icon: Icons.psychology_alt_outlined,
              label: '질문',
              value: prompt,
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            const _ComposerLine(
              icon: Icons.lock_outline,
              label: '공개',
              value: '나만 보기',
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onStartWriting,
              icon: const Icon(Icons.edit_note),
              label: const Text('오늘 기록 작성'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComposerLine extends StatelessWidget {
  const _ComposerLine({
    required this.icon,
    required this.label,
    required this.value,
    this.maxLines = 1,
  });

  final IconData icon;
  final String label;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: scheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DiaryWorkspace extends StatelessWidget {
  const _DiaryWorkspace({
    required this.allItems,
    required this.items,
    required this.memoryItems,
  });

  final List<DiarySummary> allItems;
  final List<DiarySummary> items;
  final AsyncValue<List<DiarySummary>> memoryItems;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final thisMonthCount = allItems.where((item) {
      return item.entryDate.year == today.year &&
          item.entryDate.month == today.month;
    }).length;
    final emotionCount = allItems
        .map((item) => item.emotionCode)
        .toSet()
        .length;
    final latestDate = allItems.isEmpty ? null : allItems.first.entryDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _JournalStatsBar(
          totalCount: allItems.length,
          visibleCount: items.length,
          thisMonthCount: thisMonthCount,
          emotionCount: emotionCount,
          latestDate: latestDate,
        ),
        const SizedBox(height: 14),
        _DiaryFilterSection(allItems: allItems),
        _MemorySection(memoryItems: memoryItems),
        _RecentDiaryPanel(items: items),
      ],
    );
  }
}

class _JournalStatsBar extends StatelessWidget {
  const _JournalStatsBar({
    required this.totalCount,
    required this.visibleCount,
    required this.thisMonthCount,
    required this.emotionCount,
    required this.latestDate,
  });

  final int totalCount;
  final int visibleCount;
  final int thisMonthCount;
  final int emotionCount;
  final DateTime? latestDate;

  @override
  Widget build(BuildContext context) {
    return _SurfaceFrame(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          final tileWidth = wide
              ? (constraints.maxWidth - 30) / 4
              : (constraints.maxWidth - 10) / 2;

          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InsightTile(
                width: tileWidth,
                icon: Icons.menu_book_outlined,
                label: '표시 중',
                value: '$visibleCount/$totalCount',
              ),
              _InsightTile(
                width: tileWidth,
                icon: Icons.calendar_month_outlined,
                label: '이번 달',
                value: '$thisMonthCount건',
              ),
              _InsightTile(
                width: tileWidth,
                icon: Icons.palette_outlined,
                label: '감정 폭',
                value: '$emotionCount종',
              ),
              _InsightTile(
                width: tileWidth,
                icon: Icons.history_outlined,
                label: '최근 기록',
                value: latestDate == null ? '-' : _formatDate(latestDate!),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DiaryFilterSection extends ConsumerStatefulWidget {
  const _DiaryFilterSection({required this.allItems});

  final List<DiarySummary> allItems;

  @override
  ConsumerState<_DiaryFilterSection> createState() =>
      _DiaryFilterSectionState();
}

class _DiaryFilterSectionState extends ConsumerState<_DiaryFilterSection> {
  late final TextEditingController _queryController;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController(
      text: ref.read(diarySearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(diarySearchQueryProvider);
    final selectedTag = ref.watch(diarySelectedTagProvider);
    final tags = _uniqueTags(widget.allItems);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: _SurfaceFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '기록 찾기',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _queryController,
              decoration: InputDecoration(
                labelText: '검색',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.trim().isEmpty
                    ? null
                    : IconButton(
                        tooltip: '검색어 지우기',
                        onPressed: () {
                          _queryController.clear();
                          ref.read(diarySearchQueryProvider.notifier).state =
                              '';
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                ref.read(diarySearchQueryProvider.notifier).state = value;
              },
            ),
            if (tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in tags)
                    FilterChip(
                      avatar: const Icon(Icons.tag_outlined, size: 16),
                      label: Text(tag),
                      selected: selectedTag == tag,
                      onSelected: (selected) {
                        ref.read(diarySelectedTagProvider.notifier).state =
                            selected ? tag : null;
                      },
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MemorySection extends StatelessWidget {
  const _MemorySection({required this.memoryItems});

  final AsyncValue<List<DiarySummary>> memoryItems;

  @override
  Widget build(BuildContext context) {
    return memoryItems.when(
      data: (items) {
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _SurfaceFrame(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PanelTitle(
                  title: '지난 오늘',
                  subtitle: '${items.length}개의 과거 기록',
                ),
                const SizedBox(height: 12),
                ...items.take(3).map((item) => _DiarySummaryTile(item: item)),
              ],
            ),
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.only(bottom: 14),
        child: LinearProgressIndicator(),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _RecentDiaryPanel extends StatelessWidget {
  const _RecentDiaryPanel({required this.items});

  final List<DiarySummary> items;

  @override
  Widget build(BuildContext context) {
    return _SurfaceFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelTitle(
            title: '최근 일기',
            subtitle: items.isEmpty ? '아직 작성된 기록이 없습니다.' : '최근 작성한 기록입니다.',
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const _EmptyJournalLine()
          else
            ...items.take(6).map((item) => _DiarySummaryTile(item: item)),
        ],
      ),
    );
  }
}

class _PanelTitle extends StatelessWidget {
  const _PanelTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({
    required this.width,
    required this.icon,
    required this.label,
    required this.value,
  });

  final double width;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.48),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icon, color: scheme.primary),
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
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiarySummaryTile extends StatelessWidget {
  const _DiarySummaryTile({required this.item});

  final DiarySummary item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locationName = item.locationName?.trim();
    final weatherSummary = item.weatherSummary?.trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.34),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 56,
                    child: Column(
                      children: [
                        Text(
                          '${item.entryDate.day}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          _weekdayShort(item.entryDate),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_formatDate(item.entryDate)} · ${item.emotionCode}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        if ((locationName?.isNotEmpty ?? false) ||
                            (weatherSummary?.isNotEmpty ?? false)) ...[
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              if (locationName != null &&
                                  locationName.isNotEmpty)
                                _MiniMetaChip(
                                  icon: Icons.place_outlined,
                                  label: locationName,
                                ),
                              if (weatherSummary != null &&
                                  weatherSummary.isNotEmpty)
                                _MiniMetaChip(
                                  icon: Icons.wb_sunny_outlined,
                                  label: weatherSummary,
                                ),
                            ],
                          ),
                        ],
                        if (item.tags.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              for (final tag in item.tags.take(3))
                                Chip(
                                  label: Text(tag),
                                  visualDensity: VisualDensity.compact,
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniMetaChip extends StatelessWidget {
  const _MiniMetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _SurfaceFrame extends StatelessWidget {
  const _SurfaceFrame({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _DiaryLoadingSurface extends StatelessWidget {
  const _DiaryLoadingSurface({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return _SurfaceFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          const LinearProgressIndicator(),
        ],
      ),
    );
  }
}

class _DiaryErrorSurface extends StatelessWidget {
  const _DiaryErrorSurface({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return _SurfaceFrame(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: scheme.error),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(message),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyJournalLine extends StatelessWidget {
  const _EmptyJournalLine();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.36),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Text('표시할 일기가 아직 없습니다.'),
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

String _weekdayShort(DateTime value) {
  return ['월', '화', '수', '목', '금', '토', '일'][value.weekday - 1];
}

List<String> _uniqueTags(List<DiarySummary> items) {
  final tags = <String>{};
  for (final item in items) {
    tags.addAll(item.tags);
  }

  return tags.toList()..sort();
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
