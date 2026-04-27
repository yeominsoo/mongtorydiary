# 역할 간 응답 인덱스

## 사용법
- 이 문서는 PM이 관리하는 공통 응답 인덱스다.
- 각 역할은 자기 역할 디렉토리의 `responses.md`에 상세 응답을 먼저 기록한다.
- PM은 역할별 응답을 확인한 뒤 이 문서에는 추적에 필요한 요약만 반영한다.
- 응답 제목은 `RES-요청ID` 형식을 사용한다.
- 긴 검증 로그나 상세 재현 절차는 역할별 `responses.md`에 남긴다.

## 응답 목록
| 응답 ID | 요청 ID | 담당 역할 | 상태 | 요약 | 작성일 |
| --- | --- | --- | --- | --- | --- |
| RES-REQ-20260428-01 | REQ-20260428-01 | PM | 완료 | PM/QA/FE/BE 협업 문서 체계 확정 | 2026-04-28 |
| RES-REQ-20260428-05 | REQ-20260428-05 | PM | 완료 | 초기 요청 완료 이후 2차 업무 준비 | 2026-04-28 |
| RES-REQ-20260428-02 | REQ-20260428-02 | QA | 완료 | API/DTO 계약 재확인 및 후속 BE 요청 등록 | 2026-04-28 |
| RES-REQ-20260428-04 | REQ-20260428-04 | BE | 완료 | 인증/소유권 검증 테스트 보강 및 Maven 테스트 통과 | 2026-04-28 |
| RES-REQ-20260428-03 | REQ-20260428-03 | FE | 완료 | Flutter 로그인 화면 실제 입력 폼 전환 | 2026-04-28 |
| RES-REQ-20260428-06 | REQ-20260428-06 | QA | 완료 | 로그인 후 remote 통합 회귀 검증 완료 | 2026-04-28 |
| RES-REQ-20260428-07 | REQ-20260428-07 | FE | 완료 | 일기 목록에서 상세 진입 플로우 구현 및 Flutter 검증 통과 | 2026-04-28 |
| RES-REQ-20260428-08 | REQ-20260428-08 | BE | 완료 | 전역 예외 응답 ApiResponse 표준화 및 Maven 테스트 통과 | 2026-04-28 |
| RES-REQ-20260428-10 | REQ-20260428-10 | QA | 완료 | Flutter QA 자동화 하네스 1차 구축 | 2026-04-28 |
| RES-REQ-20260428-11 | REQ-20260428-11 | PM | 완료 | 역할별 디렉토리와 요청자별 문서 체계 도입 | 2026-04-28 |
| RES-REQ-20260428-12 | REQ-20260428-12 | PM | 완료 | 역할별 handoff와 요청자 responses 양방향 기록 규칙 추가 | 2026-04-28 |
| RES-REQ-20260428-13 | REQ-20260428-13 | PM | 완료 | 완료 작업 PM 취합 커밋 규칙 추가 | 2026-04-28 |
| RES-REQ-20260428-14 | REQ-20260428-14 | PM | 완료 | PM 전체 역할 디렉토리 모니터링과 협업룰 조정 절차 추가 | 2026-04-28 |
| RES-REQ-20260428-15 | REQ-20260428-15 | PM | 완료 | 매 작업 시작 전 변경 룰 확인 강제 | 2026-04-28 |
| RES-REQ-20260428-21 | REQ-20260428-21 | PM | 완료 | 기준선 확인과 단계적 업무계획 수립 | 2026-04-28 |
| RES-REQ-20260428-09 | REQ-20260428-09 | FE | 완료 | 일기 생성/수정/삭제 Flutter 플로우 구현 | 2026-04-28 |
| RES-REQ-20260428-25 | REQ-20260428-25 | PM | 완료 | 위젯/딥링크 1차 설계 문서 작성 | 2026-04-28 |
| RES-REQ-20260428-24 | REQ-20260428-24 | QA | 완료 | 일기 CRUD 회귀 시나리오 및 QA 하네스 확장 | 2026-04-28 |
| RES-REQ-20260428-26 | REQ-20260428-26 | FE | 완료 | CRUD 이후 앱 사용성 개선 후보 설계 | 2026-04-28 |

## 응답 상세
### RES-REQ-20260428-25
- 요청 ID: REQ-20260428-25
- 담당 역할: PM
- 상태: 완료
- 요약:
  - 위젯 요약 데이터 모델 후보와 딥링크 URL/Flutter route 후보를 정리했다.
  - 위젯은 앱이 기록한 로컬 공유 요약 데이터를 읽는 조회 전용 진입점으로 우선 설계했다.
  - FE 딥링크 라우터, 앱 기반 위젯 요약 데이터 생성, 네이티브 위젯 shell 검토와 BE 위젯 요약 API, 연속 작성 일수, 날짜별 일기 조회 계약 검토를 후속 후보로 분리했다.
- 변경 파일:
  - `.ai-work/msyeo/docs/widget-deeplink-plan.md`
  - `.ai-work/msyeo/docs/delivery-roadmap.md`
  - `.ai-work/msyeo/docs/collaboration/requests.md`
  - `.ai-work/msyeo/docs/collaboration/status.md`
  - `.ai-work/msyeo/docs/collaboration/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/inbox.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/status.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/handoff/2026-04-28.md`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/handoff/2026-04-28.md`
- 검증:
  - 문서 설계 작업이라 백엔드/Flutter 테스트는 실행하지 않았다.
  - `git diff --check -- .ai-work/msyeo/docs`로 문서 diff 공백 검증을 수행했다.
- 남은 이슈:
  - 실제 Android/iOS 위젯 구현과 Flutter 딥링크 라우터 구현은 아직 시작하지 않았다.
  - 위젯 요약 API가 필요한지는 BE `REQ-20260428-27` 결과와 함께 판단한다.
- 다음 제안:
  - PM은 FE `REQ-20260428-26`과 BE `REQ-20260428-27` 결과를 모아 딥링크/위젯 구현 요청을 별도 ID로 분리한다.

### RES-REQ-20260428-01
- 요청 ID: REQ-20260428-01
- 담당 역할: PM
- 상태: 완료
- 요약:
  - PM, QA, FE 개발자, BE 개발자 4역할 기준 협업 마스터 문서와 요청/현황/응답 창구를 정리했다.
  - 기존 PM/기획자/개발자 3역할 표현을 4역할 기준으로 교체했다.
  - 초기 작업 요청을 QA, FE, BE 대상으로 각각 등록했다.
- 변경 파일:
  - `.ai-work/msyeo/docs/collaboration/master-flow.md`
  - `.ai-work/msyeo/docs/collaboration/requests.md`
  - `.ai-work/msyeo/docs/collaboration/status.md`
  - `.ai-work/msyeo/docs/collaboration/responses.md`
  - `AGENTS.md`
  - `.ai-work/msyeo/docs/README.md`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/handoff/2026-04-28.md`
- 검증:
  - 협업 문서 4개와 공통룰 참조 문서를 읽어 구조를 확인했다.
- 남은 이슈:
  - 실제 QA, FE, BE 세션의 작업은 아직 시작하지 않았다.
- 다음 제안:
  - QA는 `REQ-20260428-02`, FE는 `REQ-20260428-03`, BE는 `REQ-20260428-04`를 기준으로 작업을 시작한다.

### RES-REQ-20260428-05
- 요청 ID: REQ-20260428-05
- 담당 역할: PM
- 상태: 완료
- 요약:
  - 초기 요청 `REQ-20260428-02`, `REQ-20260428-03`, `REQ-20260428-04` 완료 후 바로 이어갈 2차 업무를 준비했다.
  - QA, FE, BE 후속 요청을 각각 등록하고, 최종적으로 일기 생성/수정/삭제 구현 범위 확정 요청까지 배치했다.
- 변경 파일:
  - `.ai-work/msyeo/docs/collaboration/requests.md`
  - `.ai-work/msyeo/docs/collaboration/status.md`
  - `.ai-work/msyeo/docs/collaboration/responses.md`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/handoff/2026-04-28.md`
- 검증:
  - 협업 요청/현황/응답 문서의 요청 ID와 선행 조건을 확인했다.
- 남은 이슈:
  - 실제 2차 업무 착수는 초기 요청 3개가 완료된 뒤 PM이 상태를 확인하고 진행해야 한다.
- 다음 제안:
  - 초기 요청이 끝나면 QA는 `REQ-20260428-06`, FE는 `REQ-20260428-07`, BE는 `REQ-20260428-08`을 우선 착수한다.
  - 세 요청이 끝나면 `REQ-20260428-09`로 일기 생성/수정/삭제 구현 범위를 확정한다.

### RES-REQ-20260428-02
- 요청 ID: REQ-20260428-02
- 담당 역할: QA
- 상태: 완료
- 요약:
  - 백엔드 컨트롤러/DTO와 Flutter remote datasource/DTO를 대조했다.
  - 현재 Flutter remote가 사용하는 로그인, 일기 목록/상세, 캘린더 월 조회, 감정 목록 경로와 응답 필드는 백엔드와 일치한다고 기록했다.
  - 회원가입, 토큰 재발급, 일기 생성/수정/삭제는 백엔드 계약에는 있으나 Flutter repository/remote 계약에는 아직 없다고 정리했다.
  - 오류 응답 계약 보강 필요 항목은 BE 후속 작업으로 연결했다.
- 변경 파일:
  - `.ai-work/msyeo/docs/api-contract.md`
  - `.ai-work/msyeo/docs/source-doc-audit.md`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/inbox.md`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/status.md`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/requests.md`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/responses.md`
- 검증:
  - 소스/문서 정적 대조를 수행했다.
  - 백엔드 서버 실행과 Flutter remote 실제 통합 실행은 `REQ-20260428-06`으로 남겼다.
- 남은 이슈:
  - 누락 query parameter, 유효하지 않은 calendar `year/month`, malformed JSON body의 오류 계약은 추가 테스트/구현 보강이 필요하다.
- 다음 제안:
  - `REQ-20260428-06`에서 실제 서버와 Flutter remote 모드 통합 검증을 진행한다.

### RES-REQ-20260428-04
- 요청 ID: REQ-20260428-04
- 담당 역할: BE
- 상태: 완료
- 요약:
  - 인증 성공 응답 테스트를 유지하면서 로그인 실패, 회원가입 토큰 발급, refresh token 재발급 테스트를 추가했다.
  - access token 기반 일기 목록 조회 테스트를 유지하고, invalid access token 거부와 타 사용자 일기 상세 접근 차단 테스트를 추가했다.
  - 테스트 간 생성 데이터가 목록 정렬을 바꿔도 깨지지 않도록 일기 목록 테스트를 특정 첫 항목이 아니라 포함 여부 기준으로 안정화했다.
  - 시드 데이터 초기화 순서를 `UserDataInitializer` -> `DiaryDataInitializer`로 고정해 사용자 시드보다 일기 시드가 먼저 실행되는 불안정성을 제거했다.
- 변경 파일:
  - `src/main/java/com/mongtory/diary/config/UserDataInitializer.java`
  - `src/main/java/com/mongtory/diary/config/DiaryDataInitializer.java`
  - `src/test/java/com/mongtory/diary/controller/AuthControllerTest.java`
  - `src/test/java/com/mongtory/diary/controller/DiaryControllerTest.java`
  - `.ai-work/msyeo/docs/collaboration/requests.md`
  - `.ai-work/msyeo/docs/collaboration/status.md`
  - `.ai-work/msyeo/docs/collaboration/responses.md`
- 검증:
  - `bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test`
  - 결과: `BUILD SUCCESS`, tests run 8, failures 0, errors 0, skipped 0
- 남은 이슈:
  - 현재 `ResponseStatusException` 오류 응답은 `ApiResponse` 형태로 표준화되어 있지 않다. 이 범위는 `REQ-20260428-08`에서 처리하는 것이 적절하다.
- 다음 제안:
  - 후속 `REQ-20260428-08` 전역 예외 응답 표준화가 완료되었으므로, QA는 remote 통합 검증에서 오류 응답 표시를 확인한다.

### RES-REQ-20260428-03
- 요청 ID: REQ-20260428-03
- 담당 역할: FE
- 상태: 완료
- 요약:
  - 임시 로그인 버튼 중심 화면을 이메일/비밀번호 입력 폼으로 전환했다.
  - mock/remote 모드 표시와 remote API URL 표시는 유지했다.
  - 필수 입력 검증, 이메일 형식 검증, 비밀번호 보기/숨기기, 로딩 중 버튼 비활성화, 오류 메시지 박스를 추가했다.
  - 시드 계정 검증을 빠르게 할 수 있도록 `테스트 계정 입력` 버튼을 제공했다.
  - 모바일 화면 기준으로 최대 너비, 안전 영역, 스크롤, 버튼/입력 간격을 정리했다.
- 변경 파일:
  - `mobile-flutter/lib/presentation/screens/sign_in_screen.dart`
  - `mobile-flutter/test/widget_test.dart`
  - `.ai-work/msyeo/docs/collaboration/requests.md`
  - `.ai-work/msyeo/docs/collaboration/status.md`
  - `.ai-work/msyeo/docs/collaboration/responses.md`
- 검증:
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze`: 통과
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test`: 통과
  - 최초 sandbox 실행은 `pub.dev` DNS 조회 실패로 중단되어 네트워크 권한으로 재실행했다.
- 남은 이슈:
  - 실제 remote 백엔드 연결 검증은 Integration 또는 QA 세션에서 확인이 필요하다.
  - 회원가입, 토큰 재발급, 일기 작성/수정/삭제 플로우는 아직 구현되지 않았다.
- 다음 제안:
  - remote 백엔드 연결 검증은 `REQ-20260428-06`에서 진행한다.

### RES-REQ-20260428-06
- 요청 ID: REQ-20260428-06
- 담당 역할: QA
- 상태: 완료
- 요약:
  - 백엔드 서버를 실제 기동하고 로그인 이후 Flutter remote datasource가 사용하는 API 경로를 curl로 회귀 검증했다.
  - 로그인, 일기 목록, 일기 상세, 캘린더 월 조회, 감정 목록, invalid access token 실패 응답이 현재 계약과 일치했다.
  - Flutter QA 하네스 테스트와 정적 분석도 재실행해 통과를 확인했다.
- 변경 파일:
  - `.ai-work/msyeo/docs/collaboration/roles/qa/inbox.md`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/status.md`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/handoff/2026-04-28.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/responses.md`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/handoff/2026-04-28.md`
- 검증:
  - `bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 spring-boot:run`: 8080 기동 확인 후 종료
  - `POST /api/v1/auth/login`: 200, `success=true`, `data.accessToken` 확인
  - `GET /api/v1/diaries`: 200, `success=true`, 목록 응답 확인
  - `GET /api/v1/diaries/{diaryId}`: 200, `success=true`, 상세 응답 확인
  - `GET /api/v1/calendar?year=2026&month=3`: 200, `success=true`
  - `GET /api/v1/emotions`: 200, `success=true`
  - invalid token `GET /api/v1/diaries`: 401, `success=false`, `message=Invalid access token`, `data=null`
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test`: 통과
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze`: 통과
- 남은 이슈:
  - Flutter 앱을 실제 remote 모드 UI로 구동하는 검증은 CLI 환경에서 수행하지 않았다.
  - malformed JSON, 누락 query parameter, calendar `year/month` 범위 검증은 기존 `QA-REQ-20260428-02` BE 요청 범위로 유지한다.
- 다음 제안:
  - PM은 `REQ-20260428-09` 선행 조건 충족 여부를 확인하고 FE/BE 범위 산정을 진행시킨다.

### RES-REQ-20260428-07
- 요청 ID: REQ-20260428-07
- 담당 역할: FE
- 상태: 완료
- 요약:
  - 일기 목록 provider와 같은 repository 계약을 사용하는 `diaryDetailProvider`를 추가했다.
  - 최근 일기 항목 선택 시 `DiaryDetailScreen`으로 이동하도록 연결했다.
  - 상세 화면에 감정 코드, 날짜, 제목, 본문, 첨부 사진 빈 상태, 수정 시간, 로딩/오류/재시도 상태를 추가했다.
  - 목록에서 상세로 진입해 본문을 확인하는 위젯 테스트를 추가했다.
- 변경 파일:
  - `mobile-flutter/lib/application/providers/app_providers.dart`
  - `mobile-flutter/lib/presentation/screens/diary/diary_home_screen.dart`
  - `mobile-flutter/lib/presentation/screens/diary/diary_detail_screen.dart`
  - `mobile-flutter/test/widget_test.dart`
  - `mobile-flutter/test/support/qa_app_harness.dart`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/inbox.md`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/status.md`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/handoff/2026-04-28.md`
- 검증:
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze`: 통과
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test`: 통과
  - `git diff --check`: 통과
- 남은 이슈:
  - remote 백엔드 상세 API 실기기/웹 실행 검증은 `REQ-20260428-06`에서 추가 확인한다.
- 다음 제안:
  - PM은 `REQ-20260428-06` 결과를 본 뒤 `REQ-20260428-09` 생성/수정/삭제 연결 준비 착수 여부를 판단한다.

### RES-REQ-20260428-08
- 요청 ID: REQ-20260428-08
- 담당 역할: BE
- 상태: 완료
- 요약:
  - `ApiResponse.error(message)` 팩토리를 추가했다.
  - `GlobalExceptionHandler`를 추가해 `ResponseStatusException`, `MissingRequestHeaderException`, `MethodArgumentTypeMismatchException`, 일반 예외를 JSON `ApiResponse` 형태로 변환했다.
  - 로그인 실패, 중복 이메일, invalid access token, 타 사용자 일기 접근, Authorization 헤더 누락 케이스의 오류 body 테스트를 보강했다.
- 변경 파일:
  - `src/main/java/com/mongtory/diary/common/ApiResponse.java`
  - `src/main/java/com/mongtory/diary/common/GlobalExceptionHandler.java`
  - `src/test/java/com/mongtory/diary/controller/AuthControllerTest.java`
  - `src/test/java/com/mongtory/diary/controller/DiaryControllerTest.java`
  - `.ai-work/msyeo/docs/collaboration/roles/be/inbox.md`
  - `.ai-work/msyeo/docs/collaboration/roles/be/status.md`
  - `.ai-work/msyeo/docs/collaboration/roles/be/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/be/handoff/2026-04-28.md`
- 검증:
  - `bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test`
  - 결과: `BUILD SUCCESS`, tests run 10, failures 0, errors 0, skipped 0
- 남은 이슈:
  - 일반 `Exception`은 보안상 `Internal server error`로만 응답한다.
  - QA가 Flutter remote 모드에서 실패 응답이 `ApiException.message`로 표시되는지 확인해야 한다.
- 다음 제안:
  - `REQ-20260428-06` remote 통합 검증에서 오류 응답 파싱과 사용자 메시지 표시를 확인한다.

### RES-REQ-20260428-10
- 요청 ID: REQ-20260428-10
- 담당 역할: QA
- 상태: 완료
- 요약:
  - Flutter widget test 기반 QA 하네스를 추가했다.
  - `ProviderScope` override로 mock repository를 주입하는 구조를 만들었다.
  - seed account 로그인, 일기 요약 렌더링, 캘린더/프로필 탭 smoke, 로그인 실패 표시를 자동화했다.
- 변경 파일:
  - `mobile-flutter/test/support/qa_app_harness.dart`
  - `mobile-flutter/test/qa_harness_smoke_test.dart`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/status.md`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/responses.md`
- 검증:
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test`: 통과
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze`: 통과
- 남은 이슈:
  - `integration_test` 도입은 아직 하지 않았다.
  - remote 모드 통합 회귀 검증은 `REQ-20260428-06`에서 별도로 진행한다.
- 다음 제안:
  - 다음 기능 변경 후 QA 하네스와 remote API 회귀 검증을 확장한다.

### RES-REQ-20260428-11
- 요청 ID: REQ-20260428-11
- 담당 역할: PM
- 상태: 완료
- 요약:
  - 공통 문서 동시 편집 위험을 줄이기 위해 역할별 디렉토리와 요청자별 문서 체계를 도입했다.
  - 공통 요청/현황/응답 문서는 PM 관리 인덱스로 전환했다.
- 변경 파일:
  - `.ai-work/msyeo/docs/collaboration/roles/`
  - `.ai-work/msyeo/docs/collaboration/master-flow.md`
  - `.ai-work/msyeo/docs/collaboration/requests.md`
  - `.ai-work/msyeo/docs/collaboration/status.md`
  - `.ai-work/msyeo/docs/collaboration/responses.md`
  - `AGENTS.md`
  - `.ai-work/msyeo/docs/README.md`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/handoff/2026-04-28.md`
- 검증:
  - 역할별 디렉토리와 공통 인덱스 문서의 연결 구조를 확인했다.
- 남은 이슈:
  - PM은 역할별 문서와 공통 인덱스의 상태를 주기적으로 동기화해야 한다.
- 다음 제안:
  - QA, FE, BE 세션은 자기 역할 디렉토리의 `inbox.md`, `status.md`, `responses.md`를 우선 사용한다.

### RES-REQ-20260428-12
- 요청 ID: REQ-20260428-12
- 요청자: 사용자/PM
- 담당 역할: PM
- 상태: 완료
- 요약:
  - 모든 역할이 작업 블록 종료 시 자기 역할 디렉토리에 handoff를 작성하도록 규칙을 추가했다.
  - 요청 처리 응답은 수행자와 요청자 양쪽 `responses.md`에 남기도록 규칙을 추가했다.
  - PM 모니터링 절차와 오류 감지 체크리스트를 만들었다.
- 변경 파일:
  - `AGENTS.md`
  - `.ai-work/msyeo/docs/README.md`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/collaboration/master-flow.md`
  - `.ai-work/msyeo/docs/collaboration/roles/README.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/monitoring.md`
  - `.ai-work/msyeo/docs/collaboration/roles/*/handoff/README.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/handoff/2026-04-28.md`
- 검증:
  - 문서 구조와 규칙 반영 여부를 확인했다.
- 남은 이슈:
  - 기존 완료 응답에는 새 양방향 responses 규칙이 소급 적용되지 않았다. 신규 요청부터 적용한다.
- 다음 제안:
  - PM은 `roles/pm/monitoring.md` 기준으로 responses/handoff 누락을 정기 확인한다.

### RES-REQ-20260428-13
- 요청 ID: REQ-20260428-13
- 요청자: 사용자/PM
- 담당 역할: PM
- 상태: 완료
- 요약:
  - PM이 완료된 요청의 변경을 요청 ID 단위로 취합해 직접 커밋하는 규칙을 추가했다.
  - 커밋 전 확인 조건, 커밋 범위 원칙, 커밋 메시지 형식, 커밋 후 기록 규칙을 정의했다.
- 변경 파일:
  - `AGENTS.md`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/collaboration/master-flow.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/monitoring.md`
  - `.ai-work/msyeo/docs/collaboration/requests.md`
  - `.ai-work/msyeo/docs/collaboration/status.md`
  - `.ai-work/msyeo/docs/collaboration/responses.md`
- 검증:
  - 문서 규칙 변경이라 코드 테스트는 실행하지 않았다.
- 남은 이슈:
  - 실제 커밋은 완료 요청 단위로 PM이 별도 판단해 수행한다.
- 다음 제안:
  - PM은 커밋 전 `git status --short`와 역할별 responses/handoff를 대조한다.

### RES-REQ-20260428-14
- 요청 ID: REQ-20260428-14
- 요청자: 사용자/PM
- 담당 역할: PM
- 상태: 완료
- 요약:
  - PM 모니터링 범위를 모든 역할 디렉토리 문서로 확장했다.
  - 소통 문제 triage 기준과 협업룰 조정 절차를 추가했다.
- 변경 파일:
  - `AGENTS.md`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/collaboration/master-flow.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/monitoring.md`
  - `.ai-work/msyeo/docs/collaboration/requests.md`
  - `.ai-work/msyeo/docs/collaboration/status.md`
  - `.ai-work/msyeo/docs/collaboration/responses.md`
- 검증:
  - 문서 규칙 변경이라 코드 테스트는 실행하지 않았다.
- 남은 이슈:
  - 실제 모니터링 결과에 따라 추가 협업룰 조정 요청이 생길 수 있다.
- 다음 제안:
  - PM은 정기적으로 모든 역할 디렉토리의 requests/inbox/status/responses/handoff를 함께 확인한다.

### RES-REQ-20260428-15
- 요청 ID: REQ-20260428-15
- 요청자: 사용자/PM
- 담당 역할: PM
- 상태: 완료
- 요약:
  - 모든 담당자가 매 작업 시작마다 변경된 룰을 확인하도록 강제했다.
  - 역할별 `status.md`에 `룰 확인 기록` 섹션을 추가했다.
  - PM 모니터링에서 룰 확인 기록 누락을 오류로 감지하도록 했다.
- 변경 파일:
  - `AGENTS.md`
  - `.ai-work/msyeo/docs/collaboration/master-flow.md`
  - `.ai-work/msyeo/docs/collaboration/roles/README.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/monitoring.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/status.md`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/status.md`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/status.md`
  - `.ai-work/msyeo/docs/collaboration/roles/be/status.md`
  - `.ai-work/msyeo/docs/collaboration/requests.md`
  - `.ai-work/msyeo/docs/collaboration/status.md`
  - `.ai-work/msyeo/docs/collaboration/responses.md`
- 검증:
  - 문서 규칙 변경이라 코드 테스트는 실행하지 않았다.
- 남은 이슈:
  - 기존 진행중 작업에는 이 규칙이 소급 적용되지 않을 수 있다. 다음 작업 시작부터 강제한다.
- 다음 제안:
  - PM은 완료 처리 전 해당 역할 status에 룰 확인 기록이 있는지 확인한다.

### RES-REQ-20260428-21
- 요청 ID: REQ-20260428-21
- 담당 역할: PM
- 상태: 완료
- 요약:
  - 완료된 기준선과 검증 상태를 확인하고 단계적 업무계획을 작성했다.
  - `.ai-work/msyeo/docs/delivery-roadmap.md`에 MVP 진행 순서를 정리했다.
  - 후속 요청 `REQ-20260428-22`부터 `REQ-20260428-25`까지 BE, FE, QA, PM 대상으로 배분했다.
- 변경 파일:
  - `.ai-work/msyeo/docs/delivery-roadmap.md`
  - `.ai-work/msyeo/docs/collaboration/requests.md`
  - `.ai-work/msyeo/docs/collaboration/status.md`
  - `.ai-work/msyeo/docs/collaboration/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/inbox.md`
  - `.ai-work/msyeo/docs/collaboration/roles/be/inbox.md`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/inbox.md`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/inbox.md`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/handoff/2026-04-28.md`
- 검증:
  - 문서/계획 작업이라 코드 테스트는 새로 실행하지 않았다.
  - 기준선 검증 결과는 기존 BE Maven 테스트, Flutter analyze/test, QA remote 검증 기록을 참조했다.
- 커밋:
  - `5fc65e5b42cd69e1e827e12cd3a6a5434ed3a6a0` (`docs: AI 협업 기준선 정리 (REQ-20260428-21)`)
- 남은 이슈:
  - 실제 커밋은 여러 역할 변경이 섞여 있어 요청 ID 단위 선별이 필요하다.
- 다음 제안:
  - BE는 `REQ-20260428-22`를 우선 진행하고, `REQ-20260428-23`은 `REQ-20260428-09`에 흡수되어 보류됐으며, `REQ-20260428-24`는 완료됐다.

### RES-REQ-20260428-09
- 요청 ID: REQ-20260428-09
- 담당 역할: FE
- 상태: 완료
- 요약:
  - Flutter 일기 생성/수정/삭제 플로우와 repository/remote/mock 계약을 구현했다.
  - 홈 작성 진입, 상세 수정/삭제 진입, 저장/삭제 후 provider 갱신을 연결했다.
  - PM이 `flutter analyze`, `flutter test`, `git diff --check`를 재실행해 통과를 확인했다.
  - 중복 후속 요청 `REQ-20260428-23`은 별도 진행하지 않고 이 결과에 흡수했다.
- 검증:
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze`: 통과
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test`: 통과, 8 tests passed
  - `git diff --check -- mobile-flutter/lib mobile-flutter/test .ai-work/msyeo/docs/collaboration/roles/fe`: 통과
- 남은 이슈:
  - QA가 remote 모드에서 백엔드 생성/수정/삭제 회귀 검증을 수행해야 한다.
  - 감정 코드 입력은 후속 UX 개선 후보로 남는다.

### RES-REQ-20260428-24
- 요청 ID: REQ-20260428-24
- 담당 역할: QA
- 상태: 완료
- 요약:
  - QA가 일기 생성/수정/삭제 회귀 시나리오를 정리했다.
  - 상태형 QA harness fake repository와 작성/상세/수정/삭제 smoke test를 추가했다.
- 검증:
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test`: 통과, 9건
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze`: 통과
- 남은 이슈:
  - 실제 서버 remote CRUD 검증도 QA 후속 검증에서 완료됐다.

### RES-REQ-20260428-26
- 요청 ID: REQ-20260428-26
- 담당 역할: FE
- 상태: 완료
- 요약:
  - CRUD 이후 앱 사용성 개선 후보를 사용자 가치, Flutter 변경 범위, BE 의존성 기준으로 비교했다.
  - 1순위 구현 후보는 캘린더 날짜 탭에서 해당 날짜 일기 확인 또는 작성으로 이어지는 플로우다.
- 검증:
  - 설계 문서 작업이라 코드 테스트는 실행하지 않았다.
  - `git diff --check`: 통과
- 남은 이슈:
  - 같은 날짜 다건 처리 UX는 PM 결정 후 신규 구현 요청으로 분리한다.

## 응답 템플릿
```text
### RES-REQ-YYYYMMDD-NN
- 요청 ID:
- 담당 역할:
- 상태:
- 요약:
- 변경 파일:
- 검증:
- 남은 이슈:
- 다음 제안:
```
