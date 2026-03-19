package com.mongtory.diary.dto.emotion;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class EmotionTypeResponse {

	private final String code;
	private final String label;
	private final String iconKey;
}
