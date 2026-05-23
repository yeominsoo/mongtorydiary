# API/DTO 계약 현황

## 목적
이 문서는 현재 소스 코드 기준으로 Spring Boot 백엔드와 Flutter 앱이 실제로 맞물리는 API 계약을 정리한다. 과거 초안의 `sign-up`, `sign-in`, `/calendar/monthly` 경로는 현재 코드와 다르므로 사용하지 않는다.

## 공통 응답 형식
모든 백엔드 컨트롤러는 `ApiResponse<T>`를 반환한다.

```json
{
  "success": true,
  "message": "OK",
  "data": {}
}
```

현재 `ApiResponse`에는 성공 응답 헬퍼와 오류 응답 헬퍼가 있다. `GlobalExceptionHandler`가 추가되어 `ResponseStatusException`, `MissingRequestHeaderException`, `MethodArgumentTypeMismatchException`, 그 외 일반 예외를 `ApiResponse<Void>` 형태로 감싼다.

다만 누락된 query parameter, malformed JSON body, 캘린더의 유효하지 않은 `year/month`처럼 세부 요청 검증 케이스는 아직 별도 계약으로 고정되지 않았다. Flutter `ApiClient`는 오류 body도 `ApiResponse` JSON이라고 가정하므로, 백엔드 오류 응답은 계속 `success/message/data` 형태를 유지해야 한다.

## 인증 API
### POST `/api/v1/auth/signup`
- 설명: 회원가입 후 임시 access/refresh token 발급
- 요청 DTO: `SignupRequest`
- 응답 DTO: `ApiResponse<AuthTokenResponse>`

요청:
```json
{
  "email": "user@example.com",
  "password": "password123!",
  "nickname": "몽토리유저"
}
```

### POST `/api/v1/auth/login`
- 설명: 이메일/비밀번호 로그인 후 임시 access/refresh token 발급
- 요청 DTO: `LoginRequest`
- 응답 DTO: `ApiResponse<AuthTokenResponse>`

요청:
```json
{
  "email": "user@example.com",
  "password": "password123!"
}
```

### POST `/api/v1/auth/refresh`
- 설명: refresh token으로 새 access/refresh token 발급
- 요청 DTO: `RefreshTokenRequest`
- 응답 DTO: `ApiResponse<AuthTokenResponse>`

요청:
```json
{
  "refreshToken": "refresh-token"
}
```

### AuthTokenResponse
```json
{
  "accessToken": "access-uuid",
  "refreshToken": "refresh-uuid",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "nickname": "몽토리유저"
  }
}
```

현재 토큰은 JWT가 아니라 DB에 저장하는 임시 문자열이다. `access-`, `refresh-` prefix와 UUID를 조합해 생성한다.

## 인증 헤더
일기와 캘린더 API는 아래 헤더가 필요하다.

```http
Authorization: Bearer <accessToken>
```

백엔드는 access token으로 `UserAccount`를 조회한다. Spring Security 필터 체인은 아직 없다.

## 일기 API
### GET `/api/v1/diaries`
- 설명: 현재 사용자 일기 목록 조회
- 선택 쿼리: `from`, `to`, `emotion`
- 응답 DTO: `ApiResponse<List<DiarySummaryResponse>>`

예시:
```text
GET /api/v1/diaries?from=2026-03-01&to=2026-03-31&emotion=CALM
```

### GET `/api/v1/diaries/{diaryId}`
- 설명: 현재 사용자 소유 일기 상세 조회
- 응답 DTO: `ApiResponse<DiaryDetailResponse>`

### POST `/api/v1/diaries`
- 설명: 현재 사용자 일기 생성
- 요청 DTO: `DiaryUpsertRequest`
- 응답 DTO: `ApiResponse<DiaryDetailResponse>`

요청:
```json
{
  "entryDate": "2026-03-19",
  "title": "오늘의 기록",
  "content": "몽토리와 함께한 하루",
  "emotionCode": "CALM",
  "imageUrls": []
}
```

### PUT `/api/v1/diaries/{diaryId}`
- 설명: 현재 사용자 소유 일기 수정
- 요청 DTO: `DiaryUpsertRequest`
- 응답 DTO: `ApiResponse<DiaryDetailResponse>`

### DELETE `/api/v1/diaries/{diaryId}`
- 설명: 현재 사용자 소유 일기 삭제
- 응답 DTO: `ApiResponse<Void>`

## 일기 DTO
### DiarySummaryResponse
```json
{
  "id": 10,
  "entryDate": "2026-03-19",
  "title": "오늘의 기록",
  "emotionCode": "CALM",
  "thumbnailUrl": null,
  "createdAt": "2026-03-19T10:00:00",
  "updatedAt": "2026-03-19T10:10:00"
}
```

### DiaryDetailResponse
```json
{
  "id": 10,
  "entryDate": "2026-03-19",
  "title": "오늘의 기록",
  "content": "몽토리와 함께한 하루",
  "emotionCode": "CALM",
  "imageUrls": [],
  "createdAt": "2026-03-19T10:00:00",
  "updatedAt": "2026-03-19T10:10:00"
}
```

## 감정 API
### GET `/api/v1/emotions`
- 설명: 사용 가능한 감정 타입 목록 조회
- 인증: 현재 코드 기준 불필요
- 응답 DTO: `ApiResponse<List<EmotionTypeResponse>>`

### EmotionTypeResponse
```json
{
  "code": "HAPPY",
  "label": "행복",
  "iconKey": "mongtory_happy"
}
```

## 캘린더 API
### GET `/api/v1/calendar`
- 설명: 현재 사용자 월간 캘린더 요약 조회
- 필수 쿼리: `year`, `month`
- 응답 DTO: `ApiResponse<CalendarMonthResponse>`

예시:
```text
GET /api/v1/calendar?year=2026&month=3
```

### CalendarMonthResponse
```json
{
  "year": 2026,
  "month": 3,
  "days": [
    {
      "date": "2026-03-19",
      "hasEntry": true,
      "emotionCode": "CALM",
      "entryCount": 1
    }
  ]
}
```

현재 캘린더 응답은 기록이 있는 날짜만 `days`에 포함한다. 빈 날짜 전체를 채우는 월간 그리드 API는 아직 없다.

## 위젯/요약 API
### GET `/api/v1/widgets/today-summary`
- 설명: 현재 사용자 기준 지정일의 위젯/홈 요약 정보 조회
- 필수 쿼리: `date`
- 인증: 필요
- 응답 DTO: `ApiResponse<WidgetTodaySummaryResponse>`

예시:
```text
GET /api/v1/widgets/today-summary?date=2026-04-28
```

### WidgetTodaySummaryResponse
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
  "updatedAt": "2026-04-28T19:46:00"
}
```

동일 날짜에 여러 일기가 있으면 `todayEntryCount`에는 해당 날짜 전체 건수를 넣고, `latestDiaryId/latestDiaryTitle/latestEmotionCode`는 `updatedAt`이 가장 최신인 일기 기준으로 채운다. `streakDays`는 요청일 또는 그 이전 마지막 작성일을 기준으로 연속 작성 날짜 수를 계산한다.

## Flutter 연동 현황
Flutter remote datasource가 실제 사용하는 API는 아래 범위다.
- 로그인: `POST /api/v1/auth/login`
- 일기 목록: `GET /api/v1/diaries`
- 일기 상세: `GET /api/v1/diaries/{diaryId}`
- 캘린더: `GET /api/v1/calendar?year=2026&month=3`
- 감정 목록: `GET /api/v1/emotions`
- 위젯/요약: `GET /api/v1/widgets/today-summary?date=YYYY-MM-DD`

Flutter repository 계약에는 아직 회원가입, 토큰 재발급, 일기 생성/수정/삭제 메서드가 없다. 화면은 로그인 입력 폼, 일기 목록/상세, 캘린더/프로필 요약 표시 중심이다.
