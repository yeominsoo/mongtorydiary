package com.mongtory.diary.service;

import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.mongtory.diary.domain.diary.DiaryEntry;
import com.mongtory.diary.domain.user.UserAccount;
import com.mongtory.diary.dto.calendar.CalendarDaySummaryResponse;
import com.mongtory.diary.dto.calendar.CalendarMonthResponse;
import com.mongtory.diary.repository.DiaryEntryRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CalendarService {

	private final DiaryEntryRepository diaryEntryRepository;

	public CalendarMonthResponse getMonth(UserAccount currentUser, int year, int month) {
		final LocalDate startDate = LocalDate.of(year, month, 1);
		final LocalDate endDate = startDate.withDayOfMonth(startDate.lengthOfMonth());
		final Map<LocalDate, List<DiaryEntry>> diariesByDate = diaryEntryRepository.findAllByOwnerAndEntryDateBetween(currentUser, startDate, endDate)
			.stream()
			.collect(Collectors.groupingBy(DiaryEntry::getEntryDate));

		return CalendarMonthResponse.builder()
			.year(year)
			.month(month)
			.days(
				diariesByDate.entrySet().stream()
					.map(entry -> toDaySummary(entry.getKey(), entry.getValue()))
					.sorted(Comparator.comparing(CalendarDaySummaryResponse::getDate))
					.toList()
			)
			.build();
	}

	private CalendarDaySummaryResponse toDaySummary(LocalDate date, List<DiaryEntry> diaryEntries) {
		final DiaryEntry latestEntry = diaryEntries.stream()
			.max(Comparator.comparing(DiaryEntry::getUpdatedAt))
			.orElseThrow();

		return CalendarDaySummaryResponse.builder()
			.date(date)
			.hasEntry(true)
			.emotionCode(latestEntry.getEmotionCode())
			.entryCount(diaryEntries.size())
			.build();
	}
}
