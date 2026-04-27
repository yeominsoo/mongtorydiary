# QA 요청 문서

## 목적
QA가 PM, FE 개발자, BE 개발자에게 요청하거나 이슈를 전달할 때 사용하는 문서다.

## 요청 목록
| 요청 ID | 우선순위 | 대상 역할 | 상태 | 제목 | 생성일 |
| --- | --- | --- | --- | --- | --- |
| QA-REQ-20260428-01 | P0 | PM | 완료 | `REQ-20260428-10`을 QA inbox에 반영 요청 | 2026-04-28 |
| QA-REQ-20260428-02 | P1 | BE | 완료 | 오류 응답/요청 검증 계약 보강 요청 | 2026-04-28 |

## 요청 상세
### QA-REQ-20260428-01
- 우선순위: P0
- 요청자: QA
- 대상 역할: PM
- 상태: 완료
- 요청 내용:
  - 공통 요청 인덱스에 등록된 `REQ-20260428-10` Flutter QA 자동화 하네스 1차 구축 요청을 `.ai-work/msyeo/docs/collaboration/roles/qa/inbox.md`에도 반영해달라.
  - 최신 협업 룰에 따라 QA는 공통 인덱스를 직접 수정하지 않고 역할별 문서에 먼저 기록한다.
- 완료 기준:
  - QA 수신함에 `REQ-20260428-10`이 추가됨
  - QA 현황에서 `REQ-20260428-10`을 진행중으로 전환할 수 있음
- 관련 파일/영역:
  - `.ai-work/msyeo/docs/collaboration/requests.md`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/inbox.md`
  - `.ai-work/msyeo/docs/collaboration/roles/qa/status.md`

### QA-REQ-20260428-02
- 우선순위: P1
- 요청자: QA
- 대상 역할: BE
- 상태: 완료
- 요청 내용:
  - `GlobalExceptionHandler`가 추가되어 주요 오류 응답은 `ApiResponse`로 감싸지지만, 아래 요청 검증 케이스는 계약과 테스트 보강이 필요하다.
  - `GET /api/v1/calendar`에서 `year` 또는 `month` query parameter가 누락된 경우 현재 별도 handler가 없다.
  - `GET /api/v1/calendar?year=2026&month=13`처럼 유효하지 않은 월 값은 `LocalDate.of` 단계에서 일반 예외로 처리될 수 있다.
  - malformed JSON body, 타입이 맞지 않는 JSON body가 400 `ApiResponse`로 내려가는지 확인이 필요하다.
- 2026-04-28 QA 재현 결과:
  - `GET /api/v1/calendar?month=3`: 500, `{"success":false,"message":"Internal server error","data":null}`
  - `GET /api/v1/calendar?year=2026`: 500, `{"success":false,"message":"Internal server error","data":null}`
  - `GET /api/v1/calendar?year=2026&month=13`: 500, `{"success":false,"message":"Internal server error","data":null}`
  - `GET /api/v1/calendar?year=abc&month=3`: 400, `{"success":false,"message":"Invalid request parameter","data":null}`
  - malformed JSON `POST /api/v1/diaries`: 500, `{"success":false,"message":"Internal server error","data":null}`
  - `imageUrls`를 문자열로 보낸 `POST /api/v1/diaries`: 500, `{"success":false,"message":"Internal server error","data":null}`
  - 빈 `title/content/emotionCode` `POST /api/v1/diaries`: 200 생성 허용. QA가 생성된 검증 레코드는 삭제 완료.
- 완료 기준:
  - 누락 query parameter가 400 계열 `ApiResponse<Void>`로 고정됨
  - 유효하지 않은 calendar year/month가 400 계열 `ApiResponse<Void>`로 고정됨
  - malformed JSON body 처리 기준이 테스트 또는 문서로 정리됨
  - Flutter `ApiClient`가 `success/message/data` 형태의 오류 body를 안정적으로 받을 수 있음
  - 빈 제목/본문/감정 코드 요청을 400 계열 오류로 거부하거나, 허용 정책이면 PM/QA에 명시적으로 계약을 공유함
- 관련 파일/영역:
  - `src/main/java/com/mongtory/diary/common/GlobalExceptionHandler.java`
  - `src/main/java/com/mongtory/diary/service/CalendarService.java`
  - `src/test/java/com/mongtory/diary/controller`

## 작성 템플릿
```text
### REQ-YYYYMMDD-NN
- 우선순위:
- 요청자: QA
- 대상 역할:
- 상태: 완료
- 요청 내용:
- 완료 기준:
- 관련 파일/영역:
```
