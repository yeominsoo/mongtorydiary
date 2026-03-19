package com.mongtory.diary.service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.springframework.stereotype.Service;

@Service
public class PasswordHashService {

	public String hash(String rawValue) {
		if (rawValue == null || rawValue.isBlank()) {
			throw new IllegalArgumentException("Password is required");
		}

		try {
			final MessageDigest digest = MessageDigest.getInstance("SHA-256");
			final byte[] hashedBytes = digest.digest(rawValue.getBytes(StandardCharsets.UTF_8));
			return toHex(hashedBytes);
		} catch (NoSuchAlgorithmException exception) {
			throw new IllegalStateException("SHA-256 algorithm is not available", exception);
		}
	}

	public boolean matches(String rawValue, String hashedValue) {
		return hash(rawValue).equals(hashedValue);
	}

	private String toHex(byte[] bytes) {
		final StringBuilder builder = new StringBuilder(bytes.length * 2);

		for (byte currentByte : bytes) {
			builder.append(String.format("%02x", currentByte));
		}

		return builder.toString();
	}
}
