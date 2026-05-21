class DiaryDetail {
  const DiaryDetail({
    required this.id,
    required this.entryDate,
    required this.title,
    required this.content,
    required this.emotionCode,
    required this.imageUrls,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final DateTime entryDate;
  final String title;
  final String content;
  final String emotionCode;
  final List<String> imageUrls;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
}
