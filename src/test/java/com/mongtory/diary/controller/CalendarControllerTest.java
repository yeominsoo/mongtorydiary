package com.mongtory.diary.controller;

import static org.hamcrest.Matchers.nullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

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
}
