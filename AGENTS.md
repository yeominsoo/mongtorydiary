# Repository Guidelines

## 문서 및 인코딩 원칙
이 저장소의 작업 문서와 운영 문서는 한글로 작성한다. 신규 문서는 UTF-8 인코딩을 기본으로 사용해 한글 깨짐을 최소화한다. 기존 파일의 인코딩이나 개행 방식은 작업 목적과 직접 관련이 없으면 바꾸지 않는다.

## 현재 제품 방향
이 프로젝트는 Spring Boot 백엔드와 Flutter 기반 모바일 앱을 중심으로 개발한다. 웹은 앱과 분리된 별도 프론트엔드로 운영하는 방향을 따른다. 위젯은 안드로이드는 App Widget 또는 Glance, iOS는 WidgetKit 기반으로 확장한다.

## 프로젝트 구조
- `src/main/java/com/mongtory/diary`: 백엔드 소스
- `src/main/resources`: 백엔드 설정
- `src/test/java/com/mongtory/diary`: 백엔드 테스트
- `mobile-flutter/`: Flutter 앱 작업 공간
- `.ai-work/msyeo/docs/`: 계획, 상태, handoff 문서
- `frontend/`: 전환 전 초기 React 프로토타입, 필요 시 참고용으로만 사용

## 작업 범위 원칙
관련 없는 파일은 수정하지 않는다. 요청과 직접 연관된 파일만 수정하고, 변경량은 가능한 작게 유지한다. 포맷 정리, import 재배열, 개행 변경도 작업 목적과 무관하면 하지 않는다.

## 바이브코딩 작업 공간
모든 프로젝트 문서와 AI 보조 개발 산출물은 `.ai-work/msyeo/docs/` 아래에서 관리한다. 루트 `docs/` 디렉토리는 새로 만들지 않는다. `.ai-work/msyeo/docs/`는 코드 실행 결과물이 아니라 작업 맥락, 분석, 의사결정 기록을 보관하는 문서 루트로 사용한다.

`.ai-work/msyeo/docs/` 문서는 아래 원칙을 따른다.
- 프로젝트 구조, 현재 상태, 다음 작업 후보를 한글로 정리한다.
- 실제 비밀번호, 토큰, 개인 인증 정보는 기록하지 않는다.
- 코드 변경과 직접 연결되는 판단 근거만 남기고, 오래된 추정은 새 분석으로 갱신한다.
- 저장소 규칙이나 handoff와 충돌하는 내용이 있으면 `AGENTS.md`와 `.ai-work/msyeo/docs/project-status.md`를 우선한다.

## AI 단일 세션 작업룰
2026-05-21부터 PM, QA, FE 개발자, BE 개발자 역할 분배는 활성 운영 방식에서 철회한다. 이후 작업은 하나의 AI 세션이 계획, 구현, 검증, 문서화를 순서대로 처리한다.

- 단일 세션 마스터 문서: `.ai-work/msyeo/docs/collaboration/master-flow.md`
- 단일 작업 목록: `.ai-work/msyeo/docs/single-session-worklist.md`
- 요청 인덱스: `.ai-work/msyeo/docs/collaboration/requests.md`
- 현황 인덱스: `.ai-work/msyeo/docs/collaboration/status.md`
- 응답 인덱스: `.ai-work/msyeo/docs/collaboration/responses.md`
- 과거 역할 문서: `.ai-work/msyeo/docs/collaboration/roles/{pm|qa|fe|be}/`

역할별 디렉토리는 과거 분장과 검증 이력 확인용으로 유지한다. 사용자가 명시적으로 다중 역할 운영을 복구하라고 지시하지 않는 한, 새 요청과 진행 기록은 역할별 inbox/status/responses가 아니라 공통 인덱스와 `single-session-worklist.md`에 남긴다.

작업 시작 시 `AGENTS.md`, `.ai-work/msyeo/docs/collaboration/master-flow.md`, `.ai-work/msyeo/docs/project-status.md`, `.ai-work/msyeo/docs/single-session-worklist.md`, 최신 handoff를 확인한다. 확인 후 `.ai-work/msyeo/docs/collaboration/status.md`의 `룰 확인 기록`에 기록한다.

요청 처리 결과는 공통 `responses.md`에 남기고, 의미 있는 작업 블록이 끝나면 `.ai-work/msyeo/docs/handoff/YYYY-MM-DD.md`를 갱신한다. 역할별 handoff는 과거 이력 보관용이며 단일 세션 전환 이후에는 새로 작성하지 않는다.

커밋 메시지는 한글로 작성한다. 필요한 경우 conventional commit 타입은 사용할 수 있지만 제목과 설명은 담당자가 이해할 수 있는 한글 문장으로 남긴다.

## 기술 규칙
백엔드는 `Controller -> Service -> Repository` 구조를 따른다. API는 DTO로만 통신하고 Entity를 직접 노출하지 않는다. 응답은 `ApiResponse<T>` 형태로 통일한다. Maven 실행 전에는 `JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64` 환경을 기준으로 한다.

Flutter 앱은 `presentation`, `application`, `domain`, `data`, `core` 계층을 기준으로 확장한다. 위젯은 앱 UI와 분리된 요약 진입점으로 설계하고, 복잡한 편집 기능은 앱 내부 화면에서 처리한다.

## Handoff 및 상태 문서 규칙
`.ai-work/msyeo/docs/project-status.md`는 현재 구조, 구현 범위, 미해결 이슈, 다음 우선순위를 항상 반영해야 한다. handoff 문서는 루트 `docs/`가 아니라 반드시 `.ai-work/msyeo/docs/handoff/` 아래에 생성한다. 해당 디렉토리가 없으면 먼저 생성한 뒤 `.ai-work/msyeo/docs/handoff/YYYY-MM-DD.md` 형식으로 작업이 끝난 직후 매번 즉시 기록하며, 이 규칙은 예외 없이 따른다.
단일 세션 전환 이후 역할별 작업 블록 handoff는 새로 작성하지 않는다. 과거 역할별 handoff는 이력 확인용으로만 둔다.

각 handoff에는 아래 내용을 포함한다.
- 이번 작업 목적
- 실제 변경 파일
- 현재 동작 상태
- 미해결 이슈
- 다음 세션 시작 체크포인트

작업을 마치고 handoff를 미기록 상태로 종료하지 않는다.

## 권한 위임 규칙
사용자는 관리자 권한이 필요한 작업을 수행할 수 있도록 포괄적인 실행 승인을 부여했다. 앞으로 시스템 설정, 패키지 설치, SDK 설치, 빌드 도구 설정 등 작업 목적에 필요한 경우 관리자 권한 사용을 허용된 것으로 간주하고 진행한다.

단, 실제 비밀번호나 민감한 인증 정보는 문서 파일에 기록하지 않는다. 비밀값은 대화 맥락에서만 사용하고 저장소 문서에는 남기지 않는다.
