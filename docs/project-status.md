# 프로젝트 상태 문서

## 현재 개요
Mongtory Diary는 캐릭터 기반 감정형 일기 서비스를 목표로 하는 풀스택 프로젝트다. 현재 저장소는 Spring Boot 백엔드와 초기 `frontend/` React 프로젝트가 함께 있는 구조지만, 제품 방향은 Flutter 앱 중심으로 재정리되고 있다.

## 현재 디렉토리 구조
- `src/main/java/com/mongtory/diary`: 백엔드 Java 소스
- `src/main/resources/application.properties`: 백엔드 설정
- `src/test/java/com/mongtory/diary`: 백엔드 테스트
- `frontend/`: 초기 React + TypeScript + Vite 프론트엔드 골격
- `mobile-flutter/`: Flutter 앱 초안 디렉토리
- `docs/planning.md`: 제품 비전 및 로드맵
- `docs/platform-direction.md`: Flutter 중심 플랫폼 방향
- `docs/flutter-architecture.md`: Flutter 기준 최종 아키텍처 및 저장소 구조
- `docs/api-spec.md`: 백엔드-앱 공용 API/DTO 초안
- `docs/session-continuity.md`: 새 세션용 상세 인수인계 문서

## 현재 구현 상태
백엔드는 `MongtoryDiaryApplication.java` 중심의 초기 부트스트랩 상태에서 한 단계 진전되어, `ApiResponse`, 인증/감정/일기/캘린더 DTO와 컨트롤러, 서비스 골격이 추가된 상태다. `DiaryEntry` 엔티티, `DiaryEntryRepository`, `UserAccount` 엔티티, `UserAccountRepository`, 기본 시드 데이터 초기화가 추가되어 일기 CRUD와 월간 캘린더 조회, 회원가입/로그인/토큰 재발급은 SQLite 기반으로 옮겨가기 시작했다. 현재 인증은 JWT가 아니라 DB에 저장된 임시 access/refresh token 기반이며, 일기와 캘린더 API는 `Authorization: Bearer <token>` 기준으로 현재 사용자를 식별한다. Spring Security는 아직 도입하지 않았다.

프론트엔드는 `frontend/src/App.tsx`에 단순 안내 화면이 있고, `frontend/src/store/index.ts`에 Redux Toolkit 스토어 초기 골격만 존재한다. 기능 구현 수준이 매우 낮아 지금 시점은 Flutter 기반 모바일 구조로 전환하기에 적절하다.

`mobile-flutter/`에는 실제 Flutter 프로젝트가 초기화되어 있으며 `pubspec.yaml`, `android/`, `ios/` 기본 파일이 생성된 상태다. `lib/main.dart`, `lib/app.dart`, `lib/core/theme/app_theme.dart`, `lib/core/router/app_routes.dart`와 `startup`, `sign-in`, `home shell` 화면, 그리고 `diary`, `calendar`, `profile` 개별 화면까지 분리해 MVP 화면 골격을 확장했다. 상태 계층은 `flutter_riverpod`와 `application/providers`, `application/session`, `application/navigation` 구조로 시작했고, `domain/models`, `domain/repositories`, `data/dto`, `data/mappers`, `data/datasources/mock`, `data/datasources/remote`, `data/repositories`, `core/network`도 `docs/api-spec.md` 기준으로 1차 정리 완료 상태다. 현재는 `DATA_SOURCE_MODE`와 `API_BASE_URL` `dart-define`으로 `mock/remote` 전환이 가능하며, `remote` 모드에서는 로그인 후 세션 access token을 일기/캘린더 API 요청 헤더에 붙인다. 로그인 화면과 일기/캘린더/프로필 화면은 데이터 소스 상태, 기본 API 오류, 실제 응답 항목 일부를 표시한다.

로컬 검증 기준으로 Flutter 앱은 Riverpod 추가 이후에도 `flutter pub get`, `flutter analyze`, `flutter test`를 통과한 상태다. 백엔드도 `JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 bash ./mvnw -Dmaven.repo.local=/home/msyeo/mongtorydiary/.m2 test` 기준 `BUILD SUCCESS`를 확인했다.

## 현재 기술 스택
- Backend: Java 17, Spring Boot, Maven Wrapper
- Current Frontend Prototype: React 18, TypeScript, Vite, Redux Toolkit
- Target App Frontend: Flutter
- Target Widget Layer: Android App Widget 또는 Glance, iOS WidgetKit
- 예정 DB: SQLite

## 확정된 운영 원칙
- 작업 문서는 한글로 작성
- 신규 문서는 UTF-8 인코딩 사용
- 관련 파일 외 수정 금지
- 변경 범위 최소화
- 의미 있는 작업 세션마다 `docs/handoff/YYYY-MM-DD.md` 작성

## 권장 아키텍처 방향
앱은 Flutter를 메인으로 두고, 웹은 별도 프론트엔드로 분리하는 방향이 적절하다. 현재 `frontend/`는 참고용 초기 프로토타입으로 보고, 앱 본체는 `mobile-flutter/` 같은 별도 구조로 전환하는 것이 바람직하다.

위젯 지원이 목표이므로, 최종적으로는 아래 구조가 바람직하다.

- 웹: 별도 FE
- 앱: Flutter
- 위젯: Android App Widget 또는 Glance, iOS WidgetKit
- 공통: API 계약, 딥링크 규칙, 서버 응답 모델

## 다음 우선 작업
1. Flutter `mock` repository를 실제 HTTP API repository 흐름으로 전환하고 provider 선택 정책을 정리
2. 백엔드 인증 토큰 전략을 임시 UUID 토큰에서 실제 세션/JWT 전략으로 고도화
3. 사용자-일기 관계와 소유권 검증을 추가
4. Diary, Calendar, Profile 각 화면을 기능 위젯과 상태 단위로 세분화
5. Riverpod 상태를 실제 인증/API/위젯 설정 흐름에 연결
6. 위젯용 데이터 모델과 딥링크 규칙 설계
7. Android/iOS 위젯 플랫폼 설정 상세 설계

## 주의 사항
현재 Git 작업 트리에는 본 세션 이전부터 수정 중인 파일이 존재할 수 있다. 향후 작업 시 요청 범위와 직접 관련된 파일만 수정하고, 문서와 코드 변경을 분리해서 관리하는 것이 안전하다.

새 세션에서 컨텍스트를 복구해야 할 때는 `AGENTS.md` 다음으로 `docs/session-continuity.md`를 먼저 보는 것을 권장한다.

백엔드 테스트는 `JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 bash ./mvnw -Dmaven.repo.local=/home/msyeo/mongtorydiary/.m2 test` 기준 통과했다. Flutter도 `HOME=/home/msyeo/mongtorydiary/.tmp_flutter_home /home/msyeo/mongtorydiary/.tooling/flutter-sdk/bin/flutter analyze`, `... flutter test` 기준 통과했다. 이후 기능 추가 시 같은 명령으로 재검증하면 된다.
