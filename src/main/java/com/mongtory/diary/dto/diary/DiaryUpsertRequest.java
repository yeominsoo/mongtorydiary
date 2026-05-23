package com.mongtory.diary.dto.diary;

import java.time.LocalDate;
import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class DiaryUpsertRequest {

	private LocalDate entryDate;
	private String title;
	private String content;
	private String emotionCode;
	private String locationName;
	private String weatherSummary;
	private List<String> imageUrls;
	private List<String> tags;
}
