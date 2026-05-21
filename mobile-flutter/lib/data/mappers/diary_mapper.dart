import 'package:mongtory_diary/data/dto/diary_detail_response_dto.dart';
import 'package:mongtory_diary/data/dto/diary_summary_response_dto.dart';
import 'package:mongtory_diary/data/dto/diary_upsert_request_dto.dart';
import 'package:mongtory_diary/domain/models/diary_detail.dart';
import 'package:mongtory_diary/domain/models/diary_summary.dart';
import 'package:mongtory_diary/domain/models/diary_upsert.dart';

class DiaryMapper {
  const DiaryMapper._();

  static DiarySummary toSummary(DiarySummaryResponseDto dto) {
    return DiarySummary(
      id: dto.id,
      entryDate: DateTime.parse(dto.entryDate),
      title: dto.title,
      emotionCode: dto.emotionCode,
      thumbnailUrl: dto.thumbnailUrl,
      tags: dto.tags,
      createdAt: DateTime.parse(dto.createdAt),
      updatedAt: DateTime.parse(dto.updatedAt),
    );
  }

  static DiaryDetail toDetail(DiaryDetailResponseDto dto) {
    return DiaryDetail(
      id: dto.id,
      entryDate: DateTime.parse(dto.entryDate),
      title: dto.title,
      content: dto.content,
      emotionCode: dto.emotionCode,
      imageUrls: dto.imageUrls,
      tags: dto.tags,
      createdAt: DateTime.parse(dto.createdAt),
      updatedAt: DateTime.parse(dto.updatedAt),
    );
  }

  static DiaryUpsertRequestDto toUpsertRequest(DiaryUpsert input) {
    return DiaryUpsertRequestDto(
      entryDate: _formatDate(input.entryDate),
      title: input.title,
      content: input.content,
      emotionCode: input.emotionCode,
      imageUrls: input.imageUrls,
      tags: input.tags,
    );
  }

  static String _formatDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
