# QA 현황

## 현재 상태
- 역할: QA
- 현재 요청: `REQ-20260428-35` 대기
- 최근 완료: `REQ-20260428-30`, `REQ-20260428-29`, `REQ-20260428-24`, `REQ-20260428-06`, `REQ-20260428-02`, `REQ-20260428-10`
- 담당 문서:
  - `.ai-work/msyeo/docs/api-contract.md`
  - `.ai-work/msyeo/docs/api-spec.md`
  - `.ai-work/msyeo/docs/source-doc-audit.md`
  - `mobile-flutter/test`
  - 필요 시 `mobile-flutter/integration_test`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/`

## 작업 메모
- QA는 기능 구현보다 API/DTO 계약, 수동 검증 시나리오, 회귀 위험 정리에 집중한다.
- 테스트 코드 수정이 필요하면 PM에게 담당 파일 범위를 먼저 공유한다.
- PM이 추가한 최신 룰에 따라 공통 인덱스 문서는 PM이 최종 정리하고, QA는 기본적으로 `roles/qa/` 아래 문서를 먼저 갱신한다.
- `REQ-20260428-10` Flutter QA 자동화 하네스 구축 요청은 QA inbox와 공통 인덱스 모두 완료 상태로 반영됐다.

## 완료 결과: REQ-20260428-02
- 목표: 실제 백엔드 컨트롤러/DTO와 Flutter remote datasource/DTO 기준 API 계약 재확인
- 확인 대상:
  - 인증: 로그인, 회원가입, 토큰 재발급
  - 일기: 목록, 상세, 생성, 수정, 삭제
  - 캘린더: 월 조회
  - 감정: 목록 조회
- 확인 결과:
  - 백엔드 경로와 Flutter remote datasource의 로그인, 일기 목록/상세, 캘린더, 감정 목록 경로는 일치한다.
  - 백엔드 DTO와 Flutter remote DTO의 핵심 필드는 일치한다.
  - Flutter는 회원가입, 토큰 재발급, 일기 생성/수정/삭제 repository/remote 계약이 아직 없다.
  - `GlobalExceptionHandler`가 추가되어 주요 오류 응답은 `ApiResponse`로 감싸진다.
  - 누락 query parameter, 유효하지 않은 calendar `year/month`, malformed JSON body는 추가 테스트/계약 보강이 필요하다.
- 후속 요청:
  - `QA-REQ-20260428-02`: BE 오류 응답/요청 검증 계약 보강 요청
- 실행하지 못한 검증:
  - 백엔드 서버와 Flutter remote 모드 실제 통합 실행은 수행하지 않았다. 해당 검증은 `REQ-20260428-06`에서 진행한다.

## 착수 준비: REQ-20260428-10
- 목표: Flutter QA 자동화 하네스 1차 구축
- 1차 범위:
  - `mobile-flutter/test` 아래 공통 widget test harness 설계
  - `ProviderScope` 기반 앱/화면 pump helper 정리
  - mock 모드 smoke test 대상 선정
  - 자동화 실패 발생 시 FE/BE/QA 분류 기준 적용
- 보류 범위:
  - `integration_test` 패키지 추가와 실제 E2E 실행은 1차 harness 구조 확인 후 결정
  - FE가 진행 중인 `REQ-20260428-03` 변경 파일과 충돌하면 해당 파일 편집은 보류
- 예상 검증 명령:
```bash
cd mobile-flutter
HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test
```

## 완료 결과: REQ-20260428-10
- 추가 파일:
  - `mobile-flutter/test/support/qa_app_harness.dart`
  - `mobile-flutter/test/qa_harness_smoke_test.dart`
- 구축 내용:
  - `ProviderScope` override 기반 QA app harness
  - mock repository 대역
  - seed account 로그인 helper
  - 로그인 후 일기 요약, 캘린더/프로필 탭, 로그인 실패 표시 smoke test
- 검증:
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test`: 통과
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze`: 통과
- 자동화 중 발생한 오류:
  - `캘린더`, `몽토리` 텍스트가 AppBar와 NavigationBar label에 중복되어 QA assertion이 실패했다.
  - 원인 분류: QA 하네스 자체 문제
  - 조치: 화면 고유 텍스트인 `월간 캘린더`, `현재 사용자` 기준으로 assertion을 조정했다.
- FE/BE 후속 요청:
  - 없음

## 자동화 실패 후속 요청 작성 기준
- FE 대상: 화면 렌더링, 입력 검증, navigation, Riverpod 상태, Flutter repository/mock 처리 문제
- BE 대상: HTTP status, 응답 body, DTO 필드, 인증/권한, 서버 오류, 데이터 소유권 문제
- QA 유지: 하네스 자체 문제, flaky test, 원인 미분류 분석

## 완료 결과: REQ-20260428-06
- 목표: 로그인 완료 후 remote 통합 회귀 검증
- 선행 조건 확인:
  - `REQ-20260428-02`: QA 완료
  - `REQ-20260428-03`: FE 완료
  - `REQ-20260428-04`: BE 완료
- 검증 범위:
  - 백엔드 서버 실행
  - 로그인 성공으로 access token 획득
  - 일기 목록 조회
  - 일기 상세 조회
  - 캘린더 월 조회
  - 감정 목록 조회
  - 실패 응답 wrapper 확인
- 실행 결과:
  - 백엔드 서버 `spring-boot:run` 8080 기동 확인
  - `POST /api/v1/auth/login`: 성공, access token 발급 확인
  - `GET /api/v1/diaries`: 성공, 일기 목록 응답 확인
  - `GET /api/v1/diaries/{diaryId}`: 성공, 상세 본문/감정/이미지 목록 응답 확인
  - `GET /api/v1/calendar?year=2026&month=3`: 성공, 월간 캘린더 응답 확인
  - `GET /api/v1/emotions`: 성공, 감정 목록 응답 확인
  - 잘못된 access token으로 `GET /api/v1/diaries`: 401, `success=false`, `message=Invalid access token`, `data=null` 확인
- Flutter 검증:
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test`: 통과
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze`: 통과
- 자동화/통합 중 발생한 오류:
  - 없음
- FE/BE 후속 요청:
  - 없음
- 제한:
  - Flutter 앱 remote 모드 화면 실행은 CLI 환경 한계로 API 레벨 검증과 Flutter test/analyze 결과를 함께 기록했다.
- 다음 QA 요청은 `REQ-20260428-24` 일기 CRUD 회귀 시나리오 및 자동화 확장이다. 작업 시작 전 룰 확인 기록을 먼저 남긴다.

## 다음 작업 점검 결과
- 2026-04-28 02:39 기준 QA 수신함과 공통 협업 보드를 확인했다.
- 신규 기능 구상 단계로 넘어가기 전에 이미 `REQ-20260428-09`와 후속 `REQ-20260428-22~25`가 등록되어 있다.
- 각 역할 분장:
  - BE: `REQ-20260428-22` API 검증 오류 계약 보강, `REQ-20260428-09` Diary CRUD 계약 확인
  - FE: `REQ-20260428-09` 일기 생성/수정/삭제 Flutter 구현 완료, `REQ-20260428-23`은 보류
  - QA: `REQ-20260428-24` 일기 CRUD 회귀 시나리오 및 자동화 확장
  - PM: `REQ-20260428-25` 위젯/딥링크 1차 설계 요청 준비
- QA는 `REQ-20260428-24`를 바로 착수할 수 있다.

## 사용성 개선 요청 기록
- 2026-04-28 02:44 사용자 요청에 따라 FE/BE에 CRUD 이후 사용성 개선 후보 설계 요청을 남겼다.
- FE 요청: `REQ-20260428-26`
  - 캘린더 날짜 탭 -> 해당 날짜 일기 작성/상세 진입
  - 일기 작성 UX 개선, 작성 중 임시 저장, 빈 상태 CTA, 오프라인/로딩/재시도 상태, 감정 기반 필터
- BE 요청: `REQ-20260428-27`
  - 일기 검색/필터 API, 작성 검증 강화, 이미지 업로드 준비 API, 월간 감정 통계 API, 위젯용 요약 API, 토큰 만료/갱신 전략
- 두 요청은 즉시 구현이 아니라 다음 구현 후보를 정하기 위한 설계/우선순위 요청이다.

## 완료 결과: REQ-20260428-24
- 목표: 일기 생성/수정/삭제에 대한 QA 회귀 시나리오 및 자동화 확장
- 자동화 확장:
  - `QaDiaryRepository` fake를 상태형으로 변경해 생성/수정/삭제 결과가 목록과 상세 조회에 반영되도록 했다.
  - QA harness smoke test에 작성 -> 상세 확인 -> 수정 -> 상세 확인 -> 삭제 -> 목록 제외 확인 플로우를 추가했다.
- 수동/API 회귀 시나리오:
  - 로그인 성공 후 access token을 획득한다.
  - `POST /api/v1/diaries`로 새 일기를 생성하고 200 계열 `ApiResponse`와 `data.id/title/content/emotionCode/entryDate`를 확인한다.
  - `GET /api/v1/diaries/{id}`로 생성된 상세 본문을 확인한다.
  - `PUT /api/v1/diaries/{id}`로 제목/본문/감정을 수정하고 상세 조회에서 변경값을 확인한다.
  - `GET /api/v1/diaries` 목록에서 수정된 제목이 반영되는지 확인한다.
  - `DELETE /api/v1/diaries/{id}` 후 목록에서 제외되는지 확인한다.
  - 잘못된 access token, 존재하지 않는 id, 타 사용자 id에 대한 실패 응답은 `success=false`, `message`, `data=null` 형태인지 확인한다.
- 검증:
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test`: 통과, 9건
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze`: 통과
- 자동화/통합 중 발생한 오류:
  - 없음
- FE/BE 후속 요청:
  - 없음
- 남은 이슈:
  - malformed JSON, 누락 query parameter, calendar 범위 오류는 기존 `REQ-20260428-22` BE 요청 범위로 남아 있다.
- 후속 remote 검증:
  - `spring-boot:run`으로 백엔드 서버를 8080에서 기동한 뒤 종료했다.
  - 로그인 -> 생성 -> 상세 -> 수정 -> 목록 반영 -> 삭제 -> 목록 제외 -> invalid token 실패 응답을 curl로 확인했다.
  - 생성한 검증 일기는 삭제까지 확인해 테스트 데이터가 남지 않도록 했다.

## QA 사전 검증: REQ-20260428-22
- 목표: BE 오류 계약 보강 전 현재 응답 기준선 재현
- 실행:
  - 백엔드 서버를 `spring-boot:run`으로 8080에서 기동한 뒤 종료했다.
  - 로그인 후 access token을 받아 calendar/diary 오류 케이스를 curl로 호출했다.
- 재현 결과:
  - calendar `year` 누락: 500, `Internal server error`
  - calendar `month` 누락: 500, `Internal server error`
  - calendar `month=13`: 500, `Internal server error`
  - calendar `year=abc`: 400, `Invalid request parameter`
  - diary 생성 malformed JSON: 500, `Internal server error`
  - diary 생성 `imageUrls` 타입 오류: 500, `Internal server error`
  - diary 생성 빈 `title/content/emotionCode`: 200 생성 허용
- 정리:
  - 빈 필드 생성 검증으로 생긴 레코드는 삭제했고, 삭제 후 빈 제목 레코드가 남지 않음을 확인했다.
  - `QA-REQ-20260428-02`와 BE `REQ-20260428-22` 메모에 재현 결과를 보강했다.
- FE/BE 후속 요청:
  - 신규 요청은 만들지 않고 기존 BE `REQ-20260428-22` 범위로 유지한다.

## 완료 결과: REQ-20260428-29
- 목표: BE `REQ-20260428-22` 이후 API 검증 오류 계약을 실제 서버에서 회귀 검증
- 실행:
  - `JAVA_HOME=/usr/lib/jvm/java-21-openjdk bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 spring-boot:run`으로 백엔드 서버를 8080에서 기동했다.
  - 로그인 후 access token을 받아 calendar/diary 오류 케이스를 curl로 호출했다.
  - 검증 후 서버 프로세스를 종료했다.
- 검증 결과:
  - calendar `year` 누락: 400, `year parameter is required`
  - calendar `month` 누락: 400, `month parameter is required`
  - calendar `month=13`: 400, `Invalid calendar month`
  - calendar `year=abc`: 400, `Invalid request parameter`
  - diary 생성 malformed JSON: 400, `Invalid request body`
  - diary 생성 `imageUrls` 타입 오류: 400, `Invalid request body`
  - diary 생성 빈 `title/content/emotionCode`: 400, `Diary title is required`
- 자동화/통합 중 발생한 오류:
  - 없음. 서버 종료를 위해 프로세스를 kill 했으므로 `spring-boot:run` Maven 세션은 exit code 143으로 종료됐다.
- FE/BE 후속 요청:
  - 신규 후속 요청 없음. QA 기준 `REQ-20260428-22` 오류 계약은 통과로 판단한다.

## 완료 결과: REQ-20260428-30
- 목표: FE `REQ-20260428-28` 캘린더 날짜 탭 UX를 하네스 기준으로 회귀 검증
- 실행:
  - QA 하네스에서 기존 일기가 있는 날짜를 탭해 bottom sheet와 상세 진입을 확인했다.
  - QA 하네스에 빈 날짜 `2026-03-22` 시나리오를 추가하고, 날짜 탭 후 작성 화면 기본 날짜를 확인했다.
- 검증 결과:
  - 기존 일기 날짜 `2026-03-20`: bottom sheet 노출, `QA 자동화 일기` 선택, `일기 상세`와 본문 노출 확인
  - 빈 날짜 `2026-03-22`: `이 날짜에 작성된 일기가 없습니다.` 노출, `이 날짜로 작성` 선택 후 `일기 작성` 화면과 `2026-03-22` 기본값 확인
  - Flutter `analyze`: 통과
  - Flutter `test`: 통과, 10건
- 자동화/통합 중 발생한 오류:
  - 없음
- FE/BE 후속 요청:
  - FE 결함 요청 없음. 데이터가 많아질 경우 날짜별 조회 API는 BE `REQ-20260428-27` 후보로 검토한다.

## 룰 확인 기록
- 2026-04-28 02:31: 작업 시작 전 AGENTS/master-flow/roles README/inbox/status 확인, 변경 룰 반영 여부: 예, 요청 ID: REQ-20260428-06
- 2026-04-28 02:39: 다음 작업 점검 전 AGENTS/master-flow/roles README/inbox/status 확인, 변경 룰 반영 여부: 예, 요청 ID: 요청 점검/업무 분장
- 2026-04-28 02:44: 사용성 개선 요청 작성 전 AGENTS/master-flow/roles README/inbox/status 확인, 변경 룰 반영 여부: 예, 요청 ID: REQ-20260428-26/27
- 2026-04-28 07:35: `REQ-20260428-29` 착수 전 AGENTS/project-status/QA inbox/QA status 확인, 변경 룰 반영 여부: 예
- 2026-04-28 07:36: `REQ-20260428-30` 착수 전 AGENTS/project-status/QA inbox/QA status 확인, 변경 룰 반영 여부: 예
- 2026-04-28 02:52: 작업 시작 전 AGENTS/master-flow/roles README/inbox/status 확인, 변경 룰 반영 여부: 예, 요청 ID: REQ-20260428-24
- 2026-04-28 02:57: QA 후속 remote CRUD 검증 전 AGENTS/master-flow/roles README/inbox/status 확인, 변경 룰 반영 여부: 예, 요청 ID: REQ-20260428-24
- 2026-04-28 07:22: BE 오류 계약 기준선 검증 전 AGENTS/master-flow/roles README/inbox/status 확인, 변경 룰 반영 여부: 예, 요청 ID: REQ-20260428-22
