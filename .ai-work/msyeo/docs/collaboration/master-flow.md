# 단일 세션 운영 마스터 플로우

## 목적
이 문서는 Mongtory Diary 작업을 하나의 AI 세션에서 이어가기 위한 최상위 운영 규칙이다. 2026-05-21부터 PM, QA, FE 개발자, BE 개발자 역할 분배는 활성 운영 방식에서 철회한다. 과거 역할별 문서는 이력 확인용으로만 사용하고, 신규 작업은 단일 세션이 순서대로 계획, 구현, 검증, 문서화를 처리한다.

## 현재 운영 방식
- 운영 단위: 단일 AI 세션
- 담당 범위: 기획 정리, Spring Boot 백엔드, Flutter 앱, QA 검증, 문서/handoff, 커밋 준비
- 공식 작업 목록: `.ai-work/msyeo/docs/single-session-worklist.md`
- 공통 요청 인덱스: `.ai-work/msyeo/docs/collaboration/requests.md`
- 공통 현황 인덱스: `.ai-work/msyeo/docs/collaboration/status.md`
- 공통 응답 인덱스: `.ai-work/msyeo/docs/collaboration/responses.md`
- 과거 역할 문서: `.ai-work/msyeo/docs/collaboration/roles/`

`roles/{pm|qa|fe|be}/` 아래 문서는 과거 분장, 검증 근거, 응답 이력을 확인하기 위한 보관 영역이다. 사용자가 명시적으로 다중 역할 운영을 복구하라고 지시하지 않는 한, 새 요청을 역할별 inbox/status/responses에 추가하지 않는다.

## 작업 시작 전 확인
모든 작업 시작 시 아래 문서를 확인한다.

1. `AGENTS.md`
2. `.ai-work/msyeo/docs/collaboration/master-flow.md`
3. `.ai-work/msyeo/docs/project-status.md`
4. `.ai-work/msyeo/docs/single-session-worklist.md`
5. 최신 `.ai-work/msyeo/docs/handoff/YYYY-MM-DD.md`

확인 후 `.ai-work/msyeo/docs/collaboration/status.md`의 `룰 확인 기록`에 아래 형식으로 남긴다.

```text
- YYYY-MM-DD HH:MM: 작업 시작 전 AGENTS/master-flow/project-status/single-session-worklist/handoff 확인, 변경 룰 반영 여부: 예/아니오, 작업 ID: ...
```

## 작업 흐름
1. `single-session-worklist.md`에서 다음 작업을 고른다.
2. 필요한 경우 기존 `REQ-...` ID를 유지하되, 현재 담당은 `단일 세션`으로 본다.
3. 작업 시작 전 `collaboration/status.md`에서 상태를 `진행중`으로 갱신한다.
4. 코드 변경이 있으면 해당 계층의 검증 명령을 실행한다.
5. 작업 완료 후 `collaboration/responses.md`에 결과, 변경 파일, 검증 결과, 남은 이슈를 기록한다.
6. 의미 있는 작업 블록 종료 시 `.ai-work/msyeo/docs/handoff/YYYY-MM-DD.md`를 갱신한다.
7. `project-status.md`와 `single-session-worklist.md`의 다음 작업 상태를 최신화한다.
8. 커밋이 필요하면 완료된 범위만 선별하고, 관련 없는 기존 변경이나 미추적 파일은 포함하지 않는다.

## 상태값
- `대기`: 아직 작업하지 않음
- `진행중`: 단일 세션이 처리 중
- `차단`: 질문, 환경, 권한, 충돌 등으로 진행 불가
- `검토중`: 구현 또는 문서 결과가 나왔고 확인 필요
- `완료`: 완료 기준 충족
- `보류`: 지금 처리하지 않기로 결정
- `재작업`: 완료 기준 미충족

## 우선순위
- `P0`: 진행을 막는 협업, 환경, 빌드, 데이터 손실 위험
- `P1`: MVP 핵심 기능, API 계약, 인증/일기/캘린더/위젯 진입 핵심 플로우
- `P2`: UX 개선, 테스트 보강, 문서 정합성, 플랫폼 범위 결정
- `P3`: 장기 개선, 운영 편의, 후속 확장

## 파일 범위 원칙
- 요청과 직접 관련된 파일만 수정한다.
- 기존 미추적 파일이나 사용자 변경은 요청과 무관하면 건드리지 않는다.
- 역할별 담당 경로 제한은 철회했지만, 계층 경계는 유지한다.
- 백엔드는 `Controller -> Service -> Repository` 구조와 DTO/API 응답 규칙을 지킨다.
- Flutter는 `presentation`, `application`, `domain`, `data`, `core` 계층을 유지한다.
- 문서는 `.ai-work/msyeo/docs/` 아래에만 작성한다. 루트 `docs/`는 만들지 않는다.

## 검증 규칙
백엔드 변경은 가능한 경우 아래 명령으로 검증한다.

```bash
bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test
```

현재 환경은 OpenJDK 21이 설치되어 있으며, Maven은 프로젝트 설정에 따라 `release 17`로 컴파일한다. Java 17 경로가 없으면 Java 21 JDK 기준 실행 결과를 문서에 남긴다.

Flutter 변경은 가능한 경우 아래 명령으로 검증한다.

```bash
cd mobile-flutter
HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze
HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test
```

실제 서버 검증은 실행 명령, 접속 URL, 주요 요청/응답, 실패 로그 요약을 `responses.md`와 handoff에 남긴다. 검증하지 못한 경우 이유와 남은 위험을 명시한다.

## 응답 및 Handoff
단일 세션 전환 이후 신규 작업 결과는 공통 응답 인덱스에 기록한다.

```text
요청 ID:
담당: 단일 세션
요약:
변경 파일:
검증:
남은 이슈:
다음 제안:
```

작업 종료 시 전체 handoff는 반드시 아래 경로에 작성한다.

```text
.ai-work/msyeo/docs/handoff/YYYY-MM-DD.md
```

역할별 handoff는 과거 이력 보관용이다. 단일 세션 전환 이후에는 별도 지시가 없으면 새 역할별 handoff를 만들지 않는다.

## 커밋 규칙
- 커밋 메시지는 한글로 작성한다.
- 필요한 경우 `docs`, `feat`, `fix`, `test`, `refactor`, `chore` 타입 접두어를 사용할 수 있다.
- 커밋 전 `git status --short`로 변경 범위를 확인한다.
- 진행 중 작업, 사용자 변경, 요청과 무관한 미추적 파일은 커밋에 포함하지 않는다.
