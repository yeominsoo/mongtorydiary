# QA 현황

## 현재 상태
- 역할: QA
- 현재 요청: `REQ-20260428-24` 대기
- 최근 완료: `REQ-20260428-06`, `REQ-20260428-02`, `REQ-20260428-10`
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
- 공통 요청 인덱스에는 `REQ-20260428-10` Flutter QA 자동화 하네스 구축 요청이 등록되어 있으나, 현재 QA `inbox.md`에는 아직 반영되지 않았다. 사용자가 진행을 지시해 QA 역할 문서와 `mobile-flutter/test` 범위에서 먼저 완료했다.

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
  - `REQ-20260428-03`: FE 응답 검토중, 구현/테스트 통과 기록 있음
  - `REQ-20260428-04`: BE 응답 검토중, 구현/테스트 통과 기록 있음
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
  - FE: `REQ-20260428-23` 일기 생성/수정/삭제 Flutter 구현
  - QA: `REQ-20260428-24` 일기 CRUD 회귀 시나리오 및 자동화 확장
  - PM: `REQ-20260428-25` 위젯/딥링크 1차 설계 요청 준비
- QA는 `REQ-20260428-24`를 FE `REQ-20260428-23` 착수 또는 완료 후 진행한다.

## 룰 확인 기록
- 2026-04-28 02:31: 작업 시작 전 AGENTS/master-flow/roles README/inbox/status 확인, 변경 룰 반영 여부: 예, 요청 ID: REQ-20260428-06
- 2026-04-28 02:39: 다음 작업 점검 전 AGENTS/master-flow/roles README/inbox/status 확인, 변경 룰 반영 여부: 예, 요청 ID: 요청 점검/업무 분장
