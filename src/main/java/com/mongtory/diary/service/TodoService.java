package com.mongtory.diary.service;

import java.time.LocalDate;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.mongtory.diary.domain.todo.TodoItem;
import com.mongtory.diary.domain.user.UserAccount;
import com.mongtory.diary.dto.todo.TodoItemResponse;
import com.mongtory.diary.dto.todo.TodoUpsertRequest;
import com.mongtory.diary.repository.TodoItemRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TodoService {

	private final TodoItemRepository todoItemRepository;

	public List<TodoItemResponse> getTodos(UserAccount currentUser, LocalDate from, LocalDate to) {
		final LocalDate startDate = from == null ? LocalDate.now() : from;
		final LocalDate endDate = to == null ? startDate : to;

		if (endDate.isBefore(startDate)) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Todo date range is invalid");
		}

		return todoItemRepository.findAllByOwnerAndDueDateBetweenOrderByDueDateAscCreatedAtAsc(
				currentUser,
				startDate,
				endDate
			)
			.stream()
			.map(this::toResponse)
			.toList();
	}

	public TodoItemResponse createTodo(UserAccount currentUser, TodoUpsertRequest request) {
		final TodoItem todoItem = TodoItem.builder()
			.owner(currentUser)
			.dueDate(requireDueDate(request))
			.content(requireContent(request))
			.completed(request.getCompleted() != null && request.getCompleted())
			.build();

		return toResponse(todoItemRepository.save(todoItem));
	}

	public TodoItemResponse updateTodo(UserAccount currentUser, Long todoId, TodoUpsertRequest request) {
		final TodoItem todoItem = getTodoItem(currentUser, todoId);
		todoItem.update(
			requireDueDate(request),
			requireContent(request),
			request.getCompleted() != null && request.getCompleted()
		);

		return toResponse(todoItemRepository.save(todoItem));
	}

	public void deleteTodo(UserAccount currentUser, Long todoId) {
		if (!todoItemRepository.existsByIdAndOwner(todoId, currentUser)) {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Todo item not found");
		}

		todoItemRepository.deleteById(todoId);
	}

	private TodoItem getTodoItem(UserAccount currentUser, Long todoId) {
		return todoItemRepository.findByIdAndOwner(todoId, currentUser)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Todo item not found"));
	}

	private LocalDate requireDueDate(TodoUpsertRequest request) {
		if (request.getDueDate() == null) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Todo due date is required");
		}

		return request.getDueDate();
	}

	private String requireContent(TodoUpsertRequest request) {
		if (request.getContent() == null || request.getContent().isBlank()) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Todo content is required");
		}

		return request.getContent().trim();
	}

	private TodoItemResponse toResponse(TodoItem todoItem) {
		return TodoItemResponse.builder()
			.id(todoItem.getId())
			.dueDate(todoItem.getDueDate())
			.content(todoItem.getContent())
			.completed(todoItem.isCompleted())
			.createdAt(todoItem.getCreatedAt())
			.updatedAt(todoItem.getUpdatedAt())
			.build();
	}
}
