# FE 응답 문서

## 응답 목록
| 응답 ID | 요청 ID | 상태 | 요약 | 작성일 |
| --- | --- | --- | --- | --- |
| RES-REQ-20260428-03 | REQ-20260428-03 | 완료 | Flutter 로그인 화면 실제 입력 폼 전환 | 2026-04-28 |
| RES-REQ-20260428-07 | REQ-20260428-07 | 완료 | 일기 목록에서 상세 진입 플로우 구현 | 2026-04-28 |
| RES-REQ-20260428-09 | REQ-20260428-09 | 완료 | 일기 생성/수정/삭제 Flutter 플로우 구현 | 2026-04-28 |
| RES-REQ-20260428-26 | REQ-20260428-26 | 완료 | CRUD 이후 앱 사용성 개선 후보 설계 | 2026-04-28 |
| RES-REQ-20260428-28 | REQ-20260428-28 | 완료 | 캘린더 날짜 탭에서 일기 확인/작성 진입 플로우 구현 | 2026-04-28 |
| RES-FE-IMPROVE-20260428-01 | FE-IMPROVE-20260428-01 | 완료 | 일기 홈/상세 퍼블리싱 품질 보강 | 2026-04-28 |
| RES-FE-IMPROVE-20260428-03 | FE-IMPROVE-20260428-03 | 완료 | 일기 작성/수정 감정 선택 UI 개선 | 2026-04-28 |
| RES-FE-IMPROVE-20260428-04 | FE-IMPROVE-20260428-04 | 완료 | 일기 작성/수정 날짜 선택 UI 개선 | 2026-04-28 |
| RES-REQ-20260428-33 | REQ-20260428-33 | 완료 | 일기 작성 UX 잔여 개선 | 2026-04-28 |

## 응답 상세
### RES-REQ-20260428-03
- 요청 ID: REQ-20260428-03
- 담당 역할: FE
- 상태: 완료
- 요약:
  - 임시 로그인 버튼 중심 화면을 이메일/비밀번호 입력 폼으로 전환했다.
  - mock/remote 모드 표시와 remote API URL 표시는 유지했다.
  - 필수 입력 검증, 이메일 형식 검증, 비밀번호 보기/숨기기, 로딩 중 버튼 비활성화, 오류 메시지 박스를 추가했다.
  - 시드 계정 검증을 빠르게 할 수 있도록 `테스트 계정 입력` 버튼을 제공했다.
  - 모바일 화면 기준으로 안전 영역, 스크롤, 최대 너비, 입력/버튼 간격을 정리했다.
- 변경 파일:
  - `mobile-flutter/lib/presentation/screens/sign_in_screen.dart`
  - `mobile-flutter/test/widget_test.dart`
- 검증:
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze`: 통과
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test`: 통과
  - 최초 sandbox 실행은 `pub.dev` DNS 조회 실패로 중단되어 네트워크 권한으로 재실행했다.
- 남은 이슈:
  - 실제 remote 백엔드 연결 검증은 Integration 또는 QA 세션에서 확인이 필요하다.
  - 회원가입, 토큰 재발급, 일기 작성/수정/삭제 플로우는 아직 구현되지 않았다.
- 다음 제안:
  - PM/QA가 로그인 입력 폼을 확인한 뒤 다음 FE 요청으로 `REQ-20260428-07` 일기 목록에서 상세 진입 플로우를 배정한다.

### RES-REQ-20260428-07
- 요청 ID: REQ-20260428-07
- 담당 역할: FE
- 상태: 완료
- 요약:
  - 일기 목록 provider와 같은 repository 계약을 사용하는 `diaryDetailProvider`를 추가했다.
  - 최근 일기 항목을 터치 가능한 항목으로 바꾸고 `DiaryDetailScreen`으로 이동하도록 연결했다.
  - 상세 화면에 감정 코드, 날짜, 제목, 본문, 첨부 사진 빈 상태, 수정 시간을 표시했다.
  - 상세 조회 로딩/오류/재시도 상태를 추가했다.
  - 목록 항목 탭 후 상세 콘텐츠가 노출되는 위젯 테스트를 추가했다.
  - 기존 QA 하네스의 미사용 import 1건을 제거해 `flutter analyze`가 통과하도록 했다.
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
  - 최초 sandbox 실행은 `pub.dev` DNS 조회 실패로 중단되어 네트워크 권한으로 재실행했다.
- 남은 이슈:
  - 공통 PM 인덱스 문서 동기화는 PM 규칙에 따라 PM이 처리해야 한다.
  - remote 백엔드 상세 API 실기기/웹 실행 검증은 QA 또는 통합 세션에서 추가 확인이 필요하다.
- 다음 제안:
  - PM/QA가 `REQ-20260428-07`을 검토한 뒤 생성/수정/삭제 플로우 준비 요청 착수 여부를 판단한다.

### RES-FE-IMPROVE-20260428-01
- 요청 ID: FE-IMPROVE-20260428-01
- 담당 역할: FE
- 상태: 완료
- 요약:
  - FE 영역을 점검한 결과 작성/사진 첨부 CTA가 실제 동작 없이 노출되고, 홈/상세 화면의 웹 폭 대응이 부족한 점을 개선 대상으로 잡았다.
  - 생성/수정/삭제 API 연결 전까지 작성 기능이 준비 상태임을 명확히 안내하도록 빠른 작성 영역과 FAB 스낵바를 정리했다.
  - 일기 홈의 주요 섹션을 최대 폭으로 제한해 모바일/웹에서 콘텐츠 폭이 과도하게 벌어지지 않도록 했다.
  - 상세 화면 본문을 중앙 정렬하고 작성일/수정일 메타데이터 패널을 추가했다.
  - 작성 준비 상태 안내와 상세 메타데이터 노출을 위젯 테스트로 보강했다.
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
  - 최초 sandbox 실행은 `pub.dev` DNS 조회 실패로 중단되어 네트워크 권한으로 재실행했다.
- 남은 이슈:
  - 일기 생성/수정/삭제 플로우는 `REQ-20260428-09` 선행 조건 완료 후 별도 구현해야 한다.
  - remote 상세 API 실기기/웹 검증은 QA 또는 통합 세션에서 확인이 필요하다.
- 다음 제안:
  - 로그인/상세 진입 요청은 이후 완료 처리됐고 `REQ-20260428-09`도 구현 완료됐다.

### RES-REQ-20260428-09
- 요청 ID: REQ-20260428-09
- 담당 역할: FE
- 상태: 완료
- 요약:
  - 백엔드 `POST/PUT/DELETE /api/v1/diaries` 계약을 기준으로 Flutter `ApiClient`에 `put`, `delete`를 추가했다.
  - `DiaryRepository`, API/mock repository, remote/mock datasource에 일기 생성/수정/삭제 계약을 추가했다.
  - `DiaryUpsert` 모델과 요청 DTO를 추가해 작성/수정 입력을 API body로 변환한다.
  - `DiaryEditScreen`을 추가하고 홈 FAB에서 작성, 상세 화면에서 수정/삭제로 진입하도록 연결했다.
  - 저장/삭제 성공 후 `diaryListProvider`와 `diaryDetailProvider`를 invalidate해 화면 갱신 흐름을 연결했다.
  - 작성 화면 필수 입력 검증 위젯 테스트를 추가했고 QA 하네스 repository도 새 계약에 맞췄다.
- 변경 파일:
  - `mobile-flutter/lib/core/network/api_client.dart`
  - `mobile-flutter/lib/domain/models/diary_upsert.dart`
  - `mobile-flutter/lib/domain/repositories/diary_repository.dart`
  - `mobile-flutter/lib/data/dto/diary_upsert_request_dto.dart`
  - `mobile-flutter/lib/data/mappers/diary_mapper.dart`
  - `mobile-flutter/lib/data/datasources/remote/remote_diary_datasource.dart`
  - `mobile-flutter/lib/data/datasources/mock/mock_diary_datasource.dart`
  - `mobile-flutter/lib/data/repositories/api_diary_repository.dart`
  - `mobile-flutter/lib/data/repositories/mock_diary_repository.dart`
  - `mobile-flutter/lib/presentation/screens/diary/diary_home_screen.dart`
  - `mobile-flutter/lib/presentation/screens/diary/diary_detail_screen.dart`
  - `mobile-flutter/lib/presentation/screens/diary/diary_edit_screen.dart`
  - `mobile-flutter/test/widget_test.dart`
  - `mobile-flutter/test/support/qa_app_harness.dart`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/inbox.md`
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
  - 실제 remote 모드에서 생성/수정/삭제를 백엔드 서버와 통합 실행하는 검증은 QA 세션에서 필요하다.
  - 감정 코드는 현재 텍스트 입력으로 받으며, 감정 목록 드롭다운 전환은 후속 UX 개선 후보로 남는다.
- 다음 제안:
  - QA가 `REQ-20260428-24`로 일기 CRUD 회귀 시나리오와 자동화 확장을 완료했다.

### RES-REQ-20260428-26
- 요청 ID: REQ-20260428-26
- 담당 역할: FE
- 상태: 완료
- 요약:
  - CRUD 이후 앱 사용성 개선 후보를 사용자 가치, Flutter 변경 범위, BE 의존성 기준으로 비교했다.
  - 1순위 구현 후보는 캘린더 날짜 탭에서 해당 날짜 일기 확인 또는 작성으로 이어지는 플로우다.
  - 이 후보는 이미 캘린더 월 데이터와 일기 작성/상세 화면이 있어 BE 추가 API 없이 Flutter 화면/상태 연결로 1차 구현 가능하다.
- 후보 비교:
  - 1순위: 캘린더 날짜 탭 -> 해당 날짜 일기 목록/상세/작성 진입
    - 사용자 가치: 캘린더에서 기록된 날짜를 보고 바로 확인하거나 빈 날짜에 작성할 수 있어 앱의 핵심 탐색 흐름이 짧아진다.
    - Flutter 변경 예상 파일/화면: `calendar_screen.dart`, `diary_edit_screen.dart`, 필요 시 날짜별 일기 목록 또는 bottom sheet 컴포넌트, `widget_test.dart`.
    - BE API 의존성: 1차는 기존 월간 캘린더, 일기 목록, 작성 API로 가능하다. 날짜별 목록 필터 API가 필요하면 BE 후속 요청으로 분리한다.
  - 2순위: 일기 작성 UX 개선
    - 사용자 가치: 감정 코드 직접 입력을 줄이고 날짜 선택, 감정 선택, 사진 URL 입력을 더 자연스럽게 만든다.
    - Flutter 변경 예상 파일/화면: `diary_edit_screen.dart`, 감정 목록 provider 사용, 입력 컴포넌트 분리, 작성 화면 테스트.
    - BE API 의존성: 없음. 기존 감정 목록 API와 CRUD API로 가능하다.
  - 3순위: 빈 상태 CTA 개선
    - 사용자 가치: 일기가 없을 때 사용자가 다음 행동을 바로 알 수 있다.
    - Flutter 변경 예상 파일/화면: `diary_home_screen.dart`, `calendar_screen.dart`, 빈 상태 위젯 공통화.
    - BE API 의존성: 없음.
  - 4순위: 오프라인/로딩/재시도 상태 강화
    - 사용자 가치: remote 장애나 토큰 오류 상황에서 회복 가능성이 높아진다.
    - Flutter 변경 예상 파일/화면: error/empty/loading 공통 위젯, `api_client.dart` 오류 분류, 각 화면의 retry 액션.
    - BE API 의존성: 낮음. 토큰 만료/갱신 전략은 BE/PM 후속 설계와 맞춰야 한다.
  - 5순위: 작성 중 임시 저장
    - 사용자 가치: 장문 작성 중 이탈 손실을 줄인다.
    - Flutter 변경 예상 파일/화면: `diary_edit_screen.dart`, local state persistence, 앱 생명주기 처리.
    - BE API 의존성: 1차 로컬 임시 저장은 없음. 서버 임시 저장은 별도 API 필요.
  - 6순위: 감정 기반 필터
    - 사용자 가치: 감정별 회고가 가능해진다.
    - Flutter 변경 예상 파일/화면: `diary_home_screen.dart`, 목록 provider query 확장, 필터 UI, 테스트.
    - BE API 의존성: 현재 백엔드 목록 API에는 `emotion` query가 있으나 Flutter remote datasource가 아직 query를 노출하지 않아 FE 확장이 필요하다.
- 1순위 구현 요청 후보:
  - 제목: 캘린더 날짜 탭에서 일기 확인/작성 진입 플로우 구현
  - 제안 요청 ID: PM이 신규 요청으로 `REQ-20260428-28` 또는 다음 번호를 배정
  - 완료 기준: 캘린더 날짜 선택 시 기록 있음/없음 상태를 구분하고, 기록 있음은 상세 진입, 기록 없음은 해당 날짜가 채워진 작성 화면으로 이동한다. `flutter analyze`, `flutter test` 통과.
- 변경 파일:
  - `.ai-work/msyeo/docs/collaboration/roles/fe/inbox.md`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/status.md`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/handoff/2026-04-28.md`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/handoff/2026-04-28.md`
- 검증:
  - 설계 문서 작업이라 코드 테스트는 실행하지 않았다.
  - `git diff --check`: 통과
- 남은 이슈:
  - 1순위 후보 구현 전 QA CRUD 회귀 검증 결과를 확인하는 것이 안전하다.
  - 날짜별 일기 목록 UX를 단일 상세 진입으로 제한할지, 같은 날짜 다건 목록을 보여줄지 PM 결정이 필요하다.
- 다음 제안:
  - PM은 `REQ-20260428-26`을 검토한 뒤 캘린더 날짜 탭 진입 플로우 구현 요청을 FE에 배정한다.

### RES-REQ-20260428-28
- 요청 ID: REQ-20260428-28
- 담당 역할: FE
- 상태: 완료
- 요약:
  - 사용자 직접 지시로 시작한 `FE-IMPROVE-20260428-02` 작업을 PM 공통 요청 `REQ-20260428-28` 범위로 정규화해 완료했다.
  - 캘린더 날짜를 탭하면 해당 날짜 action sheet가 열리도록 했다.
  - 해당 날짜 일기가 있으면 action sheet에서 일기를 선택해 상세 화면으로 진입한다.
  - 해당 날짜 일기가 없거나 추가 작성이 필요하면 날짜가 기본값으로 채워진 작성 화면으로 진입한다.
  - 저장 후 일기 목록과 캘린더 provider를 갱신한다.
  - QA harness 테스트에 캘린더 날짜 탭 후 상세 진입 회귀를 추가했다.
- 변경 파일:
  - `mobile-flutter/lib/presentation/screens/calendar/calendar_screen.dart`
  - `mobile-flutter/lib/presentation/screens/diary/diary_edit_screen.dart`
  - `mobile-flutter/test/qa_harness_smoke_test.dart`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/inbox.md`
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
  - QA `REQ-20260428-30`에서 상세 진입과 빈 날짜 작성 기본값을 하네스 기준으로 검증했다.
  - 현재 날짜별 일기 매칭은 로드된 일기 목록 기준이다. 날짜별 다건 조회가 많아지면 목록 query 확장이 필요할 수 있다.
- 다음 제안:
  - FE 신규 결함은 없으며 다음 FE 요청은 PM 배정을 기다린다.

### RES-FE-IMPROVE-20260428-03
- 요청 ID: FE-IMPROVE-20260428-03
- 담당 역할: FE
- 상태: 완료
- 요약:
  - 공식 FE 수신함에 신규 배정 요청이 없어 사용자 지시를 직접 FE 후속 개선 작업으로 보고 착수했다.
  - 일기 작성/수정 화면의 감정 코드 직접 입력을 `emotionListProvider` 기반 선택 UI로 개선했다.
  - 감정 목록 로딩 실패 또는 빈 목록 상황에서는 기존 감정 코드 입력 fallback을 유지해 저장 계약이 막히지 않도록 했다.
  - 저장 payload는 기존 `emotionCode` 문자열 계약을 유지해 BE API 변경 없이 동작한다.
  - 위젯 테스트와 QA 하네스 테스트에서 기본 감정 선택 UI 노출을 확인하도록 보강했다.
- 변경 파일:
  - `mobile-flutter/lib/presentation/screens/diary/diary_edit_screen.dart`
  - `mobile-flutter/test/widget_test.dart`
  - `mobile-flutter/test/qa_harness_smoke_test.dart`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/status.md`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/handoff/2026-04-28.md`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/handoff/2026-04-28.md`
- 검증:
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze`: 통과
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test`: 통과, 9건
  - `git diff --check`: 통과
- 남은 이슈:
  - 실제 remote 감정 목록 API 실패 상황의 화면 노출은 QA remote 검증에서 추가 확인할 수 있다.
  - 날짜 입력은 아직 텍스트 필드이며, date picker 전환은 별도 FE 개선 후보로 남아 있다.
- 다음 제안:
  - PM은 이 개선을 검토한 뒤 필요하면 공통 인덱스에 FE 보강 작업으로 반영한다.
  - QA는 기존 `REQ-20260428-30` 검증 시 작성 화면 감정 선택 UI도 함께 확인한다.

### RES-FE-IMPROVE-20260428-04
- 요청 ID: FE-IMPROVE-20260428-04
- 담당 역할: FE
- 상태: 완료
- 요약:
  - 공식 FE 수신함에 신규 배정 요청이 없어 사용자 지시를 직접 FE 후속 개선 작업으로 보고 착수했다.
  - 일기 작성/수정 화면의 날짜 직접 입력을 read-only 필드와 date picker 기반 선택 UX로 전환했다.
  - 캘린더 날짜 탭에서 작성 화면으로 넘어온 `initialDate` 기본값은 유지했다.
  - 저장 payload는 기존 `YYYY-MM-DD` 문자열을 `DateTime.parse`하는 계약을 유지해 BE API 변경 없이 동작한다.
  - 위젯 테스트에서 날짜 선택 아이콘과 `DatePickerDialog` 노출을 검증하고, QA 하네스 CRUD 작성 플로우는 기본 날짜를 사용하도록 조정했다.
- 변경 파일:
  - `mobile-flutter/lib/presentation/screens/diary/diary_edit_screen.dart`
  - `mobile-flutter/test/widget_test.dart`
  - `mobile-flutter/test/qa_harness_smoke_test.dart`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/status.md`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/handoff/2026-04-28.md`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/handoff/2026-04-28.md`
- 검증:
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze`: 통과
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test`: 통과, 10건
  - `git diff --check`: 통과
- 남은 이슈:
  - 날짜 picker의 locale/표시 언어는 앱 전체 localization 설정이 확정되면 함께 조정할 수 있다.
  - 사진 URL 입력 UX는 아직 단일 텍스트 입력이며 후속 개선 후보로 남아 있다.
- 다음 제안:
  - PM은 이 개선을 검토한 뒤 필요하면 공통 인덱스에 FE 보강 작업으로 반영한다.
  - 다음 FE 자체 개선은 사진 URL 입력 UX 정리 또는 캘린더 월 이동 UX 확장이 적절하다.

### RES-REQ-20260428-33
- 요청 ID: REQ-20260428-33
- 담당 역할: FE
- 상태: 검토중
- 요약:
  - PM이 배정한 일기 작성 UX 잔여 개선 요청을 처리했다.
  - 이미 완료된 날짜 선택 UI는 유지하고, 사진 URL 입력을 쉼표 문자열에서 추가/삭제 가능한 목록 UI로 전환했다.
  - 저장 시 입력칸에 남아 있는 URL도 자동으로 목록에 반영해 기존 `imageUrls: List<String>` 저장 계약을 유지했다.
  - 작성/수정 화면에서 변경사항이 있을 때 AppBar 뒤로가기를 누르면 이탈 확인 다이얼로그를 표시한다.
  - 저장 중 중복 탭 방지와 저장 실패 표시 흐름은 기존 동작을 유지했다.
  - 위젯 테스트에 사진 URL 추가와 이탈 확인 흐름을 추가하고, QA 하네스 CRUD 테스트의 스크롤 저장 회귀를 보강했다.
- 변경 파일:
  - `mobile-flutter/lib/presentation/screens/diary/diary_edit_screen.dart`
  - `mobile-flutter/test/widget_test.dart`
  - `mobile-flutter/test/qa_harness_smoke_test.dart`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/status.md`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/pm/responses.md`
  - `.ai-work/msyeo/docs/collaboration/roles/fe/handoff/2026-04-28.md`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/handoff/2026-04-28.md`
- 검증:
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze`: 통과
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test`: 통과, 10건
  - `git diff --check`: 통과
- 남은 이슈:
  - AppBar 뒤로가기 기준 이탈 확인을 구현했다. Android 시스템 back까지 포함한 route-level 차단은 후속 안정화 후보로 남길 수 있다.
  - 사진 URL 자체의 네트워크 접근성 검증이나 이미지 미리보기는 아직 구현하지 않았다.
- 다음 제안:
  - QA는 `REQ-20260428-35` 검증 계획에 사진 URL 목록 UI와 이탈 확인을 포함한다.
  - 다음 FE 후보는 캘린더 월 이동 UX 또는 위젯/딥링크 FE 구현 요청이다.

## 작성 템플릿
```text
### RES-REQ-YYYYMMDD-NN
- 요청 ID:
- 담당 역할: FE
- 상태:
- 요약:
- 변경 파일:
- 검증:
- 남은 이슈:
- 다음 제안:
```
