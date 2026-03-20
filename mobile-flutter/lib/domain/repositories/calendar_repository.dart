import 'package:mongtory_diary/domain/models/calendar_month.dart';

abstract class CalendarRepository {
  Future<CalendarMonth> getCalendarMonth({
    required int year,
    required int month,
  });
}
