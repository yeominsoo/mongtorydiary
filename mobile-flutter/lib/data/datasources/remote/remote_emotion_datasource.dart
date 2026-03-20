import 'package:mongtory_diary/core/network/api_client.dart';
import 'package:mongtory_diary/data/dto/emotion_response_dto.dart';

class RemoteEmotionDataSource {
  const RemoteEmotionDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<EmotionResponseDto>> getEmotions() async {
    final response = await _apiClient.get<List<EmotionResponseDto>>(
      '/api/v1/emotions',
      parser: (json) => (json as List<dynamic>? ?? const [])
          .map(
            (item) =>
                EmotionResponseDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );

    return response.data;
  }
}
