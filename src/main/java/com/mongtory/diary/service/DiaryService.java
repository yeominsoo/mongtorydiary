package com.mongtory.diary.service;

import java.time.DateTimeException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

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

	public List<DiarySummaryResponse> getDiaries(
		UserAccount currentUser,
		LocalDate from,
		LocalDate to,
		String emotion,
		String query,
		String tag
	) {
		final String normalizedQuery = normalizeSearchTerm(query);
		final String normalizedTag = normalizeTagForFilter(tag);

		return diaryEntryRepository.findAllByOwner(currentUser).stream()
			.filter(entry -> from == null || !entry.getEntryDate().isBefore(from))
			.filter(entry -> to == null || !entry.getEntryDate().isAfter(to))
			.filter(entry -> emotion == null || emotion.isBlank() || entry.getEmotionCode().equalsIgnoreCase(emotion))
			.filter(entry -> normalizedQuery == null || containsQuery(entry, normalizedQuery))
			.filter(entry -> normalizedTag == null || containsTag(entry, normalizedTag))
			.sorted(
				Comparator.comparing(DiaryEntry::getEntryDate).reversed()
					.thenComparing(DiaryEntry::getUpdatedAt, Comparator.reverseOrder())
			)
			.map(this::toSummaryResponse)
			.toList();
	}

	public List<DiarySummaryResponse> getMemoriesOnDate(UserAccount currentUser, int month, int day) {
		validateMonthDay(month, day);
		final int currentYear = LocalDate.now().getYear();

		return diaryEntryRepository.findAllByOwner(currentUser).stream()
			.filter(entry -> entry.getEntryDate().getYear() < currentYear)
			.filter(entry -> entry.getEntryDate().getMonthValue() == month)
			.filter(entry -> entry.getEntryDate().getDayOfMonth() == day)
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
			.tags(normalizeTags(request.getTags()))
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
			copyImageUrls(request.getImageUrls()),
			normalizeTags(request.getTags())
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
			.tags(List.copyOf(diaryEntry.getTags()))
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
			.tags(List.copyOf(diaryEntry.getTags()))
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
		return emotionCode.trim().toUpperCase(Locale.ROOT);
	}

	private String normalizeSearchTerm(String value) {
		return value == null || value.isBlank()
			? null
			: value.trim().toLowerCase(Locale.ROOT);
	}

	private boolean containsQuery(DiaryEntry diaryEntry, String normalizedQuery) {
		return diaryEntry.getTitle().toLowerCase(Locale.ROOT).contains(normalizedQuery)
			|| diaryEntry.getContent().toLowerCase(Locale.ROOT).contains(normalizedQuery)
			|| diaryEntry.getTags().stream()
				.map(tag -> tag.toLowerCase(Locale.ROOT))
				.anyMatch(tag -> tag.contains(normalizedQuery));
	}

	private String normalizeTagForFilter(String value) {
		if (value == null || value.isBlank()) {
			return null;
		}

		return stripLeadingHash(value.trim()).toLowerCase(Locale.ROOT);
	}

	private boolean containsTag(DiaryEntry diaryEntry, String normalizedTag) {
		return diaryEntry.getTags().stream()
			.map(tag -> tag.toLowerCase(Locale.ROOT))
			.anyMatch(tag -> tag.equals(normalizedTag));
	}

	private List<String> normalizeTags(List<String> tags) {
		if (tags == null || tags.isEmpty()) {
			return new ArrayList<>();
		}

		final Set<String> normalizedTags = new LinkedHashSet<>();
		for (String tag : tags) {
			if (tag == null || tag.isBlank()) {
				continue;
			}

			final String normalizedTag = stripLeadingHash(tag.trim());
			if (normalizedTag.isBlank()) {
				continue;
			}
			if (normalizedTag.length() > 40) {
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Diary tag must be 40 characters or less");
			}

			normalizedTags.add(normalizedTag);
			if (normalizedTags.size() > 8) {
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Diary tags must be 8 or fewer");
			}
		}

		return new ArrayList<>(normalizedTags);
	}

	private String stripLeadingHash(String value) {
		String normalizedValue = value;
		while (normalizedValue.startsWith("#")) {
			normalizedValue = normalizedValue.substring(1).trim();
		}
		return normalizedValue;
	}

	private void validateMonthDay(int month, int day) {
		try {
			LocalDate.of(2000, month, day);
		} catch (DateTimeException exception) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid memory date");
		}
	}
}
