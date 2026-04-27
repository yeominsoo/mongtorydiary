import 'package:mongtory_diary/data/datasources/mock/mock_diary_datasource.dart';
import 'package:mongtory_diary/data/mappers/diary_mapper.dart';
import 'package:mongtory_diary/domain/models/diary_detail.dart';
import 'package:mongtory_diary/domain/models/diary_summary.dart';
import 'package:mongtory_diary/domain/models/diary_upsert.dart';
import 'package:mongtory_diary/domain/repositories/diary_repository.dart';

class MockDiaryRepository implements DiaryRepository {
  const MockDiaryRepository(this._dataSource);

  final MockDiaryDataSource _dataSource;

  @override
  Future<DiaryDetail> getDiaryDetail(int diaryId) async {
    final dto = await _dataSource.getDiaryDetail(diaryId);
    return DiaryMapper.toDetail(dto);
  }

  @override
  Future<List<DiarySummary>> getDiarySummaries() async {
    final dtos = await _dataSource.getDiarySummaries();
    return dtos.map(DiaryMapper.toSummary).toList();
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
