package com.mongtory.diary.controller;

import static org.hamcrest.Matchers.nullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
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
class CalendarControllerTest {

	@Autowired
	private MockMvc mockMvc;

	@Test
	void calendarIncludesTodoCountsWithDiarySummaries() throws Exception {
		final String accessToken = signup("calendar-todo-" + UUID.randomUUID() + "@example.com");
		final long todoId = createTodo(accessToken, "2026-06-02", "캘린더 TODO");
		createDiary(accessToken, "2026-06-02", "캘린더 일기", "HAPPY");

		mockMvc.perform(
				put("/api/v1/todos/" + todoId)
					.header("Authorization", "Bearer " + accessToken)
					.contentType(MediaType.APPLICATION_JSON)
					.content("""
						{
						  "dueDate": "2026-06-02",
						  "content": "캘린더 TODO",
						  "completed": true
						}
						""")
			)
			.andExpect(status().isOk());

		mockMvc.perform(
				get("/api/v1/calendar?year=2026&month=6")
					.header("Authorization", "Bearer " + accessToken)
			)
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.data.days[0].date").value("2026-06-02"))
			.andExpect(jsonPath("$.data.days[0].entryCount").value(1))
			.andExpect(jsonPath("$.data.days[0].emotionCode").value("HAPPY"))
			.andExpect(jsonPath("$.data.days[0].todoCount").value(1))
			.andExpect(jsonPath("$.data.days[0].completedTodoCount").value(1));
	}

	@Test
	void calendarRejectsMissingYearWithWrappedError() throws Exception {
		final String accessToken = login("user@example.com", "password123!");

		mockMvc.perform(
				get("/api/v1/calendar?month=3")
					.header("Authorization", "Bearer " + accessToken)
			)
			.andExpect(status().isBadRequest())
			.andExpect(jsonPath("$.success").value(false))
			.andExpect(jsonPath("$.message").value("year parameter is required"))
			.andExpect(jsonPath("$.data").value(nullValue()));
	}

	@Test
	void calendarRejectsMissingMonthWithWrappedError() throws Exception {
		final String accessToken = login("user@example.com", "password123!");

		mockMvc.perform(
				get("/api/v1/calendar?year=2026")
					.header("Authorization", "Bearer " + accessToken)
			)
			.andExpect(status().isBadRequest())
			.andExpect(jsonPath("$.success").value(false))
			.andExpect(jsonPath("$.message").value("month parameter is required"))
			.andExpect(jsonPath("$.data").value(nullValue()));
	}

	@Test
	void calendarRejectsInvalidMonthWithWrappedError() throws Exception {
		final String accessToken = login("user@example.com", "password123!");

		mockMvc.perform(
				get("/api/v1/calendar?year=2026&month=13")
					.header("Authorization", "Bearer " + accessToken)
			)
			.andExpect(status().isBadRequest())
			.andExpect(jsonPath("$.success").value(false))
			.andExpect(jsonPath("$.message").value("Invalid calendar month"))
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

	private long createTodo(String accessToken, String dueDate, String content) throws Exception {
		final MvcResult result = mockMvc.perform(
				post("/api/v1/todos")
					.header("Authorization", "Bearer " + accessToken)
					.contentType(MediaType.APPLICATION_JSON)
					.content("""
						{
						  "dueDate": "%s",
						  "content": "%s"
						}
						""".formatted(dueDate, content))
			)
			.andExpect(status().isOk())
			.andReturn();

		final Number id = JsonPath.read(result.getResponse().getContentAsString(), "$.data.id");
		return id.longValue();
	}

	private void createDiary(String accessToken, String entryDate, String title, String emotionCode) throws Exception {
		mockMvc.perform(
				post("/api/v1/diaries")
					.header("Authorization", "Bearer " + accessToken)
					.contentType(MediaType.APPLICATION_JSON)
					.content("""
						{
						  "entryDate": "%s",
						  "title": "%s",
						  "content": "캘린더 요약 검증 본문입니다.",
						  "emotionCode": "%s",
						  "imageUrls": []
						}
						""".formatted(entryDate, title, emotionCode))
			)
			.andExpect(status().isOk());
	}

	private String signup(String email) throws Exception {
		final MvcResult signupResult = mockMvc.perform(
				post("/api/v1/auth/signup")
					.contentType(MediaType.APPLICATION_JSON)
					.content("""
						{
						  "email": "%s",
						  "password": "password123!",
						  "nickname": "캘린더 유저"
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
}
