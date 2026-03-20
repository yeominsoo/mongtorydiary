# API/DTO 초안

## 목적
이 문서는 Spring Boot 백엔드와 Flutter 앱이 공통으로 참조할 초기 API 계약 초안이다. 현재 단계에서는 MVP 범위의 인증, 일기, 감정, 캘린더 데이터를 우선 정의한다.

## 공통 응답 형식
모든 응답은 아래 구조를 따른다.

```json
{
  "success": true,
  "message": "OK",
  "data": {}
}
```

## 인증
### POST `/api/v1/auth/sign-up`
- 요청: `SignUpRequest`
- 응답: `ApiResponse<AuthSessionResponse>`

### POST `/api/v1/auth/sign-in`
- 요청: `SignInRequest`
- 응답: `ApiResponse<AuthSessionResponse>`

### POST `/api/v1/auth/refresh`
- 요청: `RefreshTokenRequest`
- 응답: `ApiResponse<AuthSessionResponse>`

## 일기
### GET `/api/v1/diaries`
- 설명: 최근 일기 목록 조회
- 쿼리: `page`, `size`
- 응답: `ApiResponse<List<DiarySummaryResponse>>`

### GET `/api/v1/diaries/{diaryId}`
- 설명: 일기 상세 조회
- 응답: `ApiResponse<DiaryDetailResponse>`

### POST `/api/v1/diaries`
- 설명: 일기 작성
- 요청: `CreateDiaryRequest`
- 응답: `ApiResponse<DiaryDetailResponse>`

### PUT `/api/v1/diaries/{diaryId}`
- 설명: 일기 수정
- 요청: `UpdateDiaryRequest`
- 응답: `ApiResponse<DiaryDetailResponse>`

### DELETE `/api/v1/diaries/{diaryId}`
- 설명: 일기 삭제
- 응답: `ApiResponse<Void>`

## 감정
### GET `/api/v1/emotions`
- 설명: 사용 가능한 감정 스티커 목록
- 응답: `ApiResponse<List<EmotionResponse>>`

## 캘린더
### GET `/api/v1/calendar/monthly`
- 설명: 월간 캘린더 요약 조회
- 쿼리: `year`, `month`
- 응답: `ApiResponse<CalendarMonthResponse>`

## 주요 DTO 초안
### SignUpRequest
```json
{
  "email": "user@example.com",
  "password": "string",
  "nickname": "몽토리"
}
```

### SignInRequest
```json
{
  "email": "user@example.com",
  "password": "string"
}
```

### AuthSessionResponse
```json
{
  "userId": 1,
  "nickname": "몽토리",
  "accessToken": "token",
  "refreshToken": "refresh-token"
}
```

### CreateDiaryRequest
```json
{
  "title": "오늘의 기록",
  "content": "몽토리와 함께한 하루",
  "entryDate": "2026-03-19",
  "emotionCode": "HAPPY",
  "imageUrls": [
    "https://example.com/image1.jpg"
  ]
}
```

### DiarySummaryResponse
```json
{
  "diaryId": 10,
  "title": "오늘의 기록",
  "entryDate": "2026-03-19",
  "emotionCode": "HAPPY",
  "thumbnailUrl": "https://example.com/thumb.jpg"
}
```

### DiaryDetailResponse
```json
{
  "diaryId": 10,
  "title": "오늘의 기록",
  "content": "몽토리와 함께한 하루",
  "entryDate": "2026-03-19",
  "emotionCode": "HAPPY",
  "imageUrls": [
    "https://example.com/image1.jpg"
  ],
  "createdAt": "2026-03-19T10:00:00",
  "updatedAt": "2026-03-19T10:10:00"
}
```

### EmotionResponse
```json
{
  "code": "HAPPY",
  "label": "기뻐요",
  "iconUrl": "https://example.com/emotions/happy.png"
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
      "hasDiary": true,
      "emotionCode": "HAPPY"
    }
  ]
}
```
