package com.mongtory.diary.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.mongtory.diary.domain.emotion.EmotionCode;
import com.mongtory.diary.dto.emotion.EmotionTypeResponse;

@Service
public class EmotionService {

	public List<EmotionTypeResponse> getEmotions() {
		return List.of(EmotionCode.values()).stream()
			.map(this::toResponse)
			.toList();
	}

	private EmotionTypeResponse toResponse(EmotionCode emotionCode) {
		return EmotionTypeResponse.builder()
			.code(emotionCode.name())
			.label(resolveLabel(emotionCode))
			.iconKey("mongtory_" + emotionCode.name().toLowerCase())
			.build();
	}

	private String resolveLabel(EmotionCode emotionCode) {
		return switch (emotionCode) {
			case HAPPY -> "행복";
			case SAD -> "슬픔";
			case CALM -> "차분";
			case EXCITED -> "신남";
			case TIRED -> "피곤";
		};
	}
}
