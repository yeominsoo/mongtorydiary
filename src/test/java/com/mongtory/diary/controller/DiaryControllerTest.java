package com.mongtory.diary.controller;

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
class DiaryControllerTest {

	@Autowired
	private MockMvc mockMvc;

	@Test
	void diaryListReturnsWrappedSummaries() throws Exception {
		final MvcResult loginResult = mockMvc.perform(
				post("/api/v1/auth/login")
					.contentType(MediaType.APPLICATION_JSON)
					.content("""
						{
						  "email": "user@example.com",
						  "password": "password123!"
						}
						""")
			)
			.andExpect(status().isOk())
			.andReturn();
		final String accessToken = JsonPath.read(
			loginResult.getResponse().getContentAsString(),
			"$.data.accessToken"
		);

		mockMvc.perform(
				get("/api/v1/diaries")
					.header("Authorization", "Bearer " + accessToken)
			)
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.success").value(true))
			.andExpect(jsonPath("$.data[0].title").value("오늘의 기록"));
	}
}
