class EmotionResponseDto {
  const EmotionResponseDto({
    required this.code,
    required this.label,
    required this.iconKey,
  });

  final String code;
  final String label;
  final String iconKey;

  factory EmotionResponseDto.fromJson(Map<String, dynamic> json) {
    return EmotionResponseDto(
      code: json['code'] as String? ?? '',
      label: json['label'] as String? ?? '',
      iconKey: json['iconKey'] as String? ?? '',
    );
  }
}
