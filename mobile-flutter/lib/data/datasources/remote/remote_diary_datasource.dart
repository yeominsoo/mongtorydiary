import 'package:mongtory_diary/core/network/api_client.dart';
import 'package:mongtory_diary/core/network/api_exception.dart';
import 'package:mongtory_diary/data/dto/diary_detail_response_dto.dart';
import 'package:mongtory_diary/data/dto/diary_summary_response_dto.dart';

class RemoteDiaryDataSource {
  const RemoteDiaryDataSource(this._apiClient, this._accessToken);

  final ApiClient _apiClient;
  final String? _accessToken;

  Future<List<DiarySummaryResponseDto>> getDiarySummaries() async {
    final response = await _apiClient.get<List<DiarySummaryResponseDto>>(
      '/api/v1/diaries',
      parser: (json) => (json as List<dynamic>? ?? const [])
          .map(
            (item) => DiarySummaryResponseDto.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      headers: _authorizationHeaders,
    );

    return response.data;
  }

  Future<DiaryDetailResponseDto> getDiaryDetail(int diaryId) async {
    final response = await _apiClient.get<DiaryDetailResponseDto>(
      '/api/v1/diaries/$diaryId',
      parser: (json) =>
          DiaryDetailResponseDto.fromJson(json as Map<String, dynamic>),
      headers: _authorizationHeaders,
    );

    return response.data;
  }

  Map<String, String> get _authorizationHeaders {
    if (_accessToken == null || _accessToken.isEmpty) {
      throw const ApiException('로그인이 필요합니다.');
    }

    return {
      'Authorization': 'Bearer $_accessToken',
    };
  }
}
