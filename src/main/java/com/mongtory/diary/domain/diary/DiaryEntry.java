package com.mongtory.diary.domain.diary;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.mongtory.diary.domain.user.UserAccount;

import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OrderColumn;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "diary_entries")
@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class DiaryEntry {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(nullable = false)
	private LocalDate entryDate;

	@Column(nullable = false)
	private String title;

	@Column(nullable = false, length = 4000)
	private String content;

	@Column(nullable = false, length = 32)
	private String emotionCode;

	@ManyToOne(fetch = FetchType.LAZY, optional = false)
	@JoinColumn(name = "owner_id", nullable = false)
	private UserAccount owner;

	@ElementCollection(fetch = FetchType.EAGER)
	@CollectionTable(name = "diary_entry_images", joinColumns = @JoinColumn(name = "diary_entry_id"))
	@OrderColumn(name = "display_order")
	@Column(name = "image_url", nullable = false, length = 1000)
	@Builder.Default
	private List<String> imageUrls = new ArrayList<>();

	@ElementCollection(fetch = FetchType.EAGER)
	@CollectionTable(name = "diary_entry_tags", joinColumns = @JoinColumn(name = "diary_entry_id"))
	@OrderColumn(name = "display_order")
	@Column(name = "tag", nullable = false, length = 40)
	@Builder.Default
	private List<String> tags = new ArrayList<>();

	@Column(nullable = false, updatable = false)
	private LocalDateTime createdAt;

	@Column(nullable = false)
	private LocalDateTime updatedAt;

	public void update(
		LocalDate entryDate,
		String title,
		String content,
		String emotionCode,
		List<String> imageUrls,
		List<String> tags
	) {
		this.entryDate = entryDate;
		this.title = title;
		this.content = content;
		this.emotionCode = emotionCode;
		this.imageUrls = imageUrls == null ? new ArrayList<>() : new ArrayList<>(imageUrls);
		this.tags = tags == null ? new ArrayList<>() : new ArrayList<>(tags);
	}

	@PrePersist
	void onCreate() {
		final LocalDateTime now = LocalDateTime.now();
		createdAt = now;
		updatedAt = now;
		if (imageUrls == null) {
			imageUrls = new ArrayList<>();
		}
		if (tags == null) {
			tags = new ArrayList<>();
		}
	}

	@PreUpdate
	void onUpdate() {
		updatedAt = LocalDateTime.now();
		if (imageUrls == null) {
			imageUrls = new ArrayList<>();
		}
		if (tags == null) {
			tags = new ArrayList<>();
		}
	}
}
