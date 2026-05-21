class DiarySummaryResponseDto {
  const DiarySummaryResponseDto({
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
  final String entryDate;
  final String title;
  final String emotionCode;
  final String? thumbnailUrl;
  final String? locationName;
  final String? weatherSummary;
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
