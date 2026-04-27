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
		final LocalDate entryDate = requireEntryDate(request);
		final String title = requireText(request.getTitle(), "Diary title is required");
		final String content = requireText(request.getContent(), "Diary content is required");
		final String emotionCode = requireText(request.getEmotionCode(), "Diary emotion code is required");

		final DiaryEntry diaryEntry = DiaryEntry.builder()
			.entryDate(entryDate)
			.title(title)
			.content(content)
			.emotionCode(normalizeEmotionCode(emotionCode))
			.owner(currentUser)
			.imageUrls(copyImageUrls(request.getImageUrls()))
			.build();

		return toDetailResponse(diaryEntryRepository.save(diaryEntry));
	}

	public DiaryDetailResponse updateDiary(UserAccount currentUser, Long diaryId, DiaryUpsertRequest request) {
		final DiaryEntry diaryEntry = getDiaryEntry(currentUser, diaryId);
		final LocalDate entryDate = requireEntryDate(request);
		final String title = requireText(request.getTitle(), "Diary title is required");
		final String content = requireText(request.getContent(), "Diary content is required");
		final String emotionCode = requireText(request.getEmotionCode(), "Diary emotion code is required");

		diaryEntry.update(
			entryDate,
			title,
			content,
			normalizeEmotionCode(emotionCode),
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

	private LocalDate requireEntryDate(DiaryUpsertRequest request) {
		if (request.getEntryDate() == null) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Diary entry date is required");
		}

		return request.getEntryDate();
	}

	private String requireText(String value, String message) {
		if (value == null || value.isBlank()) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, message);
		}

		return value.trim();
	}

	private String normalizeEmotionCode(String emotionCode) {
		return emotionCode.trim().toUpperCase();
	}
}
