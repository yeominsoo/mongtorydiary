package com.mongtory.diary.dto.calendar;

import java.util.List;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class CalendarMonthResponse {

	private final int year;
	private final int month;
	private final List<CalendarDaySummaryResponse> days;
}
