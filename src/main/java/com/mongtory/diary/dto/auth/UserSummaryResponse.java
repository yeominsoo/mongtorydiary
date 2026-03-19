package com.mongtory.diary.dto.auth;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class UserSummaryResponse {

	private final Long id;
	private final String email;
	private final String nickname;
}
