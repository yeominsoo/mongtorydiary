package com.mongtory.diary.config;

import java.time.LocalDate;
import java.util.List;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import com.mongtory.diary.domain.diary.DiaryEntry;
import com.mongtory.diary.domain.user.UserAccount;
import com.mongtory.diary.repository.DiaryEntryRepository;
import com.mongtory.diary.repository.UserAccountRepository;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class DiaryDataInitializer implements CommandLineRunner {

	private final DiaryEntryRepository diaryEntryRepository;
	private final UserAccountRepository userAccountRepository;

	@Override
	public void run(String... args) {
		if (diaryEntryRepository.count() > 0) {
			return;
		}

		final UserAccount owner = userAccountRepository.findByEmail("user@example.com")
			.orElse(null);

		if (owner == null) {
			return;
		}

		diaryEntryRepository.save(
			DiaryEntry.builder()
				.entryDate(LocalDate.now())
				.title("오늘의 기록")
				.content("몽토리와 함께 산책을 했다.")
				.emotionCode("CALM")
				.owner(owner)
				.imageUrls(List.of())
				.build()
		);
	}
}
