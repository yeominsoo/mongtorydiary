# Mongtory Diary Flutter App

이 디렉토리는 Mongtory Diary의 메인 모바일 앱 작업 공간이다.

## 목표
- iOS/Android 공통 Flutter 앱 개발
- 안드로이드 홈 위젯 및 iOS 위젯 확장 준비
- Spring Boot 백엔드 API 연동

## 기본 구조
- `lib/core`: 공통 설정, 상수, 유틸, 딥링크
- `lib/data`: API client, repository 구현, 로컬 저장소
- `lib/domain`: 핵심 도메인 모델
- `lib/application`: 상태 관리, 유스케이스
- `lib/presentation`: 화면, 컴포넌트, 라우팅
- `test`: Flutter 테스트

현재는 `flutter create --platforms=android,ios` 기준으로 실제 프로젝트 초기화까지 완료된 상태다.

## 현재 포함된 항목
- `lib/main.dart`
- `lib/app.dart`
- `lib/core/router/app_routes.dart`
- `lib/core/theme/app_theme.dart`
- `lib/application/providers/app_providers.dart`
- `lib/application/session/session_state.dart`
- `lib/application/session/session_controller.dart`
- `lib/application/navigation/home_tab.dart`
- `lib/application/navigation/home_tab_controller.dart`
- `lib/domain/models/*.dart`
- `lib/domain/repositories/*.dart`
- `lib/data/dto/*.dart`
- `lib/data/datasources/mock/*.dart`
- `lib/data/repositories/*.dart`
- `lib/data/mappers/*.dart`
- `lib/presentation/screens/diary/diary_home_screen.dart`
- `lib/presentation/screens/calendar/calendar_screen.dart`
- `lib/presentation/screens/profile/profile_screen.dart`
- `lib/presentation/screens/sign_in_screen.dart`
- `lib/presentation/screens/home_shell_screen.dart`
- `lib/presentation/screens/startup_screen.dart`
- `lib/presentation/widgets/section_card.dart`
- `pubspec.yaml`
- `android/`
- `ios/`
- `test/`

## 다음 작업
- 앱 화면 구조를 `presentation/application/domain/data/core` 기준으로 계속 확장
- Riverpod 기반 상태 계층 확장
- API 계약에 맞춘 domain/dto 모델 확장
- 백엔드 API 연동 구조 추가
- repository와 mock datasource 계층 추가
- mock repository를 실제 API repository로 교체
- Diary, Calendar, Profile를 기능별 위젯과 상태 단위로 추가 세분화
- Android/iOS 위젯 확장 구조 설계

## 실행 모드
기본값은 `mock` 데이터 소스다. 원격 API를 붙이려면 `dart-define`으로 모드를 전환한다.

```bash
/home/msyeo/mongtorydiary/.tooling/flutter-sdk/bin/flutter run \
  --dart-define=DATA_SOURCE_MODE=remote \
  --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

- Android Emulator 기준 기본 API 주소는 `http://10.0.2.2:8080`
- iOS Simulator 또는 macOS 환경에서는 필요 시 `http://localhost:8080`로 바꿔서 실행
