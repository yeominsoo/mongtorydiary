# BE 현황

## 현재 상태
- 역할: BE 개발자
- 현재 요청: 없음
- 최근 완료: `REQ-20260428-22`
- 담당 경로:
  - `src/main/java/com/mongtory/diary`
  - `src/test/java/com/mongtory/diary`
  - `src/main/resources`

## 잠금 상태
| 경로 | 상태 | 메모 |
| --- | --- | --- |
| `src/main/java` | 열림 | `REQ-20260428-22` 구현 완료, 후속 `REQ-20260428-27` 착수 가능 |
| `src/test/java` | 열림 | `REQ-20260428-22` 오류 계약 테스트 보강 완료 |
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
- 다음 BE 요청은 `REQ-20260428-27` 사용성 개선용 API 후보 설계다.

## 룰 확인 기록
- 2026-04-28 `REQ-20260428-22` 착수 전 `AGENTS.md`, `project-status.md`, BE `inbox.md`, BE `status.md`, QA 오류 기준 기록을 확인했다. 공통 문서는 PM 인덱스이고 BE 상세 응답은 역할별 `responses.md`에 먼저 남기는 원칙을 따른다.
