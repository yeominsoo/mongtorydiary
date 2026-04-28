package com.mongtory.diary.dto.widget;

import java.time.LocalDate;
import java.time.LocalDateTime;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class WidgetTodaySummaryResponse {

	private LocalDate date;
	private boolean hasTodayEntry;
	private int todayEntryCount;
	private Long latestDiaryId;
	private String latestDiaryTitle;
	private String latestEmotionCode;
	private int streakDays;
	private LocalDate lastEntryDate;
	private String message;
	private LocalDateTime updatedAt;
}
