package com.mongtory.diary.service;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.mongtory.diary.domain.user.UserAccount;
import com.mongtory.diary.repository.UserAccountRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuthenticatedUserService {

	private final UserAccountRepository userAccountRepository;

	public UserAccount getRequiredUser(String authorizationHeader) {
		final String accessToken = extractBearerToken(authorizationHeader);

		return userAccountRepository.findByAccessToken(accessToken)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid access token"));
	}

	private String extractBearerToken(String authorizationHeader) {
		if (authorizationHeader == null || authorizationHeader.isBlank()) {
			throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Authorization header is required");
		}

		if (!authorizationHeader.startsWith("Bearer ")) {
			throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Bearer token is required");
		}

		final String accessToken = authorizationHeader.substring("Bearer ".length()).trim();

		if (accessToken.isEmpty()) {
			throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Access token is required");
		}

		return accessToken;
	}
}
