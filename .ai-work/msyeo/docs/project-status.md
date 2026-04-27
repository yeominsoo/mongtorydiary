# 프로젝트 상태 문서

## 현재 개요
Mongtory Diary는 캐릭터 기반 감정형 일기 서비스를 목표로 하는 풀스택 프로젝트다. 현재 저장소는 Spring Boot 백엔드와 초기 `frontend/` React 프로젝트가 함께 있는 구조지만, 제품 방향은 Flutter 앱 중심으로 재정리되고 있다.

## 현재 디렉토리 구조
- `src/main/java/com/mongtory/diary`: 백엔드 Java 소스
- `src/main/resources/application.properties`: 백엔드 설정
- `src/test/java/com/mongtory/diary`: 백엔드 테스트
- `frontend/`: 초기 React + TypeScript + Vite 프론트엔드 골격
- `mobile-flutter/`: Flutter 앱 초안 디렉토리
- `.ai-work/msyeo/docs/README.md`: 문서 루트 구성과 운영 원칙
- `.ai-work/msyeo/docs/planning.md`: 제품 비전 및 로드맵
- `.ai-work/msyeo/docs/platform-direction.md`: Flutter 중심 플랫폼 방향
- `.ai-work/msyeo/docs/flutter-architecture.md`: Flutter 기준 최종 아키텍처 및 저장소 구조
- `.ai-work/msyeo/docs/api-spec.md`: 백엔드-앱 공용 API/DTO 초안
- `.ai-work/msyeo/docs/collaboration/master-flow.md`: PM/QA/FE/BE 협업 마스터 플로우
- `.ai-work/msyeo/docs/collaboration/requests.md`: 역할 간 요청 문서
- `.ai-work/msyeo/docs/collaboration/status.md`: 역할별 현황과 파일 잠금 문서
- `.ai-work/msyeo/docs/collaboration/responses.md`: 역할 간 응답 문서
- `.ai-work/msyeo/docs/collaboration/roles/`: PM/QA/FE/BE 역할별 요청, 수신함, 현황, 응답 문서
- `.ai-work/msyeo/docs/session-continuity.md`: 새 세션용 상세 인수인계 문서
- `.ai-work/msyeo/docs/project-analysis.md`: 바이브코딩 및 AI 보조 개발용 분석/작업 맥락 문서
- `.ai-work/msyeo/docs/delivery-roadmap.md`: 목표 달성을 위한 단계적 업무계획과 역할별 후속 요청
- `.ai-work/msyeo/docs/source-doc-audit.md`: 실제 소스와 문서 정합성 점검 결과
- `.ai-work/msyeo/docs/multiwindow-dev-prep.md`: 멀티 터미널 개발 역할 분담과 충돌 방지 기준 보조 문서
- `.ai-work/msyeo/docs/pm-collaboration-board.md`: 이전 PM 중심 협업 보조 문서
- `.ai-work/msyeo/docs/windows-flutter-app-guide.md`: 윈도우에서 Flutter 앱 타깃으로 확인하는 절차

## 현재 구현 상태
백엔드는 `MongtoryDiaryApplication.java` 중심의 초기 부트스트랩 상태에서 한 단계 진전되어, `ApiResponse`, 인증/감정/일기/캘린더 DTO와 컨트롤러, 서비스 골격이 추가된 상태다. `DiaryEntry` 엔티티, `DiaryEntryRepository`, `UserAccount` 엔티티, `UserAccountRepository`, 기본 시드 데이터 초기화가 추가되어 일기 CRUD와 월간 캘린더 조회, 회원가입/로그인/토큰 재발급은 SQLite 기반으로 옮겨가기 시작했다. 현재 인증은 JWT가 아니라 DB에 저장된 임시 access/refresh token 기반이며, 일기와 캘린더 API는 `Authorization: Bearer <token>` 기준으로 현재 사용자를 식별한다. Spring Security는 아직 도입하지 않았다.

프론트엔드는 `frontend/src/App.tsx`에 단순 안내 화면이 있고, `frontend/src/store/index.ts`에 Redux Toolkit 스토어 초기 골격만 존재한다. 기능 구현 수준이 매우 낮아 지금 시점은 Flutter 기반 모바일 구조로 전환하기에 적절하다.

`mobile-flutter/`에는 실제 Flutter 프로젝트가 초기화되어 있으며 `pubspec.yaml`, `android/`, `ios/`, `web/` 기본 파일이 생성된 상태다. `lib/main.dart`, `lib/app.dart`, `lib/core/theme/app_theme.dart`, `lib/core/router/app_routes.dart`와 `startup`, `sign-in`, `home shell` 화면, 그리고 `diary`, `calendar`, `profile` 개별 화면까지 분리해 MVP 화면 골격을 확장했다. 상태 계층은 `flutter_riverpod`와 `application/providers`, `application/session`, `application/navigation` 구조로 시작했고, `domain/models`, `domain/repositories`, `data/dto`, `data/mappers`, `data/datasources/mock`, `data/datasources/remote`, `data/repositories`, `core/network`도 `.ai-work/msyeo/docs/api-spec.md` 기준으로 1차 정리 완료 상태다. 현재는 `DATA_SOURCE_MODE`와 `API_BASE_URL` `dart-define`으로 `mock/remote` 전환이 가능하며, `remote` 모드에서는 로그인 후 세션 access token을 일기/캘린더 API 요청 헤더에 붙인다. Flutter remote datasource가 실제 호출하는 범위는 로그인, 일기 목록/상세/생성/수정/삭제, 캘린더 월 조회, 감정 목록이다. Flutter repository 계약과 화면에는 아직 회원가입, 토큰 재발급 플로우가 없다. 로그인 화면은 이메일/비밀번호 입력 폼, 입력 검증, 비밀번호 보기/숨기기, 로딩/오류 상태 UI, 시드 계정 입력 버튼을 제공한다. 일기 목록은 최근 일기 항목 탭으로 `DiaryDetailScreen`에 진입하며, 상세 화면은 `diaryDetailProvider`를 통해 상세 본문, 감정 코드, 날짜, 첨부 사진 빈 상태, 작성일/수정일 메타데이터를 표시한다. 홈 FAB에서 `DiaryEditScreen` 작성 화면으로 진입하고, 상세 화면에서 수정/삭제가 가능하다. 저장/삭제 후에는 일기 목록과 상세 provider를 갱신한다. 캘린더 provider는 현재 `2026년 3월`을 고정 조회한다. 2026-04-28에는 리눅스에서 Flutter 웹 개발 서버를 실행해 윈도우 브라우저에서 접속할 수 있도록 `web/` 타깃을 추가했고, `/tmp/flutter`의 Flutter 3.41.7 SDK로 `flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080` 실행을 확인했다.

2026-04-28 기준 바이브코딩용 작업 공간으로 `.ai-work/msyeo/` 경로를 추가했고, `project-analysis.md`에 프로젝트 구조, 백엔드/Flutter 상태, 리스크, 추천 작업 순서를 정리했다. `AGENTS.md`에도 해당 경로의 사용 원칙을 추가했다.

이후 문서 관리 위치를 `.ai-work/msyeo/docs/`로 통합했다. 기존 루트 `docs/`의 문서는 모두 `.ai-work/msyeo/docs/` 아래로 이동했고, `project-analysis.md`와 `multiwindow-dev-prep.md`도 같은 문서 루트로 옮겼다. 앞으로 새 문서는 루트 `docs/`가 아니라 `.ai-work/msyeo/docs/` 아래에 생성한다.

AI 세션 간 역할 부여 협업은 `.ai-work/msyeo/docs/collaboration/master-flow.md`를 공식 기준으로 한다. 현재 역할은 PM, QA, FE 개발자, BE 개발자 4개로 운영한다. 공통 `requests.md`, `status.md`, `responses.md`는 PM이 관리하는 인덱스이며, 실제 요청/현황/응답 작성은 `.ai-work/msyeo/docs/collaboration/roles/{pm|qa|fe|be}/` 아래 역할별 문서에서 수행한다. 기존 `.ai-work/msyeo/docs/pm-collaboration-board.md`와 `.ai-work/msyeo/docs/multiwindow-dev-prep.md`는 보조 문서다.
2026-04-28에는 `REQ-20260428-11` 기준으로 역할별 디렉토리와 요청자별 문서 체계를 도입했다. 이는 공통 문서 동시 편집 충돌을 줄이기 위한 프로세스 개선이다.
이후 역할별 작업 블록 handoff 규칙을 추가했다. 각 역할은 작업 블록 종료 시 자기 역할의 `handoff/YYYY-MM-DD.md`를 작성하고, 요청 처리 응답은 수행자와 요청자 양쪽 `responses.md`에 남긴다. PM은 `roles/pm/monitoring.md` 절차로 역할별 문서와 공통 인덱스의 상태 불일치, 응답 누락, handoff 누락, 파일 잠금 불일치를 확인한다.
PM은 모니터링 중 모든 역할 디렉토리 문서를 확인한다. 각 역할의 요청, 수신함, 현황, 응답, handoff를 모두 보고 소통 누락이나 상태 불일치를 찾으며, 문제가 반복되면 협업룰을 조정한다. 완료된 작업에 커밋이 필요하다고 판단하면 요청 ID 단위로 변경 파일을 취합해 직접 커밋한다. 커밋 전에는 수행자/요청자 responses, 역할별 handoff, 검증 결과 또는 미실행 사유를 확인하고 진행중 요청 파일을 제외한다.
모든 담당자는 매 작업 시작마다 변경된 룰이 없는지 확인해야 한다. 확인 대상은 `AGENTS.md`, `.ai-work/msyeo/docs/collaboration/master-flow.md`, `.ai-work/msyeo/docs/collaboration/roles/README.md`, 자기 역할 `inbox.md`, 자기 역할 `status.md`이며, 확인 후 자기 역할 `status.md`의 `룰 확인 기록`에 남긴다. PM은 완료 처리 전 이 기록 누락 여부를 모니터링한다.
초기 요청 완료 이후의 2차 업무도 준비했다. `REQ-20260428-06`은 QA remote 통합 회귀 검증, `REQ-20260428-07`은 FE 일기 목록에서 상세 진입 플로우, `REQ-20260428-08`은 BE 전역 예외 응답 표준화, `REQ-20260428-09`는 일기 생성/수정/삭제 연결 준비 요청이다.
2026-04-28에는 `.ai-work/msyeo/docs/delivery-roadmap.md`를 추가해 MVP 완료까지의 단계적 업무계획을 정리했다. 즉시 배분된 다음 요청은 BE `REQ-20260428-22` API 검증 오류 계약 보강, FE `REQ-20260428-23` 일기 생성/수정/삭제 Flutter 구현, QA `REQ-20260428-24` 일기 CRUD 회귀 시나리오 및 자동화 확장, PM `REQ-20260428-25` 위젯/딥링크 1차 설계 요청 준비다. FE 쪽은 기존 `REQ-20260428-09` 진행 기록이 있어 PM이 `REQ-20260428-23`과 범위 중복을 정리하면서 진행한다.

현재 이 대화의 AI 세션 역할은 PM이다. PM은 협업룰, 요청 인덱스, 역할별 문서 모니터링, 완료 작업 커밋 필요성 판단을 담당한다.

윈도우에서 Flutter 앱을 앱 형태로 확인하는 절차는 `.ai-work/msyeo/docs/windows-flutter-app-guide.md`에 정리했다. 윈도우 데스크톱 타깃은 `flutter config --enable-windows-desktop` 후 `flutter create --platforms windows .`, Android 에뮬레이터는 AVD 실행 후 `flutter run`으로 확인하는 흐름이다.

로컬 검증 기준으로 Flutter 앱은 Riverpod 추가 이후에도 `flutter pub get`, `flutter analyze`, `flutter test`를 통과한 상태다. 2026-04-28 개발 준비 점검에서는 `/tmp/flutter`와 `HOME=/tmp/mongtory-flutter-home` 기준으로 `flutter analyze`, `flutter test`를 통과했다. 백엔드는 Rocky 10 환경에서 Java 17 패키지가 제공되지 않아 OpenJDK 21 JDK를 설치했고, `bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test` 기준 `BUILD SUCCESS`를 확인했다. 테스트 중 시드 데이터 생성 순서가 불안정해 `UserDataInitializer`를 먼저, `DiaryDataInitializer`를 그 다음 실행하도록 `@Order`를 추가했다.

2026-04-28 `REQ-20260428-04` 기준으로 백엔드 인증/소유권 검증 테스트를 보강했다. `AuthControllerTest`는 로그인 성공, 로그인 실패, 회원가입 토큰 발급, refresh token 재발급을 확인한다. `DiaryControllerTest`는 access token 기반 일기 목록 조회, invalid access token 거부, 타 사용자 일기 상세 접근 차단을 확인한다. 이후 `REQ-20260428-08`에서 `ApiResponse.error(message)`와 `GlobalExceptionHandler`를 추가해 주요 오류 응답을 `success=false`, `message`, `data=null` 형태로 표준화했다. 현재 Maven 테스트는 10개 기준 통과한다.

2026-04-28 PM 모니터링으로 역할별 문서와 공통 인덱스를 대조했다. `REQ-20260428-02`, `REQ-20260428-03`, `REQ-20260428-04`, `REQ-20260428-06`, `REQ-20260428-07`, `REQ-20260428-08`, `REQ-20260428-10`은 수행자 응답과 검증 결과를 근거로 완료 처리했다. 이후 QA가 `REQ-20260428-06` 기준으로 백엔드 서버를 실제 기동해 로그인, 일기 목록/상세, 캘린더, 감정 목록, invalid token 실패 응답을 API 레벨에서 회귀 검증했다. Flutter `test`와 `analyze`도 통과했다. `REQ-20260428-21`로 기준선 점검과 단계적 업무계획 수립도 완료되어 후속 요청은 `REQ-20260428-22`부터 `REQ-20260428-25`까지 배분되어 있다.

소스 대조 결과 `.ai-work/msyeo/docs/api-contract.md`의 과거 초안 경로였던 `/api/v1/auth/sign-up`, `/api/v1/auth/sign-in`, `/api/v1/calendar/monthly`는 실제 코드와 맞지 않아 현재 경로인 `/api/v1/auth/signup`, `/api/v1/auth/login`, `/api/v1/calendar` 기준으로 갱신했다. `.ai-work/msyeo/docs/planning.md`도 React/Vite 중심 표현을 제거하고 Flutter 앱 중심 계획으로 다시 정리했다.

세부 점검 결과와 다음 작업 준비 내용은 `.ai-work/msyeo/docs/source-doc-audit.md`에 정리했다.

## 현재 기술 스택
- Backend: Java 17 소스 레벨, Spring Boot, Maven Wrapper
- Current Frontend Prototype: React 18, TypeScript, Vite, Redux Toolkit
- Target App Frontend: Flutter
- Target Widget Layer: Android App Widget 또는 Glance, iOS WidgetKit
- Current DB: SQLite 파일 DB (`mongtory.db`, Hibernate `SQLiteDialect`)

## 확정된 운영 원칙
- 작업 문서는 한글로 작성
- 신규 문서는 UTF-8 인코딩 사용
- 관련 파일 외 수정 금지
- 변경 범위 최소화
- 모든 프로젝트 문서는 `.ai-work/msyeo/docs/` 아래에서 관리
- PM, QA, FE 개발자, BE 개발자 협업은 `.ai-work/msyeo/docs/collaboration/master-flow.md`를 공통룰로 사용
- 역할별 실제 요청, 진행 현황, 응답은 `.ai-work/msyeo/docs/collaboration/roles/{role}/` 아래에 기록
- 공통 `.ai-work/msyeo/docs/collaboration/requests.md`, `status.md`, `responses.md`는 PM이 관리하는 인덱스로 사용
- 요청 처리 응답은 수행자 역할과 요청자 역할의 `responses.md` 양쪽에 기록
- 역할별 작업 블록 handoff는 `.ai-work/msyeo/docs/collaboration/roles/{role}/handoff/YYYY-MM-DD.md`에 기록
- PM은 `.ai-work/msyeo/docs/collaboration/roles/pm/monitoring.md` 기준으로 모든 역할 디렉토리 문서를 확인하고 상태 불일치, 소통 누락, 파일 충돌을 점검
- PM은 반복되는 소통 문제를 발견하면 협업룰 조정 요청을 만들고 `master-flow.md` 또는 `roles/README.md`를 갱신
- PM은 완료된 요청 중 커밋이 필요한 변경을 요청 ID 단위로 취합해 직접 커밋
- 모든 담당자는 매 작업 시작 전 변경 룰을 확인하고 자기 역할 `status.md`에 `룰 확인 기록`을 남김
- 의미 있는 작업 세션마다 `.ai-work/msyeo/docs/handoff/YYYY-MM-DD.md` 작성
- handoff 디렉토리가 없으면 `.ai-work/msyeo/docs/handoff/`를 먼저 생성하고, 루트 `docs/`에는 handoff를 만들지 않음

## 권장 아키텍처 방향
앱은 Flutter를 메인으로 두고, 웹은 별도 프론트엔드로 분리하는 방향이 적절하다. 현재 `frontend/`는 참고용 초기 프로토타입으로 보고, 앱 본체는 `mobile-flutter/` 같은 별도 구조로 전환하는 것이 바람직하다.

위젯 지원이 목표이므로, 최종적으로는 아래 구조가 바람직하다.

- 웹: 별도 FE
- 앱: Flutter
- 위젯: Android App Widget 또는 Glance, iOS WidgetKit
- 공통: API 계약, 딥링크 규칙, 서버 응답 모델

## 다음 우선 작업
1. BE: `REQ-20260428-22` 기준 API 검증 오류 계약 보강
2. QA: `REQ-20260428-24` 기준 일기 생성/수정/삭제 Flutter/remote 회귀 검증
3. QA: `REQ-20260428-24` 기준 일기 CRUD 회귀 시나리오 및 자동화 확장
4. PM: `REQ-20260428-25` 기준 위젯/딥링크 1차 설계 요청 준비
5. BE 개발자: 백엔드 인증 토큰 전략을 임시 UUID 토큰에서 실제 세션/JWT 전략으로 고도화
6. FE/QA: 캘린더 월 이동과 날짜별 상세 진입 UX 확장
7. BE/FE: Android/iOS 위젯 플랫폼 설정 상세 설계
8. PM: `.ai-work/msyeo/docs/project-analysis.md`와 `delivery-roadmap.md`를 주요 구조 변경 시 함께 갱신

## 주의 사항
현재 Git 작업 트리에는 본 세션 이전부터 수정 중인 파일이 존재할 수 있다. 향후 작업 시 요청 범위와 직접 관련된 파일만 수정하고, 문서와 코드 변경을 분리해서 관리하는 것이 안전하다.

새 세션에서 컨텍스트를 복구해야 할 때는 `AGENTS.md` 다음으로 `.ai-work/msyeo/docs/collaboration/master-flow.md`, `.ai-work/msyeo/docs/project-status.md`, `.ai-work/msyeo/docs/session-continuity.md` 순서로 보는 것을 권장한다.

백엔드 테스트는 현재 환경에서 `bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test` 기준 통과한다. 현재 설치된 JDK는 OpenJDK 21이며, Maven은 `release 17`로 컴파일한다. Flutter는 `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze`, `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test` 기준 통과한다.

GitHub 원격 푸시는 2026-03-20 기준 `gh auth login`, `gh auth setup-git`을 통해 HTTPS 인증 연동 이력이 있고, 당시 `feature/basic` 브랜치 푸시가 성공했다. 현재 작업 브랜치는 `feature/ai-workspace-docs`다.
