class AuthSessionResponseDto {
  const AuthSessionResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final UserSummaryDto user;

  factory AuthSessionResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthSessionResponseDto(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      user: UserSummaryDto.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class UserSummaryDto {
  const UserSummaryDto({
    required this.id,
    required this.email,
    required this.nickname,
  });

  final int id;
  final String email;
  final String nickname;

  factory UserSummaryDto.fromJson(Map<String, dynamic> json) {
    return UserSummaryDto(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
    );
  }
}
