# 단일 세션 요청 인덱스

## 사용법
- 이 문서는 단일 세션이 관리하는 공통 요청 인덱스다.
- 2026-05-21부터 PM/QA/FE/BE 역할 분배는 활성 운영 방식에서 철회됐다.
- 기존 요청 ID와 이전 대상 역할은 이력 추적을 위해 유지한다.
- 신규 작업과 상태 갱신은 역할별 문서가 아니라 이 공통 인덱스, `status.md`, `responses.md`, `single-session-worklist.md`에 남긴다.
- 상세한 남은 작업 순서는 `.ai-work/msyeo/docs/single-session-worklist.md`를 우선한다.

## 2026-05-21 이관 메모
- 대기 중이던 `REQ-20260428-35`, `REQ-20260428-37`, `REQ-20260428-38`, `REQ-20260428-39`, `REQ-20260428-40`은 모두 `단일 세션` 담당으로 이관한다.
- 과거 `roles/{pm|qa|fe|be}/` 문서는 이력 확인용이다.

## 요청 목록
| 요청 ID | 우선순위 | 요청자 | 대상 역할 | 상태 | 제목 | 생성일 | 관련 파일/영역 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| REQ-20260428-01 | P0 | 사용자/PM | PM | 완료 | PM/QA/FE/BE 협업 마스터 문서와 요청/현황/응답 창구 확정 | 2026-04-28 | `.ai-work/msyeo/docs/collaboration/` |
| REQ-20260428-02 | P1 | PM | QA | 완료 | 실제 코드 기준 API/DTO 계약 재확인 및 통합 검증 시나리오 작성 | 2026-04-28 | API 문서, 백엔드 컨트롤러, Flutter remote datasource |
| REQ-20260428-03 | P1 | PM | FE | 완료 | Flutter 로그인 화면을 실제 이메일/비밀번호 입력 플로우로 전환 | 2026-04-28 | `mobile-flutter/lib`, `mobile-flutter/test` |
| REQ-20260428-04 | P1 | PM | BE | 완료 | 백엔드 인증/소유권 검증 테스트 보강 | 2026-04-28 | `src/main/java`, `src/test/java` |
| REQ-20260428-05 | P0 | 사용자/PM | PM | 완료 | 초기 요청 완료 이후 2차 업무 준비 | 2026-04-28 | 협업 요청/현황 문서 |
| REQ-20260428-06 | P1 | PM | QA | 완료 | 로그인 완료 후 remote 통합 회귀 검증 | 2026-04-28 | 백엔드 실행, Flutter remote, API 시나리오 |
| REQ-20260428-07 | P1 | PM | FE | 완료 | 일기 목록에서 상세 진입 플로우 구현 | 2026-04-28 | `mobile-flutter/lib`, `mobile-flutter/test` |
| REQ-20260428-08 | P1 | PM | BE | 완료 | 전역 예외 응답을 ApiResponse 규칙에 맞게 표준화 | 2026-04-28 | `src/main/java`, `src/test/java` |
| REQ-20260428-09 | P1 | PM | FE/BE | 완료 | 일기 생성/수정/삭제 API와 Flutter 플로우 연결 준비 | 2026-04-28 | Diary API, Flutter diary repository/screen |
| REQ-20260428-10 | P1 | 사용자/QA | QA | 완료 | Flutter QA 자동화 하네스 1차 구축과 결함 요청 분류 규칙 적용 | 2026-04-28 | `mobile-flutter/test`, 필요 시 `mobile-flutter/integration_test`, QA 문서 |
| REQ-20260428-11 | P0 | 사용자/PM | PM | 완료 | 역할별 디렉토리와 요청자별 문서 체계 도입 | 2026-04-28 | `.ai-work/msyeo/docs/collaboration/roles/` |
| REQ-20260428-12 | P0 | 사용자/PM | PM | 완료 | 역할별 handoff와 요청자 responses 양방향 기록 규칙 추가 | 2026-04-28 | 협업 마스터, 역할별 handoff, PM 모니터링 |
| REQ-20260428-13 | P0 | 사용자/PM | PM | 완료 | 완료 작업 PM 취합 커밋 규칙 추가 | 2026-04-28 | PM monitoring, master-flow, AGENTS |
| REQ-20260428-14 | P0 | 사용자/PM | PM | 완료 | PM 전체 역할 디렉토리 모니터링과 협업룰 조정 절차 추가 | 2026-04-28 | PM monitoring, master-flow, AGENTS |
| REQ-20260428-15 | P0 | 사용자/PM | PM | 완료 | 매 작업 시작 전 변경 룰 확인 강제 | 2026-04-28 | AGENTS, master-flow, roles status |
| REQ-20260428-21 | P0 | 사용자/PM | PM | 완료 | 기준선 커밋 및 단계적 업무계획 수립 | 2026-04-28 | delivery-roadmap, collaboration docs |
| REQ-20260428-22 | P1 | PM | BE | 완료 | API 검증 오류 계약 보강 | 2026-04-28 | `src/main/java`, `src/test/java`, API 문서 |
| REQ-20260428-23 | P1 | PM | FE | 보류 | 일기 생성/수정/삭제 Flutter 구현 | 2026-04-28 | `mobile-flutter/lib`, `mobile-flutter/test` |
| REQ-20260428-24 | P1 | PM | QA | 완료 | 일기 CRUD 회귀 시나리오 및 자동화 확장 | 2026-04-28 | QA 문서, `mobile-flutter/test` |
| REQ-20260428-25 | P1 | PM | PM | 완료 | 위젯/딥링크 1차 설계 요청 준비 | 2026-04-28 | `.ai-work/msyeo/docs/widget-deeplink-plan.md` |
| REQ-20260428-26 | P2 | 사용자/PM | FE | 완료 | CRUD 이후 앱 사용성 개선 후보 설계 | 2026-04-28 | Flutter UX, calendar/diary flow |
| REQ-20260428-27 | P2 | 사용자/PM | BE | 완료 | 사용성 개선용 API 후보 설계 | 2026-04-28 | Diary search/filter, stats, widget summary |
| REQ-20260428-28 | P1 | PM | FE | 완료 | 캘린더 날짜 탭에서 일기 확인/작성 진입 플로우 구현 | 2026-04-28 | `mobile-flutter/lib`, `mobile-flutter/test` |
| REQ-20260428-29 | P1 | PM | QA | 완료 | API 검증 오류 계약 회귀 검증 | 2026-04-28 | QA 문서, 백엔드 실행 검증 |
| REQ-20260428-30 | P1 | PM | QA | 완료 | 캘린더 날짜 탭 UX 회귀 검증 | 2026-04-28 | `mobile-flutter/test`, QA 문서 |
| REQ-20260428-31 | P2 | PM | PM | 완료 | 동일 날짜 다건 일기 UX 기준 결정 | 2026-04-28 | 협업 요청 기준 |
| REQ-20260428-32 | P0 | 사용자/PM | PM | 완료 | 기획 개선 후보 도출 및 역할별 업무 배분 | 2026-04-28 | 협업 요청/현황 문서 |
| REQ-20260428-33 | P1 | PM | FE | 완료 | 일기 작성 UX 잔여 개선 | 2026-04-28 | `mobile-flutter/lib`, `mobile-flutter/test` |
| REQ-20260428-34 | P1 | PM | BE | 완료 | 오늘/위젯 요약 API 1차 구현 | 2026-04-28 | `src/main/java`, `src/test/java`, API 문서 |
| REQ-20260428-35 | P1 | PM | 단일 세션 | 대기 | MVP 릴리스 회귀 체크리스트와 신규 개선 검증 계획 | 2026-04-28 | QA 문서, `mobile-flutter/test` |
| REQ-20260428-36 | P1 | PM | PM | 완료 | 위젯/딥링크 구현 요청 분해와 우선순위 결정 | 2026-04-28 | widget/deeplink 계획, 협업 문서 |
| REQ-20260428-37 | P1 | PM | 단일 세션 | 완료 | 오늘/위젯 요약 API 실제 서버 회귀 검증 | 2026-04-28 | QA 문서, 백엔드 실행 검증 |
| REQ-20260428-38 | P1 | PM | 단일 세션 | 대기 | Flutter 딥링크 라우터 1차 구현 | 2026-04-28 | `mobile-flutter/lib`, `mobile-flutter/test` |
| REQ-20260428-39 | P1 | PM | 단일 세션 | 대기 | 위젯 요약 데이터 앱 연동 경계 구현 | 2026-04-28 | `mobile-flutter/lib`, `mobile-flutter/test` |
| REQ-20260428-40 | P2 | PM | 단일 세션 | 대기 | 네이티브 위젯 shell 범위 결정 | 2026-04-28 | Android/iOS 위젯 구현 범위 |
| SINGLE-MIGRATION-20260521-01 | P0 | 사용자 | 단일 세션 | 완료 | 역할 분배 철회와 단일 세션 작업 목록 정리 | 2026-05-21 | 협업 규칙, 작업 목록, 상태 문서 |
| REQ-20260521-01 | P1 | 사용자 | 단일 세션 | 완료 | 백엔드 30080, Flutter web 30081 포트 기준 반영 | 2026-05-21 | `src/main/resources`, `mobile-flutter`, 문서 |
| REQ-20260521-02 | P0 | 사용자 | 단일 세션 | 완료 | Rocky 10.1 미니 PC Flutter SDK 설치와 검증 복구 | 2026-05-21 | Flutter SDK, `mobile-flutter`, 실행 환경 |
| REQ-20260521-03 | P0 | 사용자 | 단일 세션 | 완료 | 웹 브라우저 확인용 백엔드/Flutter web 실행 | 2026-05-21 | systemd 임시 서비스, 30080/30081 |
| REQ-20260521-04 | P1 | 사용자 | 단일 세션 | 완료 | 출품 수준 캘린더 TODO와 몽토리 메뉴 완성도 개선 | 2026-05-21 | `src/main/java`, `src/test/java`, `mobile-flutter/lib`, `mobile-flutter/test`, 사용가이드 |
| REQ-20260521-05 | P1 | 사용자 | 단일 세션 | 진행중, 3차 완료 | 초기 로딩 진행 UI, PostgreSQL 전환, 다이어리 앱 완성도 개선 | 2026-05-21 | `mobile-flutter/web`, `mobile-flutter/lib`, `src/main/java`, `src/main/resources`, `pom.xml`, 문서 |

## 요청 상세
### REQ-20260521-05
- 우선순위: P1
- 요청자: 사용자
- 대상: 단일 세션
- 상태: 진행중, 3차 완료
- 요청 내용:
  - Flutter web 초기 로딩 구간에 로딩/인스톨 중임을 알 수 있는 진행 UI를 제공한다.
  - 데이터 저장 방식을 PostgreSQL 중심으로 전환한다.
  - 유명 다이어리 앱 기능을 참고해 더 완성형의 다이어리 앱으로 개선한다.
- 1차 완료 기준:
  - Flutter web 부트 로딩 UI와 release build 검증.
  - Spring Boot 기본 PostgreSQL 설정, 테스트 DB 분리, 실제 PostgreSQL 접속 검증.
  - 유명 다이어리 앱 기능 참고 문서 작성.
  - 일기 홈에 작성 프롬프트/기록 흐름/지난 오늘 같은 회고형 기능 반영.
  - Flutter analyze/test, Maven test 통과.
- 1차 결과:
  - `web/index.html`과 `web/flutter_bootstrap.js`로 앱 파일 다운로드, 엔진 초기화, 데이터 연결 확인 단계의 진행 UI를 추가했다.
  - 기본 DB를 PostgreSQL로 전환하고 `sqlite` 레거시 프로필과 H2 테스트 설정을 분리했다.
  - 실제 PostgreSQL 16.13 서비스에 `mongtorydiary` DB와 `mongtory` 사용자를 준비했고, 프로젝트 DB 사용자에 한정해 localhost password 인증을 허용했다.
  - Day One, Penzu, Daylio, Apple Journal, Journey 참고 기능을 `.ai-work/msyeo/docs/diary-app-feature-benchmark.md`에 정리했다.
  - 일기 홈에 `오늘의 회고`, `기록 흐름`, `지난 오늘`, `최근 일기` 구조를 반영했다.
  - `flutter analyze`, `flutter test`, `flutter build web --release`, Maven test가 통과했다.
  - 30080 백엔드는 PostgreSQL 기준, 30081은 release build 정적 서버 기준으로 재시작하고 smoke 검증했다.
- 후속 완료 기준:
  - 검색/태그 API와 Flutter 필터 UI.
  - 사진 URL 입력을 실제 업로드/첨부로 전환.
  - `지난 오늘` 전용 API.
  - 위치/날씨 메타데이터와 작성 리마인더.
- 2차 결과:
  - 백엔드 일기 엔티티/DTO에 `tags`를 추가했고, 생성/수정 요청에서 태그를 정규화해 저장한다.
  - `GET /api/v1/diaries`에 `query`, `tag` 필터를 추가했다.
  - `GET /api/v1/diaries/memories?month=&day=` 전용 API를 추가했다.
  - Flutter 홈에 검색 필드와 태그 필터 칩을 추가하고, 상세/작성 화면에 태그 표시와 입력을 연결했다.
  - Flutter repository/datasource/mock/QA 하네스와 API 문서를 태그/검색/지난 오늘 계약으로 갱신했다.
  - Maven test 26건, Flutter analyze, Flutter test 13건, Flutter release build, 실제 30080/30081 smoke가 통과했다.
- 3차 결과:
  - `POST /api/v1/diary-images` multipart 업로드 API를 추가하고 `/uploads/**` 정적 제공을 연결했다.
  - 업로드 저장 위치와 최대 크기 설정을 `mongtory.upload.*`와 Spring multipart 설정으로 분리했다.
  - Flutter 작성/수정 화면에 `사진 선택` 버튼을 추가해 파일 선택 후 업로드 URL을 `imageUrls`에 반영한다.
  - 기존 사진 URL 직접 입력은 외부 URL fallback으로 유지했다.
  - Maven test 28건, Flutter analyze, Flutter test 13건, Flutter release build, 실제 30080/30081 업로드 smoke가 통과했다.
- 남은 후속 완료 기준:
  - 위치/날씨 메타데이터와 작성 리마인더.

### REQ-20260521-04
- 우선순위: P1
- 요청자: 사용자
- 대상: 단일 세션
- 상태: 완료
- 요청 내용:
  - 캘린더 메뉴에서 큰 월간 달력을 제공한다.
  - 원하는 날짜를 눌러 TODO를 남길 수 있게 한다.
  - 캘린더와 몽토리 메뉴의 모호한 영역 정의를 출품 가능한 수준의 제품 기능으로 구체화한다.
  - 페이즈별 작업 종료 시 handoff에 작업 내용을 남긴다.
  - 완료 후 작업 내용 정리와 사용가이드 마크다운 문서를 작성한다.
  - 검증 후 Git 커밋과 푸시를 마무리한다.
  - 마지막에 서버를 재시작한다.
- 1차 완료 기준:
  - 백엔드 TODO API와 테스트
  - Flutter 캘린더 큰 월간 UI, 날짜 선택, 날짜별 TODO 조회/생성/완료 토글
  - 몽토리 메뉴의 대시보드/동반자 기능 구체화
  - Flutter analyze/test, Maven test 통과
  - handoff 갱신
- 1페이즈 결과:
  - 백엔드 TODO API와 캘린더 TODO 요약 확장을 구현했다.
  - Flutter 캘린더에서 큰 월간 달력, 날짜 선택, 날짜별 TODO 추가/완료/삭제를 구현했다.
  - 몽토리 메뉴를 상태/성장/감정/위젯 미리보기 대시보드로 구체화했다.
  - 제품 범위 문서와 사용가이드 문서를 추가했다.
  - `flutter analyze`, `flutter test`, Maven test가 통과했다.
  - `feature/ai-workspace-docs` 브랜치에 커밋/푸시했다.
  - 백엔드 30080과 Flutter web 30081 서비스를 재시작하고 실제 서버 smoke를 통과했다.

### REQ-20260521-03
- 우선순위: P0
- 요청자: 사용자
- 대상: 단일 세션
- 상태: 완료
- 요청 내용:
  - 사용자가 웹 브라우저에서 바로 접속할 수 있도록 백엔드와 Flutter web을 실행한다.
  - 백엔드는 30080, Flutter web은 30081 기준으로 띄운다.
  - Flutter web에서 백엔드 API를 호출할 수 있도록 개발 포트 CORS를 확인한다.
  - 외부 브라우저 접속 주소와 종료 명령을 안내한다.
- 완료 기준:
  - `http://192.168.75.194:30080/api/v1/emotions` 응답 확인
  - `http://192.168.75.194:30081/` HTML 응답 확인
  - `Origin: http://192.168.75.194:30081` 기준 CORS preflight 통과
  - 서비스 상태와 포트 LISTEN 확인

### REQ-20260521-02
- 우선순위: P0
- 요청자: 사용자
- 대상: 단일 세션
- 상태: 완료
- 요청 내용:
  - 현재 세션에서 찾을 수 없는 Flutter SDK를 Rocky 10.1 환경에 설치한다.
  - `mobile-flutter`에서 `flutter analyze`와 `flutter test`를 실행할 수 있는 상태로 복구한다.
  - 가능하면 Flutter web을 30081 기준으로 실행할 수 있는 명령을 확인한다.
- 완료 기준:
  - `flutter --version` 또는 동등한 SDK 버전 확인
  - `mobile-flutter` 기준 `flutter pub get`, `flutter analyze`, `flutter test` 결과 기록
  - 남은 Android/iOS/Chrome 의존성 이슈가 있으면 명시

### REQ-20260521-01
- 우선순위: P1
- 요청자: 사용자
- 대상: 단일 세션
- 상태: 완료
- 요청 내용:
  - 백엔드 서버는 30080 포트로 실행되도록 기본 설정을 변경한다.
  - Flutter web은 30081 포트로 실행하는 기준을 문서에 반영한다.
  - Flutter remote 모드의 기본 API 주소는 백엔드 포트인 30080을 바라보게 한다.
- 완료 기준:
  - `server.port=30080`
  - Flutter `API_BASE_URL` 기본값 `http://10.0.2.2:30080`
  - 현재 실행 문서의 Flutter web 포트 30081 반영
  - 백엔드 테스트 또는 미실행 사유 기록

### REQ-20260428-01
- 우선순위: P0
- 요청자: 사용자/PM
- 대상 역할: PM
- 상태: 완료
- 요청 내용:
  - PM, QA, FE 개발자, BE 개발자 역할 기준의 전체 프로젝트 흐름을 알 수 있는 마스터 문서를 만든다.
  - 역할 간 소통을 위한 요청 문서, 현황 문서, 응답 문서를 만든다.
  - 해당 문서들을 공통 룰로 지정한다.
- 완료 기준:
  - `master-flow.md`, `requests.md`, `status.md`, `responses.md`가 4역할 기준으로 정리됨
  - `AGENTS.md`, README, 상태 문서, handoff에 공통 룰 반영

### REQ-20260428-02
- 우선순위: P1
- 요청자: PM
- 대상 역할: QA
- 상태: 완료
- 요청 내용:
  - 실제 백엔드 컨트롤러와 Flutter remote datasource 기준으로 API/DTO 계약을 다시 확인한다.
  - 로그인, 일기 목록/상세, 캘린더 월 조회, 감정 목록의 수동 검증 시나리오를 작성한다.
  - 문서와 코드 불일치가 있으면 요청 또는 응답에 명확히 남긴다.
- 완료 기준:
  - 검증 대상 엔드포인트 목록
  - 요청/응답 필드 차이 목록
  - 수동 검증 시나리오
  - 실행하지 못한 검증과 이유
- PM 메모:
  - 2026-04-28 QA가 실제 코드 기준 API/DTO 계약 재확인과 수동 검증 시나리오 작성을 완료했다.
  - 오류 응답 표준화 필요 항목은 후속 BE 작업 `REQ-20260428-08`로 연결했다.

### REQ-20260428-03
- 우선순위: P1
- 요청자: PM
- 대상 역할: FE
- 상태: 완료
- 요청 내용:
  - 현재 임시 로그인 버튼 중심 화면을 실제 이메일/비밀번호 입력 폼으로 전환한다.
  - mock/remote 모드 표시와 기존 세션 흐름은 유지한다.
  - 로그인 실패 메시지를 사용자가 이해할 수 있게 표시한다.
- 완료 기준:
  - 변경 파일 목록
  - `flutter analyze`, `flutter test` 결과 또는 미실행 사유
  - BE API 변경 요청이 있으면 별도 요청 등록
- FE 메모:
  - 2026-04-28 FE 세션이 작업을 시작했다.
  - 2026-04-28 FE 구현 완료 후 `responses.md`에 결과를 등록했다.
  - 2026-04-28 PM이 응답과 검증 결과를 확인해 완료 처리했다. 이 요청은 역할별 handoff 규칙 추가 이전 완료분으로 보고 새 handoff 규칙은 소급 적용하지 않는다.

### REQ-20260428-04
- 우선순위: P1
- 요청자: PM
- 대상 역할: BE
- 상태: 완료
- 요청 내용:
  - 인증 성공/실패와 access token 기반 사용자 식별 테스트를 보강한다.
  - 타 사용자 일기 접근 차단 테스트를 추가한다.
  - 전역 예외 응답 표준화 필요 여부를 검토한다.
- 완료 기준:
  - 변경 파일 목록
  - Maven 테스트 결과
  - API 계약 또는 Flutter 오류 처리에 영향 있는 변경 사항
- BE 메모:
  - 2026-04-28 Developer 세션이 백엔드 담당으로 작업을 시작했다.
  - 2026-04-28 테스트 보강과 Maven 검증을 완료하고 `responses.md`에 결과를 기록했다.
  - 2026-04-28 PM이 수행자 응답, 검증 결과, 후속 `REQ-20260428-08` 완료 상태를 확인해 완료 처리했다.

### REQ-20260428-05
- 우선순위: P0
- 요청자: 사용자/PM
- 대상 역할: PM
- 상태: 완료
- 요청 내용:
  - `REQ-20260428-02`, `REQ-20260428-03`, `REQ-20260428-04`가 끝났을 때 바로 이어갈 다음 업무를 준비한다.
  - 2차 요청은 QA, FE, BE가 다시 병렬 또는 순차 진행할 수 있도록 선행 조건과 완료 기준을 포함한다.
- 완료 기준:
  - 2차 요청이 요청 목록에 등록됨
  - `status.md`에 2차 작업 보드가 추가됨
  - 프로젝트 상태와 handoff에 다음 업무 준비 상태가 기록됨

### REQ-20260428-06
- 우선순위: P1
- 요청자: PM
- 대상 역할: QA
- 상태: 완료
- 선행 조건:
  - `REQ-20260428-02`, `REQ-20260428-03`, `REQ-20260428-04` 완료
- 요청 내용:
  - 백엔드 서버와 Flutter remote 모드 기준으로 로그인, 일기 목록, 일기 상세, 캘린더 월 조회, 감정 목록을 실제 실행 검증한다.
  - FE 로그인 입력 폼과 BE 인증/소유권 테스트 보강 이후 회귀 이슈가 있는지 확인한다.
  - 실패 시 재현 명령, 요청/응답 요약, 담당 역할 추정치를 남긴다.
- 완료 기준:
  - 실행 명령과 접속 URL
  - 통과/실패 시나리오 목록
  - 실패 로그 요약
  - FE 또는 BE 후속 요청이 필요한 항목
- QA 메모:
  - 2026-04-28 QA가 백엔드 서버를 실제 기동하고 로그인, 일기 목록/상세, 캘린더, 감정 목록, invalid access token 오류 응답을 검증했다.
  - Flutter `test`와 `analyze`도 통과했다.
  - Flutter 앱 remote 모드 UI 실행은 CLI 환경 한계로 수행하지 않았다.

### REQ-20260428-07
- 우선순위: P1
- 요청자: PM
- 대상 역할: FE
- 상태: 완료
- 선행 조건:
  - `REQ-20260428-03` 완료
  - `REQ-20260428-02`에서 일기 상세 API 계약 차단 이슈 없음
- 요청 내용:
  - 일기 목록 화면에서 항목을 선택하면 일기 상세 화면으로 진입하는 플로우를 구현한다.
  - mock/remote 양쪽 데이터 소스에서 동일한 사용자 경험을 유지한다.
  - 상세 화면에는 제목, 날짜, 감정, 본문, 이미지 URL 목록의 기본 표시와 로딩/오류 상태를 포함한다.
- 완료 기준:
  - 변경 파일 목록
  - `flutter analyze`, `flutter test` 결과 또는 미실행 사유
  - 화면/상태 변경 요약
  - BE API 변경 요청이 있으면 별도 요청 등록
- FE 메모:
  - 2026-04-28 FE가 목록 항목 탭, 상세 화면, 상세 provider, 위젯 테스트를 완료했다.
  - 2026-04-28 PM이 수행자/요청자 responses, FE handoff, 검증 결과를 확인해 완료 처리했다.

### REQ-20260428-08
- 우선순위: P1
- 요청자: PM
- 대상 역할: BE
- 상태: 완료
- 선행 조건:
  - `REQ-20260428-04` 완료
  - `REQ-20260428-02`에서 오류 응답 계약 이슈 확인
- 요청 내용:
  - `ResponseStatusException` 등 백엔드 오류 응답이 가능한 한 `ApiResponse` 규칙과 맞도록 전역 예외 처리 기준을 정리하고 구현한다.
  - Flutter `ApiClient`가 status code와 message를 안정적으로 읽을 수 있는 응답을 보장한다.
  - 인증 실패, 리소스 없음, 중복 이메일 같은 주요 오류 케이스를 테스트로 확인한다.
- 완료 기준:
  - 변경 파일 목록
  - Maven 테스트 결과
  - 오류 응답 예시
  - Flutter 오류 처리에 필요한 변경 요청
- BE 메모:
  - 2026-04-28 BE가 `ApiResponse.error(message)`와 `GlobalExceptionHandler`를 추가하고 주요 오류 body 테스트를 보강했다.
  - 2026-04-28 PM이 수행자/요청자 responses, BE handoff, Maven 테스트 결과를 확인해 완료 처리했다.

### REQ-20260428-09
- 우선순위: P1
- 요청자: PM
- 대상 역할: FE/BE
- 상태: 완료
- 선행 조건:
  - `REQ-20260428-06` 완료
  - `REQ-20260428-07` 완료
  - `REQ-20260428-08` 완료 또는 오류 응답 차단 이슈 해소
- 요청 내용:
  - 일기 생성/수정/삭제 플로우를 실제 기능 구현 단계로 올리기 위한 API/FE 작업 범위를 확정한다.
  - BE는 현재 Diary CRUD API의 요청/응답/권한 검증 상태를 최종 확인한다.
  - FE는 repository 계약, remote datasource, 화면 진입 구조에 필요한 변경 범위를 산정한다.
  - PM은 이 요청 결과를 바탕으로 실제 구현 요청을 FE/BE로 분리한다.
- 완료 기준:
  - BE 작업 필요 여부
  - FE 작업 파일 범위
  - 일기 생성/수정/삭제 UX 최소 플로우
  - 다음 구현 요청 ID 후보
- 분장:
  - FE: Flutter repository/remote/mock 계약 확장 범위, 작성/수정/삭제 화면 진입, 저장 후 목록 갱신 플로우 산정
  - BE: Diary CRUD API 요청/응답/권한/오류 계약 최종 확인, 생성/수정/삭제 테스트 보강 필요 범위 산정
  - QA: FE/BE 범위 확정 후 `REQ-20260428-24`로 회귀 시나리오와 자동화 확장 준비
- PM 메모:
  - 2026-04-28 FE가 Flutter 일기 생성/수정/삭제 repository, remote/mock datasource, 작성/수정/삭제 화면, provider 갱신, 위젯 테스트를 구현했다.
  - 2026-04-28 PM이 `flutter analyze`, `flutter test`, `git diff --check`를 재실행해 통과를 확인했다.
  - 중복 후속 요청 `REQ-20260428-23`은 이 구현 결과에 흡수해 보류 처리한다.

### REQ-20260428-10
- 우선순위: P1
- 요청자: 사용자/QA
- 대상 역할: QA
- 상태: 완료
- 요청 내용:
  - Flutter 앱 QA 자동화 하네스를 1차 구축한다.
  - 우선 widget test harness를 기준으로 공통 pump/helper, ProviderScope override, mock 모드 smoke test 구조를 정리한다.
  - 필요 시 `integration_test` 도입 범위와 실행 명령을 별도 단계로 정리한다.
  - 자동화 테스트 중 발생한 오류는 원인 영역에 따라 FE 또는 BE 개발자 대상 후속 요청으로 작성한다.
- 결함 요청 작성 기준:
  - FE 요청: 화면 렌더링, 입력 검증, navigation, 상태 표시, Flutter repository/mock 처리 문제
  - BE 요청: HTTP status, 응답 body, DTO 필드, 인증/권한, 서버 오류, 데이터 소유권 문제
  - QA 요청: 자동화 하네스 자체 문제, 재현 불안정성, 원인 미분류 분석
- 완료 기준:
  - 하네스 구조와 실행 명령
  - 자동화 테스트 대상 smoke 시나리오
  - 실패 발생 시 FE/BE 후속 요청 작성 여부
  - 실행하지 못한 검증과 이유
- PM 메모:
  - 2026-04-28 QA가 widget test 기반 하네스와 smoke test를 구현하고 `flutter analyze`, `flutter test` 통과를 기록했다.
  - 2026-04-28 QA 역할별 handoff 날짜 문서가 보완되어 완료 상태로 전환했다.

### REQ-20260428-11
- 우선순위: P0
- 요청자: 사용자/PM
- 대상 역할: PM
- 상태: 완료
- 요청 내용:
  - 특정 공통 문서에 여러 세션이 동시에 쓰는 문제를 줄이기 위해 역할별 디렉토리를 만든다.
  - 누가 요청했는지 명확히 알 수 있도록 요청자별 문서를 운영한다.
  - 공통 문서는 인덱스화하고 실제 편집은 역할별 문서에서 수행하도록 프로세스를 개선한다.
- 완료 기준:
  - `collaboration/roles/{pm|qa|fe|be}/` 아래에 `requests.md`, `inbox.md`, `status.md`, `responses.md` 생성
  - `master-flow.md`와 공통 요청/현황/응답 문서가 인덱스 운영 방식으로 갱신
  - `AGENTS.md`, README, 상태 문서, handoff에 새 프로세스 반영

### REQ-20260428-12
- 우선순위: P0
- 요청자: 사용자/PM
- 대상 역할: PM
- 상태: 완료
- 요청 내용:
  - 모든 작업 블록이 끝나면 각자의 역할 디렉토리 안에 handoff 문서를 작성하도록 룰을 만든다.
  - 요청받은 업무에 대한 응답은 요청한 담당자의 `responses.md`에도 어떤 요청을 어떻게 처리했는지 남기도록 한다.
  - PM이 이를 항상 모니터링하고 오류를 방지할 수 있는 방법을 고안한다.
- 완료 기준:
  - 역할별 `handoff/YYYY-MM-DD.md` 규칙 추가
  - 수행자 responses와 요청자 responses 양방향 기록 규칙 추가
  - PM 모니터링 체크리스트 추가
  - `AGENTS.md`, README, project-status, handoff에 반영

### REQ-20260428-13
- 우선순위: P0
- 요청자: 사용자/PM
- 대상 역할: PM
- 상태: 완료
- 요청 내용:
  - PM이 모니터링하다가 완료된 작업에 대해 커밋이 필요하다고 판단하면 PM이 취합하여 직접 커밋하도록 한다.
- 완료 기준:
  - PM 커밋 판단 기준 추가
  - 커밋 전 확인 조건 추가
  - 요청 ID 단위 커밋 범위 원칙 추가
  - 커밋 메시지 형식과 커밋 후 기록 규칙 추가

### REQ-20260428-14
- 우선순위: P0
- 요청자: 사용자/PM
- 대상 역할: PM
- 상태: 완료
- 요청 내용:
  - PM이 모든 역할들의 디렉토리 문서를 모니터링하도록 한다.
  - PM이 문서를 확인해 역할 간 소통 문제를 발견하고, 해답을 찾아 협업룰을 조정하도록 한다.
- 완료 기준:
  - PM 모니터링 범위를 모든 역할 디렉토리 문서로 확장
  - 소통 문제 triage 기준 추가
  - 협업룰 조정 절차 추가

### REQ-20260428-15
- 우선순위: P0
- 요청자: 사용자/PM
- 대상 역할: PM
- 상태: 완료
- 요청 내용:
  - 모든 담당자는 매 작업 시작마다 변경된 룰이 없는지 체크하도록 강제한다.
- 완료 기준:
  - 작업 시작 전 확인 대상 문서 명시
  - 역할별 `status.md`에 룰 확인 기록 섹션 추가
  - PM 모니터링에서 룰 확인 기록 누락을 오류로 감지
  - AGENTS, master-flow, roles README, PM monitoring에 반영
  - AGENTS, project-status, master-flow, PM monitoring에 반영

### REQ-20260428-21
- 우선순위: P0
- 요청자: 사용자/PM
- 대상 역할: PM
- 상태: 완료
- 요청 내용:
  - 커밋할 수 있는 완료 변경을 PM이 취합해 커밋한다.
  - 프로젝트 목표 달성을 위한 단계적 업무계획을 작성한다.
  - 계획에 따라 QA, FE, BE, PM 후속 업무를 배분한다.
- 완료 기준:
  - 기준선 검증 결과 확인
  - `.ai-work/msyeo/docs/delivery-roadmap.md` 작성
  - 후속 요청 `REQ-20260428-22`부터 `REQ-20260428-25`까지 등록
  - 역할별 inbox/status와 공통 인덱스 반영

### REQ-20260428-22
- 우선순위: P1
- 요청자: PM
- 대상 역할: BE
- 상태: 완료
- 선행 조건:
  - `REQ-20260428-06`, `REQ-20260428-08` 완료
- 요청 내용:
  - malformed JSON body, 누락 query parameter, calendar `year/month` 범위 오류, 요청 DTO 검증 실패를 `ApiResponse` 오류 규칙으로 고정한다.
  - 필요한 경우 Bean Validation 또는 명시적 검증 로직을 적용한다.
  - 오류 응답 예시를 QA가 확인할 수 있게 남긴다.
- 완료 기준:
  - 변경 파일 목록
  - Maven 테스트 결과
  - 오류 케이스별 status/message/body 예시
  - Flutter 오류 처리 변경 필요 여부
- PM 메모:
  - 2026-04-28 BE가 누락 query parameter, malformed JSON, request body 타입 오류, calendar month 범위 오류, 일기 생성/수정 필수값 검증을 400 계열 `ApiResponse`로 고정했다.
  - PM이 `JAVA_HOME=/usr/lib/jvm/java-21-openjdk bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test`를 재실행해 통과를 확인했다.
  - QA `REQ-20260428-29` 실제 서버 curl 회귀 검증까지 통과했다.

### REQ-20260428-23
- 우선순위: P1
- 요청자: PM
- 대상 역할: FE
- 상태: 보류
- 선행 조건:
  - `REQ-20260428-07`, `REQ-20260428-08` 완료
- 요청 내용:
  - Flutter에서 일기 생성, 수정, 삭제 플로우를 구현한다.
  - mock/remote datasource, repository 계약, 화면 상태, 입력 검증, 오류 표시를 함께 정리한다.
  - 상세 화면에서 수정/삭제 진입점을 제공하고, 홈 화면에서 작성 진입점을 제공한다.
- 완료 기준:
  - 변경 파일 목록
  - `flutter analyze`, `flutter test` 결과
  - mock/remote 동작 범위
  - BE API 변경 요청이 있으면 별도 요청 등록
- PM 메모:
  - 2026-04-28 해당 구현 범위는 `REQ-20260428-09` FE 작업으로 이미 완료됐다.
  - 별도 추가 구현 요청으로 유지하지 않고 `REQ-20260428-09` 결과에 흡수했다.

### REQ-20260428-24
- 우선순위: P1
- 요청자: PM
- 대상 역할: QA
- 상태: 완료
- 선행 조건:
  - `REQ-20260428-09` 완료
- 요청 내용:
  - 일기 생성/수정/삭제에 대한 QA 회귀 시나리오를 작성한다.
  - 가능한 범위에서 widget test 하네스를 확장한다.
  - remote 검증은 BE/FE 변경 완료 후 실행 가능한 명령과 expected result로 정리한다.
- 완료 기준:
  - CRUD 시나리오 목록
  - 자동화 추가/수정 파일 목록
  - `flutter test` 또는 미실행 사유
  - FE/BE 후속 결함 요청 여부
- QA 메모:
  - 2026-04-28 QA가 상태형 harness fake repository와 CRUD smoke test를 추가했다.
  - `flutter test` 9건과 `flutter analyze` 통과를 확인했다.
  - 실제 서버 remote CRUD API도 로그인 -> 생성 -> 상세 -> 수정 -> 목록 반영 -> 삭제 -> 목록 제외 -> invalid token 실패 응답 순서로 검증했다.

### REQ-20260428-25
- 우선순위: P1
- 요청자: PM
- 대상 역할: PM
- 상태: 완료
- 선행 조건:
  - 일기 CRUD MVP 완료 또는 구현 범위 확정
- 요청 내용:
  - 위젯에 필요한 요약 데이터, 딥링크 진입점, 백엔드/앱 책임 경계를 1차 설계한다.
  - Android/iOS 위젯 플랫폼 확장 요청을 FE/BE가 실행 가능한 단위로 나눈다.
- 완료 기준:
  - 위젯 데이터 모델 후보
  - 딥링크 URL/route 후보
  - FE/BE 후속 요청 후보
  - 구현 전 리스크와 보류 범위
- PM 메모:
  - 2026-04-28 `.ai-work/msyeo/docs/widget-deeplink-plan.md`에 위젯 요약 데이터 모델, 딥링크 URL/route 후보, FE/BE 후속 요청 후보, 리스크와 보류 범위를 정리했다.
  - 위젯은 앱이 생성한 로컬 공유 요약 데이터를 읽는 조회 전용 진입점으로 우선 설계하고, 서버 위젯 요약 API는 BE `REQ-20260428-27`에서 필요성을 평가하도록 연결한다.

### REQ-20260428-26
- 우선순위: P2
- 요청자: 사용자/PM
- 대상 역할: FE
- 상태: 완료
- 선행 조건:
  - `REQ-20260428-09` 완료
- 요청 내용:
  - CRUD 이후 앱 사용성을 높일 Flutter 기능 후보를 설계한다.
  - 우선 후보는 캘린더 날짜 탭 -> 해당 날짜 일기 작성/상세 진입, 일기 작성 UX 개선, 작성 중 임시 저장, 빈 상태 CTA 개선, 오프라인/로딩/재시도 상태 강화, 감정 기반 필터다.
  - 구현은 바로 시작하지 말고 UX 영향, 구현 난이도, BE 의존성을 기준으로 우선순위를 제안한다.
- 완료 기준:
  - 후보별 사용자 가치
  - Flutter 변경 예상 파일/화면
  - BE API 의존성 여부
  - 1순위 구현 요청 후보
- PM 메모:
  - 2026-04-28 FE가 캘린더 날짜 탭에서 해당 날짜 일기 확인/작성으로 이어지는 플로우를 1순위 후보로 제안했다.
  - 같은 날짜 다건 처리 UX는 PM 결정 후 신규 구현 요청으로 분리한다.

### REQ-20260428-27
- 우선순위: P2
- 요청자: 사용자/PM
- 대상 역할: BE
- 상태: 완료
- 선행 조건:
  - `REQ-20260428-22` 착수 또는 완료
  - `REQ-20260428-09` CRUD Flutter 구현 범위 확인
- 요청 내용:
  - 앱 사용성을 높일 백엔드 API 후보를 설계한다.
  - 우선 후보는 일기 검색/필터 API, 작성 검증 강화, 이미지 업로드 준비 API, 월간 감정 통계 API, 위젯용 요약 API, 토큰 만료/갱신 전략 정리다.
  - 구현은 바로 시작하지 말고 API 가치, Flutter 의존성, 테스트 범위, 위젯 확장성과 연결해 우선순위를 제안한다.
- 완료 기준:
  - 후보별 API 경로/응답 초안
  - 기존 모델/DTO 변경 필요 여부
  - 테스트 보강 범위
  - 1순위 구현 요청 후보
- PM 메모:
  - 2026-04-28 BE가 후보 설계를 완료했다.
  - 날짜별 일기 조회는 기존 `GET /api/v1/diaries?from=YYYY-MM-DD&to=YYYY-MM-DD` 사용으로 우선 처리 가능하다고 판단했다.
  - 1순위 구현 후보는 `GET /api/v1/widgets/today-summary?date=YYYY-MM-DD` 오늘/위젯 요약 API다.

### REQ-20260428-28
- 우선순위: P1
- 요청자: PM
- 대상 역할: FE
- 상태: 검토중
- 선행 조건:
  - `REQ-20260428-26` 완료
  - `REQ-20260428-31` 완료
- 요청 내용:
  - 캘린더 화면에서 날짜를 탭하면 해당 날짜 일기 목록 또는 작성 진입으로 이어지는 플로우를 구현한다.
  - 같은 날짜에 여러 일기가 있을 수 있으므로 최신 1건으로 바로 이동하지 말고 날짜별 목록 또는 bottom sheet로 선택지를 보여준다.
  - 해당 날짜에 일기가 없으면 날짜가 미리 입력된 작성 화면으로 이동한다.
  - 기존 mock/remote 데이터 구조를 깨지 않고 1차 구현은 기존 월간 캘린더, 일기 목록, 작성/상세 화면을 활용한다.
- 완료 기준:
  - 변경 파일 목록
  - 캘린더 날짜 탭, 기록 있음, 기록 없음, 작성 진입 동작 요약
  - `flutter analyze`, `flutter test` 결과
  - BE API 변경 요청이 있으면 별도 요청 등록
- PM 메모:
  - FE 역할 문서에 이미 `FE-IMPROVE-20260428-02`로 같은 범위의 구현이 진행 중이므로, 공통 추적 ID는 `REQ-20260428-28`로 정규화한다.
  - FE는 최종 응답과 handoff에서 `FE-IMPROVE-20260428-02`와 `REQ-20260428-28`의 관계를 함께 남긴다.
  - 2026-04-28 FE가 구현 응답을 남겼고, PM이 `flutter analyze`, `flutter test`를 재실행해 통과를 확인했다.
  - QA `REQ-20260428-30`에서 기존 날짜 상세 진입과 빈 날짜 작성 기본값을 하네스 기준으로 검증했다.

### REQ-20260428-29
- 우선순위: P1
- 요청자: PM
- 대상 역할: QA
- 상태: 완료
- 선행 조건:
  - `REQ-20260428-22` BE 구현과 QA 검증 완료
- 요청 내용:
  - BE가 보강한 malformed JSON, 누락 query parameter, calendar `year/month` 범위 오류, 요청 DTO 검증 실패 응답을 실제 서버 기준으로 회귀 검증한다.
  - 각 실패 케이스의 HTTP status, `success=false`, `message`, `data=null` 여부를 확인한다.
  - Flutter 오류 표시 변경이 필요한 경우 FE 또는 BE 후속 요청으로 분리한다.
- 완료 기준:
  - 검증 명령과 대상 엔드포인트 목록
  - 케이스별 기대/실제 응답 요약
  - 결함이 있으면 담당 역할 추정과 후속 요청 후보
  - 실행하지 못한 검증과 이유

### REQ-20260428-30
- 우선순위: P1
- 요청자: PM
- 대상 역할: QA
- 상태: 완료
- 선행 조건:
  - `REQ-20260428-28` FE 구현과 QA 검증 완료
- 요청 내용:
  - 캘린더 날짜 탭에서 기록 있음/없음 상태, 다건 선택, 작성 화면 날짜 기본값, 상세 진입을 widget test 또는 수동 시나리오로 검증한다.
  - 기존 로그인, 일기 CRUD, 캘린더 탭 smoke test가 깨지지 않는지 확인한다.
- 완료 기준:
  - 자동화 추가/수정 파일 목록 또는 수동 시나리오
  - `flutter analyze`, `flutter test` 결과
  - FE/BE 후속 결함 요청 여부

### REQ-20260428-31
- 우선순위: P2
- 요청자: PM
- 대상 역할: PM
- 상태: 완료
- 요청 내용:
  - FE `REQ-20260428-26`에서 남긴 동일 날짜 다건 일기 UX 결정을 내린다.
- 결정:
  - 같은 날짜에 일기가 여러 건 있을 수 있으므로 날짜 탭은 최신 1건으로 바로 진입하지 않는다.
  - 기록 있음 상태는 날짜별 목록 또는 bottom sheet를 보여주고 사용자가 상세를 선택한다.
  - 기록 없음 상태는 해당 날짜가 기본값으로 들어간 작성 화면으로 이동한다.
- 완료 기준:
  - FE `REQ-20260428-28` 요청에 UX 기준 반영

### REQ-20260428-32
- 우선순위: P0
- 요청자: 사용자/PM
- 대상 역할: PM
- 상태: 완료
- 요청 내용:
  - 기획자 관점에서 현재 MVP 이후 개선할 사항과 필요한 기능을 도출한다.
  - PM, QA, FE, BE가 바로 이어갈 수 있도록 요청 ID, 선행 조건, 완료 기준을 분리한다.
- 완료 기준:
  - 공통 요청 인덱스와 역할별 inbox에 신규 요청 반영
  - 공통 현황과 project-status의 다음 우선순위 갱신
  - handoff에 다음 세션 체크포인트 기록
- PM 메모:
  - 개선 축은 작성 UX, 날짜별 조회/API 사용성, 릴리스 QA, 위젯/딥링크 구현 분해로 나눴다.

### REQ-20260428-33
- 우선순위: P1
- 요청자: PM
- 대상 역할: FE
- 상태: 검토중
- 선행 조건:
  - `REQ-20260428-28` 완료
  - `FE-IMPROVE-20260428-03` 감정 선택 UI 개선 결과 확인
- 요청 내용:
  - 이미 완료된 날짜 선택 UI 개선 결과를 회귀 확인하고, 작성/수정 화면 잔여 UX를 정리한다.
  - 사진 URL 입력을 추가/삭제 가능한 목록 또는 chip UI로 정리한다.
  - 저장 전 변경사항 이탈 확인, 저장 중 중복 탭 방지, 저장 실패 표시를 점검한다.
  - 기존 감정 선택 UI는 유지하되 mock/remote 감정 목록 실패 fallback이 깨지지 않도록 한다.
- 완료 기준:
  - 변경 파일 목록
  - 작성/수정 화면 UX 변경 요약
  - `flutter analyze`, `flutter test` 결과
  - BE API 변경 요청이 있으면 별도 요청 등록

### REQ-20260428-34
- 우선순위: P1
- 요청자: PM
- 대상 역할: BE
- 상태: 검토중
- 선행 조건:
  - `REQ-20260428-27` 완료
  - `REQ-20260428-22` 오류 계약 보강 완료
- 요청 내용:
  - BE `REQ-20260428-27` 1순위 후보인 `GET /api/v1/widgets/today-summary?date=YYYY-MM-DD` 오늘/위젯 요약 API를 1차 구현한다.
  - 응답에는 선택 날짜 작성 여부, 오늘 또는 지정일 일기 수, 대표 감정, 최근 일기 ID/제목, 연속 작성 일수 후보 값을 포함한다.
  - 동일 날짜 다건 처리 기준과 access token 소유권 기준을 테스트로 고정한다.
  - 아직 구현하지 않는 검색/필터, 월간 감정 통계, 이미지 업로드 준비 API는 후속 후보로 남긴다.
- 완료 기준:
  - 변경 파일 목록
  - API endpoint/DTO/오류 계약 요약
  - Maven 테스트 결과
  - Flutter 연동 시 필요한 DTO 필드 공유
- PM 메모:
  - 2026-04-28 구현 파일과 테스트 파일이 생성됐고 Maven 테스트 19건이 통과했다.
  - BE `responses.md`와 BE handoff에 `RES-REQ-20260428-34` 결과를 반영해 완료 처리했다.

### REQ-20260428-35
- 우선순위: P1
- 요청자: PM
- 대상: 단일 세션
- 이전 대상 역할: QA
- 상태: 완료
- 선행 조건:
  - `REQ-20260428-24`, `REQ-20260428-29`, `REQ-20260428-30` 완료
- 요청 내용:
  - MVP 릴리스 전 필수 회귀 체크리스트를 작성한다.
  - 로그인, 일기 CRUD, 캘린더 날짜 진입, 감정 선택, 오류 표시, remote/mock 전환을 포함한다.
  - FE `REQ-20260428-33`, BE `REQ-20260428-34` 결과를 검증할 자동화/수동 시나리오 초안을 준비한다.
- 완료 기준:
  - 체크리스트 문서 또는 QA status 상세 섹션
  - 자동화 가능/수동 필요 항목 분류
  - 후속 결함 작업 기준
  - 실행하지 못한 검증과 이유

### REQ-20260428-36
- 우선순위: P1
- 요청자: PM
- 대상 역할: PM
- 상태: 완료
- 선행 조건:
  - `REQ-20260428-27` 또는 `REQ-20260428-34`의 BE API 후보 결과 확인
  - `widget-deeplink-plan.md` 기존 설계 확인
- 요청 내용:
  - 위젯/딥링크 구현을 FE Flutter 라우팅, Android/iOS 네이티브 shell, BE 요약 API로 분해한다.
  - MVP에 포함할 범위와 후속 버전으로 미룰 범위를 결정한다.
  - FE/BE/QA에 배정할 구현 및 검증 요청을 별도 요청 ID로 작성한다.
- 완료 기준:
  - 위젯/딥링크 구현 요청 분해표
  - 선행 API와 플랫폼 작업 순서
  - QA 검증 범위
- PM 메모:
  - 2026-04-28 `.ai-work/msyeo/docs/widget-deeplink-implementation-plan.md`를 작성했다.
  - MVP 포함 범위는 Flutter 내부 딥링크 라우터, today-summary 앱 연동 경계, QA 검증 계획까지로 제한했다.
  - Android/iOS 네이티브 위젯 shell은 `REQ-20260428-40`에서 별도 결정한다.

### REQ-20260428-37
- 우선순위: P1
- 요청자: PM
- 대상: 단일 세션
- 이전 대상 역할: QA
- 상태: 완료
- 선행 조건:
  - `REQ-20260428-34` 완료
- 요청 내용:
  - today-summary API를 실제 서버 기준으로 검증한다.
  - today entry 없음, 1건, 다건, streak, invalid token 케이스를 포함한다.
  - FE `REQ-20260428-38`, `REQ-20260428-39` 결과 검증 시나리오 초안을 준비한다.
- 완료 기준:
  - 실제 서버 검증 명령과 케이스별 결과
  - 딥링크/위젯 요약 앱 연동 자동화/수동 검증 분류
  - 결함이 있으면 후속 구현/검증 작업 후보
- 단일 세션 메모:
  - 2026-05-21 실제 서버 회귀 검증을 완료했다.
  - 검증 결과와 케이스별 응답 요약은 `RES-REQ-20260428-37`에 기록했다.

### REQ-20260428-38
- 우선순위: P1
- 요청자: PM
- 대상: 단일 세션
- 이전 대상 역할: FE
- 상태: 대기
- 선행 조건:
  - `REQ-20260428-34` 완료
  - `widget-deeplink-implementation-plan.md` 확인
- 요청 내용:
  - Flutter 내부 딥링크 라우터 1차 구현을 진행한다.
  - `mongtory://home`, `mongtory://diaries/new?date=YYYY-MM-DD`, `mongtory://diaries/{diaryId}`, `mongtory://calendar?year=YYYY&month=MM&date=YYYY-MM-DD` 후보를 앱 내부 route로 매핑한다.
  - 세션이 없을 때 로그인 후 원래 진입 의도를 이어갈 수 있는 최소 구조를 둔다.
  - 네이티브 Android/iOS link 설정은 아직 수정하지 않는다.
- 완료 기준:
  - 변경 파일 목록
  - 지원 딥링크와 fallback 동작 요약
  - `flutter analyze`, `flutter test` 결과
  - 네이티브 설정 변경 필요 여부

### REQ-20260428-39
- 우선순위: P1
- 요청자: PM
- 대상: 단일 세션
- 이전 대상 역할: FE
- 상태: 대기
- 선행 조건:
  - `REQ-20260428-34` 완료
  - `REQ-20260428-38` 착수 또는 완료
- 요청 내용:
  - BE today-summary 응답을 Flutter DTO/model/repository 경계에 추가한다.
  - 홈 진입, 일기 CRUD 성공, 캘린더 새로고침 이후 요약 갱신 책임을 정리한다.
  - Android/iOS 공유 저장소 쓰기는 네이티브 shell 결정 전까지 interface 또는 adapter 경계로 둔다.
- 완료 기준:
  - 변경 파일 목록
  - 위젯 요약 DTO/model/repository 계약
  - 갱신 트리거와 실패 fallback 요약
  - `flutter analyze`, `flutter test` 결과

### REQ-20260428-40
- 우선순위: P2
- 요청자: PM
- 대상: 단일 세션
- 이전 대상 역할: PM
- 상태: 대기
- 선행 조건:
  - `REQ-20260428-38` 또는 `REQ-20260428-39` 결과 확인
  - `REQ-20260428-37` 또는 `REQ-20260428-35` 검증 결과 확인
- 요청 내용:
  - Android App Widget 또는 Glance, iOS WidgetKit 중 1차 구현 방식을 결정한다.
  - `mobile-flutter/android`, `mobile-flutter/ios` 변경 범위와 PM 승인 필요 범위를 분리한다.
  - 후속 구현 및 검증 작업을 새 요청 ID로 분리한다.
- 완료 기준:
  - Android/iOS 위젯 shell 구현 방식 결정
  - 플랫폼별 변경 파일 범위
  - 후속 요청 ID 후보
