package com.mongtory.diary.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import com.mongtory.diary.domain.user.UserAccount;
import com.mongtory.diary.repository.UserAccountRepository;
import com.mongtory.diary.service.PasswordHashService;

import lombok.RequiredArgsConstructor;

@Component
@Order(1)
@RequiredArgsConstructor
public class UserDataInitializer implements CommandLineRunner {

	private final UserAccountRepository userAccountRepository;
	private final PasswordHashService passwordHashService;

	@Override
	public void run(String... args) {
		if (userAccountRepository.count() > 0) {
			return;
		}

		userAccountRepository.save(
			UserAccount.builder()
				.email("user@example.com")
				.passwordHash(passwordHashService.hash("password123!"))
				.nickname("몽토리유저")
				.accessToken("seed-access-token")
				.refreshToken("seed-refresh-token")
				.build()
		);
	}
}
