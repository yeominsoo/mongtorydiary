import 'package:mongtory_diary/data/dto/diary_detail_response_dto.dart';
import 'package:mongtory_diary/data/dto/diary_summary_response_dto.dart';

class MockDiaryDataSource {
  const MockDiaryDataSource();

  Future<List<DiarySummaryResponseDto>> getDiarySummaries() async {
    return const [
      DiarySummaryResponseDto(
        id: 101,
        entryDate: '2026-03-19',
        title: '오늘의 기록',
        emotionCode: 'CALM',
        thumbnailUrl: null,
        createdAt: '2026-03-19T09:00:00',
        updatedAt: '2026-03-19T09:10:00',
      ),
      DiarySummaryResponseDto(
        id: 102,
        entryDate: '2026-03-18',
        title: '산책한 날',
        emotionCode: 'HAPPY',
        thumbnailUrl: null,
        createdAt: '2026-03-18T20:10:00',
        updatedAt: '2026-03-18T20:30:00',
      ),
    ];
  }

  Future<DiaryDetailResponseDto> getDiaryDetail(int diaryId) async {
    return DiaryDetailResponseDto(
      id: diaryId,
      entryDate: '2026-03-19',
      title: '오늘의 기록',
      content: '몽토리와 함께 산책을 했다.',
      emotionCode: 'CALM',
      imageUrls: const [],
      createdAt: '2026-03-19T09:00:00',
      updatedAt: '2026-03-19T09:10:00',
    );
  }
}
