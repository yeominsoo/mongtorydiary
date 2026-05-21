package com.mongtory.diary.dto.diary;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class DiarySummaryResponse {

	private final Long id;
	private final LocalDate entryDate;
	private final String title;
	private final String emotionCode;
	private final String thumbnailUrl;
	private final List<String> tags;
	private final LocalDateTime createdAt;
	private final LocalDateTime updatedAt;
}
