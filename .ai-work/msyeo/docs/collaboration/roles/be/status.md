# BE 현황

> 2026-05-21부터 역할 분배는 철회됐다. 이 문서는 과거 BE 상태 이력이며, 신규 상태 기록은 공통 `.ai-work/msyeo/docs/collaboration/status.md`에 남긴다.

## 현재 상태
- 역할: BE 개발자
- 현재 요청: 없음
- 최근 완료: `REQ-20260428-34`, `REQ-20260428-27`, `REQ-20260428-22`
- 담당 경로:
  - `src/main/java/com/mongtory/diary`
  - `src/test/java/com/mongtory/diary`
  - `src/main/resources`

## 잠금 상태
| 경로 | 상태 | 메모 |
| --- | --- | --- |
| `src/main/java` | 열림 | REQ-20260428-34 오늘/위젯 요약 API 구현 완료 |
| `src/test/java` | 열림 | REQ-20260428-34 테스트 보강 완료 |
| `src/main/resources` | BE 작업 가능 | 설정 변경 시 PM 공유 |

## 작업 메모
- API 계약 변경이 있으면 PM과 QA에 요청으로 남긴다.
- Maven 테스트 결과를 응답에 남긴다.
- `REQ-20260428-04`는 `bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test` 기준 통과했다.
- 새 규칙에 따라 BE 세션은 공통 인덱스가 아니라 `roles/be/` 아래 문서를 우선 수정한다.
- 사용자 지시에 따라 `REQ-20260428-08`을 착수했고 구현/검증을 완료했다. 공통 인덱스와 handoff 반영도 완료됐다.
- `REQ-20260428-08`은 `bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test` 기준 통과했다.
- `REQ-20260428-22`에서 누락 query parameter, malformed JSON, request body 타입 오류, calendar month 범위 오류, 일기 생성/수정 필수값 검증을 400 계열 `ApiResponse`로 고정했다.
- `REQ-20260428-22`는 `JAVA_HOME=/usr/lib/jvm/java-21-openjdk bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test` 기준 통과했다. Java 17 지정 경로는 현재 환경에 없어 Java 21 JDK로 실행했다.
- QA `REQ-20260428-29` 실제 서버 회귀 검증도 통과해 `REQ-20260428-22` 완료 처리 가능 상태다.
- `REQ-20260428-27`에서 사용성 개선용 API 후보 설계를 완료했다. 1순위 구현 후보는 `GET /api/v1/widgets/today-summary?date=YYYY-MM-DD` 오늘/위젯 요약 API다.
- `REQ-20260428-34`에서 `GET /api/v1/widgets/today-summary?date=YYYY-MM-DD` API를 구현했다. 동일 날짜 다건은 최신 수정 일기를 대표 일기로 선택하고, streak는 요청일 또는 이전 마지막 작성일 기준 연속 작성 날짜 수로 계산한다.
- `REQ-20260428-34`는 `JAVA_HOME=/usr/lib/jvm/java-21-openjdk bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test` 기준 통과했다. tests run 19, failures 0, errors 0, skipped 0.

## 룰 확인 기록
- 2026-04-28 `REQ-20260428-22` 착수 전 `AGENTS.md`, `project-status.md`, BE `inbox.md`, BE `status.md`, QA 오류 기준 기록을 확인했다. 공통 문서는 PM 인덱스이고 BE 상세 응답은 역할별 `responses.md`에 먼저 남기는 원칙을 따른다.
- 2026-04-28 `REQ-20260428-27` 착수 전 `AGENTS.md`, `project-status.md`, BE `inbox.md`, BE `status.md`, `api-contract.md`, `widget-deeplink-plan.md`를 확인했다. 설계 요청이므로 소스 코드는 변경하지 않고 문서/응답만 갱신한다.
- 2026-04-28 `REQ-20260428-34` 착수 전 `AGENTS.md`, `project-status.md`, BE `inbox.md`, BE `status.md`, `api-usability-improvement-plan.md`를 확인했다.
