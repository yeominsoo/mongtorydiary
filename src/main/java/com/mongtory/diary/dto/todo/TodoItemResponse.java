package com.mongtory.diary.dto.todo;

import java.time.LocalDate;
import java.time.LocalDateTime;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class TodoItemResponse {

	private final Long id;
	private final LocalDate dueDate;
	private final String content;
	private final boolean completed;
	private final LocalDateTime createdAt;
	private final LocalDateTime updatedAt;
}
