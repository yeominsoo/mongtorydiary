class DiaryDetailResponseDto {
  const DiaryDetailResponseDto({
    required this.id,
    required this.entryDate,
    required this.title,
    required this.content,
    required this.emotionCode,
    required this.imageUrls,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String entryDate;
  final String title;
  final String content;
  final String emotionCode;
  final List<String> imageUrls;
  final String createdAt;
  final String updatedAt;

  factory DiaryDetailResponseDto.fromJson(Map<String, dynamic> json) {
    return DiaryDetailResponseDto(
      id: json['id'] as int? ?? 0,
      entryDate: json['entryDate'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      emotionCode: json['emotionCode'] as String? ?? '',
      imageUrls:
          (json['imageUrls'] as List<dynamic>? ?? const []).cast<String>(),
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }
}
