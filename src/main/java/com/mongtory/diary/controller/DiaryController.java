package com.mongtory.diary.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mongtory.diary.common.ApiResponse;
import com.mongtory.diary.domain.user.UserAccount;
import com.mongtory.diary.dto.diary.DiaryDetailResponse;
import com.mongtory.diary.dto.diary.DiarySummaryResponse;
import com.mongtory.diary.dto.diary.DiaryUpsertRequest;
import com.mongtory.diary.service.AuthenticatedUserService;
import com.mongtory.diary.service.DiaryService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/diaries")
@RequiredArgsConstructor
public class DiaryController {

	private final DiaryService diaryService;
	private final AuthenticatedUserService authenticatedUserService;

	@GetMapping
	public ApiResponse<List<DiarySummaryResponse>> getDiaries(
		@RequestHeader("Authorization") String authorizationHeader,
		@RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
		@RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
		@RequestParam(required = false) String emotion,
		@RequestParam(required = false) String query,
		@RequestParam(required = false) String tag
	) {
		final UserAccount currentUser = authenticatedUserService.getRequiredUser(authorizationHeader);
		return ApiResponse.ok(diaryService.getDiaries(currentUser, from, to, emotion, query, tag));
	}

	@GetMapping("/memories")
	public ApiResponse<List<DiarySummaryResponse>> getMemories(
		@RequestHeader("Authorization") String authorizationHeader,
		@RequestParam int month,
		@RequestParam int day
	) {
		final UserAccount currentUser = authenticatedUserService.getRequiredUser(authorizationHeader);
		return ApiResponse.ok(diaryService.getMemoriesOnDate(currentUser, month, day));
	}

	@GetMapping("/{diaryId}")
	public ApiResponse<DiaryDetailResponse> getDiary(
		@RequestHeader("Authorization") String authorizationHeader,
		@PathVariable Long diaryId
	) {
		final UserAccount currentUser = authenticatedUserService.getRequiredUser(authorizationHeader);
		return ApiResponse.ok(diaryService.getDiary(currentUser, diaryId));
	}

	@PostMapping
	public ApiResponse<DiaryDetailResponse> createDiary(
		@RequestHeader("Authorization") String authorizationHeader,
		@RequestBody DiaryUpsertRequest request
	) {
		final UserAccount currentUser = authenticatedUserService.getRequiredUser(authorizationHeader);
		return ApiResponse.ok(diaryService.createDiary(currentUser, request));
	}

	@PutMapping("/{diaryId}")
	public ApiResponse<DiaryDetailResponse> updateDiary(
		@RequestHeader("Authorization") String authorizationHeader,
		@PathVariable Long diaryId,
		@RequestBody DiaryUpsertRequest request
	) {
		final UserAccount currentUser = authenticatedUserService.getRequiredUser(authorizationHeader);
		return ApiResponse.ok(diaryService.updateDiary(currentUser, diaryId, request));
	}

	@DeleteMapping("/{diaryId}")
	public ApiResponse<Void> deleteDiary(
		@RequestHeader("Authorization") String authorizationHeader,
		@PathVariable Long diaryId
	) {
		final UserAccount currentUser = authenticatedUserService.getRequiredUser(authorizationHeader);
		diaryService.deleteDiary(currentUser, diaryId);
		return ApiResponse.ok(null);
	}
}
