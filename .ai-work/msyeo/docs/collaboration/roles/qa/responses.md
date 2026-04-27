# QA 응답 문서

## 응답 목록
| 응답 ID | 요청 ID | 상태 | 요약 | 작성일 |
| --- | --- | --- | --- | --- |
| RES-REQ-20260428-02 | REQ-20260428-02 | 완료 | API/DTO 계약 재확인 및 후속 BE 요청 등록 | 2026-04-28 |
| RES-REQ-20260428-10 | REQ-20260428-10 | 완료 | Flutter QA 자동화 하네스 1차 구축 | 2026-04-28 |
| RES-REQ-20260428-06 | REQ-20260428-06 | 완료 | 로그인 후 remote 통합 회귀 검증 완료 | 2026-04-28 |

## 응답 상세
### RES-REQ-20260428-02
- 요청 ID: REQ-20260428-02
- 담당 역할: QA
- 상태: 완료
- 요약:
  - 백엔드 컨트롤러/DTO와 Flutter remote datasource/DTO를 대조했다.
  - 현재 Flutter remote가 사용하는 로그인, 일기 목록/상세, 캘린더 월 조회, 감정 목록 경로와 응답 필드는 백엔드와 일치한다.
  - 백엔드 전체 계약에는 회원가입, 토큰 재발급, 일기 생성/수정/삭제가 있으나 Flutter repository/remote 계약에는 아직 없다.
  - `GlobalExceptionHandler` 추가로 주요 오류 응답이 `ApiResponse` 형태로 감싸지는 최신 상태를 문서에 반영했다.
- 검증 대상 엔드포인트:
  - `POST /api/v1/auth/signup`
  - `POST /api/v1/auth/login`
  - `POST /api/v1/auth/refresh`
  - `GET /api/v1/diaries`
  - `GET /api/v1/diaries/{diaryId}`
  - `POST /api/v1/diaries`
  - `PUT /api/v1/diaries/{diaryId}`
  - `DELETE /api/v1/diaries/{diaryId}`
  - `GET /api/v1/calendar?year=2026&month=3`
  - `GET /api/v1/emotions`
- 요청/응답 필드 차이:
  - 핵심 DTO 필드 차이는 발견하지 못했다.
  - `UserSummaryResponse.id`, `Diary*Response.id`는 백엔드 `Long`, Flutter `int`로 매핑된다. 현재 JSON 숫자 범위에서는 문제 가능성이 낮다.
  - Flutter는 백엔드 CRUD 전체 중 로그인, 일기 목록/상세, 캘린더, 감정 목록만 remote로 호출한다.
  - `api-spec.md`의 토큰 재발급 예시는 `jwt-refresh-token` 표현을 쓰지만 현재 토큰은 임시 `refresh-UUID` 문자열이다.
- 수동 검증 시나리오:
  - 로그인 성공 후 `accessToken` 획득
  - `Authorization: Bearer <accessToken>`으로 일기 목록 조회
  - 목록 첫 항목의 `id`로 일기 상세 조회
  - 같은 토큰으로 `GET /api/v1/calendar?year=2026&month=3` 조회
  - `GET /api/v1/emotions` 조회
  - 잘못된 access token으로 일기 목록 조회 시 401 `ApiResponse` 확인
  - 존재하지 않거나 타 사용자 소유인 일기 상세 조회 시 404 `ApiResponse` 확인
- 변경 파일:
  - `.ai-work/msyeo/docs/api-contract.md`
  - `.ai-work/msyeo/docs/source-doc-audit.md`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/inbox.md`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/status.md`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/requests.md`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/responses.md`
- 검증:
  - 소스/문서 정적 대조를 수행했다.
  - 백엔드 서버 실행과 Flutter remote 실제 통합 실행은 수행하지 않았다.
- 후속 요청:
  - `QA-REQ-20260428-02`: BE에 오류 응답/요청 검증 계약 보강 요청
- 남은 이슈:
  - 누락 query parameter, 유효하지 않은 calendar `year/month`, malformed JSON body의 오류 계약은 BE 테스트/구현으로 고정해야 한다.
  - 실제 서버/Flutter remote 통합 검증은 `REQ-20260428-06`에서 진행한다.
- 다음 제안:
  - PM이 `QA-REQ-20260428-02`를 BE inbox에 반영한다.
  - PM이 공통 인덱스에서 `REQ-20260428-02` 완료 상태를 반영한다.

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
- 자동화 중 발생한 오류와 분류:
  - `캘린더`, `몽토리` 텍스트가 AppBar와 NavigationBar label에 중복되어 초기 assertion이 실패했다.
  - 원인: QA 하네스 자체 문제
  - 처리: 화면 고유 텍스트 기준으로 assertion을 수정했다.
- FE/BE 후속 요청:
  - 없음
- 남은 이슈:
  - `integration_test` 도입은 아직 하지 않았다.
  - remote 모드 통합 회귀 검증은 `REQ-20260428-06`에서 별도로 진행한다.
- 다음 제안:
  - PM이 공통 인덱스와 QA inbox에 `REQ-20260428-10` 완료 상태를 반영한다.
  - QA는 다음으로 `REQ-20260428-02` API/DTO 계약 재확인을 진행한다.

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
- 자동화/통합 중 발생한 오류와 분류:
  - 없음
- FE/BE 후속 요청:
  - 없음
- 남은 이슈:
  - Flutter 앱을 실제 remote 모드 UI로 구동하는 검증은 CLI 환경에서 수행하지 않았다.
  - malformed JSON, 누락 query parameter, calendar `year/month` 범위 검증은 기존 `QA-REQ-20260428-02` BE 요청 범위로 유지한다.
- 다음 제안:
  - PM이 공통 인덱스에서 `REQ-20260428-06` 완료 상태를 반영한다.
  - 다음 QA 작업은 PM 공통 인덱스와 QA inbox 동기화 후 선정한다.

## 작성 템플릿
```text
### RES-REQ-YYYYMMDD-NN
- 요청 ID:
- 담당 역할: QA
- 상태:
- 요약:
- 변경 파일:
- 검증:
- 남은 이슈:
- 다음 제안:
```
