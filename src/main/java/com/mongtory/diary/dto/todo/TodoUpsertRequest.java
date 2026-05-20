package com.mongtory.diary.dto.todo;

import java.time.LocalDate;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class TodoUpsertRequest {

	private LocalDate dueDate;
	private String content;
	private Boolean completed;
}
