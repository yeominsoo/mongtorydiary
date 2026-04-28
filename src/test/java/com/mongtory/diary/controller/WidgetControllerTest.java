package com.mongtory.diary.controller;

import static org.hamcrest.Matchers.nullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.UUID;

import com.jayway.jsonpath.JsonPath;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

@SpringBootTest
@AutoConfigureMockMvc
class WidgetControllerTest {

	@Autowired
	private MockMvc mockMvc;

	@Test
	void todaySummaryReturnsLatestDiaryAndStreakForCurrentUser() throws Exception {
		final String accessToken = signup("widget-owner-" + UUID.randomUUID() + "@example.com");
		final String otherAccessToken = signup("widget-other-" + UUID.randomUUID() + "@example.com");
		final long latestDiaryId;

		createDiary(accessToken, "2026-04-26", "이틀 전 기록", "CALM");
		createDiary(accessToken, "2026-04-27", "어제 기록", "HAPPY");
		createDiary(accessToken, "2026-04-28", "오늘 첫 기록", "SAD");
		latestDiaryId = createDiary(accessToken, "2026-04-28", "오늘 최신 기록", "CALM");
		createDiary(otherAccessToken, "2026-04-28", "다른 사용자 기록", "ANGRY");

		mockMvc.perform(
				get("/api/v1/widgets/today-summary?date=2026-04-28")
					.header("Authorization", "Bearer " + accessToken)
			)
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.success").value(true))
			.andExpect(jsonPath("$.data.date").value("2026-04-28"))
			.andExpect(jsonPath("$.data.hasTodayEntry").value(true))
			.andExpect(jsonPath("$.data.todayEntryCount").value(2))
			.andExpect(jsonPath("$.data.latestDiaryId").value(latestDiaryId))
			.andExpect(jsonPath("$.data.latestDiaryTitle").value("오늘 최신 기록"))
			.andExpect(jsonPath("$.data.latestEmotionCode").value("CALM"))
			.andExpect(jsonPath("$.data.streakDays").value(3))
			.andExpect(jsonPath("$.data.lastEntryDate").value("2026-04-28"))
			.andExpect(jsonPath("$.data.updatedAt").exists());
	}

	@Test
	void todaySummaryReturnsEmptyStateForUserWithoutDiaries() throws Exception {
		final String accessToken = signup("widget-empty-" + UUID.randomUUID() + "@example.com");

		mockMvc.perform(
				get("/api/v1/widgets/today-summary?date=2026-04-28")
					.header("Authorization", "Bearer " + accessToken)
			)
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.success").value(true))
			.andExpect(jsonPath("$.data.hasTodayEntry").value(false))
			.andExpect(jsonPath("$.data.todayEntryCount").value(0))
			.andExpect(jsonPath("$.data.latestDiaryId").value(nullValue()))
			.andExpect(jsonPath("$.data.latestDiaryTitle").value(nullValue()))
			.andExpect(jsonPath("$.data.latestEmotionCode").value(nullValue()))
			.andExpect(jsonPath("$.data.streakDays").value(0))
			.andExpect(jsonPath("$.data.lastEntryDate").value(nullValue()));
	}

	@Test
	void todaySummaryRejectsInvalidAccessToken() throws Exception {
		mockMvc.perform(
				get("/api/v1/widgets/today-summary?date=2026-04-28")
					.header("Authorization", "Bearer invalid-access-token")
			)
			.andExpect(status().isUnauthorized())
			.andExpect(jsonPath("$.success").value(false))
			.andExpect(jsonPath("$.message").value("Invalid access token"))
			.andExpect(jsonPath("$.data").value(nullValue()));
	}

	private String signup(String email) throws Exception {
		final MvcResult signupResult = mockMvc.perform(
				post("/api/v1/auth/signup")
					.contentType(MediaType.APPLICATION_JSON)
					.content("""
						{
						  "email": "%s",
						  "password": "password123!",
						  "nickname": "위젯유저"
						}
						""".formatted(email))
			)
			.andExpect(status().isOk())
			.andReturn();

		return JsonPath.read(
			signupResult.getResponse().getContentAsString(),
			"$.data.accessToken"
		);
	}

	private long createDiary(String accessToken, String entryDate, String title, String emotionCode) throws Exception {
		final MvcResult createResult = mockMvc.perform(
				post("/api/v1/diaries")
					.header("Authorization", "Bearer " + accessToken)
					.contentType(MediaType.APPLICATION_JSON)
					.content("""
						{
						  "entryDate": "%s",
						  "title": "%s",
						  "content": "위젯 요약 검증 본문",
						  "emotionCode": "%s",
						  "imageUrls": []
						}
						""".formatted(entryDate, title, emotionCode))
			)
			.andExpect(status().isOk())
			.andReturn();

		return ((Number) JsonPath.read(
			createResult.getResponse().getContentAsString(),
			"$.data.id"
		)).longValue();
	}
}
