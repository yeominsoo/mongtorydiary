package com.mongtory.diary.controller;

import java.time.LocalDate;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mongtory.diary.common.ApiResponse;
import com.mongtory.diary.domain.user.UserAccount;
import com.mongtory.diary.dto.widget.WidgetTodaySummaryResponse;
import com.mongtory.diary.service.AuthenticatedUserService;
import com.mongtory.diary.service.WidgetSummaryService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/widgets")
@RequiredArgsConstructor
public class WidgetController {

	private final WidgetSummaryService widgetSummaryService;
	private final AuthenticatedUserService authenticatedUserService;

	@GetMapping("/today-summary")
	public ApiResponse<WidgetTodaySummaryResponse> getTodaySummary(
		@RequestHeader("Authorization") String authorizationHeader,
		@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date
	) {
		final UserAccount currentUser = authenticatedUserService.getRequiredUser(authorizationHeader);
		return ApiResponse.ok(widgetSummaryService.getTodaySummary(currentUser, date));
	}
}
