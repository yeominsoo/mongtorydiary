# 사용성 개선용 API 후보 설계

## 목적
BE `REQ-20260428-27` 기준으로 Flutter 앱 사용성을 높이는 백엔드 API 후보를 비교하고, 다음 구현 요청으로 분리할 1순위 후보를 정리한다. 현재 구현은 설계 단계이며, 소스 코드는 변경하지 않는다.

## 현재 API 기준
- 일기 목록 API `GET /api/v1/diaries`는 이미 `from`, `to`, `emotion` 선택 쿼리를 지원한다.
- 캘린더 API `GET /api/v1/calendar?year=&month=`는 기록이 있는 날짜 요약만 반환한다.
- 감정 목록 API `GET /api/v1/emotions`는 인증 없이 감정 코드 목록을 반환한다.
- 위젯/딥링크 설계에서는 오늘 작성 여부, 오늘 감정, 오늘 일기 진입, 연속 작성 일수, 최근 작성일이 필요하다.

## 후보 1: 오늘/위젯 요약 API
### 제안 경로
`GET /api/v1/widgets/today-summary?date=YYYY-MM-DD`

### 목적
홈 화면, 프로필 요약, Android/iOS 위젯이 같은 기준으로 오늘의 기록 상태와 연속 작성 정보를 표시할 수 있게 한다.

### 응답 초안
```json
{
  "date": "2026-04-28",
  "hasTodayEntry": true,
  "todayEntryCount": 2,
  "latestDiaryId": 101,
  "latestDiaryTitle": "오늘의 기록",
  "latestEmotionCode": "CALM",
  "streakDays": 3,
  "lastEntryDate": "2026-04-28",
  "message": "오늘도 몽토리와 기록했어요.",
  "updatedAt": "2026-04-28T08:00:00"
}
```

### DTO/모델 변경
- `WidgetTodaySummaryResponse` 신규 DTO가 필요하다.
- 새 엔티티는 필요 없다.
- `DiaryEntryRepository`에는 owner 기준 날짜 조회와 최근 작성일 조회를 위한 쿼리 메서드가 필요하다.

### 테스트 범위
- 오늘 일기가 없는 경우 `hasTodayEntry=false`, `todayEntryCount=0`, 최신 일기 필드 `null`.
- 오늘 일기가 여러 건이면 최신 수정 일기 기준으로 `latestDiaryId/title/emotionCode`를 선택한다.
- 연속 작성 일수는 날짜별 1건 이상이면 하루로 계산한다.
- 타 사용자 일기는 집계에서 제외한다.
- 인증 누락/invalid token은 기존 `ApiResponse` 오류 계약을 따른다.

### 평가
- 장점: 위젯, 홈 요약, 프로필 streak에 바로 재사용 가능하다.
- 리스크: 연속 작성 일수 계산 기준을 명확히 해야 한다.
- 우선순위: P1

## 후보 2: 월간 감정 통계 API
### 제안 경로
`GET /api/v1/statistics/emotions/monthly?year=YYYY&month=M`

### 목적
캘린더와 프로필에서 월간 감정 분포, 작성 일수, 주요 감정을 보여준다.

### 응답 초안
```json
{
  "year": 2026,
  "month": 4,
  "totalEntryCount": 8,
  "activeDayCount": 6,
  "dominantEmotionCode": "CALM",
  "emotionCounts": [
    {
      "emotionCode": "CALM",
      "count": 4
    }
  ]
}
```

### DTO/모델 변경
- `MonthlyEmotionStatsResponse`, `EmotionCountResponse` 신규 DTO가 필요하다.
- 새 엔티티는 필요 없다.

### 테스트 범위
- 해당 월 작성 건수가 없는 경우 빈 카운트와 `dominantEmotionCode=null`.
- 동일 날짜 다건 일기는 `totalEntryCount`에는 모두 반영하고 `activeDayCount`에는 날짜 1개로 반영한다.
- 잘못된 `month`는 `REQ-20260428-22`와 동일하게 400으로 처리한다.

### 평가
- 장점: 캘린더/프로필 사용성을 높인다.
- 리스크: 위젯 1차 범위에는 오늘 요약보다 직접성이 낮다.
- 우선순위: P2

## 후보 3: 일기 검색/필터 확장
### 제안 경로
기존 `GET /api/v1/diaries` 확장

```text
GET /api/v1/diaries?from=2026-04-01&to=2026-04-30&emotion=CALM&q=산책
```

### 목적
제목/본문 검색과 기존 날짜/감정 필터를 한 API에서 처리한다.

### DTO/모델 변경
- 응답 DTO 변경은 필요 없다.
- `q` query parameter만 추가한다.
- 데이터가 많아지면 `page`, `size`, `sort`를 별도 요청으로 확장한다.

### 테스트 범위
- 제목 검색, 본문 검색, 날짜+감정+검색어 조합.
- 빈 검색어는 필터 미적용.
- 타 사용자 일기 제외.

### 평가
- 장점: 구현 비용이 낮고 앱 검색 UX로 확장하기 쉽다.
- 리스크: 현재 SQLite와 단순 contains 검색 기준으로 시작해야 하며, 전문 검색은 후속이다.
- 우선순위: P2

## 후보 4: 날짜별 일기 조회 계약 명시
### 제안 경로
기존 API 사용을 공식화한다.

```text
GET /api/v1/diaries?from=YYYY-MM-DD&to=YYYY-MM-DD
```

### 목적
캘린더 날짜 탭 UX에서 특정 날짜 일기 목록을 서버 기준으로 안정적으로 가져온다.

### DTO/모델 변경
- 변경 없음.
- `api-contract.md`에 날짜별 조회 사용 예시를 보강하면 충분하다.

### 테스트 범위
- 같은 날짜 다건 일기 목록 반환.
- 날짜 범위 밖 일기 제외.
- 정렬 기준 최신순 유지.

### 평가
- 장점: 신규 API 없이 FE가 즉시 사용할 수 있다.
- 리스크: 대량 목록/페이징이 도입되면 별도 날짜별 조회 최적화가 필요할 수 있다.
- 우선순위: P1 문서 보강, 구현 변경 없음

## 후보 5: 이미지 업로드 준비 API
### 제안 경로
보류. 스토리지 결정 후 아래 형태를 검토한다.

```text
POST /api/v1/uploads/images/presign
```

### 평가
- 현재 `imageUrls`는 클라이언트가 URL 문자열을 직접 전달하는 구조다.
- S3, 로컬 스토리지, 외부 이미지 정책이 정해지지 않아 지금 구현하면 폐기 가능성이 높다.
- 우선순위: P3

## 후보 6: 토큰 만료/갱신 전략 고도화
### 제안 경로
기존 `POST /api/v1/auth/refresh` 유지, 토큰 정책만 고도화한다.

### 평가
- 현재 access/refresh token은 DB 저장 임시 UUID 문자열이다.
- 실제 만료 시간, 재발급 회전, 로그아웃, 세션 저장 UX가 아직 없다.
- 앱 안정성에는 중요하지만 위젯/캘린더 사용성보다 인증 기반 작업으로 별도 요청이 적절하다.
- 우선순위: P2 별도 인증 요청

## 1순위 구현 요청 후보
### 권장 요청
BE 신규 요청: 오늘/위젯 요약 API 구현

### 권장 이유
- 위젯/딥링크 1차 설계의 핵심 데이터인 오늘 작성 여부, 오늘 일기 진입 대상, 연속 작성 일수를 한 번에 제공한다.
- Flutter 홈/프로필에도 재사용할 수 있어 위젯 구현 전에도 앱 사용성이 올라간다.
- 기존 일기/캘린더 API 조합만으로는 `streakDays`와 `lastEntryDate` 계산을 클라이언트가 직접 해야 하므로 중복과 불일치 위험이 있다.

### 완료 기준 초안
- `GET /api/v1/widgets/today-summary?date=YYYY-MM-DD` 구현
- 인증 사용자 소유 일기만 집계
- 동일 날짜 다건 일기 기준 최신 수정 일기를 `latest*` 필드로 선택
- 연속 작성 일수 계산 기준 테스트 포함
- Maven 테스트 통과
- QA 실제 서버 curl 검증 요청 분리

## PM/FE/QA 후속 요청 제안
- PM: 위 후보 중 `오늘/위젯 요약 API`를 실제 구현 요청 ID로 분리한다.
- FE: 날짜별 일기 조회는 기존 `GET /api/v1/diaries?from=date&to=date` 계약을 우선 사용하도록 remote datasource 개선 후보로 둔다.
- QA: 오늘/위젯 요약 API 구현 후 today entry 없음/1건/다건/streak/invalid token 케이스를 회귀 검증한다.
