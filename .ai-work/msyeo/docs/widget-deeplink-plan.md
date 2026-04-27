# 위젯/딥링크 1차 설계

## 목적
`REQ-20260428-25` 기준으로 Flutter 앱 MVP 이후 Android/iOS 위젯과 앱 딥링크를 구현하기 위한 1차 책임 경계를 정리한다. 현재 단계에서는 네이티브 위젯 구현을 시작하지 않고, 위젯에 필요한 요약 데이터와 앱 진입 URL 규칙, FE/BE 후속 요청 후보를 확정 가능한 수준으로 좁힌다.

## 설계 원칙
- 위젯은 앱의 축소판이 아니라 오늘 상태를 확인하고 앱으로 진입하는 조회 전용 요약 진입점으로 둔다.
- 일기 작성, 수정, 삭제, 감정 선택 같은 편집 기능은 Flutter 앱 내부 화면에서 처리한다.
- 위젯은 서버 API를 직접 호출하지 않고, 앱이 로그인 상태와 API 응답을 바탕으로 공유 저장소에 기록한 요약 데이터를 읽는 방향을 우선한다.
- 공통 계약은 API DTO, 로컬 위젯 요약 모델, 딥링크 route 문자열로 분리한다.

## 위젯 데이터 모델 후보
### WidgetTodaySummary
오늘 위젯의 기본 데이터다. 앱이 로그인 이후 홈, 일기 CRUD, 캘린더 새로고침 시 갱신한다.

```json
{
  "date": "2026-04-28",
  "hasTodayEntry": true,
  "todayDiaryId": 101,
  "todayEmotionCode": "CALM",
  "todayDiaryTitle": "오늘의 기록",
  "streakDays": 3,
  "lastEntryDate": "2026-04-28",
  "message": "오늘도 몽토리와 기록했어요.",
  "updatedAt": "2026-04-28T02:54:00"
}
```

필수 후보:
- `date`: 요약 기준일
- `hasTodayEntry`: 오늘 일기 작성 여부
- `todayDiaryId`: 오늘 일기가 있으면 상세 진입에 사용
- `todayEmotionCode`: 오늘 감정 표시용 코드
- `streakDays`: 최근 연속 작성 일수
- `message`: 위젯에 노출할 한 줄 메시지
- `updatedAt`: 위젯 데이터 최신성 표시와 디버깅 기준

### WidgetCalendarSummary
월간 캘린더 진입형 위젯을 위한 확장 후보다. MVP 위젯에서는 보류 가능하다.

```json
{
  "year": 2026,
  "month": 4,
  "today": "2026-04-28",
  "monthEntryCount": 8,
  "dominantEmotionCode": "CALM",
  "recentDays": [
    {
      "date": "2026-04-28",
      "hasEntry": true,
      "emotionCode": "CALM"
    }
  ]
}
```

### WidgetQuickAction
위젯 터치 영역별 앱 진입점을 표현한다.

```json
{
  "type": "CREATE_TODAY_DIARY",
  "label": "오늘 일기 쓰기",
  "deepLink": "mongtory://diaries/new?date=2026-04-28"
}
```

우선 action 후보:
- `OPEN_HOME`: 홈 진입
- `CREATE_TODAY_DIARY`: 오늘 일기 작성 화면 진입
- `OPEN_TODAY_DIARY`: 오늘 일기 상세 화면 진입
- `OPEN_CALENDAR_DATE`: 캘린더 특정 날짜 진입

## 딥링크 URL 및 Flutter route 후보
| 목적 | 딥링크 후보 | Flutter route 후보 | 비고 |
| --- | --- | --- | --- |
| 홈 진입 | `mongtory://home` | `/home` | 로그인 필요, 세션 없으면 로그인 후 홈 |
| 오늘 일기 작성 | `mongtory://diaries/new?date=YYYY-MM-DD` | `/diaries/new?date=YYYY-MM-DD` | 오늘 일기 존재 시 상세 또는 수정으로 보낼지 FE 설계 필요 |
| 일기 상세 | `mongtory://diaries/{diaryId}` | `/diaries/:diaryId` | 권한 오류 또는 삭제된 일기 처리 필요 |
| 캘린더 날짜 | `mongtory://calendar?year=YYYY&month=MM&date=YYYY-MM-DD` | `/calendar?year=YYYY&month=MM&date=YYYY-MM-DD` | 현재 Flutter 캘린더는 2026년 3월 고정이라 확장 필요 |
| 프로필 | `mongtory://profile` | `/profile` | 계정/설정 진입 후보 |

딥링크 처리 기본 규칙:
- 앱 세션이 없으면 로그인 화면으로 이동하고, 로그인 성공 후 원래 딥링크를 재개한다.
- 서버에서 대상 일기를 찾을 수 없거나 권한이 없으면 홈 또는 일기 목록으로 복귀하고 오류 메시지를 표시한다.
- 딥링크 query date는 `YYYY-MM-DD`, year/month는 정수로 제한한다.

## FE 후속 요청 후보
1. Flutter 딥링크 라우터 1차 구현
   - 담당: FE
   - 범위: `mobile-flutter/lib/core/router`, `presentation/screens`, navigation provider
   - 완료 기준: 위 딥링크 후보 중 홈, 작성, 상세, 캘린더 진입을 mock 모드 widget test로 확인

2. 앱 기반 위젯 요약 데이터 생성 설계
   - 담당: FE
   - 범위: `mobile-flutter/lib/application`, `data`, Android/iOS 공유 저장소 연동 방식 조사
   - 완료 기준: 로그인/CRUD/캘린더 갱신 후 `WidgetTodaySummary`를 생성할 수 있는 앱 내부 모델과 저장 책임 정리

3. Android/iOS 위젯 shell 기술 선택
   - 담당: FE
   - 범위: Android App Widget 또는 Glance, iOS WidgetKit, Flutter 플러그인 후보
   - 완료 기준: 네이티브 프로젝트 변경 파일 범위와 최소 위젯 렌더링 방식 결정

## BE 후속 요청 후보
1. 위젯 요약 API 후보 검토
   - 담당: BE
   - 후보 경로: `GET /api/v1/widgets/today-summary?date=YYYY-MM-DD`
   - 완료 기준: `WidgetTodaySummary`를 서버에서 직접 내려줄 필요가 있는지, 기존 일기/캘린더 API 조합으로 충분한지 결정

2. 연속 작성 일수 계산 API 설계
   - 담당: BE
   - 후보 경로: `GET /api/v1/users/me/streak`
   - 완료 기준: `streakDays`, `lastEntryDate` 계산 기준과 테스트 범위 확정

3. 날짜별 일기 조회 계약 검토
   - 담당: BE
   - 후보 경로: `GET /api/v1/diaries?from=YYYY-MM-DD&to=YYYY-MM-DD`
   - 완료 기준: 오늘 일기 조회를 기존 목록 API로 처리할지 전용 API를 둘지 결정

## 리스크와 보류 범위
- 네이티브 위젯 구현은 Android/iOS 프로젝트 설정과 서명, App Group, background refresh 제약이 있어 별도 작업으로 분리한다.
- iOS WidgetKit은 네트워크 직접 호출과 실시간 갱신 제약이 크므로 앱이 공유 저장소에 기록하는 구조를 우선 검증해야 한다.
- Android Glance 사용 여부는 현재 Flutter 프로젝트의 Android Gradle/Kotlin 설정과 충돌 가능성을 확인한 뒤 결정한다.
- 위젯 이미지 렌더링과 캐릭터 애니메이션은 MVP에서 보류한다. 우선 감정 코드, 텍스트, 앱 진입만 처리한다.
- 위젯 데이터에 실제 토큰, 이메일, 개인 인증 정보는 저장하지 않는다.

## 1차 권장 순서
1. QA `REQ-20260428-24`로 일기 CRUD 회귀 검증을 먼저 마친다.
2. FE `REQ-20260428-26` 결과와 맞춰 딥링크 route 후보를 앱 사용성 개선 범위에 반영한다.
3. BE `REQ-20260428-27`에서 위젯 요약 API와 연속 작성 일수 API 필요성을 같이 평가한다.
4. 이후 PM이 FE 딥링크 구현 요청과 BE 요약 API 요청을 실제 구현 단위로 분리한다.
