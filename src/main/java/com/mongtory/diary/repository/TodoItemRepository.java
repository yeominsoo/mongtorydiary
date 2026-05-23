package com.mongtory.diary.repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.mongtory.diary.domain.todo.TodoItem;
import com.mongtory.diary.domain.user.UserAccount;

public interface TodoItemRepository extends JpaRepository<TodoItem, Long> {

	List<TodoItem> findAllByOwnerAndDueDateBetweenOrderByDueDateAscCreatedAtAsc(
		UserAccount owner,
		LocalDate from,
		LocalDate to
	);

	List<TodoItem> findAllByOwnerAndDueDate(UserAccount owner, LocalDate dueDate);

	Optional<TodoItem> findByIdAndOwner(Long id, UserAccount owner);

	boolean existsByIdAndOwner(Long id, UserAccount owner);
}
