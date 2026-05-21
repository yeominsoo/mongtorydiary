package com.mongtory.diary.dto.diary;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class DiaryImageUploadResponse {

	private final String url;
	private final String originalFilename;
	private final String contentType;
	private final long size;
}
