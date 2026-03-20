package com.mongtory.diary.service;

import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.mongtory.diary.domain.user.UserAccount;
import com.mongtory.diary.dto.auth.AuthTokenResponse;
import com.mongtory.diary.dto.auth.LoginRequest;
import com.mongtory.diary.dto.auth.RefreshTokenRequest;
import com.mongtory.diary.dto.auth.SignupRequest;
import com.mongtory.diary.dto.auth.UserSummaryResponse;
import com.mongtory.diary.repository.UserAccountRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuthService {

	private final UserAccountRepository userAccountRepository;
	private final PasswordHashService passwordHashService;

	public AuthTokenResponse signup(SignupRequest request) {
		final String email = normalizeEmail(request.getEmail());

		if (userAccountRepository.existsByEmail(email)) {
			throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already exists");
		}

		final UserAccount userAccount = userAccountRepository.save(
			UserAccount.builder()
				.email(email)
				.passwordHash(passwordHashService.hash(request.getPassword()))
				.nickname(normalizeNickname(request.getNickname()))
				.build()
		);

		return issueTokens(userAccount);
	}

	public AuthTokenResponse login(LoginRequest request) {
		final UserAccount userAccount = userAccountRepository.findByEmail(normalizeEmail(request.getEmail()))
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid email or password"));

		if (!passwordHashService.matches(request.getPassword(), userAccount.getPasswordHash())) {
			throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid email or password");
		}

		return issueTokens(userAccount);
	}

	public AuthTokenResponse refresh(RefreshTokenRequest request) {
		final UserAccount userAccount = userAccountRepository.findByRefreshToken(normalizeRefreshToken(request.getRefreshToken()))
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid refresh token"));

		return issueTokens(userAccount);
	}

	private AuthTokenResponse issueTokens(UserAccount userAccount) {
		final String accessToken = generateToken("access");
		final String refreshToken = generateToken("refresh");

		userAccount.updateTokens(accessToken, refreshToken);
		userAccountRepository.save(userAccount);

		return AuthTokenResponse.builder()
			.accessToken(accessToken)
			.refreshToken(refreshToken)
			.user(
				UserSummaryResponse.builder()
					.id(userAccount.getId())
					.email(userAccount.getEmail())
					.nickname(userAccount.getNickname())
					.build()
			)
			.build();
	}

	private String normalizeEmail(String email) {
		if (email == null || email.isBlank()) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Email is required");
		}

		return email.trim().toLowerCase();
	}

	private String generateToken(String prefix) {
		return prefix + "-" + UUID.randomUUID();
	}

	private String normalizeNickname(String nickname) {
		if (nickname == null || nickname.isBlank()) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nickname is required");
		}

		return nickname.trim();
	}

	private String normalizeRefreshToken(String refreshToken) {
		if (refreshToken == null || refreshToken.isBlank()) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Refresh token is required");
		}

		return refreshToken.trim();
	}
}
