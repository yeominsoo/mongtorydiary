import 'package:mongtory_diary/data/datasources/remote/remote_diary_datasource.dart';
import 'package:mongtory_diary/data/mappers/diary_mapper.dart';
import 'package:mongtory_diary/domain/models/diary_detail.dart';
import 'package:mongtory_diary/domain/models/diary_summary.dart';
import 'package:mongtory_diary/domain/models/diary_upsert.dart';
import 'package:mongtory_diary/domain/repositories/diary_repository.dart';

class ApiDiaryRepository implements DiaryRepository {
  const ApiDiaryRepository(this._dataSource);

  final RemoteDiaryDataSource _dataSource;

  @override
  Future<DiaryDetail> getDiaryDetail(int diaryId) async {
    final dto = await _dataSource.getDiaryDetail(diaryId);
    return DiaryMapper.toDetail(dto);
  }

  @override
  Future<List<DiarySummary>> getDiarySummaries({
    String? query,
    String? tag,
  }) async {
    final dtos = await _dataSource.getDiarySummaries(query: query, tag: tag);
    return dtos.map(DiaryMapper.toSummary).toList();
  }

  @override
  Future<List<DiarySummary>> getDiaryMemories({
    required int month,
    required int day,
  }) async {
    final dtos = await _dataSource.getDiaryMemories(month: month, day: day);
    return dtos.map(DiaryMapper.toSummary).toList();
  }

  @override
  Future<String> uploadDiaryImage({
    required String fileName,
    required List<int> bytes,
  }) async {
    final dto = await _dataSource.uploadDiaryImage(
      fileName: fileName,
      bytes: bytes,
    );
    return dto.url;
  }

  @override
  Future<DiaryDetail> createDiary(DiaryUpsert input) async {
    final dto = await _dataSource.createDiary(
      DiaryMapper.toUpsertRequest(input),
    );
    return DiaryMapper.toDetail(dto);
  }

  @override
  Future<DiaryDetail> updateDiary(int diaryId, DiaryUpsert input) async {
    final dto = await _dataSource.updateDiary(
      diaryId,
      DiaryMapper.toUpsertRequest(input),
    );
    return DiaryMapper.toDetail(dto);
  }

  @override
  Future<void> deleteDiary(int diaryId) {
    return _dataSource.deleteDiary(diaryId);
  }
}
