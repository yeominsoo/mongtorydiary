package com.mongtory.diary.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mongtory.diary.common.ApiResponse;
import com.mongtory.diary.domain.user.UserAccount;
import com.mongtory.diary.dto.calendar.CalendarMonthResponse;
import com.mongtory.diary.service.AuthenticatedUserService;
import com.mongtory.diary.service.CalendarService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/calendar")
@RequiredArgsConstructor
public class CalendarController {

	private final CalendarService calendarService;
	private final AuthenticatedUserService authenticatedUserService;

	@GetMapping
	public ApiResponse<CalendarMonthResponse> getCalendar(
		@RequestHeader("Authorization") String authorizationHeader,
		@RequestParam int year,
		@RequestParam int month
	) {
		final UserAccount currentUser = authenticatedUserService.getRequiredUser(authorizationHeader);
		return ApiResponse.ok(calendarService.getMonth(currentUser, year, month));
	}
}
