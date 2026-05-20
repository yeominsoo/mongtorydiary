import 'package:mongtory_diary/data/dto/calendar_month_response_dto.dart';
import 'package:mongtory_diary/domain/models/calendar_day_summary.dart';
import 'package:mongtory_diary/domain/models/calendar_month.dart';

class CalendarMapper {
  const CalendarMapper._();

  static CalendarMonth toDomain(CalendarMonthResponseDto dto) {
    return CalendarMonth(
      year: dto.year,
      month: dto.month,
      days: dto.days
          .map(
            (day) => CalendarDaySummary(
              date: DateTime.parse(day.date),
              hasEntry: day.hasEntry,
              emotionCode: day.emotionCode,
              entryCount: day.entryCount,
              todoCount: day.todoCount,
              completedTodoCount: day.completedTodoCount,
            ),
          )
          .toList(),
    );
  }
}
