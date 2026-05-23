class DiarySummary {
  const DiarySummary({
    required this.id,
    required this.entryDate,
    required this.title,
    required this.emotionCode,
    this.thumbnailUrl,
    this.locationName,
    this.weatherSummary,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final DateTime entryDate;
  final String title;
  final String emotionCode;
  final String? thumbnailUrl;
  final String? locationName;
  final String? weatherSummary;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
}
