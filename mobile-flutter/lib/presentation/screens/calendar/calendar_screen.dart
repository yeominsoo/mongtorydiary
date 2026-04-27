import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongtory_diary/application/providers/app_providers.dart';
import 'package:mongtory_diary/domain/models/calendar_day_summary.dart';
import 'package:mongtory_diary/domain/models/diary_summary.dart';
import 'package:mongtory_diary/presentation/screens/diary/diary_detail_screen.dart';
import 'package:mongtory_diary/presentation/screens/diary/diary_edit_screen.dart';
import 'package:mongtory_diary/presentation/widgets/section_card.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(calendarMonthProvider);
    final diaryList = ref.watch(diaryListProvider);
    final dataSourceModeLabel = ref.watch(dataSourceModeLabelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('캘린더')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          month.when(
            data: (calendar) => SectionCard(
              title: '월간 캘린더',
              description:
                  '${calendar.year}년 ${calendar.month}월 $dataSourceModeLabel 데이터 ${calendar.days.length}건이 준비되었습니다.',
              child: calendar.days.isEmpty
                  ? const Text('기록된 날짜가 아직 없습니다.')
                  : Column(
                      children: calendar.days
                          .take(5)
                          .map(
                            (day) => _CalendarDayTile(
                              day: day,
                              diaries: _diariesOnDate(
                                diaryList.valueOrNull ?? const [],
                                day.date,
                              ),
                              onChanged: () {
                                ref.invalidate(diaryListProvider);
                                ref.invalidate(calendarMonthProvider);
                              },
                            ),
                          )
                          .toList(),
                    ),
            ),
            loading: () => const SectionCard(
              title: '월간 캘린더',
              description: '캘린더 데이터를 불러오는 중입니다.',
            ),
            error: (error, _) => SectionCard(
              title: '월간 캘린더',
              description: '캘린더 데이터를 불러오지 못했습니다. $error',
            ),
          ),
          const SizedBox(height: 16),
          const SectionCard(
            title: '선택한 날짜 요약',
            description: '선택한 날짜의 일기 수, 감정, 대표 이미지가 들어갈 영역',
          ),
          const SizedBox(height: 16),
          const SectionCard(title: '필터', description: '감정, 기간, 검색 조건을 조합하는 영역'),
        ],
      ),
    );
  }
}

class _CalendarDayTile extends StatelessWidget {
  const _CalendarDayTile({
    required this.day,
    required this.diaries,
    required this.onChanged,
  });

  final CalendarDaySummary day;
  final List<DiarySummary> diaries;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _showDateActions(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _formatCalendarDate(day.date),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${day.entryCount}건 · ${day.emotionCode ?? 'UNKNOWN'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDateActions(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => _CalendarDateSheet(
        date: day.date,
        diaries: diaries,
        onChanged: onChanged,
      ),
    );
  }
}

class _CalendarDateSheet extends StatelessWidget {
  const _CalendarDateSheet({
    required this.date,
    required this.diaries,
    required this.onChanged,
  });

  final DateTime date;
  final List<DiarySummary> diaries;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _formatCalendarDate(date),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            if (diaries.isEmpty)
              Text(
                '이 날짜에 작성된 일기가 없습니다.',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              ...diaries.map((item) => _DateDiaryAction(item: item)),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _openCreate(context),
              icon: const Icon(Icons.edit_note),
              label: Text(diaries.isEmpty ? '이 날짜로 작성' : '새 일기 작성'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCreate(BuildContext context) async {
    Navigator.of(context).pop();
    final didSave = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => DiaryEditScreen(initialDate: date),
      ),
    );

    if (didSave == true) {
      onChanged();
    }
  }
}

class _DateDiaryAction extends StatelessWidget {
  const _DateDiaryAction({required this.item});

  final DiarySummary item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(item.title),
      subtitle: Text(item.emotionCode),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _openDetail(context),
    );
  }

  Future<void> _openDetail(BuildContext context) async {
    Navigator.of(context).pop();
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => DiaryDetailScreen(diaryId: item.id),
      ),
    );
  }
}

String _formatCalendarDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

List<DiarySummary> _diariesOnDate(List<DiarySummary> diaries, DateTime date) {
  return diaries.where((item) => _isSameDate(item.entryDate, date)).toList();
}

bool _isSameDate(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}
