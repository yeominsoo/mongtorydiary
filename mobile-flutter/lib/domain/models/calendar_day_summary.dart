class CalendarDaySummary {
  const CalendarDaySummary({
    required this.date,
    required this.hasEntry,
    this.emotionCode,
    required this.entryCount,
  });

  final DateTime date;
  final bool hasEntry;
  final String? emotionCode;
  final int entryCount;
}
