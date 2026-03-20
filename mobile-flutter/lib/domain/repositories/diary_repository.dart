import 'package:mongtory_diary/domain/models/diary_detail.dart';
import 'package:mongtory_diary/domain/models/diary_summary.dart';

abstract class DiaryRepository {
  Future<List<DiarySummary>> getDiarySummaries();
  Future<DiaryDetail> getDiaryDetail(int diaryId);
}
