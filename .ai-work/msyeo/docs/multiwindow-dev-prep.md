# 멀티윈도우 개발 준비 노트

> 참고: 이 문서는 멀티 터미널 작업을 위한 보조 문서다. 현재 공식 협업 기준은 `.ai-work/msyeo/docs/collaboration/master-flow.md`이며, 역할은 PM, QA, FE 개발자, BE 개발자 4개로 운영한다.

## 목적
PuTTY 터미널을 여러 개 띄워 각 세션에 역할을 나눠 개발할 때, 세션 간 충돌을 줄이고 바로 작업에 들어가기 위한 기준 문서다. 이 문서는 코드 실행 산출물이 아니라 작업 맥락과 역할 분담 기준을 기록한다.

## 현재 프로젝트 목표
Mongtory Diary는 감정형 일기 서비스를 목표로 한다. 현재 유효한 제품 방향은 `Spring Boot 백엔드 + Flutter 모바일 앱 + 별도 웹 FE + Android/iOS 위젯 확장`이다.

우선순위는 모바일 앱 MVP와 이를 뒷받침하는 백엔드 API 안정화다. `frontend/`는 초기 React 프로토타입이므로 현재 기능 개발의 중심이 아니다.

## 현재 구조 요약
- `src/main/java/com/mongtory/diary`: Spring Boot 백엔드
- `src/main/resources/application.properties`: SQLite/JPA/서버 설정
- `src/test/java/com/mongtory/diary`: 백엔드 테스트
- `mobile-flutter/`: Flutter 앱
- `frontend/`: 참고용 React 프로토타입
- `.ai-work/msyeo/docs/`: 프로젝트 문서, 세션별 분석 및 작업 준비 문서

주의: 루트 `docs/` 디렉터리는 더 이상 사용하지 않는다. 모든 프로젝트 문서는 `.ai-work/msyeo/docs/` 아래에서 관리한다.

## 현재 구현 상태
### 백엔드
- `ApiResponse<T>` 공통 응답 구조가 있다.
- 인증 API는 `/api/v1/auth/signup`, `/api/v1/auth/login`, `/api/v1/auth/refresh`로 구현되어 있다.
- 현재 인증은 JWT가 아니라 DB에 저장하는 임시 `accessToken`, `refreshToken` 방식이다.
- 일기 API는 `/api/v1/diaries` 아래에 목록, 상세, 생성, 수정, 삭제가 있다.
- 일기/캘린더 API는 `Authorization: Bearer <accessToken>`으로 현재 사용자를 찾는다.
- `DiaryEntry`와 `UserAccount`는 JPA 엔티티이며 SQLite 설정을 사용한다.
- 감정 목록과 월간 캘린더 조회 골격이 있다.

### Flutter 앱
- 계층은 `presentation`, `application`, `domain`, `data`, `core` 기준으로 분리되어 있다.
- 상태 관리는 `flutter_riverpod`를 사용한다.
- `DATA_SOURCE_MODE=mock|remote`, `API_BASE_URL` `dart-define`으로 mock/remote 전환이 가능하다.
- 화면은 `startup -> sign-in -> home shell` 흐름이며 홈 탭은 일기, 캘린더, 프로필이다.
- remote 모드에서는 로그인 후 access token을 일기/캘린더 API 요청 헤더에 붙이는 구조다.
- remote datasource는 로그인, 일기 목록/상세, 캘린더 월 조회, 감정 목록을 호출한다.
- 아직 회원가입, 토큰 재발급, 실제 작성/상세/수정/삭제 폼, 영구 세션 저장, 위젯 연동은 미완성이다.

## 추천 터미널 역할
아래 역할명은 과거 기준이며 현재 공식 역할과 매핑해서 해석한다.
- 총괄/문서 세션: PM
- 백엔드 세션: BE 개발자
- Flutter 앱 세션: FE 개발자
- 실행/통합 검증 세션: QA 또는 PM이 요청 단위로 배정
- API 계약/테스트 세션: QA

### 1번: 총괄/문서 세션
- 담당: `.ai-work/msyeo/docs/` 상태/handoff 문서
- 역할: 작업 전후 상태 기록, API 계약 변경 감시, 세션 간 충돌 정리
- 주의: 실제 비밀번호, 토큰, 개인 인증 정보 기록 금지

### 2번: 백엔드 세션
- 담당: `src/main/java/com/mongtory/diary`, `src/test/java/com/mongtory/diary`, `src/main/resources`
- 우선 후보:
  - 인증 예외 처리와 `ApiResponse` 오류 응답 표준화
  - 임시 토큰 정책 개선 또는 JWT 도입 검토
  - 일기 소유권 검증 테스트 보강
  - 캘린더 월 조회와 일기 CRUD 테스트 보강
- 검증 명령:
```bash
JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test
```

### 3번: Flutter 앱 세션
- 담당: `mobile-flutter/lib`, `mobile-flutter/test`
- 우선 후보:
  - 시드 계정 버튼 중심 로그인 화면을 실제 입력 폼으로 확장
  - 일기 목록/상세/작성/수정 플로우 구현
  - remote 모드 오류 표시와 로딩 상태 정리
  - 현재 `2026년 3월` 고정 캘린더 조회를 월 선택 흐름으로 변경
- 검증 명령:
```bash
cd mobile-flutter
HOME=/home/msyeo/workspace/mongtorydiary/.tmp_flutter_home /tmp/flutter/bin/flutter analyze
HOME=/home/msyeo/workspace/mongtorydiary/.tmp_flutter_home /tmp/flutter/bin/flutter test
```

### 4번: 실행/통합 검증 세션
- 담당: 서버 실행, Flutter web 실행, curl 또는 브라우저 확인
- 백엔드 실행 후보:
```bash
JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 bash ./mvnw spring-boot:run
```
- Flutter web 실행 후보:
```bash
cd mobile-flutter
HOME=/home/msyeo/workspace/mongtorydiary/.tmp_flutter_home /tmp/flutter/bin/flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```
- 주의: 백엔드 기본 포트도 8080이므로 동시에 실행하려면 둘 중 하나의 포트를 바꿔야 한다.

### 5번: API 계약/테스트 세션
- 담당: API 계약 문서, 컨트롤러 테스트, 수동 API 호출 시나리오
- 우선 후보:
  - `.ai-work/msyeo/docs/api-contract.md`와 실제 코드 정합성 유지
  - Flutter DTO와 백엔드 DTO 필드명 비교 자동/수동 체크
  - 인증 후 일기/캘린더 조회까지의 수동 테스트 스크립트 정리

## 세션 간 충돌 방지 규칙
- 각 세션은 자기 담당 경로만 수정한다.
- 같은 파일을 여러 세션이 동시에 수정하지 않는다.
- 공통 문서 수정은 1번 총괄/문서 세션에서만 처리한다.
- 기능 변경 후 검증 결과와 변경 파일 목록을 1번 세션에 전달한다.
- 신규 문서는 루트 `docs/`가 아니라 `.ai-work/msyeo/docs/` 아래에 생성한다.

## 바로 확인할 상태
- 현재 브랜치: `feature/ai-workspace-docs`
- 현재 작업 트리에는 기존 변경이 있다. `git status --short` 확인 후 시작한다.
- Git 기준 루트 `docs/` 파일들은 `.ai-work/msyeo/docs/`로 이동된 상태다.
- 미추적 `.codex`가 존재하지만 현재 작업과 직접 관련이 없으면 건드리지 않는다.
- Flutter web 타깃이 추가되어 있고, `/tmp/flutter` SDK 기준 실행 이력이 있다.
- `/tmp/flutter`는 임시 위치라 사라질 수 있다. 장기 사용 전용 SDK 위치는 아직 확정되지 않았다.
- 루트 `docs/`는 다시 만들지 않는다. 문서는 모두 `.ai-work/msyeo/docs/` 아래에서 갱신한다.

## 다음 작업 추천 순서
1. Flutter remote 모드로 로그인, 일기 목록/상세, 캘린더, 감정 목록을 실제 백엔드에 붙여 확인한다.
2. 백엔드 인증/소유권 검증과 오류 응답을 테스트로 고정한다.
3. Flutter 로그인 입력 폼과 세션 실패/만료 UX를 구현한다.
4. Flutter 일기 작성/상세/수정/삭제 화면과 repository 계약을 구현한다.
5. 위젯용 요약 API와 딥링크 규칙을 문서화한다.

## 시작 체크리스트
```bash
git status --short
git branch --show-current
sed -n '1,220p' .ai-work/msyeo/docs/multiwindow-dev-prep.md
```
