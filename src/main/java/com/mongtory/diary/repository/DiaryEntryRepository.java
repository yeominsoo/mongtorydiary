package com.mongtory.diary.repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.mongtory.diary.domain.diary.DiaryEntry;
import com.mongtory.diary.domain.user.UserAccount;

public interface DiaryEntryRepository extends JpaRepository<DiaryEntry, Long> {

	List<DiaryEntry> findAllByOwner(UserAccount owner);

	List<DiaryEntry> findAllByOwnerAndEntryDateBetween(UserAccount owner, LocalDate from, LocalDate to);

	Optional<DiaryEntry> findByIdAndOwner(Long id, UserAccount owner);

	boolean existsByIdAndOwner(Long id, UserAccount owner);
}
