class DiaryUpsertRequestDto {
  const DiaryUpsertRequestDto({
    required this.entryDate,
    required this.title,
    required this.content,
    required this.emotionCode,
    required this.imageUrls,
  });

  final String entryDate;
  final String title;
  final String content;
  final String emotionCode;
  final List<String> imageUrls;

  Map<String, dynamic> toJson() {
    return {
      'entryDate': entryDate,
      'title': title,
      'content': content,
      'emotionCode': emotionCode,
      'imageUrls': imageUrls,
    };
  }
}
