# Flutter 기준 최종 아키텍처안

## 목표
Mongtory Diary의 메인 제품은 모바일 앱으로 두고, 안드로이드 위젯과 iOS 위젯까지 자연스럽게 확장 가능한 구조를 만든다. 웹은 앱과 분리된 별도 프론트엔드로 운영한다.

## 최종 아키텍처
- Backend: Spring Boot API 서버
- App FE: Flutter
- Widget Layer: Android App Widget 또는 Glance, iOS WidgetKit
- Web FE: 별도 프로젝트
- Database: 초기 SQLite, 확장 시 교체 가능하도록 설계

핵심은 앱, 위젯, 웹이 모두 같은 백엔드 API를 사용하되, UI 구현은 각 채널에 맞게 분리하는 것이다.

## 앱 아키텍처
Flutter 앱은 아래 계층으로 구성한다.

- `presentation`: 화면, 위젯, 라우팅
- `application`: 상태 관리, 유스케이스, 세션 흐름
- `domain`: Diary, Emotion, User, Streak 같은 핵심 모델
- `data`: API client, repository 구현, 로컬 저장소
- `core`: 공통 상수, 에러 모델, 날짜/포맷 유틸, 딥링크

상태 관리는 `Riverpod` 또는 `Bloc` 중 하나로 통일한다. 초기 생산성과 테스트 균형을 고려하면 `Riverpod`가 유리하다.

## 위젯 연동 구조
위젯은 앱 UI와 분리된 네이티브 확장으로 둔다.

- Android:
  - App Widget 또는 Glance 사용
  - 앱이 로컬 저장소에 요약 데이터를 기록
  - 위젯은 해당 요약 데이터와 딥링크를 사용
- iOS:
  - WidgetKit 사용
  - App Group 저장소 또는 공유 데이터 영역 사용
  - 위젯 탭 시 앱 특정 화면으로 이동

위젯은 아래 정보만 우선 노출한다.

- 오늘 일기 작성 여부
- 오늘 감정 스티커
- 최근 연속 작성 일수
- Mongtory 한 줄 메시지

## 저장소 구조 제안
```text
docs/
  handoff/
  flutter-architecture.md
  planning.md
  platform-direction.md
  project-status.md
frontend-web/
mobile-flutter/
  lib/
    core/
    data/
    domain/
    application/
    presentation/
  android/
  ios/
  test/
src/main/java/
src/main/resources/
src/test/java/
```

현재의 `frontend/`는 전환 전 임시 프론트엔드로 보고, 정식 웹을 시작할 때 `frontend-web/` 같은 명확한 경로로 분리하는 편이 낫다.

## MVP 기능 우선순위
### 1순위: 백엔드 API
- 회원가입, 로그인
- 일기 CRUD
- 월간 캘린더 조회
- 감정 스티커 저장/조회
- 통합 `ApiResponse<T>` 규칙

### 2순위: Flutter 앱 MVP
- 로그인
- 오늘 일기 작성
- 일기 목록 및 상세
- 월간 캘린더
- 감정 선택

### 3순위: 위젯 MVP
- 오늘 상태 요약
- 연속 작성 일수
- 앱 딥링크 연결

### 4순위: 웹 FE
- 랜딩
- 계정 기반 조회 시나리오
- 필요 시 운영/관리 화면

## 설계 원칙
- 위젯은 조회 전용으로 단순화한다.
- 앱과 웹은 UI를 공유하지 않는다.
- 공통은 API 계약과 도메인 규칙 수준에서 맞춘다.
- 서버 응답 모델은 DTO로 통일한다.
- 컨텍스트 유실을 막기 위해 구조 변경 시 `docs/project-status.md`와 일자별 `handoff`를 함께 갱신한다.
