import 'package:mongtory_diary/data/datasources/remote/remote_emotion_datasource.dart';
import 'package:mongtory_diary/data/mappers/emotion_mapper.dart';
import 'package:mongtory_diary/domain/models/emotion_type.dart';
import 'package:mongtory_diary/domain/repositories/emotion_repository.dart';

class ApiEmotionRepository implements EmotionRepository {
  const ApiEmotionRepository(this._dataSource);

  final RemoteEmotionDataSource _dataSource;

  @override
  Future<List<EmotionType>> getEmotions() async {
    final dtos = await _dataSource.getEmotions();
    return dtos.map(EmotionMapper.toDomain).toList();
  }
}
