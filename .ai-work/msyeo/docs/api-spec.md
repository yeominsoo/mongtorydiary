# API 및 DTO 초안

## 목적
이 문서는 Spring Boot 백엔드와 Flutter 앱이 함께 참조할 최소 API 계약 초안이다. 현재 목표는 MVP 범위의 인증, 일기 CRUD, TODO, 감정 스티커, 캘린더 조회를 안정적으로 정의하는 것이다.

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
  "accessToken": "access-uuid",
  "refreshToken": "refresh-uuid",
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
  "locationName": "동네 공원",
  "weatherSummary": "맑음",
  "tags": ["산책", "회고"],
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
  "locationName": "동네 공원",
  "weatherSummary": "맑음",
  "tags": ["산책", "회고"],
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
  "entryCount": 1,
  "todoCount": 2,
  "completedTodoCount": 1
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
      "entryCount": 1,
      "todoCount": 2,
      "completedTodoCount": 1
    }
  ]
}
```

### TodoItem
```json
{
  "id": 201,
  "dueDate": "2026-03-19",
  "content": "출품용 캘린더 TODO 점검",
  "completed": false,
  "createdAt": "2026-03-19T09:00:00",
  "updatedAt": "2026-03-19T09:00:00"
}
```

### TodoUpsert
```json
{
  "dueDate": "2026-03-19",
  "content": "출품용 캘린더 TODO 점검",
  "completed": false
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

현재 백엔드 토큰은 JWT가 아니라 `UserAccount` 테이블에 저장되는 임시 문자열이다. access token은 `Authorization: Bearer <token>` 헤더로 일기/캘린더 API에서 사용한다.

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
- `GET /api/v1/diaries?from=2026-03-01&to=2026-03-31&emotion=CALM&query=산책&tag=회고`

query parameters:
- `from`, `to`: 선택 날짜 범위
- `emotion`: 선택 감정 코드
- `query`: 선택 검색어. 제목, 본문, 태그, 장소, 날씨를 대상으로 한다.
- `tag`: 선택 태그. `#` prefix는 서버에서 제거한다.

응답:
- `ApiResponse<List<DiarySummary>>`

### 지난 오늘 조회
- `GET /api/v1/diaries/memories?month=5&day=21`

응답:
- `ApiResponse<List<DiarySummary>>`
- 현재 연도보다 이전 연도의 같은 월/일 일기만 반환한다.

### 일기 이미지 업로드
- `POST /api/v1/diary-images`
- `Content-Type: multipart/form-data`
- `Authorization: Bearer <accessToken>`

요청:
- form field `file`: 이미지 파일. 현재 허용 확장자는 `jpg`, `jpeg`, `png`, `webp`, `gif`이며 최대 5MB다.

응답:
```json
{
  "url": "http://localhost:30080/uploads/diary/1/uuid.png",
  "originalFilename": "walk.png",
  "contentType": "image/png",
  "size": 102400
}
```

업로드 응답의 `url`을 일기 생성/수정 요청의 `imageUrls`에 포함해 사진 첨부로 사용한다. 로컬 개발 저장 경로는 `mongtory.upload.root-dir` 설정을 따른다.

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
  "imageUrls": [],
  "locationName": "동네 공원",
  "weatherSummary": "맑음",
  "tags": ["산책", "회고"]
}
```

응답:
- `ApiResponse<DiaryDetail>`

### 일기 수정
- `PUT /api/v1/diaries/{diaryId}`

요청:
```json
{
  "entryDate": "2026-03-19",
  "title": "수정된 제목",
  "content": "수정된 내용",
  "emotionCode": "HAPPY",
  "imageUrls": [],
  "locationName": "한강 공원",
  "weatherSummary": "흐림",
  "tags": ["수정", "회고"]
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

현재 응답의 `days`에는 일기 또는 TODO가 있는 날짜만 포함된다. 빈 날짜 전체를 내려주는 월간 그리드 응답은 아직 구현되어 있지 않으며, Flutter 앱은 월 정보를 바탕으로 빈 날짜 셀을 클라이언트에서 생성한다.

## TODO API
TODO API는 access token 기준 현재 사용자 데이터만 조회/변경한다.

### TODO 목록 조회
- `GET /api/v1/todos?from=2026-03-01&to=2026-03-31`

응답:
- `ApiResponse<List<TodoItem>>`

`from`과 `to`를 생략하면 오늘 하루 기준으로 조회한다. `to`가 `from`보다 이전이면 400 오류를 반환한다.

### TODO 생성
- `POST /api/v1/todos`

요청:
```json
{
  "dueDate": "2026-03-19",
  "content": "달력에서 할 일 남기기",
  "completed": false
}
```

응답:
- `ApiResponse<TodoItem>`

### TODO 수정
- `PUT /api/v1/todos/{todoId}`

요청:
```json
{
  "dueDate": "2026-03-19",
  "content": "달력에서 할 일 완료 처리하기",
  "completed": true
}
```

응답:
- `ApiResponse<TodoItem>`

### TODO 삭제
- `DELETE /api/v1/todos/{todoId}`

응답:
- `ApiResponse<Void>`

## 위젯 관점 최소 데이터
위젯은 아래 데이터만 우선 참조한다.

- 오늘 일기 작성 여부
- 오늘 감정 코드
- 최근 연속 작성 일수
- 한 줄 메시지

이 값은 추후 별도 위젯 요약 API 또는 앱 로컬 저장소 캐시로 제공할 수 있다.

## 다음 작업
- Flutter 딥링크 route와 위젯 요약 데이터 앱 연동 계약 추가 정의
- 작성 리마인더를 OS 알림으로 확장할 경우 Android/iOS 권한, 스케줄링, 저장 경계 정의
- 운영 전 PostgreSQL schema migration과 업로드 파일 보존/삭제 정책 정의
