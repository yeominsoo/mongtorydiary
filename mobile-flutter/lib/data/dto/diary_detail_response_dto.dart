class DiaryDetailResponseDto {
  const DiaryDetailResponseDto({
    required this.id,
    required this.entryDate,
    required this.title,
    required this.content,
    required this.emotionCode,
    required this.imageUrls,
    this.locationName,
    this.weatherSummary,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String entryDate;
  final String title;
  final String content;
  final String emotionCode;
  final List<String> imageUrls;
  final String? locationName;
  final String? weatherSummary;
  final List<String> tags;
  final String createdAt;
  final String updatedAt;

  factory DiaryDetailResponseDto.fromJson(Map<String, dynamic> json) {
    return DiaryDetailResponseDto(
      id: json['id'] as int? ?? 0,
      entryDate: json['entryDate'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      emotionCode: json['emotionCode'] as String? ?? '',
      imageUrls: (json['imageUrls'] as List<dynamic>? ?? const [])
          .cast<String>(),
      locationName: json['locationName'] as String?,
      weatherSummary: json['weatherSummary'] as String?,
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(),
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }
}
