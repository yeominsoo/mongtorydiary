# PM/QA/FE/BE 협업 마스터 플로우

## 목적
이 문서는 PM, QA, FE 개발자, BE 개발자 AI 세션이 서로 다른 터미널에서 같은 프로젝트를 진행할 때 따르는 최상위 협업 규칙이다. 모든 세션은 작업 시작 시 `AGENTS.md` 다음으로 이 문서를 읽고, 요청/현황/응답 문서를 통해 비동기 소통을 남긴다.

## 공통 문서 창구
- 마스터 문서: `.ai-work/msyeo/docs/collaboration/master-flow.md`
- 요청 인덱스: `.ai-work/msyeo/docs/collaboration/requests.md`
- 현황 인덱스: `.ai-work/msyeo/docs/collaboration/status.md`
- 응답 인덱스: `.ai-work/msyeo/docs/collaboration/responses.md`
- 역할별 작업 문서: `.ai-work/msyeo/docs/collaboration/roles/`

공통 인덱스 문서는 PM이 최종 정리한다. 각 역할 세션은 자기 역할 디렉토리의 문서를 우선 수정한다. 구두로 정한 내용도 작업에 영향을 주면 반드시 역할별 요청, 현황, 응답 중 하나에 남긴다.

## 작업 시작 전 룰 변경 확인
모든 담당자는 매 작업 시작마다 변경된 룰이 없는지 확인해야 한다. 이 확인 없이 작업을 시작하지 않는다.

확인 대상:
- `AGENTS.md`
- `.ai-work/msyeo/docs/collaboration/master-flow.md`
- `.ai-work/msyeo/docs/collaboration/roles/README.md`
- 자기 역할의 `inbox.md`
- 자기 역할의 `status.md`
- PM이 별도 지정한 요청 문서 또는 handoff

확인 후 각 담당자는 자기 역할의 `status.md`에 아래 형식으로 기록한다.

```text
## 룰 확인 기록
- YYYY-MM-DD HH:MM: 작업 시작 전 AGENTS/master-flow/roles README/inbox/status 확인, 변경 룰 반영 여부: 예/아니오, 요청 ID: REQ-...
```

PM은 모니터링 시 이 기록이 없는 작업을 절차 위반으로 본다.

## 역할별 디렉토리
```text
.ai-work/msyeo/docs/collaboration/roles/
  pm/
    requests.md
    inbox.md
    status.md
    responses.md
    handoff/
  qa/
    requests.md
    inbox.md
    status.md
    responses.md
    handoff/
  fe/
    requests.md
    inbox.md
    status.md
    responses.md
    handoff/
  be/
    requests.md
    inbox.md
    status.md
    responses.md
    handoff/
```

- `requests.md`: 해당 역할이 요청한 항목
- `inbox.md`: 해당 역할이 받은 요청
- `status.md`: 해당 역할의 진행 현황과 잠금 파일
- `responses.md`: 해당 역할의 완료 응답과 검증 결과
- `handoff/YYYY-MM-DD.md`: 해당 역할의 블록 단위 작업 종료 기록

## 역할 정의
### PM
- 프로젝트 목표, 우선순위, 범위, 완료 기준을 조정한다.
- QA, FE, BE 사이의 요청과 차단 이슈를 정리한다.
- 공통 문서와 handoff를 최종 정리한다.
- 완료된 작업 중 커밋이 필요한 변경은 PM이 범위를 취합해 직접 커밋한다.
- 담당 문서/경로:
  - `.ai-work/msyeo/docs/collaboration/`
  - `.ai-work/msyeo/docs/project-status.md`
  - `.ai-work/msyeo/docs/handoff/YYYY-MM-DD.md`

### QA
- API 계약, 화면 동작, 통합 실행, 회귀 위험을 검증한다.
- 요구사항과 실제 구현의 차이를 요청 또는 이슈로 등록한다.
- 테스트 시나리오와 검증 결과를 응답 문서에 남긴다.
- Flutter 앱 QA 자동화 하네스를 구축하고, 자동화 테스트 실패를 FE 또는 BE 후속 요청으로 분류한다.
- 담당 문서/경로:
  - `.ai-work/msyeo/docs/api-contract.md`
  - `.ai-work/msyeo/docs/api-spec.md`
  - `.ai-work/msyeo/docs/source-doc-audit.md`
  - 필요 시 `src/test/java/com/mongtory/diary/controller`
  - 필요 시 `mobile-flutter/test`
  - 필요 시 `mobile-flutter/integration_test`

### FE 개발자
- Flutter 앱 화면, 상태 관리, API 연동 UI를 구현한다.
- 담당 경로 밖 파일은 PM 승인 없이 수정하지 않는다.
- BE API 변경 요청이나 QA 발견 이슈는 요청 문서에 남긴다.
- 담당 경로:
  - `mobile-flutter/lib`
  - `mobile-flutter/test`
  - `mobile-flutter/pubspec.yaml`은 의존성 변경이 필요할 때만 PM 확인 후 수정

### BE 개발자
- Spring Boot API, 서비스, repository, 백엔드 테스트를 구현한다.
- API 계약 변경이 있으면 PM과 QA에 요청으로 남긴다.
- 담당 경로:
  - `src/main/java/com/mongtory/diary`
  - `src/test/java/com/mongtory/diary`
  - `src/main/resources`
  - `pom.xml`은 의존성 변경이 필요할 때만 PM 확인 후 수정

## 공식 업무 흐름
1. 모든 담당자는 작업 시작 전 룰 변경 확인을 수행하고 자기 역할 `status.md`에 기록한다.
2. PM이 공통 `status.md`와 역할별 `status.md`에서 진행 중 작업과 잠금 파일을 확인한다.
3. PM, QA, FE, BE 중 누구든 새 요청은 자기 역할 디렉토리의 `requests.md`에 먼저 작성한다.
4. PM이 요청 ID, 우선순위, 대상 역할, 담당 경로, 완료 기준을 확인하고 공통 `requests.md` 인덱스와 대상 역할의 `inbox.md`에 반영한다.
5. 담당 역할은 자기 `inbox.md`와 `status.md`에서 요청 상태를 `대기`에서 `진행중`으로 바꾸고 작업을 시작한다.
6. 진행 중 차단 이슈가 생기면 자기 `status.md`에 기록하고, 필요 시 자기 `requests.md`에 새 질문을 남긴다.
7. 작업 완료 후 담당자는 자기 `responses.md`에 결과, 변경 파일, 검증 내용을 기록한다.
8. 담당자는 같은 응답 내용을 요청자 역할의 `responses.md`에도 추가해 요청자가 자기 문서에서 처리 결과를 확인할 수 있게 한다.
9. 담당자는 블록 단위 작업이 끝날 때 자기 역할의 `handoff/YYYY-MM-DD.md`에 handoff를 남긴다.
10. PM은 역할별 응답을 보고 공통 `responses.md`와 `status.md`에 요약을 반영한다.
11. QA가 필요한 작업은 PM이 `검토중`으로 전환하고 QA `inbox.md`에 검증 요청을 등록한다.
12. QA 또는 PM이 완료 기준을 확인하면 PM이 공통/역할별 상태를 `완료`, `보류`, `재작업` 중 하나로 갱신한다.
13. 의미 있는 변경이 있으면 PM이 `project-status.md`와 전체 `handoff/YYYY-MM-DD.md`를 갱신한다.
14. 완료된 요청이 커밋 가능한 단위라면 PM이 관련 변경을 취합해 직접 커밋한다.

## 요청 ID 규칙
요청은 아래 형식을 사용한다.

```text
REQ-YYYYMMDD-NN
```

예시:
```text
REQ-20260428-01
```

응답은 요청 ID를 그대로 참조한다.

```text
RES-REQ-20260428-01
```

## 상태값
- `대기`: 아직 담당자가 작업을 시작하지 않음
- `진행중`: 담당자가 작업 중
- `차단`: 질문, 권한, 충돌, 외부 조건으로 진행 불가
- `검토중`: 결과가 나왔고 PM 또는 QA 확인 필요
- `완료`: 완료 기준 충족
- `보류`: 지금 처리하지 않기로 결정
- `재작업`: 결과가 요구사항을 충족하지 못해 다시 작업 필요

## 우선순위
- `P0`: 진행을 막는 협업, 환경, 빌드, 데이터 손실 위험
- `P1`: MVP 핵심 기능, API 계약, 인증/일기/캘린더 핵심 플로우
- `P2`: UX 개선, 테스트 보강, 리팩터링, 문서 정합성
- `P3`: 장기 개선, 위젯/웹 확장, 운영 편의

## 파일 충돌 규칙
- 같은 파일을 여러 세션이 동시에 수정하지 않는다.
- PM은 `status.md`의 충돌 방지 현황에 잠금 경로를 기록한다.
- 각 역할은 자기 담당 경로만 수정한다.
- 공통 문서인 `requests.md`, `status.md`, `responses.md`는 PM이 관리하는 인덱스로 본다.
- 각 역할 세션은 기본적으로 `.ai-work/msyeo/docs/collaboration/roles/{pm|qa|fe|be}/` 아래 자기 역할 문서만 수정한다.
- 다른 역할에게 요청할 때도 먼저 자기 `requests.md`에 작성하고, PM이 공통 인덱스와 대상 역할 `inbox.md`에 반영한다.
- 코드 변경과 문서 변경은 가능하면 별도 요청 ID로 분리한다.
- 루트 `docs/`는 사용하지 않는다. 문서는 `.ai-work/msyeo/docs/` 아래에만 작성한다.

## 검증 규칙
- BE 변경은 가능한 경우 아래 명령으로 검증한다.

```bash
bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test
```

현재 Rocky 10 환경에는 OpenJDK 21이 설치되어 있으며, Maven은 프로젝트 설정에 따라 `release 17`로 컴파일한다.

- FE 변경은 가능한 경우 아래 명령으로 검증한다.

```bash
cd mobile-flutter
HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze
HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test
```

- 통합 검증은 실행 명령, 접속 URL, 실패 로그 요약을 `responses.md`에 남긴다.
- 검증하지 못한 경우 이유와 남은 위험을 명시한다.

## QA 자동화 결함 처리 규칙
- QA는 Flutter 자동화 하네스에서 실패가 발생하면 실패명, 재현 명령, 기대 결과, 실제 결과, 로그 요약을 남긴다.
- 화면 렌더링, 입력 검증, navigation, Riverpod 상태, Flutter repository/mock 처리 문제는 FE 개발자 대상 요청으로 등록한다.
- HTTP status, 응답 body, DTO 필드, 인증/권한, 서버 오류, 데이터 소유권 문제는 BE 개발자 대상 요청으로 등록한다.
- 원인 영역이 불명확하면 QA 대상 분석 요청 또는 PM 대상 triage 요청을 먼저 등록하고, FE/BE 동시 수정 요청은 피한다.
- 자동화 하네스 자체 문제는 QA 요청으로 유지하고 앱/서버 구현 요청과 분리한다.

## 완료 보고 필수 항목
모든 역할은 작업 종료 시 자기 역할 디렉토리의 `responses.md`와 요청자 역할 디렉토리의 `responses.md`에 아래 내용을 남긴다. 요청자가 사용자/PM이면 PM의 `responses.md`에도 남긴다.

```text
요청 ID:
요청자:
담당 역할:
요약:
변경 파일:
검증:
남은 이슈:
다음 제안:
```

## 역할별 Handoff 규칙
모든 역할은 요청 하나 또는 명확한 작업 블록 하나가 끝날 때 자기 역할 디렉토리 안에 handoff를 작성한다.

```text
.ai-work/msyeo/docs/collaboration/roles/{role}/handoff/YYYY-MM-DD.md
```

handoff에는 아래 내용을 포함한다.

```text
요청 ID:
작업 블록:
실제 변경 파일:
검증 결과:
요청자 responses 반영 여부:
공통 인덱스 반영 필요 여부:
남은 이슈:
다음 역할/PM 확인 사항:
```

역할별 handoff는 세션 내부 작업 종료 기록이고, `.ai-work/msyeo/docs/handoff/YYYY-MM-DD.md`는 PM이 정리하는 프로젝트 전체 handoff다.

## PM 모니터링 규칙
PM은 역할별 문서와 공통 인덱스의 불일치를 줄이기 위해 모든 역할 디렉토리 문서를 모니터링한다.

1. 공통 인덱스인 `requests.md`, `status.md`, `responses.md`를 확인한다.
2. `roles/pm`, `roles/qa`, `roles/fe`, `roles/be` 아래 모든 `requests.md`, `inbox.md`, `status.md`, `responses.md`, `handoff/`를 확인한다.
3. 요청 상태가 `진행중`인데 역할별 handoff 또는 responses가 생겼으면 공통 인덱스를 `검토중` 또는 `완료` 후보로 갱신한다.
4. 수행자 responses에는 있는데 요청자 responses에 없으면 누락으로 표시하고 보완 요청한다.
5. 역할별 status의 잠금 경로와 실제 Git 변경 경로가 어긋나면 충돌 위험으로 표시한다.
6. 역할 간 요청 전달 누락, 응답 전달 누락, 담당 경로 모호성, ping-pong 이슈를 triage한다.
7. 기존 협업룰로 해결이 어렵다면 PM이 협업룰 조정 요청을 만들고 `master-flow.md` 또는 `roles/README.md`를 갱신한다.
8. 완료된 요청 중 커밋 가능한 단위가 있는지 확인한다.
9. PM 확인 후 공통 `requests.md`, `status.md`, `responses.md`, `project-status.md`, 전체 handoff를 갱신한다.
10. 커밋이 필요하면 PM이 관련 변경 파일만 선별해 직접 커밋한다.

## PM 커밋 규칙
PM은 모니터링 중 완료된 작업에 대해 커밋이 필요하다고 판단하면 직접 커밋한다.

커밋 전 조건:
- 요청 상태가 `완료`이거나 PM이 완료 처리할 수 있는 근거가 있다.
- 수행자 responses, 요청자 responses, 역할별 handoff가 존재한다.
- 검증 결과 또는 검증 미실행 사유가 기록되어 있다.
- `git status --short`로 변경 파일을 확인했다.
- 다른 진행중 요청의 파일과 섞이지 않도록 커밋 범위를 선별했다.

커밋 범위 원칙:
- 가능하면 요청 ID 단위로 커밋한다.
- 문서 프로세스 변경과 앱/서버 코드 변경은 분리한다.
- FE와 BE 변경이 독립적이면 별도 커밋한다.
- 공통 인덱스나 handoff는 해당 요청 커밋에 함께 포함한다.
- 사용자 또는 다른 세션이 만든 관련 없는 변경은 포함하지 않는다.

커밋 메시지 형식:
```text
<type>: <한글 요약> (<요청ID>)
```

예시:
```text
docs: 역할별 handoff 절차 추가 (REQ-20260428-12)
test: 인증 소유권 검증 보강 (REQ-20260428-04)
feat: 로그인 입력 폼 추가 (REQ-20260428-03)
```

커밋 메시지 제목과 본문은 한글로 작성한다. `docs`, `feat`, `fix`, `test`, `refactor`, `chore` 같은 타입 접두어는 허용하지만, 설명은 한글이어야 한다.

커밋 후 PM 기록:
- 커밋 해시를 공통 `responses.md`와 해당 역할/요청자 `responses.md`에 추가한다.
- `status.md`에 커밋 완료 여부를 표시한다.
- 필요하면 전체 handoff에 커밋 해시와 범위를 기록한다.

## 현재 1차 운영 방침
- 역할은 PM, QA, FE 개발자, BE 개발자 4개로 운영한다.
- PM은 마스터 문서와 공통 인덱스 문서를 기준으로 작업을 배정한다.
- QA는 기능 구현을 직접 진행하기보다 검증 기준과 불일치 목록을 제공한다.
- FE와 BE는 각자 담당 경로 밖 파일을 수정하지 않는다.
- 기존 `pm-collaboration-board.md`와 `multiwindow-dev-prep.md`는 보조 문서이며, 역할 간 공식 소통은 이 문서와 역할별 디렉토리 문서를 우선한다.
