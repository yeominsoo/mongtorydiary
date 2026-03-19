class ApiResponseDto<T> {
  const ApiResponseDto({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final T data;

  factory ApiResponseDto.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) parser,
  ) {
    return ApiResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: parser(json['data']),
    );
  }
}
