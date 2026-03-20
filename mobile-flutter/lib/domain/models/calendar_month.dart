import 'package:mongtory_diary/domain/models/calendar_day_summary.dart';

class CalendarMonth {
  const CalendarMonth({
    required this.year,
    required this.month,
    required this.days,
  });

  final int year;
  final int month;
  final List<CalendarDaySummary> days;
}
