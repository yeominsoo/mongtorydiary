# 세션 연속성 인수인계 문서

## 문서 목적
이 문서는 대화 컨텍스트가 초기화된 새 세션에서도 현재 저장소 상태를 빠르게 복구할 수 있도록 만든 상세 인수인계 문서다. `.ai-work/msyeo/docs/project-status.md`가 현재 상태 요약이라면, 이 문서는 왜 이런 구조가 되었는지와 다음 작업 진입 절차까지 포함한다.

## 프로젝트 한 줄 요약
Mongtory Diary는 감정형 일기 서비스를 목표로 하며, 현재 방향은 `Spring Boot 백엔드 + Flutter 모바일 앱 + 별도 웹 FE + Android/iOS 위젯 확장`이다.

## 작업 전 상태
초기 저장소는 Spring Boot 루트 프로젝트와 `frontend/`의 React + TypeScript + Vite 프로토타입이 함께 있었고, 실제 기능은 거의 없는 부트스트랩 수준이었다. 앱과 웹을 동시에 고려하던 단계였지만, 위젯 지원 요구가 추가되면서 모바일 앱 중심 재정리가 필요해졌다.

작업 전 특징:
- 백엔드: Spring Boot 엔트리포인트 중심의 초기 구조
- 웹: `frontend/`에 Hello World 수준의 초기 골격
- 앱: 없음
- 위젯: 설계 없음
- 운영 문서: 일부 계획 문서만 존재

## 왜 Flutter 중심으로 전환했는가
현재 `frontend/`는 기능 자산이 거의 없어 전환 비용이 낮았다. 반면 제품 요구사항은 모바일 앱 중심 경험, 감성형 UI, 추후 Android/iOS 위젯 지원까지 포함한다. 이 조건에서는 웹과 앱을 억지로 한 프론트엔드로 묶기보다, 앱은 Flutter로 집중하고 웹은 별도 FE로 분리하는 편이 구조적으로 자연스럽다고 판단했다.

핵심 판단:
- 사용자용 메인 제품은 모바일 앱
- 웹은 별도 프론트엔드로 추후 운영
- 위젯은 앱의 딥링크와 요약 데이터를 활용
- 공통 계약은 서버 API와 DTO로 관리

## 현재 저장소 구조
### 백엔드
- `src/main/java/com/mongtory/diary`
  - `common/ApiResponse.java`
  - `controller/`: 인증, 감정, 일기, 캘린더 API 컨트롤러
  - `service/`: 인증/Diary/Calendar 서비스
  - `dto/`: auth, emotion, diary, calendar DTO
  - `domain/emotion/EmotionCode.java`
  - `domain/diary/DiaryEntry.java`
  - `domain/user/UserAccount.java`
  - `repository/DiaryEntryRepository.java`
  - `repository/UserAccountRepository.java`
  - `config/DiaryDataInitializer.java`
  - `config/UserDataInitializer.java`
- `src/main/resources/application.properties`
- `src/test/java/com/mongtory/diary`
  - 기본 애플리케이션 테스트
  - `controller/` 웹 레이어 테스트

### 모바일 앱
- `mobile-flutter/`
  - `lib/core`: 라우팅, 테마
  - `lib/application`: Riverpod 상태, 세션, 탭 상태
  - `lib/domain`: 도메인 모델, repository 인터페이스
  - `lib/data`: DTO, 매퍼, mock/remote datasource, mock/API repository
  - `lib/presentation`: 시작, 로그인, 홈 셸, 일기, 캘린더, 프로필 화면
  - `android/`, `ios/`, `web/`: Flutter 기본 플랫폼 프로젝트와 웹 실행 타깃
  - `test/widget_test.dart`

### 문서
- `AGENTS.md`: 저장소 운영 규칙
- `.ai-work/msyeo/docs/planning.md`: 제품 비전과 초기 계획
- `.ai-work/msyeo/docs/platform-direction.md`: 플랫폼 방향
- `.ai-work/msyeo/docs/flutter-architecture.md`: Flutter 기준 아키텍처
- `.ai-work/msyeo/docs/api-spec.md`: 백엔드-앱 공용 API 계약 초안
- `.ai-work/msyeo/docs/api-contract.md`: 현재 소스 기준 API/DTO 계약 현황
- `.ai-work/msyeo/docs/project-status.md`: 현재 상태 요약
- `.ai-work/msyeo/docs/project-analysis.md`: 바이브코딩용 분석 문서
- `.ai-work/msyeo/docs/multiwindow-dev-prep.md`: 멀티 터미널 작업 준비 문서
- `.ai-work/msyeo/docs/windows-flutter-app-guide.md`: 윈도우 앱 실행 가이드
- `.ai-work/msyeo/docs/handoff/2026-03-19.md`: 일자별 작업 기록
- `.ai-work/msyeo/docs/session-continuity.md`: 현재 문서

### 참고용 이전 웹 프로토타입
- `frontend/`: React + TypeScript + Vite 초기 프로토타입

## 현재 구현 후 상태
### 백엔드
문서만 있던 상태에서 실제 API 골격과 Diary/Calendar 영속화 뼈대까지 추가되었다.

구현된 항목:
- `ApiResponse<T>` 공통 응답 래퍼
- `UserAccount` 엔티티와 `UserAccountRepository`
- 회원가입, 로그인, 토큰 재발급 DB 기반 서비스 연결
- Diary/Calendar API는 access token 기준 현재 사용자 소유 데이터만 조회
- 감정 목록 API mock 골격
- `DiaryEntry` 엔티티와 `DiaryEntryRepository`
- 일기 목록/상세/생성/수정/삭제 SQLite 기반 서비스 연결
- 월간 캘린더 조회 SQLite 기반 집계 연결
- 기본 일기 1건 시드 초기화
- 기본 사용자 1건 시드 초기화
- 일부 컨트롤러 테스트 골격

아직 없는 항목:
- JWT 등 실제 인증 토큰 전략
- 이미지 업로드
- 예외 처리 표준화

### Flutter 앱
Flutter SDK 설치와 실제 앱 초기화가 끝났고, 단순 생성 앱을 MVP 골격으로 바꿨다.

구현된 항목:
- `startup -> sign-in -> home shell` 라우팅
- 홈 셸 탭: 일기, 캘린더, 프로필
- `flutter_riverpod` 기반 상태 계층 시작
- `domain/models`, `domain/repositories` 정리
- `data/dto`, `data/mappers` 정리
- `core/network`, `mock datasource`, `remote datasource`, `mock/API repository` 추가
- provider가 `mock/remote` 전환 가능한 구조를 가짐
- 현재 화면은 기본적으로 mock repository 기반 상태를 읽도록 연결
- `DATA_SOURCE_MODE`, `API_BASE_URL` `dart-define`으로 원격 API 전환 가능
- 로그인 화면과 일기/캘린더 화면이 원격 API 오류를 기본 문구로 표시
- 일기/캘린더/프로필 화면이 실제 응답 항목 일부를 카드 안에서 렌더링
- `remote` 모드에서는 로그인 성공 후 access token을 일기/캘린더 API에 `Authorization` 헤더로 전달
- `web/` 타깃이 추가되어 `/tmp/flutter` SDK 기준 web-server 실행 이력이 있음

아직 없는 항목:
- 현재 문서 최신화 세션 기준 새로 실행 검증한 API 연동 결과
- 회원가입, 토큰 재발급 repository/화면 플로우
- 일기 생성/수정/삭제 repository/화면 플로우
- 영구 세션 저장
- 위젯 연동 코드
- 기능별 세부 화면과 폼 흐름

## 중요 기술 결정
### 백엔드
- Java 17 기준
- Spring Boot 3.2.0
- Maven Wrapper 사용
- 응답 형태는 `ApiResponse<T>`로 통일
- 구조는 `Controller -> Service -> Repository`

### 모바일 앱
- Flutter 메인 앱
- 상태 관리는 Riverpod
- 계층은 `presentation / application / domain / data / core`
- 위젯은 앱 편집 UI와 분리된 요약 진입점으로 설계

### 위젯 방향
- Android: App Widget 또는 Glance
- iOS: WidgetKit
- 위젯에서 보여줄 최소 정보:
  - 오늘 일기 작성 여부
  - 오늘 감정
  - 연속 작성 일수
  - 몽토리 한 줄 메시지
- 탭 시 앱 특정 화면으로 딥링크 이동

## 검증 이력
### Flutter
사용자 로컬 환경에서 아래 검증이 통과했다.

```bash
cd /home/msyeo/workspace/mongtorydiary/mobile-flutter
HOME=/home/msyeo/workspace/mongtorydiary/.tmp_flutter_home /home/msyeo/workspace/mongtorydiary/.tooling/flutter-sdk/bin/flutter pub get
HOME=/home/msyeo/workspace/mongtorydiary/.tmp_flutter_home /home/msyeo/workspace/mongtorydiary/.tooling/flutter-sdk/bin/flutter analyze
HOME=/home/msyeo/workspace/mongtorydiary/.tmp_flutter_home /home/msyeo/workspace/mongtorydiary/.tooling/flutter-sdk/bin/flutter test
```

검증 결과:
- `flutter analyze`: `no issues found!`
- `flutter test`: `All tests passed!`

원격 API 모드 실행 예시:

```bash
cd /home/msyeo/workspace/mongtorydiary/mobile-flutter
/home/msyeo/workspace/mongtorydiary/.tooling/flutter-sdk/bin/flutter run \
  --dart-define=DATA_SOURCE_MODE=remote \
  --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

### 백엔드
아래 명령으로 백엔드 테스트를 실제 실행했고 통과했다.

```bash
cd /home/msyeo/workspace/mongtorydiary
JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test
```

검증 결과:
- `BUILD SUCCESS`
- `Tests run: 3, Failures: 0, Errors: 0, Skipped: 0`

## 로컬 환경 및 도구 위치
- 저장소 루트: `/home/msyeo/workspace/mongtorydiary`
- 현재 주요 작업 브랜치: `feature/ai-workspace-docs`
- Flutter SDK: 과거 `.tooling/flutter-sdk` 검증 이력과 2026-04-28 `/tmp/flutter` web-server 실행 이력이 함께 있음
- Flutter 실행 파일 후보: `/tmp/flutter/bin/flutter`
- Maven 실행 기준 Java:
  - `JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64`

## Git 상태 관련 주의사항
현재 작업 트리는 이미 dirty 상태다. 이번 세션 이전부터 변경된 파일도 섞여 있으므로, 새 세션에서는 먼저 `git status --short`를 보고 요청 범위와 직접 관련된 파일만 건드려야 한다.

현재 눈에 띄는 특징:
- 루트 `docs/` 문서는 `.ai-work/msyeo/docs/`로 이동된 상태다.
- `mobile-flutter/.metadata`, `mobile-flutter/web/` 변경은 Flutter web 타깃 추가 작업에서 발생했다.
- `.codex` 미추적 항목은 이번 문서 작업과 직접 관련이 없어 건드리지 않는다.
- `.m2/`, `.tmp_flutter_home/`, `.tooling/`, `mobile-flutter/build/`, `mobile-flutter/.dart_tool/` 같은 로컬 산출물이 존재할 수 있다.

## 새 세션 시작 체크리스트
1. `AGENTS.md`를 먼저 읽어 작업 규칙을 확인한다.
2. `.ai-work/msyeo/docs/project-status.md`로 전체 상태를 빠르게 확인한다.
3. `.ai-work/msyeo/docs/session-continuity.md`로 전환 배경과 현재 구조를 복구한다.
4. `.ai-work/msyeo/docs/handoff/`에서 2026-03-19, 2026-03-20, 2026-04-28 순서로 작업 흐름을 확인한다.
5. `git status --short`로 기존 변경 파일과 신규 파일 상태를 점검한다.
6. 작업 종료 직후 `.ai-work/msyeo/docs/project-status.md`와 `.ai-work/msyeo/docs/handoff/YYYY-MM-DD.md`를 바로 갱신한다.

## 다음 우선순위
### 1순위
- Flutter 원격 API 모드로 실제 백엔드 연결 검증
- 로그인, 일기 목록/상세, 캘린더 조회, 감정 목록의 성공/실패 플로우 확인
- Flutter 로그인 화면을 실제 입력 폼으로 바꾸고 provider와 세션 상태를 다듬기

### 2순위
- 인증 로직과 예외 처리 표준화
- 일기 생성/수정/삭제 Flutter repository와 화면 구현
- 감정/위젯 요약 데이터까지 실제 영속화 흐름 확장
- Flutter remote 모드 실기기/에뮬레이터 통합 검증

### 3순위
- 위젯용 데이터 모델과 딥링크 규칙 상세화
- Android/iOS 위젯 플랫폼 설정 설계

## 2026-04-28 최신 협업 상태
현재 협업 역할은 PM, QA, FE, BE로 나뉘며 공통 인덱스는 `.ai-work/msyeo/docs/collaboration/requests.md`, `.ai-work/msyeo/docs/collaboration/status.md`, `.ai-work/msyeo/docs/collaboration/responses.md`다. 각 역할은 `.ai-work/msyeo/docs/collaboration/roles/{pm|qa|fe|be}/` 아래 자기 문서를 먼저 확인하고 갱신한다. 모든 역할은 작업 시작 전 `AGENTS.md`, `collaboration/master-flow.md`, `collaboration/roles/README.md`, 자기 `inbox.md`, 자기 `status.md`를 확인하고 자기 `status.md`의 `룰 확인 기록`에 남겨야 한다.

### 완료된 핵심 요청
- `REQ-20260428-06`: QA가 실제 서버에서 로그인, 일기 목록/상세, 캘린더, 감정 목록, invalid token 응답을 검증했다.
- `REQ-20260428-09`: FE가 Flutter 일기 생성/수정/삭제 플로우를 구현했고 PM 재검증도 완료됐다.
- `REQ-20260428-10`: QA가 Flutter widget test 기반 QA 하네스를 구축했다.
- `REQ-20260428-24`: QA가 일기 CRUD 회귀 자동화를 확장했고 실제 서버 CRUD API도 검증했다.
- `REQ-20260428-25`: PM이 위젯/딥링크 1차 설계 문서를 작성했다.
- `REQ-20260428-26`: FE가 CRUD 이후 사용성 개선 후보를 설계했다.

### 최신 검증 결과
- Flutter:
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test`: 통과, 9건
  - `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze`: 통과
- 백엔드 remote CRUD API:
  - `bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 spring-boot:run`으로 8080 기동 확인 후 종료
  - 로그인 성공과 access token 발급 확인
  - `POST /api/v1/diaries` 생성 성공 확인
  - `GET /api/v1/diaries/{id}` 상세 조회 성공 확인
  - `PUT /api/v1/diaries/{id}` 수정 성공과 목록 반영 확인
  - `DELETE /api/v1/diaries/{id}` 삭제 성공과 목록 제외 확인
  - invalid token 상세 요청은 401, `success=false`, `message=Invalid access token`, `data=null` 확인

### 다음 역할별 시작점
- QA 역할:
  - 현재 QA inbox 기준 바로 착수할 신규 요청은 없다.
  - BE `REQ-20260428-22` 완료 후 오류 계약 회귀 검증 요청이 들어오면 진행한다.
- BE 역할:
  - 1순위는 `REQ-20260428-22` API 검증 오류 계약 보강이다.
  - malformed JSON body, 누락 query parameter, calendar `year/month` 범위 오류, 요청 DTO 검증 실패를 `ApiResponse` 오류 규칙으로 고정한다.
  - 그 다음 `REQ-20260428-27` 사용성 개선용 API 후보 설계를 진행한다.
- FE 역할:
  - `REQ-20260428-09` CRUD 구현과 `REQ-20260428-26` 사용성 개선 후보 설계는 완료 상태다.
  - 다음 FE 구현 요청은 PM이 `REQ-20260428-25`, `REQ-20260428-26`, BE `REQ-20260428-27` 결과를 보고 분리해야 한다.
- PM 역할:
  - BE `REQ-20260428-22`, `REQ-20260428-27` 진행을 모니터링한다.
  - 완료 요청 단위로 responses, handoff, 검증 결과를 확인하고 커밋 범위를 선별한다.

## 새 세션에서 바로 쓸 수 있는 요약
이 저장소는 더 이상 React 웹이 메인이 아니다. 현재 유효한 메인 방향은 `Spring Boot API + Flutter 앱 + 추후 별도 웹 + Android/iOS 위젯`이다. Flutter 앱은 Riverpod, 도메인 모델, DTO, 매퍼, mock/remote datasource와 repository까지 연결되어 있으며, 현재는 로그인, 일기 목록/상세, 일기 생성/수정/삭제, 캘린더, 감정 목록 흐름이 구현되어 있다. QA 하네스는 widget test에서 로그인, 탭 이동, 로그인 실패, 일기 CRUD 회귀를 검증한다. 백엔드는 SQLite와 임시 access token 기반으로 Auth/Diary/Calendar/Emotion API를 제공하고, 주요 오류는 `ApiResponse`로 감싼다. 다음 실질 작업은 BE `REQ-20260428-22` 오류 계약 보강이며, QA는 그 결과를 받아 오류 응답 회귀 검증을 이어가면 된다.
