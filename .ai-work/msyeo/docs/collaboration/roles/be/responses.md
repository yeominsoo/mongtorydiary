# BE 응답 문서

## 응답 목록
| 응답 ID | 요청 ID | 상태 | 요약 | 작성일 |
| --- | --- | --- | --- | --- |
| RES-REQ-20260428-04 | REQ-20260428-04 | 완료 | 인증/소유권 검증 테스트 보강 및 Maven 테스트 통과 | 2026-04-28 |
| RES-REQ-20260428-08 | REQ-20260428-08 | 완료 | 전역 예외 응답 ApiResponse 표준화 및 Maven 테스트 통과 | 2026-04-28 |
| RES-REQ-20260428-22 | REQ-20260428-22 | 완료 | API 검증 오류 계약 보강 및 Maven/QA 검증 통과 | 2026-04-28 |
| RES-REQ-20260428-27 | REQ-20260428-27 | 완료 | 사용성 개선용 API 후보 설계와 1순위 구현 후보 선정 | 2026-04-28 |
| RES-REQ-20260428-34 | REQ-20260428-34 | 완료 | 오늘/위젯 요약 API 구현 및 Maven 테스트 통과 | 2026-04-28 |

## 응답 상세
### RES-REQ-20260428-34
- 요청 ID: REQ-20260428-34
- 담당 역할: BE
- 상태: 완료
- 요약:
  - `GET /api/v1/widgets/today-summary?date=YYYY-MM-DD` API를 추가했다.
  - 응답에는 지정일 작성 여부, 지정일 일기 수, 최신 일기 id/title/emotionCode, streakDays, lastEntryDate, message, updatedAt을 포함한다.
  - 동일 날짜 다건은 `updatedAt`이 가장 최신인 일기를 대표 일기로 선택한다.
  - streak는 요청일 또는 그 이전 마지막 작성일 기준으로 연속 작성 날짜 수를 계산한다.
- 변경 파일:
  - `src/main/java/com/mongtory/diary/controller/WidgetController.java`
  - `src/main/java/com/mongtory/diary/dto/widget/WidgetTodaySummaryResponse.java`
  - `src/main/java/com/mongtory/diary/service/WidgetSummaryService.java`
  - `src/main/java/com/mongtory/diary/repository/DiaryEntryRepository.java`
  - `src/test/java/com/mongtory/diary/controller/WidgetControllerTest.java`
  - `.ai-work/msyeo/docs/api-contract.md`
- 검증:
  - `JAVA_HOME=/usr/lib/jvm/java-21-openjdk bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test`
  - 결과: `BUILD SUCCESS`, tests run 19, failures 0, errors 0, skipped 0
- 남은 이슈:
  - 실제 서버 curl 검증은 QA 후속 요청에서 수행하면 된다.
  - Flutter remote datasource 연동은 아직 하지 않았다.
- 다음 제안:
  - QA는 today entry 없음/1건/다건/streak/invalid token을 실제 서버 기준으로 검증한다.
  - FE는 위젯/홈 요약 DTO를 remote datasource에 연결하는 후속 요청을 받으면 된다.

### RES-REQ-20260428-27
- 요청 ID: REQ-20260428-27
- 담당 역할: BE
- 상태: 완료
- 요약:
  - 사용성 개선용 API 후보 6개를 비교했다.
  - 날짜별 일기 조회는 기존 `GET /api/v1/diaries?from=YYYY-MM-DD&to=YYYY-MM-DD`로 우선 처리 가능하다고 판단했다.
  - 1순위 구현 후보는 위젯/홈/프로필에서 재사용 가능한 `GET /api/v1/widgets/today-summary?date=YYYY-MM-DD` 오늘/위젯 요약 API로 선정했다.
- 변경 파일:
  - `.ai-work/msyeo/docs/api-usability-improvement-plan.md`
  - `.ai-work/msyeo/docs/collaboration/roles/be/inbox.md`
  - `.ai-work/msyeo/docs/collaboration/roles/be/status.md`
  - `.ai-work/msyeo/docs/collaboration/roles/be/responses.md`
- 검증:
  - 설계 문서 작업이라 백엔드/Flutter 테스트는 실행하지 않았다.
- 남은 이슈:
  - 실제 구현 요청 ID는 PM이 별도로 분리해야 한다.
  - 오늘/위젯 요약 API 구현 시 streak 계산 기준과 동일 날짜 다건 처리 기준을 테스트로 고정해야 한다.
- 다음 제안:
  - PM은 오늘/위젯 요약 API 구현 요청을 BE에 새 ID로 배정한다.
  - QA는 구현 후 today entry 없음/1건/다건/streak/invalid token 케이스를 검증한다.

### RES-REQ-20260428-22
- 요청 ID: REQ-20260428-22
- 담당 역할: BE
- 상태: 완료
- 요약:
  - 누락 query parameter를 400 `ApiResponse`로 응답하도록 `MissingServletRequestParameterException` 처리를 추가했다.
  - malformed JSON과 request body 타입 불일치를 400 `Invalid request body`로 응답하도록 처리했다.
  - calendar `month`가 1~12 범위를 벗어나면 400 `Invalid calendar month`로 응답하도록 검증했다.
  - 일기 생성/수정의 `entryDate`, `title`, `content`, `emotionCode` 필수값 검증을 추가하고 저장 전 문자열을 trim하도록 했다.
- 변경 파일:
  - `src/main/java/com/mongtory/diary/common/GlobalExceptionHandler.java`
  - `src/main/java/com/mongtory/diary/service/CalendarService.java`
  - `src/main/java/com/mongtory/diary/service/DiaryService.java`
  - `src/test/java/com/mongtory/diary/controller/CalendarControllerTest.java`
  - `src/test/java/com/mongtory/diary/controller/DiaryControllerTest.java`
- 검증:
  - `JAVA_HOME=/usr/lib/jvm/java-21-openjdk bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test`
  - 결과: `BUILD SUCCESS`, tests run 16, failures 0, errors 0, skipped 0
  - 참고: `JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64` 경로는 현재 환경에 없어 실행 실패했고, 설치된 OpenJDK 21로 재실행했다.
- 남은 이슈:
  - QA `REQ-20260428-29`에서 실제 서버 curl 재검증을 완료했다.
  - 오류 메시지는 현재 영어 고정 문자열이다. 앱 사용자 노출 문구는 FE/PM UX 기준에서 별도 정리할 수 있다.
- 다음 제안:
  - BE는 후속 `REQ-20260428-27` 사용성 개선용 API 후보 설계에 착수할 수 있다.

### RES-REQ-20260428-04
- 요청 ID: REQ-20260428-04
- 담당 역할: BE
- 상태: 완료
- 요약:
  - 로그인 실패, 회원가입 토큰 발급, refresh token 재발급 테스트를 추가했다.
  - invalid access token 거부와 타 사용자 일기 상세 접근 차단 테스트를 추가했다.
  - 일기 목록 테스트를 첫 항목 고정이 아니라 시드 일기 포함 여부 기준으로 안정화했다.
  - 사용자 시드 후 일기 시드가 생성되도록 `UserDataInitializer`와 `DiaryDataInitializer` 실행 순서를 고정했다.
- 변경 파일:
  - `src/main/java/com/mongtory/diary/config/UserDataInitializer.java`
  - `src/main/java/com/mongtory/diary/config/DiaryDataInitializer.java`
  - `src/test/java/com/mongtory/diary/controller/AuthControllerTest.java`
  - `src/test/java/com/mongtory/diary/controller/DiaryControllerTest.java`
- 검증:
  - `bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test`
  - 결과: `BUILD SUCCESS`, tests run 8, failures 0, errors 0, skipped 0
- 남은 이슈:
  - 전역 예외 응답 표준화는 후속 `REQ-20260428-08`에서 완료됐다.
- 다음 제안:
  - 추가 검증 오류 계약 보강은 `REQ-20260428-22`에서 진행한다.

### RES-REQ-20260428-08
- 요청 ID: REQ-20260428-08
- 담당 역할: BE
- 상태: 완료
- 요약:
  - `ApiResponse.error(message)` 팩토리를 추가했다.
  - `GlobalExceptionHandler`를 추가해 `ResponseStatusException`, `MissingRequestHeaderException`, `MethodArgumentTypeMismatchException`, 일반 예외를 JSON `ApiResponse` 형태로 변환하도록 했다.
  - Flutter `ApiClient`가 실패 응답에서도 `success`, `message`, `data`를 파싱할 수 있도록 오류 body를 `success=false`, `message`, `data=null` 형태로 맞췄다.
  - 로그인 실패, 중복 이메일, invalid access token, 타 사용자 일기 접근, Authorization 헤더 누락 케이스의 오류 body 테스트를 보강했다.
- 변경 파일:
  - `src/main/java/com/mongtory/diary/common/ApiResponse.java`
  - `src/main/java/com/mongtory/diary/common/GlobalExceptionHandler.java`
  - `src/test/java/com/mongtory/diary/controller/AuthControllerTest.java`
  - `src/test/java/com/mongtory/diary/controller/DiaryControllerTest.java`
  - `.ai-work/msyeo/docs/collaboration/roles/be/inbox.md`
  - `.ai-work/msyeo/docs/collaboration/roles/be/status.md`
  - `.ai-work/msyeo/docs/collaboration/roles/be/responses.md`
- 검증:
  - `bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test`
  - 결과: `BUILD SUCCESS`, tests run 10, failures 0, errors 0, skipped 0
- 남은 이슈:
  - 일반 `Exception`은 보안상 `Internal server error`로만 응답한다.
- 다음 제안:
  - malformed JSON, 누락 query parameter, calendar 범위 오류는 `REQ-20260428-22`에서 보강한다.

## 작성 템플릿
```text
### RES-REQ-YYYYMMDD-NN
- 요청 ID:
- 담당 역할: BE
- 상태:
- 요약:
- 변경 파일:
- 검증:
- 남은 이슈:
- 다음 제안:
```
