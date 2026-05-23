class CalendarMonthResponseDto {
  const CalendarMonthResponseDto({
    required this.year,
    required this.month,
    required this.days,
  });

  final int year;
  final int month;
  final List<CalendarDayResponseDto> days;

  factory CalendarMonthResponseDto.fromJson(Map<String, dynamic> json) {
    return CalendarMonthResponseDto(
      year: json['year'] as int? ?? 0,
      month: json['month'] as int? ?? 0,
      days: (json['days'] as List<dynamic>? ?? const [])
          .map(
            (item) =>
                CalendarDayResponseDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class CalendarDayResponseDto {
  const CalendarDayResponseDto({
    required this.date,
    required this.hasEntry,
    this.emotionCode,
    required this.entryCount,
    this.todoCount = 0,
    this.completedTodoCount = 0,
  });

  final String date;
  final bool hasEntry;
  final String? emotionCode;
  final int entryCount;
  final int todoCount;
  final int completedTodoCount;

  factory CalendarDayResponseDto.fromJson(Map<String, dynamic> json) {
    return CalendarDayResponseDto(
      date: json['date'] as String? ?? '',
      hasEntry: json['hasEntry'] as bool? ?? false,
      emotionCode: json['emotionCode'] as String?,
      entryCount: json['entryCount'] as int? ?? 0,
      todoCount: json['todoCount'] as int? ?? 0,
      completedTodoCount: json['completedTodoCount'] as int? ?? 0,
    );
  }
}
