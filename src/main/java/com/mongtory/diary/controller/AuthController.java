package com.mongtory.diary.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mongtory.diary.common.ApiResponse;
import com.mongtory.diary.dto.auth.AuthTokenResponse;
import com.mongtory.diary.dto.auth.LoginRequest;
import com.mongtory.diary.dto.auth.RefreshTokenRequest;
import com.mongtory.diary.dto.auth.SignupRequest;
import com.mongtory.diary.service.AuthService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

	private final AuthService authService;

	@PostMapping("/signup")
	public ApiResponse<AuthTokenResponse> signup(@RequestBody SignupRequest request) {
		return ApiResponse.ok(authService.signup(request));
	}

	@PostMapping("/login")
	public ApiResponse<AuthTokenResponse> login(@RequestBody LoginRequest request) {
		return ApiResponse.ok(authService.login(request));
	}

	@PostMapping("/refresh")
	public ApiResponse<AuthTokenResponse> refresh(@RequestBody RefreshTokenRequest request) {
		return ApiResponse.ok(authService.refresh(request));
	}
}
