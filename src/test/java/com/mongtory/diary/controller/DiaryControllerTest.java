package com.mongtory.diary.controller;

import static org.hamcrest.Matchers.hasItem;
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
class DiaryControllerTest {

	@Autowired
	private MockMvc mockMvc;

	@Test
	void diaryListReturnsWrappedSummaries() throws Exception {
		final String accessToken = login("user@example.com", "password123!");

		mockMvc.perform(
				get("/api/v1/diaries")
					.header("Authorization", "Bearer " + accessToken)
			)
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.success").value(true))
			.andExpect(jsonPath("$.data[*].title").value(hasItem("오늘의 기록")));
	}

	@Test
	void diaryListRejectsInvalidAccessToken() throws Exception {
		mockMvc.perform(
				get("/api/v1/diaries")
					.header("Authorization", "Bearer invalid-access-token")
			)
			.andExpect(status().isUnauthorized())
			.andExpect(jsonPath("$.success").value(false))
			.andExpect(jsonPath("$.message").value("Invalid access token"))
			.andExpect(jsonPath("$.data").value(nullValue()));
	}

	@Test
	void diaryDetailRejectsOtherUserEntry() throws Exception {
		final String ownerAccessToken = login("user@example.com", "password123!");
		final long diaryId = createDiary(ownerAccessToken);
		final String otherAccessToken = signup("other-diary-user-" + UUID.randomUUID() + "@example.com");

		mockMvc.perform(
				get("/api/v1/diaries/{diaryId}", diaryId)
					.header("Authorization", "Bearer " + otherAccessToken)
			)
			.andExpect(status().isNotFound())
			.andExpect(jsonPath("$.success").value(false))
			.andExpect(jsonPath("$.message").value("Diary entry not found"))
			.andExpect(jsonPath("$.data").value(nullValue()));
	}

	@Test
	void diaryListRejectsMissingAuthorizationHeaderWithWrappedError() throws Exception {
		mockMvc.perform(get("/api/v1/diaries"))
			.andExpect(status().isUnauthorized())
			.andExpect(jsonPath("$.success").value(false))
			.andExpect(jsonPath("$.message").value("Authorization header is required"))
			.andExpect(jsonPath("$.data").value(nullValue()));
	}

	private String login(String email, String password) throws Exception {
		final MvcResult loginResult = mockMvc.perform(
				post("/api/v1/auth/login")
					.contentType(MediaType.APPLICATION_JSON)
					.content("""
						{
						  "email": "%s",
						  "password": "%s"
						}
						""".formatted(email, password))
			)
			.andExpect(status().isOk())
			.andReturn();

		return JsonPath.read(
			loginResult.getResponse().getContentAsString(),
			"$.data.accessToken"
		);
	}

	private String signup(String email) throws Exception {
		final MvcResult signupResult = mockMvc.perform(
				post("/api/v1/auth/signup")
					.contentType(MediaType.APPLICATION_JSON)
					.content("""
						{
						  "email": "%s",
						  "password": "password123!",
						  "nickname": "다른유저"
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

	private long createDiary(String accessToken) throws Exception {
		final MvcResult createResult = mockMvc.perform(
				post("/api/v1/diaries")
					.header("Authorization", "Bearer " + accessToken)
					.contentType(MediaType.APPLICATION_JSON)
					.content("""
						{
						  "entryDate": "2026-04-28",
						  "title": "소유권 검증 일기",
						  "content": "다른 사용자가 볼 수 없어야 한다.",
						  "emotionCode": "CALM",
						  "imageUrls": []
						}
						""")
			)
			.andExpect(status().isOk())
			.andReturn();

		return ((Number) JsonPath.read(
			createResult.getResponse().getContentAsString(),
			"$.data.id"
		)).longValue();
	}
}
