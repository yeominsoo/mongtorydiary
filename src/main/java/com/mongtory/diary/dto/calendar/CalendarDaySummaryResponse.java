package com.mongtory.diary.dto.calendar;

import java.time.LocalDate;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class CalendarDaySummaryResponse {

	private final LocalDate date;
	private final boolean hasEntry;
	private final String emotionCode;
	private final int entryCount;
	private final int todoCount;
	private final int completedTodoCount;
}
