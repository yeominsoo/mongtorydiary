class CalendarDaySummary {
  const CalendarDaySummary({
    required this.date,
    required this.hasEntry,
    this.emotionCode,
    required this.entryCount,
    this.todoCount = 0,
    this.completedTodoCount = 0,
  });

  final DateTime date;
  final bool hasEntry;
  final String? emotionCode;
  final int entryCount;
  final int todoCount;
  final int completedTodoCount;
}
