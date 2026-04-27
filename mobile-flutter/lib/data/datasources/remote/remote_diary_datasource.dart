import 'package:mongtory_diary/core/network/api_client.dart';
import 'package:mongtory_diary/core/network/api_exception.dart';
import 'package:mongtory_diary/data/dto/diary_detail_response_dto.dart';
import 'package:mongtory_diary/data/dto/diary_summary_response_dto.dart';
import 'package:mongtory_diary/data/dto/diary_upsert_request_dto.dart';

class RemoteDiaryDataSource {
  const RemoteDiaryDataSource(this._apiClient, this._accessToken);

  final ApiClient _apiClient;
  final String? _accessToken;

  Future<List<DiarySummaryResponseDto>> getDiarySummaries() async {
    final response = await _apiClient.get<List<DiarySummaryResponseDto>>(
      '/api/v1/diaries',
      parser: (json) => (json as List<dynamic>? ?? const [])
          .map(
            (item) =>
                DiarySummaryResponseDto.fromJson(item as Map<String, dynamic>),
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

  Future<DiaryDetailResponseDto> createDiary(
    DiaryUpsertRequestDto request,
  ) async {
    final response = await _apiClient.post<DiaryDetailResponseDto>(
      '/api/v1/diaries',
      parser: (json) =>
          DiaryDetailResponseDto.fromJson(json as Map<String, dynamic>),
      body: request.toJson(),
      headers: _authorizationHeaders,
    );

    return response.data;
  }

  Future<DiaryDetailResponseDto> updateDiary(
    int diaryId,
    DiaryUpsertRequestDto request,
  ) async {
    final response = await _apiClient.put<DiaryDetailResponseDto>(
      '/api/v1/diaries/$diaryId',
      parser: (json) =>
          DiaryDetailResponseDto.fromJson(json as Map<String, dynamic>),
      body: request.toJson(),
      headers: _authorizationHeaders,
    );

    return response.data;
  }

  Future<void> deleteDiary(int diaryId) async {
    await _apiClient.delete<void>(
      '/api/v1/diaries/$diaryId',
      parser: (_) {},
      headers: _authorizationHeaders,
    );
  }

  Map<String, String> get _authorizationHeaders {
    if (_accessToken == null || _accessToken.isEmpty) {
      throw const ApiException('로그인이 필요합니다.');
    }

    return {'Authorization': 'Bearer $_accessToken'};
  }
}
