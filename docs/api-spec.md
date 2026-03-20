# API 및 DTO 초안

## 목적
이 문서는 Spring Boot 백엔드와 Flutter 앱이 함께 참조할 최소 API 계약 초안이다. 현재 목표는 MVP 범위의 인증, 일기 CRUD, 감정 스티커, 캘린더 조회를 안정적으로 정의하는 것이다.

## 공통 응답 규칙
모든 API 응답은 `ApiResponse<T>` 형태를 따른다.

```json
{
  "success": true,
  "message": "OK",
  "data": {}
}
```

에러 응답 예시:

```json
{
  "success": false,
  "message": "Diary entry not found",
  "data": null
}
```

## 핵심 DTO
### UserSummary
```json
{
  "id": 1,
  "email": "user@example.com",
  "nickname": "몽토리유저"
}
```

### AuthTokenResponse
```json
{
  "accessToken": "jwt-access-token",
  "refreshToken": "jwt-refresh-token",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "nickname": "몽토리유저"
  }
}
```

### EmotionType
```json
{
  "code": "HAPPY",
  "label": "행복",
  "iconKey": "mongtory_happy"
}
```

### DiarySummary
```json
{
  "id": 101,
  "entryDate": "2026-03-19",
  "title": "오늘의 기록",
  "emotionCode": "CALM",
  "thumbnailUrl": null,
  "createdAt": "2026-03-19T09:00:00",
  "updatedAt": "2026-03-19T09:10:00"
}
```

### DiaryDetail
```json
{
  "id": 101,
  "entryDate": "2026-03-19",
  "title": "오늘의 기록",
  "content": "몽토리와 함께 산책을 했다.",
  "emotionCode": "CALM",
  "imageUrls": [],
  "createdAt": "2026-03-19T09:00:00",
  "updatedAt": "2026-03-19T09:10:00"
}
```

### CalendarDaySummary
```json
{
  "date": "2026-03-19",
  "hasEntry": true,
  "emotionCode": "CALM",
  "entryCount": 1
}
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

## 인증 API
### 회원가입
- `POST /api/v1/auth/signup`

요청:
```json
{
  "email": "user@example.com",
  "password": "password123!",
  "nickname": "몽토리유저"
}
```

응답:
- `ApiResponse<AuthTokenResponse>`

### 로그인
- `POST /api/v1/auth/login`

요청:
```json
{
  "email": "user@example.com",
  "password": "password123!"
}
```

응답:
- `ApiResponse<AuthTokenResponse>`

### 토큰 재발급
- `POST /api/v1/auth/refresh`

요청:
```json
{
  "refreshToken": "jwt-refresh-token"
}
```

응답:
- `ApiResponse<AuthTokenResponse>`

## 감정 API
### 감정 목록 조회
- `GET /api/v1/emotions`

응답:
- `ApiResponse<List<EmotionType>>`

## 일기 API
### 일기 목록 조회
- `GET /api/v1/diaries?from=2026-03-01&to=2026-03-31&emotion=CALM`

응답:
- `ApiResponse<List<DiarySummary>>`

### 일기 상세 조회
- `GET /api/v1/diaries/{diaryId}`

응답:
- `ApiResponse<DiaryDetail>`

### 일기 생성
- `POST /api/v1/diaries`

요청:
```json
{
  "entryDate": "2026-03-19",
  "title": "오늘의 기록",
  "content": "몽토리와 함께 산책을 했다.",
  "emotionCode": "CALM",
  "imageUrls": []
}
```

응답:
- `ApiResponse<DiaryDetail>`

### 일기 수정
- `PUT /api/v1/diaries/{diaryId}`

요청:
```json
{
  "title": "수정된 제목",
  "content": "수정된 내용",
  "emotionCode": "HAPPY",
  "imageUrls": []
}
```

응답:
- `ApiResponse<DiaryDetail>`

### 일기 삭제
- `DELETE /api/v1/diaries/{diaryId}`

응답:
- `ApiResponse<Void>`

## 캘린더 API
### 월간 캘린더 조회
- `GET /api/v1/calendar?year=2026&month=3`

응답:
- `ApiResponse<CalendarMonthResponse>`

## 위젯 관점 최소 데이터
위젯은 아래 데이터만 우선 참조한다.

- 오늘 일기 작성 여부
- 오늘 감정 코드
- 최근 연속 작성 일수
- 한 줄 메시지

이 값은 추후 별도 위젯 요약 API 또는 앱 로컬 저장소 캐시로 제공할 수 있다.

## 다음 작업
- 백엔드 패키지 구조에 맞춰 Request/Response DTO 클래스로 분해
- Flutter `domain` 모델과 `data` DTO 매핑 초안 작성
- 인증 예외, 검증 규칙, 이미지 업로드 API 추가 정의
