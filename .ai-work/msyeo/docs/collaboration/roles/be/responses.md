# BE 응답 문서

## 응답 목록
| 응답 ID | 요청 ID | 상태 | 요약 | 작성일 |
| --- | --- | --- | --- | --- |
| RES-REQ-20260428-04 | REQ-20260428-04 | 완료 | 인증/소유권 검증 테스트 보강 및 Maven 테스트 통과 | 2026-04-28 |
| RES-REQ-20260428-08 | REQ-20260428-08 | 완료 | 전역 예외 응답 ApiResponse 표준화 및 Maven 테스트 통과 | 2026-04-28 |

## 응답 상세
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
