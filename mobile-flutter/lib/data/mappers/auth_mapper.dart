import 'package:mongtory_diary/data/dto/auth_session_response_dto.dart';
import 'package:mongtory_diary/domain/models/auth_session.dart';
import 'package:mongtory_diary/domain/models/user_profile.dart';

class AuthMapper {
  const AuthMapper._();

  static AuthSession toDomain(AuthSessionResponseDto dto) {
    return AuthSession(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
      user: UserProfile(
        id: dto.user.id,
        email: dto.user.email,
        nickname: dto.user.nickname,
      ),
    );
  }
}
