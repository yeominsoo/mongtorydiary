class DiaryImageUploadResponseDto {
  const DiaryImageUploadResponseDto({
    required this.url,
    required this.originalFilename,
    required this.contentType,
    required this.size,
  });

  final String url;
  final String originalFilename;
  final String contentType;
  final int size;

  factory DiaryImageUploadResponseDto.fromJson(Map<String, dynamic> json) {
    return DiaryImageUploadResponseDto(
      url: json['url'] as String? ?? '',
      originalFilename: json['originalFilename'] as String? ?? '',
      contentType: json['contentType'] as String? ?? '',
      size: json['size'] as int? ?? 0,
    );
  }
}
