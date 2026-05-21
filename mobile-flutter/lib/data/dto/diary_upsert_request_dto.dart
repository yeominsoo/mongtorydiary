class DiaryUpsertRequestDto {
  const DiaryUpsertRequestDto({
    required this.entryDate,
    required this.title,
    required this.content,
    required this.emotionCode,
    required this.imageUrls,
    required this.tags,
  });

  final String entryDate;
  final String title;
  final String content;
  final String emotionCode;
  final List<String> imageUrls;
  final List<String> tags;

  Map<String, dynamic> toJson() {
    return {
      'entryDate': entryDate,
      'title': title,
      'content': content,
      'emotionCode': emotionCode,
      'imageUrls': imageUrls,
      'tags': tags,
    };
  }
}
