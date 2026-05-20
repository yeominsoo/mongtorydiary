# 단일 세션 작업 목록

## 목적
역할별 분배를 철회한 뒤 남은 업무를 하나의 세션에서 순서대로 처리하기 위한 중앙 작업 목록이다. 기존 요청 ID는 추적을 위해 유지하되, 현재 담당은 모두 `단일 세션`이다.

## 이관 기준
- 이관일: 2026-05-21
- 기존 운영: PM, QA, FE 개발자, BE 개발자 4역할 비동기 협업
- 현재 운영: 단일 세션 순차 처리
- 과거 역할별 문서: 이력 확인용

## 남은 작업 목록
| 순서 | 기존 요청 ID | 우선순위 | 이전 담당 | 현재 담당 | 상태 | 작업 | 완료 기준 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | REQ-20260428-37 | P1 | QA | 단일 세션 | 완료 | 오늘/위젯 요약 API 실제 서버 회귀 검증 | 백엔드 서버 기동, 로그인, `GET /api/v1/widgets/today-summary?date=YYYY-MM-DD` 성공/오류 케이스 검증 기록 |
| 2 | REQ-20260428-38 | P1 | FE | 단일 세션 | 대기 | Flutter 딥링크 라우터 1차 구현 | 홈, 날짜 기본값 작성, 일기 상세, 캘린더 날짜 진입 route 처리와 Flutter 테스트 |
| 3 | REQ-20260428-39 | P1 | FE | 단일 세션 | 대기 | 위젯 요약 데이터 앱 연동 경계 구현 | today-summary DTO/model/repository, remote 호출, 갱신 트리거, 저장 adapter 경계와 테스트 |
| 4 | REQ-20260428-40 | P2 | PM | 단일 세션 | 대기 | 네이티브 위젯 shell 범위 결정 | Android/iOS 위젯 shell 구현 방식과 변경 파일 범위 결정 문서화 |
| 5 | REQ-20260428-35 | P1 | QA | 단일 세션 | 대기 | MVP 릴리스 회귀 체크리스트와 신규 개선 검증 계획 | 인증, 일기 CRUD, 캘린더, today-summary, 딥링크, 위젯 요약 경계, 빌드/검증 명령 체크리스트 작성 |
| 6 | SINGLE-20260521-OPS | P2 | PM | 단일 세션 | 대기 | 문서/커밋 정합성 정리 | 완료된 요청과 진행 중 작업을 분리하고, 관련 없는 미추적 파일을 제외한 커밋 후보 범위 정리 |

## 즉시 처리 완료 작업
| 요청 ID | 우선순위 | 요청자 | 현재 담당 | 상태 | 작업 | 완료 기준 |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-20260521-01 | P1 | 사용자 | 단일 세션 | 완료 | 백엔드 30080, Flutter web 30081 포트 기준 반영 | 백엔드 기본 포트, Flutter remote API 주소, Flutter web 실행 문서 갱신 |
| REQ-20260521-02 | P0 | 사용자 | 단일 세션 | 완료 | Rocky 10.1 미니 PC Flutter SDK 설치와 검증 복구 | Flutter SDK 설치, `mobile-flutter`의 pub get/analyze/test 결과 기록 |
| REQ-20260521-03 | P0 | 사용자 | 단일 세션 | 완료 | 웹 브라우저 확인용 백엔드/Flutter web 실행 | 30080/30081 서비스 실행, IP 기준 응답 확인, 접속 주소 안내 |
| REQ-20260521-04 | P1 | 사용자 | 단일 세션 | 검증완료 | 출품 수준 캘린더 TODO와 몽토리 메뉴 완성도 개선 | 캘린더 TODO API/UI, 몽토리 메뉴 구체화, 검증, handoff, 사용가이드/커밋/푸시/서버 재시작 |

## 권장 처리 순서
1. `REQ-20260428-37`로 today-summary API를 실제 서버에서 먼저 검증한다. 완료.
2. `REQ-20260428-38`로 Flutter 내부 딥링크 route를 고정한다.
3. `REQ-20260428-39`로 앱 내부 today-summary 연동 경계와 갱신 책임을 구현한다.
4. `REQ-20260428-40`으로 네이티브 위젯 shell을 지금 구현할지, 별도 후속으로 미룰지 결정한다.
5. `REQ-20260428-35`로 릴리스 전 회귀 체크리스트를 최신 구현 기준으로 정리한다.
6. `SINGLE-20260521-OPS`로 문서와 Git 상태를 정리한다.

## 작업별 참고 메모
### REQ-20260521-04
- 1페이즈 구현 완료:
  - 백엔드 TODO API와 월간 캘린더 TODO 요약 확장.
  - Flutter 캘린더 큰 월간 UI, 날짜별 TODO 추가/완료/삭제.
  - 몽토리 메뉴 대시보드 구체화.
  - 제품 범위 문서와 사용가이드 문서 작성.
- 검증:
  - `flutter analyze`: 통과.
  - `flutter test`: 통과, 12건.
  - `JAVA_HOME=/usr/lib/jvm/java-21-openjdk bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test`: 통과, 24건.
- 남은 마무리:
  - 관련 파일만 선별 커밋.
  - 원격 push.
  - 백엔드 30080과 Flutter web 30081 서비스 재시작 후 접속 확인.

### REQ-20260428-37
- 선행 조건: `REQ-20260428-34` 완료
- 검증 후보:
  - 유효한 access token으로 오늘 요약 조회
  - 지정일 일기 없음
  - 지정일 1건
  - 지정일 다건 대표 일기 선택
  - streakDays와 lastEntryDate
  - invalid token 401
  - 잘못된 date query 400 계열 오류

### REQ-20260428-38
- 선행 조건: `REQ-20260428-34` 완료
- 범위:
  - `mongtory://home`
  - `mongtory://diaries/new?date=YYYY-MM-DD`
  - `mongtory://diaries/{diaryId}`
  - `mongtory://calendar?year=YYYY&month=MM&date=YYYY-MM-DD`
- 네이티브 Android/iOS link 설정은 이 작업에 포함하지 않는다.

### REQ-20260428-39
- 선행 조건: `REQ-20260428-34` 완료, `REQ-20260428-38` 착수 또는 완료
- 범위:
  - BE `WidgetTodaySummaryResponse`에 대응하는 Flutter DTO/model
  - remote datasource와 repository 계약
  - 홈 진입, 일기 CRUD 성공, 캘린더 새로고침 이후 갱신 책임
  - Android/iOS 공유 저장소 쓰기는 adapter 경계까지만 둔다.

### REQ-20260428-40
- 선행 조건: `REQ-20260428-37`, `REQ-20260428-38`, `REQ-20260428-39` 결과 확인
- 결정 대상:
  - Android App Widget 직접 구현 또는 Glance 사용 여부
  - iOS WidgetKit/App Group 적용 시점
  - Flutter 플러그인 또는 platform channel 필요 여부
  - MVP에 포함할 최소 위젯 화면과 보류 범위

### REQ-20260428-35
- 선행 조건: 가능한 한 `REQ-20260428-37~40` 결과 확인
- 체크리스트 범위:
  - 백엔드 테스트
  - Flutter analyze/test
  - 실제 서버 API smoke
  - Flutter mock/remote smoke
  - 신규 딥링크 route
  - today-summary 앱 연동 경계
  - 릴리스 전 남은 위험

## 공통 검증 명령
백엔드:

```bash
bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test
```

Flutter:

```bash
cd mobile-flutter
HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze
HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test
```

## Git 주의
2026-05-21 현재 기존 미추적 항목으로 `.codex`, `node_modules/`, `package-lock.json`, `package.json`가 보인다. 단일 세션 작업과 직접 관련이 없으면 수정하거나 커밋하지 않는다.
