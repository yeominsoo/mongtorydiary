import 'package:mongtory_diary/domain/models/diary_detail.dart';
import 'package:mongtory_diary/domain/models/diary_summary.dart';
import 'package:mongtory_diary/domain/models/diary_upsert.dart';

abstract class DiaryRepository {
  Future<List<DiarySummary>> getDiarySummaries({String? query, String? tag});
  Future<List<DiarySummary>> getDiaryMemories({
    required int month,
    required int day,
  });
  Future<DiaryDetail> getDiaryDetail(int diaryId);
  Future<DiaryDetail> createDiary(DiaryUpsert input);
  Future<DiaryDetail> updateDiary(int diaryId, DiaryUpsert input);
  Future<void> deleteDiary(int diaryId);
}
