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
- `docs/`: 계획, 상태, handoff 문서
- `frontend/`: 전환 전 초기 React 프로토타입, 필요 시 참고용으로만 사용

## 작업 범위 원칙
관련 없는 파일은 수정하지 않는다. 요청과 직접 연관된 파일만 수정하고, 변경량은 가능한 작게 유지한다. 포맷 정리, import 재배열, 개행 변경도 작업 목적과 무관하면 하지 않는다.

## 기술 규칙
백엔드는 `Controller -> Service -> Repository` 구조를 따른다. API는 DTO로만 통신하고 Entity를 직접 노출하지 않는다. 응답은 `ApiResponse<T>` 형태로 통일한다. Maven 실행 전에는 `JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64` 환경을 기준으로 한다.

Flutter 앱은 `presentation`, `application`, `domain`, `data`, `core` 계층을 기준으로 확장한다. 위젯은 앱 UI와 분리된 요약 진입점으로 설계하고, 복잡한 편집 기능은 앱 내부 화면에서 처리한다.

## Handoff 및 상태 문서 규칙
`docs/project-status.md`는 현재 구조, 구현 범위, 미해결 이슈, 다음 우선순위를 항상 반영해야 한다. `docs/handoff/YYYY-MM-DD.md`는 작업이 끝난 직후 매번 즉시 기록해야 하며, 이 규칙은 예외 없이 따른다.

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
