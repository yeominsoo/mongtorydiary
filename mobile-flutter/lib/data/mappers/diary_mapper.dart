import 'package:mongtory_diary/data/dto/diary_detail_response_dto.dart';
import 'package:mongtory_diary/data/dto/diary_summary_response_dto.dart';
import 'package:mongtory_diary/domain/models/diary_detail.dart';
import 'package:mongtory_diary/domain/models/diary_summary.dart';

class DiaryMapper {
  const DiaryMapper._();

  static DiarySummary toSummary(DiarySummaryResponseDto dto) {
    return DiarySummary(
      id: dto.id,
      entryDate: DateTime.parse(dto.entryDate),
      title: dto.title,
      emotionCode: dto.emotionCode,
      thumbnailUrl: dto.thumbnailUrl,
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
      createdAt: DateTime.parse(dto.createdAt),
      updatedAt: DateTime.parse(dto.updatedAt),
    );
  }
}
