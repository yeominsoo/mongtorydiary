import 'package:mongtory_diary/core/network/api_client.dart';
import 'package:mongtory_diary/data/dto/auth_session_response_dto.dart';

class RemoteAuthDataSource {
  const RemoteAuthDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthSessionResponseDto> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<AuthSessionResponseDto>(
      '/api/v1/auth/login',
      parser: (json) =>
          AuthSessionResponseDto.fromJson(json as Map<String, dynamic>),
      body: {
        'email': email,
        'password': password,
      },
    );

    return response.data;
  }
}
