package com.mongtory.diary.controller;

import static org.hamcrest.Matchers.nullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.options;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
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

@SpringBootTest
@AutoConfigureMockMvc
class AuthControllerTest {

	@Autowired
	private MockMvc mockMvc;

	@Test
	void apiAllowsFlutterWebDevelopmentOrigin() throws Exception {
		mockMvc.perform(
				options("/api/v1/auth/login")
					.header("Origin", "http://192.168.75.194:30081")
					.header("Access-Control-Request-Method", "POST")
					.header("Access-Control-Request-Headers", "content-type,authorization")
			)
			.andExpect(status().isOk())
			.andExpect(header().string("Access-Control-Allow-Origin", "http://192.168.75.194:30081"));
	}

	@Test
	void loginReturnsWrappedResponse() throws Exception {
		mockMvc.perform(
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
			.andExpect(jsonPath("$.success").value(true))
			.andExpect(jsonPath("$.data.user.email").value("user@example.com"));
	}

	@Test
	void loginRejectsInvalidPassword() throws Exception {
		mockMvc.perform(
				post("/api/v1/auth/login")
					.contentType(MediaType.APPLICATION_JSON)
					.content("""
						{
						  "email": "user@example.com",
						  "password": "wrong-password"
						}
						""")
			)
			.andExpect(status().isUnauthorized())
			.andExpect(jsonPath("$.success").value(false))
			.andExpect(jsonPath("$.message").value("Invalid email or password"))
			.andExpect(jsonPath("$.data").value(nullValue()));
	}

	@Test
	void signupReturnsTokensForNewUser() throws Exception {
		final String email = "new-user-auth-" + UUID.randomUUID() + "@example.com";

		mockMvc.perform(
				post("/api/v1/auth/signup")
					.contentType(MediaType.APPLICATION_JSON)
					.content("""
						{
						  "email": "%s",
						  "password": "password123!",
						  "nickname": "신규유저"
						}
						""".formatted(email))
			)
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.success").value(true))
			.andExpect(jsonPath("$.data.accessToken").isNotEmpty())
			.andExpect(jsonPath("$.data.refreshToken").isNotEmpty())
			.andExpect(jsonPath("$.data.user.email").value(email));
	}

	@Test
	void refreshReturnsNewTokens() throws Exception {
		final String loginResponse = mockMvc.perform(
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
			.andReturn()
			.getResponse()
			.getContentAsString();
		final String refreshToken = JsonPath.read(loginResponse, "$.data.refreshToken");

		mockMvc.perform(
				post("/api/v1/auth/refresh")
					.contentType(MediaType.APPLICATION_JSON)
					.content("""
						{
						  "refreshToken": "%s"
						}
						""".formatted(refreshToken))
			)
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.success").value(true))
			.andExpect(jsonPath("$.data.accessToken").isNotEmpty())
			.andExpect(jsonPath("$.data.user.email").value("user@example.com"));
	}

	@Test
	void signupRejectsDuplicateEmailWithWrappedError() throws Exception {
		mockMvc.perform(
				post("/api/v1/auth/signup")
					.contentType(MediaType.APPLICATION_JSON)
					.content("""
						{
						  "email": "user@example.com",
						  "password": "password123!",
						  "nickname": "중복유저"
						}
						""")
			)
			.andExpect(status().isConflict())
			.andExpect(jsonPath("$.success").value(false))
			.andExpect(jsonPath("$.message").value("Email already exists"))
			.andExpect(jsonPath("$.data").value(nullValue()));
	}
}
