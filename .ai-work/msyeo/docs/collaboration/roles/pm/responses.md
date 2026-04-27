# PM 응답 문서

## 응답 목록
| 응답 ID | 요청 ID | 상태 | 요약 | 작성일 |
| --- | --- | --- | --- | --- |
| RES-REQ-20260428-01 | REQ-20260428-01 | 완료 | PM/QA/FE/BE 협업 문서 체계 확정 | 2026-04-28 |
| RES-REQ-20260428-05 | REQ-20260428-05 | 완료 | 초기 요청 완료 이후 2차 업무 준비 | 2026-04-28 |
| RES-REQ-20260428-11 | REQ-20260428-11 | 완료 | 역할별 디렉토리와 요청자별 문서 체계 도입 | 2026-04-28 |
| RES-REQ-20260428-12 | REQ-20260428-12 | 완료 | 역할별 handoff와 요청자 responses 양방향 기록 규칙 추가 | 2026-04-28 |
| RES-REQ-20260428-13 | REQ-20260428-13 | 완료 | 완료 작업 PM 취합 커밋 규칙 추가 | 2026-04-28 |
| RES-REQ-20260428-14 | REQ-20260428-14 | 완료 | PM 전체 역할 디렉토리 모니터링과 협업룰 조정 절차 추가 | 2026-04-28 |
| RES-REQ-20260428-15 | REQ-20260428-15 | 완료 | 매 작업 시작 전 변경 룰 확인 강제 | 2026-04-28 |
| RES-REQ-20260428-21 | REQ-20260428-21 | 완료 | 기준선 확인과 단계적 업무계획 수립 | 2026-04-28 |
| RES-REQ-20260428-08 | REQ-20260428-08 | 검토중 | BE 전역 예외 응답 ApiResponse 표준화 완료 | 2026-04-28 |
| RES-REQ-20260428-07 | REQ-20260428-07 | 검토중 | FE 일기 목록에서 상세 진입 플로우 구현 | 2026-04-28 |
| RES-REQ-20260428-06 | REQ-20260428-06 | 완료 | QA remote 통합 회귀 검증 완료 | 2026-04-28 |

## RES-REQ-20260428-21
- 요청 ID: REQ-20260428-21
- 요청자: 사용자/PM
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
- 남은 이슈:
  - 실제 커밋은 여러 역할 변경이 섞여 있어 요청 ID 단위 선별이 필요하다.
- 다음 제안:
  - BE는 `REQ-20260428-22`, FE는 `REQ-20260428-23`, QA는 `REQ-20260428-24`를 순서대로 진행한다.

## RES-REQ-20260428-11
- 요청 ID: REQ-20260428-11
- 담당 역할: PM
- 상태: 완료
- 요약:
  - 공통 협업 문서를 인덱스화하고, 실제 편집 공간을 역할별 디렉토리로 분리했다.
  - 역할별로 `requests.md`, `inbox.md`, `status.md`, `responses.md`를 만들었다.
- 변경 파일:
  - `.ai-work/msyeo/docs/collaboration/roles/`
  - `.ai-work/msyeo/docs/collaboration/master-flow.md`
  - `.ai-work/msyeo/docs/collaboration/requests.md`
  - `.ai-work/msyeo/docs/collaboration/status.md`
  - `.ai-work/msyeo/docs/collaboration/responses.md`
- 검증:
  - 역할별 문서 구조와 요청 ID 연결을 확인했다.
- 남은 이슈:
  - 기존 공통 인덱스와 역할별 문서 상태는 PM이 주기적으로 동기화해야 한다.
- 다음 제안:
  - 각 세션은 자기 역할 디렉토리의 `inbox.md`와 `status.md`를 먼저 확인한 뒤 작업한다.

## RES-REQ-20260428-06
- 요청 ID: REQ-20260428-06
- 요청자: PM
- 담당 역할: QA
- 상태: 완료
- 요약:
  - QA가 백엔드 서버를 실제 기동하고 로그인 이후 Flutter remote datasource가 사용하는 API 경로를 curl로 회귀 검증했다.
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
  - PM은 공통 인덱스에서 `REQ-20260428-06` 완료 상태를 반영한다.
  - PM은 후속 `REQ-20260428-09` 착수 가능 여부를 판단한다.

## RES-REQ-20260428-12
- 요청 ID: REQ-20260428-12
- 요청자: 사용자/PM
- 담당 역할: PM
- 상태: 완료
- 요약:
  - 역할별 handoff 작성 규칙을 추가했다.
  - 요청 처리 응답을 수행자와 요청자 양쪽 responses에 기록하도록 규칙을 추가했다.
  - PM 모니터링 절차를 `monitoring.md`로 만들었다.
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
  - 기존 완료 응답에는 새 규칙을 소급 적용하지 않는다.
- 다음 제안:
  - PM은 신규 요청 완료 시 수행자 responses, 요청자 responses, 역할별 handoff 3가지를 확인한다.

## RES-REQ-20260428-13
- 요청 ID: REQ-20260428-13
- 요청자: 사용자/PM
- 담당 역할: PM
- 상태: 완료
- 요약:
  - 완료된 요청에 대해 PM이 필요한 경우 직접 커밋하도록 규칙을 추가했다.
  - 커밋 전 확인 조건, 요청 ID 단위 커밋 범위, 메시지 형식, 커밋 후 기록 규칙을 정리했다.
- 변경 파일:
  - `AGENTS.md`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/collaboration/master-flow.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/monitoring.md`
  - `.ai-work/msyeo/docs/collaboration/requests.md`
  - `.ai-work/msyeo/docs/collaboration/status.md`
  - `.ai-work/msyeo/docs/collaboration/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/requests.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/inbox.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/handoff/2026-04-28.md`
- 검증:
  - 문서 규칙 변경이라 코드 테스트는 실행하지 않았다.
- 남은 이슈:
  - 실제 커밋 수행은 완료 요청 단위로 PM이 별도 판단한다.
- 다음 제안:
  - PM은 커밋 후 커밋 해시를 수행자 responses, 요청자 responses, 공통 responses에 기록한다.

## RES-REQ-20260428-14
- 요청 ID: REQ-20260428-14
- 요청자: 사용자/PM
- 담당 역할: PM
- 상태: 완료
- 요약:
  - PM이 모든 역할 디렉토리의 문서를 모니터링하도록 범위를 확장했다.
  - 소통 문제 triage 기준과 협업룰 조정 절차를 추가했다.
- 변경 파일:
  - `AGENTS.md`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/collaboration/master-flow.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/monitoring.md`
  - `.ai-work/msyeo/docs/collaboration/requests.md`
  - `.ai-work/msyeo/docs/collaboration/status.md`
  - `.ai-work/msyeo/docs/collaboration/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/requests.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/inbox.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/handoff/2026-04-28.md`
- 검증:
  - 문서 규칙 변경이라 코드 테스트는 실행하지 않았다.
- 남은 이슈:
  - 실제 모니터링 중 발견되는 반복 문제에 따라 추가 룰 조정 요청이 생길 수 있다.
- 다음 제안:
  - PM은 모든 역할의 requests/inbox/status/responses/handoff를 함께 확인하고, 소통 문제가 있으면 triage 후 룰을 조정한다.

## RES-REQ-20260428-15
- 요청 ID: REQ-20260428-15
- 요청자: 사용자/PM
- 담당 역할: PM
- 상태: 완료
- 요약:
  - 모든 담당자가 작업 시작 전 변경 룰을 확인하도록 공통룰에 추가했다.
  - 확인 대상은 `AGENTS.md`, `master-flow.md`, `roles/README.md`, 자기 역할 `inbox.md`, 자기 역할 `status.md`다.
  - 확인 결과는 자기 역할 `status.md`의 `룰 확인 기록`에 남기도록 했다.
- 변경 파일:
  - `AGENTS.md`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/collaboration/master-flow.md`
  - `.ai-work/msyeo/docs/collaboration/roles/README.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/monitoring.md`
  - `.ai-work/msyeo/docs/collaboration/roles/*/status.md`
  - `.ai-work/msyeo/docs/collaboration/requests.md`
  - `.ai-work/msyeo/docs/collaboration/status.md`
  - `.ai-work/msyeo/docs/collaboration/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/requests.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/inbox.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/handoff/2026-04-28.md`
- 검증:
  - 문서 규칙 변경이라 코드 테스트는 실행하지 않았다.
- 남은 이슈:
  - 기존 진행 중 작업은 각 담당자가 다음 작업 시작 시 새 룰 확인 기록을 남겨야 한다.
- 다음 제안:
  - PM은 완료 처리 전 담당 역할 `status.md`에 룰 확인 기록이 있는지 확인한다.

## RES-REQ-20260428-08
- 요청 ID: REQ-20260428-08
- 요청자: PM
- 담당 역할: BE
- 상태: 검토중
- 요약:
  - BE가 `ApiResponse.error(message)`와 `GlobalExceptionHandler`를 추가해 오류 응답을 `success=false`, `message`, `data=null` 형태로 표준화했다.
  - Flutter `ApiClient`가 실패 응답에서도 `message`를 안정적으로 읽을 수 있는 응답 형식이다.
  - 로그인 실패, 중복 이메일, invalid access token, 타 사용자 일기 접근, Authorization 헤더 누락 오류 body 테스트를 보강했다.
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
  - PM이 공통 인덱스와 전체 handoff에 반영해야 한다.
  - QA가 Flutter remote 모드에서 `ApiException.message` 표시를 확인하는 것이 좋다.
- 다음 제안:
  - PM은 `REQ-20260428-08` 완료 여부를 판단하고, 필요 시 요청 ID 단위 커밋 범위를 선별한다.

## RES-REQ-20260428-07
- 요청 ID: REQ-20260428-07
- 요청자: PM
- 담당 역할: FE
- 상태: 검토중
- 요약:
  - FE가 일기 목록 항목 탭에서 상세 화면으로 이동하는 플로우를 구현했다.
  - `diaryDetailProvider`와 `DiaryDetailScreen`을 추가하고, 상세 로딩/오류/재시도/빈 사진 상태를 표시했다.
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
  - 공통 PM 인덱스 동기화와 완료 판단은 PM이 처리해야 한다.
  - remote 백엔드 상세 API 연결 검증은 QA 또는 통합 세션에서 추가 확인이 필요하다.
- 다음 제안:
  - PM은 `REQ-20260428-07` 완료 여부를 판단하고, 후속 `REQ-20260428-09` 착수 가능성을 재검토한다.

## RES-FE-IMPROVE-20260428-01
- 요청 ID: FE-IMPROVE-20260428-01
- 요청자: 사용자/PM
- 담당 역할: FE
- 상태: 검토중
- 요약:
  - FE가 현재 화면을 점검해 생성/수정/삭제 API 전 단계에서 보강 가능한 홈/상세 퍼블리싱 품질 개선을 수행했다.
  - 작성 CTA는 실제 작성 플로우가 연결된 것처럼 보이지 않도록 준비 상태 안내와 스낵바로 정리했다.
  - 일기 홈 주요 섹션 폭을 제한하고, 상세 화면 중앙 정렬과 작성일/수정일 메타데이터를 추가했다.
  - 관련 위젯 테스트를 보강했다.
- 변경 파일:
  - `mobile-flutter/lib/presentation/screens/diary/diary_home_screen.dart`
  - `mobile-flutter/lib/presentation/screens/diary/diary_detail_screen.dart`
  - `mobile-flutter/test/widget_test.dart`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/status.md`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/handoff/2026-04-28.md`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/handoff/2026-04-28.md`
- 검증:
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze`: 통과
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test`: 통과
  - `git diff --check`: 통과
- 남은 이슈:
  - `REQ-20260428-09` 선행 조건이 완료되기 전까지 작성/수정/삭제 실제 플로우는 구현하지 않았다.
- 다음 제안:
  - PM은 이 개선을 별도 FE 보강 작업으로 검토하고, 필요 시 공통 인덱스에 후속 정리한다.
