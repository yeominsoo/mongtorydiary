package com.mongtory.diary.service;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import com.mongtory.diary.domain.user.UserAccount;
import com.mongtory.diary.dto.diary.DiaryImageUploadResponse;

@Service
public class DiaryImageStorageService {

	private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "webp", "gif");
	private static final Map<String, String> EXTENSION_BY_CONTENT_TYPE = Map.of(
		"image/jpeg", "jpg",
		"image/png", "png",
		"image/webp", "webp",
		"image/gif", "gif"
	);

	private final Path uploadRootDirectory;
	private final long maxBytes;

	public DiaryImageStorageService(
		@Value("${mongtory.upload.root-dir:./data/uploads}") String uploadRootDirectory,
		@Value("${mongtory.upload.max-bytes:5242880}") long maxBytes
	) {
		this.uploadRootDirectory = Paths.get(uploadRootDirectory).toAbsolutePath().normalize();
		this.maxBytes = maxBytes;
	}

	public DiaryImageUploadResponse store(UserAccount owner, MultipartFile file) {
		validateFile(file);

		final String originalFilename = sanitizeOriginalFilename(file.getOriginalFilename());
		final String extension = resolveExtension(file, originalFilename);
		final String storedFilename = UUID.randomUUID() + "." + extension;
		final Path ownerDirectory = uploadRootDirectory.resolve("diary").resolve(owner.getId().toString()).normalize();
		final Path targetPath = ownerDirectory.resolve(storedFilename).normalize();

		if (!targetPath.startsWith(uploadRootDirectory)) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid image file path");
		}

		try {
			Files.createDirectories(ownerDirectory);
			try (InputStream inputStream = file.getInputStream()) {
				Files.copy(inputStream, targetPath, StandardCopyOption.REPLACE_EXISTING);
			}
		} catch (IOException exception) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Image upload failed");
		}

		return DiaryImageUploadResponse.builder()
			.url("/uploads/diary/%d/%s".formatted(owner.getId(), storedFilename))
			.originalFilename(originalFilename)
			.contentType(file.getContentType())
			.size(file.getSize())
			.build();
	}

	private void validateFile(MultipartFile file) {
		if (file == null || file.isEmpty()) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Image file is required");
		}
		if (file.getSize() > maxBytes) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Image file must be 5MB or less");
		}
	}

	private String sanitizeOriginalFilename(String originalFilename) {
		if (originalFilename == null || originalFilename.isBlank()) {
			return "diary-image";
		}

		return Paths.get(originalFilename).getFileName().toString();
	}

	private String resolveExtension(MultipartFile file, String originalFilename) {
		final String contentType = file.getContentType() == null
			? ""
			: file.getContentType().toLowerCase(Locale.ROOT);
		final String filenameExtension = extensionFromFilename(originalFilename);

		if (filenameExtension != null && ALLOWED_EXTENSIONS.contains(filenameExtension)) {
			return filenameExtension.equals("jpeg") ? "jpg" : filenameExtension;
		}
		if (EXTENSION_BY_CONTENT_TYPE.containsKey(contentType)) {
			return EXTENSION_BY_CONTENT_TYPE.get(contentType);
		}

		throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Only image files can be uploaded");
	}

	private String extensionFromFilename(String filename) {
		final int dotIndex = filename.lastIndexOf('.');
		if (dotIndex < 0 || dotIndex == filename.length() - 1) {
			return null;
		}

		return filename.substring(dotIndex + 1).toLowerCase(Locale.ROOT);
	}
}
