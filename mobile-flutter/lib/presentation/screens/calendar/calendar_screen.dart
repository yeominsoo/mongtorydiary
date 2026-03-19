import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongtory_diary/application/providers/app_providers.dart';
import 'package:mongtory_diary/domain/models/calendar_day_summary.dart';
import 'package:mongtory_diary/presentation/widgets/section_card.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(calendarMonthProvider);
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
                          .map((day) => _CalendarDayTile(day: day))
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
          const SectionCard(
            title: '필터',
            description: '감정, 기간, 검색 조건을 조합하는 영역',
          ),
        ],
      ),
    );
  }
}

class _CalendarDayTile extends StatelessWidget {
  const _CalendarDayTile({required this.day});

  final CalendarDaySummary day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
        ],
      ),
    );
  }
}

String _formatCalendarDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}
