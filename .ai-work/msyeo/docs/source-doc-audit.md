# 소스-문서 정합성 점검

## 점검 목적
핸드오프 문서를 읽어 현재까지 작업 범위를 확인하고, handoff를 제외한 프로젝트 문서가 실제 소스와 다른 부분을 최신화했다.

## 점검 기준
- 기준 브랜치: `feature/ai-workspace-docs`
- 점검 일자: 2026-04-28
- 비교 대상 소스:
  - `src/main/java/com/mongtory/diary`
  - `src/main/resources/application.properties`
  - `src/test/java/com/mongtory/diary`
  - `mobile-flutter/lib`
- `mobile-flutter/pubspec.yaml`
- `frontend/src`, `frontend/package.json`
- `.ai-work/msyeo/docs/pm-collaboration-board.md`
- 비교 대상 문서:
  - `.ai-work/msyeo/docs/` 아래 handoff를 제외한 문서

## 확인한 실제 소스 상태
### 백엔드
- 인증 경로는 `/api/v1/auth/signup`, `/api/v1/auth/login`, `/api/v1/auth/refresh`다.
- 캘린더 경로는 `/api/v1/calendar?year=&month=`다.
- 일기 경로는 `/api/v1/diaries`이며 목록/상세/생성/수정/삭제가 있다.
- 감정 목록 경로는 `/api/v1/emotions`다.
- 일기와 캘린더 API는 `Authorization: Bearer <accessToken>`이 필요하다.
- access/refresh token은 JWT가 아니라 `UserAccount`에 저장되는 임시 문자열이다.
- DB는 SQLite 파일 `mongtory.db`를 사용한다.
- `GlobalExceptionHandler`가 추가되어 주요 예외를 `ApiResponse<Void>` 형태로 감싼다. 다만 누락 query parameter, malformed JSON body, 유효하지 않은 캘린더 `year/month` 같은 세부 요청 검증 케이스는 추가 확인이 필요하다.

### Flutter
- `flutter_riverpod`, `http` 기반이다.
- `DATA_SOURCE_MODE=mock|remote`, `API_BASE_URL`로 데이터 소스를 전환한다.
- remote datasource는 로그인, 일기 목록/상세, 캘린더 월 조회, 감정 목록을 호출한다.
- 회원가입, 토큰 재발급, 일기 생성/수정/삭제 repository 계약과 화면 플로우는 아직 없다.
- 로그인 화면은 이메일/비밀번호 입력 폼과 시드 계정 `user@example.com / password123!` 자동 입력 버튼을 제공한다.
- 캘린더 조회는 현재 provider에서 `2026년 3월`로 고정되어 있다.
- `web/` 타깃이 추가되어 Flutter web-server 실행 이력이 있다.

### frontend
- `frontend/`는 React + TypeScript + Vite 초기 프로토타입이다.
- `App.tsx`는 단순 안내 화면이고 Redux store는 빈 reducer 골격이다.
- 기능 개발의 중심은 아니다.

## 발견한 문서 차이와 조치
- `api-contract.md`가 과거 초안 경로인 `/api/v1/auth/sign-up`, `/api/v1/auth/sign-in`, `/api/v1/calendar/monthly`를 사용하고 있었다.
  - 조치: 실제 경로인 `/signup`, `/login`, `/refresh`, `/calendar` 기준으로 전체 갱신했다.
- `api-contract.md`의 DTO 명칭과 필드가 실제 백엔드/Flutter DTO와 달랐다.
  - 조치: `AuthTokenResponse`, `DiarySummaryResponse`, `DiaryDetailResponse`, `CalendarMonthResponse`, `EmotionTypeResponse` 기준으로 정리했다.
- `planning.md`가 영어 문서이고 React/Vite 중심 UI 표현이 남아 있었다.
  - 조치: 한글 문서로 재작성하고 Flutter 앱 중심 계획으로 갱신했다.
- `project-status.md`, `project-analysis.md`, `session-continuity.md`, `multiwindow-dev-prep.md`가 Flutter 구현 범위를 다소 넓게 표현하고 있었다.
  - 조치: 실제 구현 범위를 로그인/목록/상세/캘린더/감정 목록 중심으로 좁혀 명시하고, 미구현 항목을 분리했다.
- `pm-collaboration-board.md`가 API 계약 정합성 작업을 아직 대기 상태로 표현하고 있었다.
  - 조치: API 계약 1차 정합성 점검 완료 상태와 `source-doc-audit.md` 산출물을 반영했다.
- 루트 `docs/`에 새 문서가 다시 생긴 상태였다.
  - 조치: `windows-flutter-app-guide.md`를 `.ai-work/msyeo/docs/`로 이동하고 handoff 내용은 기존 `.ai-work/msyeo/docs/handoff/2026-04-28.md`에 병합했다.

## 현재까지 작업 완료 범위
- 백엔드 API/DTO/서비스/Repository 골격
- SQLite 기반 사용자/일기 저장 구조
- 임시 토큰 기반 로그인과 사용자 식별
- 사용자 소유 일기/캘린더 조회
- Flutter 앱 기본 화면과 Riverpod 상태 계층
- Flutter mock/remote datasource와 repository 계층
- Flutter web 타깃 추가와 web-server 실행 이력
- `.ai-work/msyeo/docs/` 단일 문서 루트 정리

## 다음 작업 준비
1. 백엔드 서버 실행 후 시드 계정 로그인 확인
2. Flutter remote 모드로 로그인, 일기 목록/상세, 캘린더, 감정 목록 확인
3. API 오류 응답이 Flutter `ApiClient`에서 안전하게 처리되는지 점검하고, 누락 query parameter와 malformed JSON 같은 오류 케이스를 백엔드 테스트로 고정
4. Flutter 로그인 입력 폼 구현
5. Flutter 일기 생성/수정/삭제 repository 계약과 화면 플로우 구현
6. 백엔드 인증/소유권 검증 테스트 보강

## 검증 상태
이번 문서 최신화 작업에서는 백엔드/Flutter 테스트를 새로 실행하지 않았다. 과거 handoff 기준으로 Maven 테스트와 Flutter analyze/test 통과 이력은 있다.
