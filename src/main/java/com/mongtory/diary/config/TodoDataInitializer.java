package com.mongtory.diary.config;

import java.time.LocalDate;

import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import com.mongtory.diary.domain.todo.TodoItem;
import com.mongtory.diary.domain.user.UserAccount;
import com.mongtory.diary.repository.TodoItemRepository;
import com.mongtory.diary.repository.UserAccountRepository;

import lombok.RequiredArgsConstructor;

@Component
@Order(3)
@RequiredArgsConstructor
public class TodoDataInitializer implements CommandLineRunner {

	private final TodoItemRepository todoItemRepository;
	private final UserAccountRepository userAccountRepository;

	@Override
	public void run(String... args) {
		if (todoItemRepository.count() > 0) {
			return;
		}

		final UserAccount owner = userAccountRepository.findByEmail("user@example.com")
			.orElse(null);

		if (owner == null) {
			return;
		}

		todoItemRepository.save(
			TodoItem.builder()
				.owner(owner)
				.dueDate(LocalDate.now())
				.content("캘린더에서 오늘 할 일을 정리하기")
				.completed(false)
				.build()
		);
	}
}
