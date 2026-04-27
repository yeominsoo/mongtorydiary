package com.mongtory.diary.common;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MissingRequestHeaderException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.server.ResponseStatusException;

@RestControllerAdvice
public class GlobalExceptionHandler {

	@ExceptionHandler(ResponseStatusException.class)
	public ResponseEntity<ApiResponse<Void>> handleResponseStatusException(ResponseStatusException exception) {
		final HttpStatus status = HttpStatus.valueOf(exception.getStatusCode().value());
		final String message = exception.getReason() == null ? status.getReasonPhrase() : exception.getReason();

		return ResponseEntity.status(status)
			.body(ApiResponse.error(message));
	}

	@ExceptionHandler(MissingRequestHeaderException.class)
	public ResponseEntity<ApiResponse<Void>> handleMissingRequestHeader(MissingRequestHeaderException exception) {
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
			.body(ApiResponse.error(exception.getHeaderName() + " header is required"));
	}

	@ExceptionHandler(MethodArgumentTypeMismatchException.class)
	public ResponseEntity<ApiResponse<Void>> handleMethodArgumentTypeMismatch(
		MethodArgumentTypeMismatchException exception
	) {
		return ResponseEntity.badRequest()
			.body(ApiResponse.error("Invalid request parameter"));
	}

	@ExceptionHandler(Exception.class)
	public ResponseEntity<ApiResponse<Void>> handleException(Exception exception) {
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
			.body(ApiResponse.error("Internal server error"));
	}
}
