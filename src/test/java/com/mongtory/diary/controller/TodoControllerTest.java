package com.mongtory.diary.controller;

import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.nullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
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
class TodoControllerTest {

	@Autowired
	private MockMvc mockMvc;

	@Test
	void todoCrudUsesCurrentUserOnly() throws Exception {
		final String accessToken = signup("todo-owner-" + UUID.randomUUID() + "@example.com");
		final String otherAccessToken = signup("todo-other-" + UUID.randomUUID() + "@example.com");

		final long todoId = createTodo(accessToken, "2026-05-21", "출품 준비 캘린더 TODO");
		createTodo(otherAccessToken, "2026-05-21", "다른 사용자 TODO");

		mockMvc.perform(
				get("/api/v1/todos?from=2026-05-21&to=2026-05-21")
					.header("Authorization", "Bearer " + accessToken)
			)
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.success").value(true))
			.andExpect(jsonPath("$.data", hasSize(1)))
			.andExpect(jsonPath("$.data[0].id").value(todoId))
			.andExpect(jsonPath("$.data[0].content").value("출품 준비 캘린더 TODO"))
			.andExpect(jsonPath("$.data[0].completed").value(false));

		mockMvc.perform(
				put("/api/v1/todos/" + todoId)
					.header("Authorization", "Bearer " + accessToken)
					.contentType(MediaType.APPLICATION_JSON)
					.content("""
						{
						  "dueDate": "2026-05-21",
						  "content": "출품 준비 캘린더 TODO 완료",
						  "completed": true
						}
						""")
			)
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.data.content").value("출품 준비 캘린더 TODO 완료"))
			.andExpect(jsonPath("$.data.completed").value(true));

		mockMvc.perform(
				delete("/api/v1/todos/" + todoId)
					.header("Authorization", "Bearer " + accessToken)
			)
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.success").value(true));

		mockMvc.perform(
				get("/api/v1/todos?from=2026-05-21&to=2026-05-21")
					.header("Authorization", "Bearer " + accessToken)
			)
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.data", hasSize(0)));
	}

	@Test
	void todoRejectsInvalidRangeWithWrappedError() throws Exception {
		final String accessToken = signup("todo-range-" + UUID.randomUUID() + "@example.com");

		mockMvc.perform(
				get("/api/v1/todos?from=2026-05-22&to=2026-05-21")
					.header("Authorization", "Bearer " + accessToken)
			)
			.andExpect(status().isBadRequest())
			.andExpect(jsonPath("$.success").value(false))
			.andExpect(jsonPath("$.message").value("Todo date range is invalid"))
			.andExpect(jsonPath("$.data").value(nullValue()));
	}

	@Test
	void todoRejectsBlankContentWithWrappedError() throws Exception {
		final String accessToken = signup("todo-blank-" + UUID.randomUUID() + "@example.com");

		mockMvc.perform(
				post("/api/v1/todos")
					.header("Authorization", "Bearer " + accessToken)
					.contentType(MediaType.APPLICATION_JSON)
					.content("""
						{
						  "dueDate": "2026-05-21",
						  "content": " "
						}
						""")
			)
			.andExpect(status().isBadRequest())
			.andExpect(jsonPath("$.success").value(false))
			.andExpect(jsonPath("$.message").value("Todo content is required"))
			.andExpect(jsonPath("$.data").value(nullValue()));
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

	private String signup(String email) throws Exception {
		final MvcResult signupResult = mockMvc.perform(
				post("/api/v1/auth/signup")
					.contentType(MediaType.APPLICATION_JSON)
					.content("""
						{
						  "email": "%s",
						  "password": "password123!",
						  "nickname": "TODO 유저"
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
