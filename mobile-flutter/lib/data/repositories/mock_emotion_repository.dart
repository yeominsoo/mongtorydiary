import 'package:mongtory_diary/data/datasources/mock/mock_emotion_datasource.dart';
import 'package:mongtory_diary/data/mappers/emotion_mapper.dart';
import 'package:mongtory_diary/domain/models/emotion_type.dart';
import 'package:mongtory_diary/domain/repositories/emotion_repository.dart';

class MockEmotionRepository implements EmotionRepository {
  const MockEmotionRepository(this._dataSource);

  final MockEmotionDataSource _dataSource;

  @override
  Future<List<EmotionType>> getEmotions() async {
    final dtos = await _dataSource.getEmotions();
    return dtos.map(EmotionMapper.toDomain).toList();
  }
}
