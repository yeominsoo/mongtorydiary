class DiarySummaryResponseDto {
  const DiarySummaryResponseDto({
    required this.id,
    required this.entryDate,
    required this.title,
    required this.emotionCode,
    this.thumbnailUrl,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String entryDate;
  final String title;
  final String emotionCode;
  final String? thumbnailUrl;
  final List<String> tags;
  final String createdAt;
  final String updatedAt;

  factory DiarySummaryResponseDto.fromJson(Map<String, dynamic> json) {
    return DiarySummaryResponseDto(
      id: json['id'] as int? ?? 0,
      entryDate: json['entryDate'] as String? ?? '',
      title: json['title'] as String? ?? '',
      emotionCode: json['emotionCode'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String?,
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(),
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }
}
