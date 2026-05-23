# Mongtory Diary 프로젝트 분석

## 분석 기준
- 기준 브랜치: `feature/ai-workspace-docs`
- 생성 기준: `origin/master` 최신 fetch 이후 생성
- 분석 일자: 2026-04-28
- 목적: 바이브코딩 세션에서 빠르게 프로젝트 맥락을 복구하고, 다음 작업을 일관되게 선택하기 위한 요약 문서

## 제품 방향
Mongtory Diary는 감정형 일기 서비스를 목표로 한다. 현재 방향은 Spring Boot 백엔드와 Flutter 모바일 앱을 중심으로 하고, 웹은 앱과 분리된 별도 프론트엔드로 운영하는 구조다. 위젯은 앱 본체를 대체하는 화면이 아니라 오늘 상태, 감정, 작성 여부, 연속 작성일 같은 요약 정보를 보여주고 앱으로 진입시키는 보조 채널로 설계한다.

## 저장소 구조 요약
- `src/main/java/com/mongtory/diary`: Spring Boot 백엔드 소스
- `src/main/resources`: 백엔드 설정
- `src/test/java/com/mongtory/diary`: 백엔드 테스트
- `mobile-flutter/`: Flutter 모바일 앱 작업 공간
- `frontend/`: 초기 React 프로토타입, 현재 제품 방향에서는 참고용
- `.ai-work/msyeo/docs/`: 기획, API, 아키텍처, 상태, handoff, AI 분석 문서를 통합 관리하는 문서 루트

## 백엔드 현재 상태
백엔드는 Spring Boot 3.2.0, Java 17, Maven Wrapper를 사용한다. 기본 계층은 `Controller -> Service -> Repository` 형태로 잡혀 있고, API 응답은 `ApiResponse<T>`로 통일하는 방향이다.

현재 구현된 주요 영역은 다음과 같다.
- 인증: `/api/v1/auth/signup`, `/api/v1/auth/login`, `/api/v1/auth/refresh` 컨트롤러와 DB 저장 임시 토큰 서비스
- 사용자: `UserAccount` 엔티티와 repository
- 일기: `DiaryEntry` 엔티티, CRUD 관련 DTO, controller/service/repository
- 캘린더: `/api/v1/calendar?year=&month=` 월간 캘린더 조회 DTO와 controller/service
- 감정: 감정 코드 enum, 감정 목록 DTO와 controller/service
- 초기 데이터: `DiaryDataInitializer`, `UserDataInitializer`

현재 인증은 Spring Security/JWT 기반으로 완성된 상태가 아니라 `access-UUID`, `refresh-UUID` 형식의 임시 토큰과 DB 저장 흐름을 기반으로 한다. 일기와 캘린더는 `Authorization: Bearer <accessToken>`으로 현재 사용자를 조회한다. 추후 실제 운영 수준으로 올리려면 토큰 전략, 비밀번호 정책, 권한 검증, 전역 예외 응답 규격을 함께 정리해야 한다.

## Flutter 현재 상태
`mobile-flutter/`에는 Flutter 프로젝트가 초기화되어 있으며 `flutter_riverpod`와 `http`를 사용한다. 앱 계층은 `presentation`, `application`, `domain`, `data`, `core`를 기준으로 분리되어 있다.

현재 확인되는 주요 구성은 다음과 같다.
- `core/config`: `DATA_SOURCE_MODE`, `API_BASE_URL` 같은 실행 설정
- `core/network`: API client와 예외 모델
- `application/providers`: mock/remote repository 선택 진입점
- `application/session`: 로그인 세션 상태 관리
- `application/navigation`: 홈 탭 상태
- `domain/models`, `domain/repositories`: 앱 내부 도메인 모델과 repository 계약
- `data/dto`, `data/mappers`: 백엔드 API DTO와 도메인 변환
- `data/datasources/mock`, `data/datasources/remote`: mock/remote 데이터 소스
- `presentation/screens`: startup, sign-in, home shell, diary, calendar, profile 화면

현재 앱은 MVP 화면 골격과 데이터 계층 분리가 진행된 상태다. remote datasource가 실제 사용하는 API는 로그인, 일기 목록/상세, 캘린더 월 조회, 감정 목록이다. 아직 회원가입, 토큰 재발급, 일기 생성/수정/삭제 repository 계약과 화면 플로우는 없다. 로그인 화면은 시드 계정으로 임시 로그인하는 버튼 중심이며, 캘린더 조회는 provider에서 `2026년 3월`로 고정되어 있다.

## 문서 상태
문서 체계는 비교적 잘 잡혀 있다.
- `AGENTS.md`: 저장소 작업 규칙
- `.ai-work/msyeo/docs/README.md`: 문서 루트 구성과 운영 원칙
- `.ai-work/msyeo/docs/project-status.md`: 현재 구조, 구현 범위, 미해결 이슈, 다음 우선순위
- `.ai-work/msyeo/docs/project-analysis.md`: 바이브코딩용 프로젝트 분석과 추천 작업 순서
- `.ai-work/msyeo/docs/platform-direction.md`: Flutter 중심 플랫폼 방향
- `.ai-work/msyeo/docs/flutter-architecture.md`: Flutter 구조 방향
- `.ai-work/msyeo/docs/api-spec.md`, `.ai-work/msyeo/docs/api-contract.md`: API/DTO 계약
- `.ai-work/msyeo/docs/session-continuity.md`: 새 세션 인수인계용 상세 문맥
- `.ai-work/msyeo/docs/handoff/`: 날짜별 작업 종료 기록

중요한 작업 후에는 `.ai-work/msyeo/docs/project-status.md`와 `.ai-work/msyeo/docs/handoff/YYYY-MM-DD.md`를 함께 갱신해야 한다.

2026-04-28 소스 대조에서 `api-contract.md`의 과거 초안 경로와 DTO 명칭을 실제 코드 기준으로 갱신했다. 실제 경로는 `/api/v1/auth/signup`, `/api/v1/auth/login`, `/api/v1/auth/refresh`, `/api/v1/diaries`, `/api/v1/calendar`, `/api/v1/emotions`다.

## 현재 리스크와 미해결 지점
- 인증이 임시 토큰 기반이라 운영 수준 보안과 만료/재발급 정책이 미완성이다.
- 전역 예외 응답이 `ApiResponse`로 표준화되어 있지 않아 Flutter 오류 파싱과 어긋날 수 있다.
- 일기 소유권 검증은 서비스에 기본 구현되어 있으나 테스트 보강이 필요하다.
- Flutter 원격 데이터 모드는 연결 골격이 있으나 회원가입, 토큰 재발급, 작성/수정/삭제, 세션 만료 UX가 미완성이다.
- 캘린더는 기록이 있는 날짜만 내려주며, Flutter는 현재 `2026년 3월`을 고정 조회한다.
- 위젯용 요약 데이터 API, 딥링크 규칙, 네이티브 위젯 구현 전략은 아직 설계 단계다.
- `frontend/`는 현재 제품 방향과 거리가 있어, 향후 별도 웹 FE로 둘지 제거/보존할지 정책을 명확히 해야 한다.

## 추천 작업 순서
1. Flutter remote 모드로 백엔드 로그인, 일기 목록/상세, 캘린더, 감정 목록을 실제 실행 검증한다.
2. Flutter 로그인 화면을 실제 입력 폼으로 확장하고 세션 실패/만료 UX를 정리한다.
3. Flutter repository 계약과 화면에 일기 생성/수정/삭제 플로우를 추가한다.
4. 백엔드 인증/소유권 검증을 실제 서비스 기준으로 고도화하고 테스트를 보강한다.
5. 전역 오류 응답과 Flutter `ApiClient` 오류 파싱 규칙을 맞춘다.
6. 위젯용 요약 API와 딥링크 규칙을 문서화한다.
7. Android/iOS 위젯 구현을 앱 본체와 분리된 진입점으로 추가한다.

## 작업 시 체크포인트
- 백엔드 테스트는 `JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64` 기준으로 실행한다.
- Flutter 변경 시 `mobile-flutter/` 기준으로 `flutter analyze`, `flutter test`를 확인한다.
- 문서와 코드 변경은 가능한 한 목적별로 분리한다.
- 신규 문서는 루트 `docs/`가 아니라 `.ai-work/msyeo/docs/` 아래에 생성한다.
- 비밀값과 인증 정보는 `.ai-work/msyeo/docs/`에 기록하지 않는다.
