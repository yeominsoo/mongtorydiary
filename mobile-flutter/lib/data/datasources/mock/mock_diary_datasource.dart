import 'package:mongtory_diary/data/dto/diary_detail_response_dto.dart';
import 'package:mongtory_diary/data/dto/diary_summary_response_dto.dart';
import 'package:mongtory_diary/data/dto/diary_upsert_request_dto.dart';

class MockDiaryDataSource {
  const MockDiaryDataSource();

  static final List<DiaryDetailResponseDto> _diaries = [
    const DiaryDetailResponseDto(
      id: 101,
      entryDate: '2026-03-19',
      title: '오늘의 기록',
      content: '몽토리와 함께 산책을 했다.',
      emotionCode: 'CALM',
      imageUrls: [],
      tags: ['산책', '회고'],
      createdAt: '2026-03-19T09:00:00',
      updatedAt: '2026-03-19T09:10:00',
    ),
    const DiaryDetailResponseDto(
      id: 102,
      entryDate: '2026-03-18',
      title: '산책한 날',
      content: '공원에서 천천히 걸으며 하루를 정리했다.',
      emotionCode: 'HAPPY',
      imageUrls: [],
      tags: ['산책', '정리'],
      createdAt: '2026-03-18T20:10:00',
      updatedAt: '2026-03-18T20:30:00',
    ),
  ];

  Future<List<DiarySummaryResponseDto>> getDiarySummaries({
    String? query,
    String? tag,
  }) async {
    final normalizedQuery = query?.trim().toLowerCase();
    final normalizedTag = tag?.replaceFirst(RegExp('^#+'), '').trim();

    return _diaries
        .where((item) {
          if (normalizedQuery == null || normalizedQuery.isEmpty) {
            return true;
          }

          return item.title.toLowerCase().contains(normalizedQuery) ||
              item.content.toLowerCase().contains(normalizedQuery) ||
              item.tags.any(
                (tag) => tag.toLowerCase().contains(normalizedQuery),
              );
        })
        .where((item) {
          if (normalizedTag == null || normalizedTag.isEmpty) {
            return true;
          }

          return item.tags.any(
            (tag) => tag.toLowerCase() == normalizedTag.toLowerCase(),
          );
        })
        .map(
          (item) => DiarySummaryResponseDto(
            id: item.id,
            entryDate: item.entryDate,
            title: item.title,
            emotionCode: item.emotionCode,
            thumbnailUrl: item.imageUrls.isEmpty ? null : item.imageUrls.first,
            tags: item.tags,
            createdAt: item.createdAt,
            updatedAt: item.updatedAt,
          ),
        )
        .toList();
  }

  Future<List<DiarySummaryResponseDto>> getDiaryMemories({
    required int month,
    required int day,
  }) async {
    final currentYear = DateTime.now().year;
    return _diaries
        .where((item) {
          final entryDate = DateTime.parse(item.entryDate);
          return entryDate.year < currentYear &&
              entryDate.month == month &&
              entryDate.day == day;
        })
        .map(
          (item) => DiarySummaryResponseDto(
            id: item.id,
            entryDate: item.entryDate,
            title: item.title,
            emotionCode: item.emotionCode,
            thumbnailUrl: item.imageUrls.isEmpty ? null : item.imageUrls.first,
            tags: item.tags,
            createdAt: item.createdAt,
            updatedAt: item.updatedAt,
          ),
        )
        .toList();
  }

  Future<DiaryDetailResponseDto> getDiaryDetail(int diaryId) async {
    return _findDiary(diaryId);
  }

  Future<String> uploadDiaryImage({
    required String fileName,
    required List<int> bytes,
  }) async {
    final safeFileName = Uri.encodeComponent(fileName);
    return 'https://example.com/mock-uploads/$safeFileName';
  }

  Future<DiaryDetailResponseDto> createDiary(
    DiaryUpsertRequestDto request,
  ) async {
    final now = DateTime.now();
    final diary = DiaryDetailResponseDto(
      id: _nextId,
      entryDate: request.entryDate,
      title: request.title,
      content: request.content,
      emotionCode: request.emotionCode,
      imageUrls: request.imageUrls,
      tags: request.tags,
      createdAt: _formatDateTime(now),
      updatedAt: _formatDateTime(now),
    );
    _diaries.insert(0, diary);
    return diary;
  }

  Future<DiaryDetailResponseDto> updateDiary(
    int diaryId,
    DiaryUpsertRequestDto request,
  ) async {
    final index = _diaries.indexWhere((item) => item.id == diaryId);
    if (index == -1) {
      throw StateError('Diary entry not found');
    }

    final current = _diaries[index];
    final updated = DiaryDetailResponseDto(
      id: current.id,
      entryDate: request.entryDate,
      title: request.title,
      content: request.content,
      emotionCode: request.emotionCode,
      imageUrls: request.imageUrls,
      tags: request.tags,
      createdAt: current.createdAt,
      updatedAt: _formatDateTime(DateTime.now()),
    );
    _diaries[index] = updated;
    return updated;
  }

  Future<void> deleteDiary(int diaryId) async {
    _diaries.removeWhere((item) => item.id == diaryId);
  }

  DiaryDetailResponseDto _findDiary(int diaryId) {
    return _diaries.firstWhere(
      (item) => item.id == diaryId,
      orElse: () => DiaryDetailResponseDto(
        id: diaryId,
        entryDate: '2026-03-19',
        title: '오늘의 기록',
        content: '몽토리와 함께 산책을 했다.',
        emotionCode: 'CALM',
        imageUrls: const [],
        tags: const ['산책', '회고'],
        createdAt: '2026-03-19T09:00:00',
        updatedAt: '2026-03-19T09:10:00',
      ),
    );
  }

  int get _nextId {
    if (_diaries.isEmpty) {
      return 101;
    }

    return _diaries.map((item) => item.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  String _formatDateTime(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');
    return '${value.year}-$month-${day}T$hour:$minute:$second';
  }
}
