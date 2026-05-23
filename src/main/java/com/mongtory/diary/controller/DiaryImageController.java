package com.mongtory.diary.controller;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import com.mongtory.diary.common.ApiResponse;
import com.mongtory.diary.domain.user.UserAccount;
import com.mongtory.diary.dto.diary.DiaryImageUploadResponse;
import com.mongtory.diary.service.AuthenticatedUserService;
import com.mongtory.diary.service.DiaryImageStorageService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/diary-images")
@RequiredArgsConstructor
public class DiaryImageController {

	private final DiaryImageStorageService diaryImageStorageService;
	private final AuthenticatedUserService authenticatedUserService;

	@PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
	public ApiResponse<DiaryImageUploadResponse> uploadDiaryImage(
		@RequestHeader("Authorization") String authorizationHeader,
		@RequestPart("file") MultipartFile file
	) {
		final UserAccount currentUser = authenticatedUserService.getRequiredUser(authorizationHeader);
		final DiaryImageUploadResponse storedImage = diaryImageStorageService.store(currentUser, file);
		final String absoluteUrl = ServletUriComponentsBuilder.fromCurrentContextPath()
			.path(storedImage.getUrl())
			.toUriString();

		return ApiResponse.ok(
			DiaryImageUploadResponse.builder()
				.url(absoluteUrl)
				.originalFilename(storedImage.getOriginalFilename())
				.contentType(storedImage.getContentType())
				.size(storedImage.getSize())
				.build()
		);
	}
}
