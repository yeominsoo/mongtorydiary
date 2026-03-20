import 'package:mongtory_diary/data/datasources/remote/remote_diary_datasource.dart';
import 'package:mongtory_diary/data/mappers/diary_mapper.dart';
import 'package:mongtory_diary/domain/models/diary_detail.dart';
import 'package:mongtory_diary/domain/models/diary_summary.dart';
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
  Future<List<DiarySummary>> getDiarySummaries() async {
    final dtos = await _dataSource.getDiarySummaries();
    return dtos.map(DiaryMapper.toSummary).toList();
  }
}
