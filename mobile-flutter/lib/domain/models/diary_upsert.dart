class DiaryUpsert {
  const DiaryUpsert({
    required this.entryDate,
    required this.title,
    required this.content,
    required this.emotionCode,
    required this.imageUrls,
    this.locationName,
    this.weatherSummary,
    required this.tags,
  });

  final DateTime entryDate;
  final String title;
  final String content;
  final String emotionCode;
  final List<String> imageUrls;
  final String? locationName;
  final String? weatherSummary;
  final List<String> tags;
}
