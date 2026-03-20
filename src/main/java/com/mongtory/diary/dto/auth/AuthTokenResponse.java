package com.mongtory.diary.dto.auth;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class AuthTokenResponse {

	private final String accessToken;
	private final String refreshToken;
	private final UserSummaryResponse user;
}
