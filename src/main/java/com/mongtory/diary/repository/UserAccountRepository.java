package com.mongtory.diary.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.mongtory.diary.domain.user.UserAccount;

public interface UserAccountRepository extends JpaRepository<UserAccount, Long> {

	boolean existsByEmail(String email);

	Optional<UserAccount> findByEmail(String email);

	Optional<UserAccount> findByAccessToken(String accessToken);

	Optional<UserAccount> findByRefreshToken(String refreshToken);
}
