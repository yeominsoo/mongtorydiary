package com.mongtory.diary.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mongtory.diary.common.ApiResponse;
import com.mongtory.diary.dto.emotion.EmotionTypeResponse;
import com.mongtory.diary.service.EmotionService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/emotions")
@RequiredArgsConstructor
public class EmotionController {

	private final EmotionService emotionService;

	@GetMapping
	public ApiResponse<List<EmotionTypeResponse>> getEmotions() {
		return ApiResponse.ok(emotionService.getEmotions());
	}
}
