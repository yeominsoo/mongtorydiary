import 'package:mongtory_diary/domain/models/emotion_type.dart';

abstract class EmotionRepository {
  Future<List<EmotionType>> getEmotions();
}
