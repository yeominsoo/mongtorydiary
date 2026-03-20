import 'package:mongtory_diary/data/dto/calendar_month_response_dto.dart';

class MockCalendarDataSource {
  const MockCalendarDataSource();

  Future<CalendarMonthResponseDto> getCalendarMonth({
    required int year,
    required int month,
  }) async {
    return CalendarMonthResponseDto(
      year: year,
      month: month,
      days: const [
        CalendarDayResponseDto(
          date: '2026-03-19',
          hasEntry: true,
          emotionCode: 'CALM',
          entryCount: 1,
        ),
        CalendarDayResponseDto(
          date: '2026-03-18',
          hasEntry: true,
          emotionCode: 'HAPPY',
          entryCount: 1,
        ),
      ],
    );
  }
}
