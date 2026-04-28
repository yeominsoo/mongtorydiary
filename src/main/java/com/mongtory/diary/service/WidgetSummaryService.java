package com.mongtory.diary.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.mongtory.diary.domain.diary.DiaryEntry;
import com.mongtory.diary.domain.user.UserAccount;
import com.mongtory.diary.dto.widget.WidgetTodaySummaryResponse;
import com.mongtory.diary.repository.DiaryEntryRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class WidgetSummaryService {

	private final DiaryEntryRepository diaryEntryRepository;

	public WidgetTodaySummaryResponse getTodaySummary(UserAccount currentUser, LocalDate date) {
		final var diariesOnDate = diaryEntryRepository.findAllByOwnerAndEntryDate(currentUser, date);
		final DiaryEntry latestDiary = diariesOnDate.stream()
			.max(Comparator.comparing(DiaryEntry::getUpdatedAt))
			.orElse(null);
		final Set<LocalDate> entryDates = diaryEntryRepository.findAllByOwner(currentUser).stream()
			.map(DiaryEntry::getEntryDate)
			.filter(entryDate -> !entryDate.isAfter(date))
			.collect(Collectors.toSet());
		final LocalDate lastEntryDate = entryDates.stream()
			.max(Comparator.naturalOrder())
			.orElse(null);

		return WidgetTodaySummaryResponse.builder()
			.date(date)
			.hasTodayEntry(!diariesOnDate.isEmpty())
			.todayEntryCount(diariesOnDate.size())
			.latestDiaryId(latestDiary == null ? null : latestDiary.getId())
			.latestDiaryTitle(latestDiary == null ? null : latestDiary.getTitle())
			.latestEmotionCode(latestDiary == null ? null : latestDiary.getEmotionCode())
			.streakDays(countStreakDays(entryDates, lastEntryDate))
			.lastEntryDate(lastEntryDate)
			.message(buildMessage(!diariesOnDate.isEmpty()))
			.updatedAt(LocalDateTime.now())
			.build();
	}

	private int countStreakDays(Set<LocalDate> entryDates, LocalDate lastEntryDate) {
		if (lastEntryDate == null) {
			return 0;
		}

		int streakDays = 0;
		LocalDate cursor = lastEntryDate;
		while (entryDates.contains(cursor)) {
			streakDays++;
			cursor = cursor.minusDays(1);
		}

		return streakDays;
	}

	private String buildMessage(boolean hasEntry) {
		if (hasEntry) {
			return "오늘도 몽토리와 기록했어요.";
		}

		return "오늘의 몽토리 기록을 기다리고 있어요.";
	}
}
