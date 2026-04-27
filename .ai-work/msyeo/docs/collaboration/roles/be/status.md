# BE 현황

## 현재 상태
- 역할: BE 개발자
- 현재 요청: `REQ-20260428-22` 대기
- 담당 경로:
  - `src/main/java/com/mongtory/diary`
  - `src/test/java/com/mongtory/diary`
  - `src/main/resources`

## 잠금 상태
| 경로 | 상태 | 메모 |
| --- | --- | --- |
| `src/main/java` | 열림 | `REQ-20260428-08` 구현 완료, PM/QA 검토 대기 |
| `src/test/java` | 열림 | 오류 응답 테스트 보강 완료 |
| `src/main/resources` | BE 작업 가능 | 설정 변경 시 PM 공유 |

## 작업 메모
- API 계약 변경이 있으면 PM과 QA에 요청으로 남긴다.
- Maven 테스트 결과를 응답에 남긴다.
- `REQ-20260428-04`는 `bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test` 기준 통과했다.
- 새 규칙에 따라 BE 세션은 공통 인덱스가 아니라 `roles/be/` 아래 문서를 우선 수정한다.
- 사용자 지시에 따라 `REQ-20260428-08`을 착수했고 구현/검증을 완료했다. 공통 인덱스와 handoff 갱신은 PM에게 맡긴다.
- `REQ-20260428-08`은 `bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test` 기준 통과했다.
- 다음 BE 요청은 `REQ-20260428-22` API 검증 오류 계약 보강이다. 작업 시작 전 룰 확인 기록을 먼저 남긴다.

## 룰 확인 기록
- 아직 기록 없음. BE 작업 시작 시 AGENTS/master-flow/roles README/BE inbox/BE status 확인 후 기록한다.
