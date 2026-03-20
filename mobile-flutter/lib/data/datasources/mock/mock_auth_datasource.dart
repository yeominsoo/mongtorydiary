import 'package:mongtory_diary/data/dto/auth_session_response_dto.dart';

class MockAuthDataSource {
  const MockAuthDataSource();

  Future<AuthSessionResponseDto> signIn({
    required String email,
    required String password,
  }) async {
    return AuthSessionResponseDto(
      accessToken: 'mock-access-token',
      refreshToken: 'mock-refresh-token',
      user: UserSummaryDto(
        id: 1,
        email: email,
        nickname: '몽토리 사용자',
      ),
    );
  }
}
