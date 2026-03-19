package com.mongtory.diary.service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.mongtory.diary.domain.diary.DiaryEntry;
import com.mongtory.diary.domain.user.UserAccount;
import com.mongtory.diary.dto.diary.DiaryDetailResponse;
import com.mongtory.diary.dto.diary.DiarySummaryResponse;
import com.mongtory.diary.dto.diary.DiaryUpsertRequest;
import com.mongtory.diary.repository.DiaryEntryRepository;

import lombok.RequiredArgsConstructor;

@Service
	@RequiredArgsConstructor
public class DiaryService {

	private final DiaryEntryRepository diaryEntryRepository;

	public List<DiarySummaryResponse> getDiaries(UserAccount currentUser, LocalDate from, LocalDate to, String emotion) {
		return diaryEntryRepository.findAllByOwner(currentUser).stream()
			.filter(entry -> from == null || !entry.getEntryDate().isBefore(from))
			.filter(entry -> to == null || !entry.getEntryDate().isAfter(to))
			.filter(entry -> emotion == null || emotion.isBlank() || entry.getEmotionCode().equalsIgnoreCase(emotion))
			.sorted(
				Comparator.comparing(DiaryEntry::getEntryDate).reversed()
					.thenComparing(DiaryEntry::getUpdatedAt, Comparator.reverseOrder())
			)
			.map(this::toSummaryResponse)
			.toList();
	}

	public DiaryDetailResponse getDiary(UserAccount currentUser, Long diaryId) {
		return toDetailResponse(getDiaryEntry(currentUser, diaryId));
	}

	public DiaryDetailResponse createDiary(UserAccount currentUser, DiaryUpsertRequest request) {
		final DiaryEntry diaryEntry = DiaryEntry.builder()
			.entryDate(request.getEntryDate())
			.title(request.getTitle())
			.content(request.getContent())
			.emotionCode(normalizeEmotionCode(request.getEmotionCode()))
			.owner(currentUser)
			.imageUrls(copyImageUrls(request.getImageUrls()))
			.build();

		return toDetailResponse(diaryEntryRepository.save(diaryEntry));
	}

	public DiaryDetailResponse updateDiary(UserAccount currentUser, Long diaryId, DiaryUpsertRequest request) {
		final DiaryEntry diaryEntry = getDiaryEntry(currentUser, diaryId);

		diaryEntry.update(
			request.getEntryDate(),
			request.getTitle(),
			request.getContent(),
			normalizeEmotionCode(request.getEmotionCode()),
			copyImageUrls(request.getImageUrls())
		);

		return toDetailResponse(diaryEntryRepository.save(diaryEntry));
	}

	public void deleteDiary(UserAccount currentUser, Long diaryId) {
		if (!diaryEntryRepository.existsByIdAndOwner(diaryId, currentUser)) {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Diary entry not found");
		}

		diaryEntryRepository.deleteById(diaryId);
	}

	private DiaryEntry getDiaryEntry(UserAccount currentUser, Long diaryId) {
		return diaryEntryRepository.findByIdAndOwner(diaryId, currentUser)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Diary entry not found"));
	}

	private DiarySummaryResponse toSummaryResponse(DiaryEntry diaryEntry) {
		final String thumbnailUrl = diaryEntry.getImageUrls().isEmpty() ? null : diaryEntry.getImageUrls().get(0);

		return DiarySummaryResponse.builder()
			.id(diaryEntry.getId())
			.entryDate(diaryEntry.getEntryDate())
			.title(diaryEntry.getTitle())
			.emotionCode(diaryEntry.getEmotionCode())
			.thumbnailUrl(thumbnailUrl)
			.createdAt(diaryEntry.getCreatedAt())
			.updatedAt(diaryEntry.getUpdatedAt())
			.build();
	}

	private DiaryDetailResponse toDetailResponse(DiaryEntry diaryEntry) {
		return DiaryDetailResponse.builder()
			.id(diaryEntry.getId())
			.entryDate(diaryEntry.getEntryDate())
			.title(diaryEntry.getTitle())
			.content(diaryEntry.getContent())
			.emotionCode(diaryEntry.getEmotionCode())
			.imageUrls(List.copyOf(diaryEntry.getImageUrls()))
			.createdAt(diaryEntry.getCreatedAt())
			.updatedAt(diaryEntry.getUpdatedAt())
			.build();
	}

	private List<String> copyImageUrls(List<String> imageUrls) {
		return imageUrls == null ? new ArrayList<>() : new ArrayList<>(imageUrls);
	}

	private String normalizeEmotionCode(String emotionCode) {
		if (emotionCode == null || emotionCode.isBlank()) {
			return "CALM";
		}

		return emotionCode.trim().toUpperCase();
	}
}
