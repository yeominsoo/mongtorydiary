# 캘린더 웹앱 리서치 기반 UI 개편 계획

## 작업 목적
몽토리 다이어리 운영 웹이 계획서 문구처럼 보이는 카드 중심 화면에 머물지 않도록, 캘린더 앱의 주요 사용 패턴을 참고해 실제 일정/일기/TODO를 한 화면에서 다루는 캘린더 중심 앱으로 개편한다.

## 참고 소스
- Google Calendar Wikipedia: https://en.wikipedia.org/wiki/Google_Calendar
- Google Calendar Help: https://support.google.com/calendar?hl=en-GB
- Microsoft Outlook Calendar Support: https://support.microsoft.com/en-us/office/introduction-to-the-outlook-calendar-d94c5203-77c7-48ec-90a5-2e2bc10bd6f8
- Microsoft Outlook Wikipedia: https://en.wikipedia.org/wiki/Microsoft_Outlook
- Calendly Help: https://calendly.com/help/get-to-know-calendly
- Calendly Wikipedia: https://en.wikipedia.org/wiki/Calendly
- Notion Calendar product page: https://www.notion.com/en-gb/product/calendar
- TechRadar Best Calendar Apps 2026: https://www.techradar.com/best/best-calendar-apps

## 리서치 요약
- Google Calendar는 일/주/월/일정 보기, 이벤트 생성/수정, 반복, 색상, 위치, 일정과 작업 관리, 공유와 약속 일정 기능을 핵심으로 둔다.
- Outlook Calendar는 메일/연락처와 통합된 일정 관리, 그룹 일정, 여러 캘린더 side-by-side/overlay, 공유/위임 관리를 제공한다.
- Calendly는 연결된 캘린더의 바쁜 시간을 충돌로 보고, 공유 링크를 통해 가능한 시간만 예약하게 하는 scheduling automation에 강점이 있다.
- Notion Calendar는 Google Calendar 이벤트와 Notion 데이터베이스 날짜 항목을 나란히 보여주며, 작업/프로젝트 데이터와 일정의 결합을 강조한다.
- 2026년 캘린더 앱 비교 기사들은 Google Calendar, Outlook/iCloud, Calendly, Any.do 같은 앱을 언급하면서 공통적으로 다중 보기, 공유, 일정/할 일 결합, 모바일/웹 동기화, 가벼운 협업을 중요하게 본다.

## 제품 반영 원칙
- 첫 화면은 문서형 홈이 아니라 오늘/이번 달 일정 상황을 바로 다루는 캘린더 작업대여야 한다.
- 월간 그리드에는 일기와 TODO가 실제 일정 칩처럼 보여야 한다.
- 사용자는 월간 보기에서 날짜를 고르고, 오른쪽 패널 또는 하단 패널에서 그 날짜의 일기/TODO를 바로 확인하고 작성할 수 있어야 한다.
- 데스크톱 웹에서는 사이드바, 월간 보드, 선택일 상세 패널의 3영역 레이아웃을 사용한다.
- 모바일에서는 같은 기능을 한 열로 접어 읽기 쉬운 작업 순서로 보여준다.
- 계획/상태 설명 문구는 사용자 UI에서 제거하고, 실제 명령과 데이터 라벨만 남긴다.

## 계획
1. 캘린더 탭을 기본 진입 화면으로 바꾼다.
2. `CalendarScreen`을 캘린더 웹앱형 레이아웃으로 재작성한다.
3. 기존 TODO/일기 API 계약은 유지하고 UI에서 더 조밀하고 명확하게 표현한다.
4. 테스트는 새 UX의 핵심 문자열과 상호작용 기준으로 갱신한다.
5. Flutter analyze/test/build, 운영 API smoke, 배포 후 Argo CD 상태와 운영 번들 확인까지 수행한다.

## 계획 세분화
- Shell:
  - 기본 탭을 `calendar`로 변경한다.
  - 하단 내비게이션 순서를 캘린더, 일기, 몽토리로 재정렬한다.
- Calendar:
  - 상단 command bar: 오늘, 이전/다음, 월/주/일정 segmented control, 새 일기 CTA.
  - 좌측 rail: 미니 월 선택, 이번 달 일기/TODO/완료율, 캘린더 소스 범례.
  - 중앙 month board: 날짜별 일기/TODO 칩, 오늘/선택일 상태, 빈 날짜 quick affordance.
  - 우측 agenda: 선택일 요약, 일기 목록, TODO 추가/완료/삭제, 가용성/공유 힌트.
  - 모바일: 좌측 rail, month board, agenda를 순서대로 한 열에 표시.
- Diary home:
  - 당장 깊은 구조 변경은 하지 않되, 기본 진입을 캘린더로 바꿔 계획서형 홈 노출을 줄인다.
  - 후속 보완에서 홈 문구를 더 제품형으로 정리한다.
- Tests:
  - QA 하네스는 캘린더가 로그인 후 기본 화면임을 확인한다.
  - 날짜 선택, 일기 상세, 빈 날짜 작성, TODO 추가/완료를 새 UI 기준으로 검증한다.

## 보완점 확인 기준
- 문서/계획처럼 보이는 문구가 첫 화면에 남아 있는가.
- 캘린더가 데스크톱에서 단순 모바일 카드 확대처럼 보이지 않는가.
- 날짜 셀 안의 텍스트가 좁은 화면에서 넘치거나 겹치지 않는가.
- 선택일 일기/TODO 작업이 스크롤을 많이 요구하지 않는가.
- 테스트가 실제 사용 흐름을 검증하는가.

## 검증 및 e2e 게이트
- `flutter analyze`
- `flutter test`
- `flutter build web --release --dart-define=DATA_SOURCE_MODE=remote --dart-define=API_BASE_URL=`
- `docker build -t mongtorydiary-frontend:calendar-redesign -f Dockerfile.frontend .`
- `kustomize build deploy/k8s/overlays/prod`
- 운영 배포 후:
  - GitHub Actions 성공
  - Argo CD `Synced Healthy`
  - backend/frontend image tag가 새 source commit으로 반영
  - `GET http://192.168.75.194:30080/` 200
  - `POST http://192.168.75.194:30080/api/v1/auth/login` 테스트 계정 200
  - 배포된 `main.dart.js`에서 새 캘린더 UI 문자열 확인
