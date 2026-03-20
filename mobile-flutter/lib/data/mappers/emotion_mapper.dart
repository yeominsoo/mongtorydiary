import 'package:mongtory_diary/data/dto/emotion_response_dto.dart';
import 'package:mongtory_diary/domain/models/emotion_type.dart';

class EmotionMapper {
  const EmotionMapper._();

  static EmotionType toDomain(EmotionResponseDto dto) {
    return EmotionType(
      code: dto.code,
      label: dto.label,
      iconKey: dto.iconKey,
    );
  }
}
