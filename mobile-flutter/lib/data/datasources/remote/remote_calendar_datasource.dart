import 'package:mongtory_diary/core/network/api_client.dart';
import 'package:mongtory_diary/core/network/api_exception.dart';
import 'package:mongtory_diary/data/dto/calendar_month_response_dto.dart';

class RemoteCalendarDataSource {
  const RemoteCalendarDataSource(this._apiClient, this._accessToken);

  final ApiClient _apiClient;
  final String? _accessToken;

  Future<CalendarMonthResponseDto> getCalendarMonth({
    required int year,
    required int month,
  }) async {
    final response = await _apiClient.get<CalendarMonthResponseDto>(
      '/api/v1/calendar',
      parser: (json) =>
          CalendarMonthResponseDto.fromJson(json as Map<String, dynamic>),
      queryParameters: {
        'year': year.toString(),
        'month': month.toString(),
      },
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
