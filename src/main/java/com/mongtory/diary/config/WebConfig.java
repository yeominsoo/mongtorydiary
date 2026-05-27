package com.mongtory.diary.config;

import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

	@Value("${mongtory.upload.root-dir:./data/uploads}")
	private String uploadRootDirectory;

	@Override
	public void addCorsMappings(CorsRegistry registry) {
		applyDevCors(registry.addMapping("/api/**"))
			.allowedMethods("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS");

		applyDevCors(registry.addMapping("/uploads/**"))
			.allowedMethods("GET", "OPTIONS");
	}

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		final Path uploadRootPath = Paths.get(uploadRootDirectory).toAbsolutePath().normalize();
		String uploadResourceLocation = uploadRootPath.toUri().toString();
		if (!uploadResourceLocation.endsWith("/")) {
			uploadResourceLocation += "/";
		}

		registry.addResourceHandler("/uploads/**")
			.addResourceLocations(uploadResourceLocation);
	}

	private CorsRegistration applyDevCors(CorsRegistration registration) {
		return registration
			.allowedOriginPatterns(
				"http://localhost:30080",
				"http://localhost:30081",
				"http://127.0.0.1:30080",
				"http://127.0.0.1:30081",
				"http://192.168.*.*:30080",
				"http://192.168.*.*:30081",
				"http://10.*.*.*:30080",
				"http://10.*.*.*:30081",
				"http://172.*.*.*:30080",
				"http://172.*.*.*:30081"
			)
			.allowedHeaders("*")
			.maxAge(3600);
	}
}
