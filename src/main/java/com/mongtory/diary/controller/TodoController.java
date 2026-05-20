package com.mongtory.diary.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mongtory.diary.common.ApiResponse;
import com.mongtory.diary.domain.user.UserAccount;
import com.mongtory.diary.dto.todo.TodoItemResponse;
import com.mongtory.diary.dto.todo.TodoUpsertRequest;
import com.mongtory.diary.service.AuthenticatedUserService;
import com.mongtory.diary.service.TodoService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/todos")
@RequiredArgsConstructor
public class TodoController {

	private final TodoService todoService;
	private final AuthenticatedUserService authenticatedUserService;

	@GetMapping
	public ApiResponse<List<TodoItemResponse>> getTodos(
		@RequestHeader("Authorization") String authorizationHeader,
		@RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
		@RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to
	) {
		final UserAccount currentUser = authenticatedUserService.getRequiredUser(authorizationHeader);
		return ApiResponse.ok(todoService.getTodos(currentUser, from, to));
	}

	@PostMapping
	public ApiResponse<TodoItemResponse> createTodo(
		@RequestHeader("Authorization") String authorizationHeader,
		@RequestBody TodoUpsertRequest request
	) {
		final UserAccount currentUser = authenticatedUserService.getRequiredUser(authorizationHeader);
		return ApiResponse.ok(todoService.createTodo(currentUser, request));
	}

	@PutMapping("/{todoId}")
	public ApiResponse<TodoItemResponse> updateTodo(
		@RequestHeader("Authorization") String authorizationHeader,
		@PathVariable Long todoId,
		@RequestBody TodoUpsertRequest request
	) {
		final UserAccount currentUser = authenticatedUserService.getRequiredUser(authorizationHeader);
		return ApiResponse.ok(todoService.updateTodo(currentUser, todoId, request));
	}

	@DeleteMapping("/{todoId}")
	public ApiResponse<Void> deleteTodo(
		@RequestHeader("Authorization") String authorizationHeader,
		@PathVariable Long todoId
	) {
		final UserAccount currentUser = authenticatedUserService.getRequiredUser(authorizationHeader);
		todoService.deleteTodo(currentUser, todoId);
		return ApiResponse.ok(null);
	}
}
