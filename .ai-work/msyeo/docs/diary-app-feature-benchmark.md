# 유명 다이어리 앱 기능 참고와 Mongtory 적용 범위

## 목적
`REQ-20260521-05` 기준으로 유명 다이어리 앱의 공통 기능을 참고해 Mongtory Diary의 완성형 방향을 정리한다. 목표는 단순 CRUD 일기장을 넘어, 매일 쓰기 쉽고 다시 돌아볼 이유가 있는 다이어리 앱으로 확장하는 것이다.

## 참고 앱과 기능 축
### Day One
- 참고: [Day One (app), Wikipedia](https://en.wikipedia.org/wiki/Day_One_(app))
- 핵심 축:
  - 사진, 영상, 오디오, 위치 같은 멀티미디어와 메타데이터를 일기와 함께 저장.
  - 여러 기기 동기화.
  - Markdown 작성, 위치/날씨/날짜/시간 자동 메타데이터, 리마인더.
  - 엔드투엔드 암호화.
- Mongtory 적용:
  - 1순위: 사진 URL 첨부를 실제 업로드로 전환, 위치/날씨 필드 설계.
  - 2순위: 다중 저널 또는 카테고리.
  - 3순위: 암호화와 백업/내보내기.

### Penzu
- 참고: [Penzu, Wikipedia](https://en.wikipedia.org/wiki/Penzu)
- 핵심 축:
  - 비공개 기본값.
  - 사진 업로드, 선택 공유.
  - 태그, 리치 텍스트, PDF 내보내기, 리마인더.
  - 저널 단위 암호화.
- Mongtory 적용:
  - 1순위: 일기 공개 범위는 기본 비공개로 명시하고, 태그/검색 기반을 추가.
  - 2순위: PDF/텍스트 내보내기.
  - 3순위: 일기 잠금과 복구 정책.

### Daylio
- 참고: [Daylio, Wikipedia](https://en.wikipedia.org/wiki/Daylio)
- 핵심 축:
  - 5단계 감정 기록과 활동 선택.
  - 빠른 마이크로 저널.
  - streak, 알림, 업적, 통계/그래프.
  - Year in Pixels처럼 감정을 색상으로 회고.
- Mongtory 적용:
  - 1순위: 감정 선택을 더 빠르게 만들고, 월간 감정 점/흐름을 표시.
  - 2순위: 활동 태그와 반복 루틴 체크.
  - 3순위: streak/업적/월간 리포트.

### Apple Journal
- 참고: [Journal (Apple), Wikipedia](https://en.wikipedia.org/wiki/Journal_(Apple))
- 핵심 축:
  - 작성 제안과 reflection prompt.
  - 사진, 영상, 음성, 위치, 운동, 음악 등 수동 첨부.
  - 잠금, 작성 일정 알림.
  - 습관 통계와 인사이트.
- Mongtory 적용:
  - 1순위: 오늘의 회고 프롬프트와 기록 흐름 카드.
  - 2순위: 사진/위치/음성 첨부.
  - 3순위: 일정 알림과 잠금.

### Journey
- 참고: [What is Journey?, Journey Help](https://help.journey.cloud/en/article/what-is-journey-1cmxhui/)
- 핵심 축:
  - 타임라인, 캘린더, 지도, 사진 보기.
  - 태그, 감정 태그, 검색/필터.
  - 사진/영상/오디오 첨부, 위치/날씨 자동 메타데이터.
  - 과거 기록 돌아보기, 템플릿, 내보내기, 셀프호스팅.
- Mongtory 적용:
  - 1순위: 타임라인/캘린더/지난 오늘을 연결.
  - 2순위: 태그/검색/필터와 템플릿.
  - 3순위: 셀프호스팅 친화적인 PostgreSQL 운영 구성을 강화.

## 이번 작업에 반영한 범위
- Flutter web 초기화 중 빈 화면 대신 진행 상태를 보여주는 부트 화면을 추가한다.
- 기본 백엔드 DB를 SQLite 파일에서 PostgreSQL로 전환하고, 테스트는 H2 인메모리 DB로 분리한다.
- 일기 홈을 `오늘의 회고`, `기록 흐름`, `지난 오늘`, `최근 일기` 구조로 개편해 작성 제안과 회고성을 강화한다.

## 다음 구현 우선순위
1. 검색/태그 API와 Flutter 필터 UI.
2. 일기 사진을 URL 입력이 아니라 실제 업로드/첨부로 전환.
3. `지난 오늘`을 API로 제공해 대량 데이터에서도 빠르게 조회.
4. 위치/날씨 메타데이터 필드 추가.
5. 작성 리마인더와 잠금 정책.
6. 월간 감정 리포트와 Year in Pixels 형태의 회고 화면.
