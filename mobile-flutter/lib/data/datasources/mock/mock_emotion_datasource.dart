import 'package:mongtory_diary/data/dto/emotion_response_dto.dart';

class MockEmotionDataSource {
  const MockEmotionDataSource();

  Future<List<EmotionResponseDto>> getEmotions() async {
    return const [
      EmotionResponseDto(code: 'HAPPY', label: '행복', iconKey: 'mongtory_happy'),
      EmotionResponseDto(code: 'SAD', label: '슬픔', iconKey: 'mongtory_sad'),
      EmotionResponseDto(code: 'CALM', label: '차분', iconKey: 'mongtory_calm'),
      EmotionResponseDto(code: 'EXCITED', label: '신남', iconKey: 'mongtory_excited'),
      EmotionResponseDto(code: 'TIRED', label: '피곤', iconKey: 'mongtory_tired'),
    ];
  }
}
