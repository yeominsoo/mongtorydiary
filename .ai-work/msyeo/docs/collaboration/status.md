# 역할별 협업 현황 인덱스

## 현재 운영 상태
- 운영 방식: PM, QA, FE 개발자, BE 개발자 4역할 비동기 협업
- 현재 대화 세션 역할: PM
- 공통 기준 문서: `.ai-work/msyeo/docs/collaboration/master-flow.md`
- 요청 인덱스: `.ai-work/msyeo/docs/collaboration/requests.md`
- 응답 인덱스: `.ai-work/msyeo/docs/collaboration/responses.md`
- 역할별 문서: `.ai-work/msyeo/docs/collaboration/roles/`
- 문서 루트: `.ai-work/msyeo/docs/`
- 루트 `docs/`: 사용하지 않음

## 역할별 현재 상태
| 역할 | 현재 상태 | 담당 중인 요청 | 담당 경로/문서 | 메모 |
| --- | --- | --- | --- | --- |
| PM | 대기 | REQ-20260428-40 | `.ai-work/msyeo/docs/`, 협업 문서 | 네이티브 위젯 shell 범위 결정 대기 |
| QA | 대기 | REQ-20260428-37 | API 문서, 테스트 시나리오, `mobile-flutter/test` | today-summary 실제 서버 검증 대기 |
| FE 개발자 | 대기 | REQ-20260428-38/39 | `mobile-flutter/lib`, `mobile-flutter/test` | 딥링크 라우터, 위젯 요약 연동 대기 |
| BE 개발자 | 완료 | REQ-20260428-34 | `src/main/java`, `src/test/java`, `src/main/resources` | 오늘/위젯 요약 API 구현과 Maven 테스트 통과 |

## 작업 보드
| 요청 ID | 우선순위 | 제목 | 담당 | 상태 | 다음 액션 |
| --- | --- | --- | --- | --- | --- |
| REQ-20260428-01 | P0 | PM/QA/FE/BE 협업 문서 체계 확정 | PM | 완료 | QA, FE, BE 요청 착수 가능 |
| REQ-20260428-02 | P1 | API/DTO 계약 재확인 및 통합 검증 시나리오 | QA | 완료 | QA 결과를 바탕으로 REQ-08 오류 응답 표준화 완료 |
| REQ-20260428-03 | P1 | Flutter 로그인 실제 입력 플로우 | FE | 완료 | remote 통합 검증은 REQ-06에서 확인 |
| REQ-20260428-04 | P1 | 백엔드 인증/소유권 검증 테스트 | BE | 완료 | Maven 테스트 통과, 후속 REQ-08 완료 |
| REQ-20260428-05 | P0 | 초기 요청 완료 이후 2차 업무 준비 | PM | 완료 | 2차 요청 등록 완료 |
| REQ-20260428-11 | P0 | 역할별 디렉토리와 요청자별 문서 체계 도입 | PM | 완료 | 공통 문서 인덱스화 완료 |
| REQ-20260428-12 | P0 | 역할별 handoff와 요청자 responses 양방향 기록 규칙 추가 | PM | 완료 | PM 모니터링 절차 추가 |
| REQ-20260428-13 | P0 | 완료 작업 PM 취합 커밋 규칙 추가 | PM | 완료 | PM 커밋 절차 추가 |
| REQ-20260428-14 | P0 | PM 전체 역할 디렉토리 모니터링과 협업룰 조정 절차 추가 | PM | 완료 | 소통 문제 triage 추가 |
| REQ-20260428-15 | P0 | 매 작업 시작 전 변경 룰 확인 강제 | PM | 완료 | 역할별 status 룰 확인 기록 추가 |
| REQ-20260428-21 | P0 | 기준선 커밋 및 단계적 업무계획 수립 | PM | 완료 | delivery-roadmap 작성 및 역할별 후속 요청 배분 |

## 2차 작업 보드
초기 요청 `REQ-20260428-02`, `REQ-20260428-03`, `REQ-20260428-04`가 완료되면 아래 순서로 진행한다.

| 요청 ID | 우선순위 | 제목 | 담당 | 상태 | 선행 조건 | 다음 액션 |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-20260428-06 | P1 | 로그인 완료 후 remote 통합 회귀 검증 | QA | 완료 | REQ-02, REQ-03, REQ-04 완료 | 실제 서버 API 검증과 Flutter analyze/test 통과 |
| REQ-20260428-07 | P1 | 일기 목록에서 상세 진입 플로우 구현 | FE | 완료 | REQ-02, REQ-03 완료 | QA remote 통합 검증에서 실제 상세 API 연결 확인 |
| REQ-20260428-08 | P1 | 전역 예외 응답 표준화 | BE | 완료 | REQ-02, REQ-04 완료 | QA remote 통합 검증에서 실패 메시지 표시 확인 |
| REQ-20260428-09 | P1 | 일기 생성/수정/삭제 연결 준비 | FE/BE | 완료 | REQ-06 완료, REQ-07 완료, REQ-08 완료 | FE 구현과 PM 재검증, QA remote CRUD 검증 완료 |
| REQ-20260428-10 | P1 | Flutter QA 자동화 하네스 1차 구축 | QA | 완료 | REQ-02와 병행 가능 | QA 하네스 구현과 Flutter analyze/test 통과 |
| REQ-20260428-22 | P1 | API 검증 오류 계약 보강 | BE | 완료 | REQ-06, REQ-08 완료 | 구현, Maven 테스트, QA 실제 서버 회귀 검증 완료 |
| REQ-20260428-23 | P1 | 일기 생성/수정/삭제 Flutter 구현 | FE | 보류 | REQ-09 FE 구현 완료 | REQ-09 결과에 흡수되어 별도 진행하지 않음 |
| REQ-20260428-24 | P1 | 일기 CRUD 회귀 시나리오 및 자동화 확장 | QA | 완료 | REQ-09 완료 | CRUD QA harness 확장, Flutter analyze/test, 실제 서버 CRUD API 검증 통과 |
| REQ-20260428-25 | P1 | 위젯/딥링크 1차 설계 요청 준비 | PM | 완료 | CRUD MVP 범위 확정 | `widget-deeplink-plan.md` 작성 완료 |
| REQ-20260428-26 | P2 | CRUD 이후 앱 사용성 개선 후보 설계 | FE | 완료 | REQ-09 완료 | 캘린더 날짜 탭 진입 플로우를 1순위 후보로 제안 |
| REQ-20260428-27 | P2 | 사용성 개선용 API 후보 설계 | BE | 완료 | REQ-22 착수 또는 완료, REQ-09 범위 확인 | 오늘/위젯 요약 API를 1순위 구현 후보로 선정 |
| REQ-20260428-28 | P1 | 캘린더 날짜 탭에서 일기 확인/작성 진입 플로우 구현 | FE | 완료 | REQ-26, REQ-31 완료 | FE 구현, PM 재검증, QA 회귀 검증 완료 |
| REQ-20260428-29 | P1 | API 검증 오류 계약 회귀 검증 | QA | 완료 | REQ-22 구현/Maven 검증 완료 | 실제 서버 오류 계약 검증 완료 |
| REQ-20260428-30 | P1 | 캘린더 날짜 탭 UX 회귀 검증 | QA | 완료 | REQ-28 FE 구현 및 PM 검토 완료 | 상세 진입과 빈 날짜 작성 기본값 검증 완료 |
| REQ-20260428-31 | P2 | 동일 날짜 다건 일기 UX 기준 결정 | PM | 완료 | REQ-26 완료 | 최신 1건 직행 대신 날짜별 목록 또는 bottom sheet 기준 확정 |
| REQ-20260428-32 | P0 | 기획 개선 후보 도출 및 역할별 업무 배분 | PM | 완료 | 사용자 요청 | FE/BE/QA/PM 후속 요청 등록 완료 |
| REQ-20260428-33 | P1 | 일기 작성 UX 잔여 개선 | FE | 완료 | REQ-28 완료, FE 감정 선택 UI 확인 | 사진 URL 목록, 저장/이탈 UX, 날짜 선택 회귀 확인 완료 |
| REQ-20260428-34 | P1 | 오늘/위젯 요약 API 1차 구현 | BE | 완료 | REQ-27 완료, REQ-22 완료 | today-summary API 구현과 테스트 통과 |
| REQ-20260428-35 | P1 | MVP 릴리스 회귀 체크리스트와 신규 개선 검증 계획 | QA | 대기 | REQ-24, REQ-29, REQ-30 완료 | 자동화/수동 검증 범위 분류 |
| REQ-20260428-36 | P1 | 위젯/딥링크 구현 요청 분해와 우선순위 결정 | PM | 완료 | REQ-34 결과 확인 | FE/QA/PM 후속 요청 분리 완료 |
| REQ-20260428-37 | P1 | 오늘/위젯 요약 API 실제 서버 회귀 검증 | QA | 대기 | REQ-34 완료 | today-summary API 실제 서버 검증 |
| REQ-20260428-38 | P1 | Flutter 딥링크 라우터 1차 구현 | FE | 대기 | REQ-34 완료 | Flutter 내부 route 매핑과 widget test |
| REQ-20260428-39 | P1 | 위젯 요약 데이터 앱 연동 경계 구현 | FE | 대기 | REQ-34 완료, REQ-38 착수 또는 완료 | today-summary DTO/model/repository 경계 |
| REQ-20260428-40 | P2 | 네이티브 위젯 shell 범위 결정 | PM | 대기 | REQ-38/39 또는 QA 검증 결과 확인 | Android/iOS 위젯 shell 구현 방식 결정 |

## 충돌 방지 현황
| 파일/경로 | 현재 담당 | 잠금 상태 | 비고 |
| --- | --- | --- | --- |
| `.ai-work/msyeo/docs/collaboration/` | PM | 열림 | PM 최종 정리 완료, 새 요청/응답 추가 가능 |
| `.ai-work/msyeo/docs/collaboration/roles/pm/` | PM | 열림 | PM 요청/응답 원본 |
| `.ai-work/msyeo/docs/collaboration/roles/qa/` | QA | 열림 | QA 요청/응답 원본 |
| `.ai-work/msyeo/docs/collaboration/roles/fe/` | FE | 열림 | FE 요청/응답 원본 |
| `.ai-work/msyeo/docs/collaboration/roles/be/` | BE | 열림 | BE 요청/응답 원본 |
| `.ai-work/msyeo/docs/project-status.md` | PM | 열림 | 협업 공통룰 반영 완료 |
| `.ai-work/msyeo/docs/handoff/2026-04-28.md` | PM | 열림 | 협업 공통룰 반영 완료 |
| `mobile-flutter/lib`, `mobile-flutter/test` | FE/QA | FE 우선 | FE REQ-33 작성 UX 개선, QA REQ-35는 문서 중심으로 시작 |
| `src/main/java`, `src/test/java`, `src/main/resources` | BE | 열림 | REQ-20260428-34 오늘/위젯 요약 API 구현 완료 |
| `.ai-work/msyeo/docs/api-contract.md`, `.ai-work/msyeo/docs/api-spec.md`, `.ai-work/msyeo/docs/source-doc-audit.md` | QA | 열림 | REQ-20260428-02 완료, remote 통합 검증은 REQ-06에서 진행 |

## 역할별 대기 요청
### PM
- REQ-20260428-05: 초기 요청 이후 2차 업무 준비 완료
- REQ-20260428-11: 역할별 디렉토리와 요청자별 문서 체계 도입 완료
- REQ-20260428-12: 역할별 handoff와 요청자 responses 양방향 기록 규칙 추가 완료
- REQ-20260428-13: 완료 작업 PM 취합 커밋 규칙 추가 완료
- REQ-20260428-14: PM 전체 역할 디렉토리 모니터링과 협업룰 조정 절차 추가 완료
- REQ-20260428-15: 매 작업 시작 전 변경 룰 확인 강제 완료
- REQ-20260428-21: 기준선 커밋 및 단계적 업무계획 수립 완료
- REQ-20260428-25: 위젯/딥링크 1차 설계 요청 준비 완료
- REQ-20260428-31: 동일 날짜 다건 일기 UX 기준 결정 완료
- REQ-20260428-32: 기획 개선 후보 도출 및 역할별 업무 배분 완료
- REQ-20260428-36: 위젯/딥링크 구현 요청 분해와 우선순위 결정 완료
- REQ-20260428-40: 네이티브 위젯 shell 범위 결정 대기

### QA
- REQ-20260428-02: API/DTO 계약 재확인 및 통합 검증 시나리오 작성 완료
- REQ-20260428-06: 초기 요청 완료 후 remote 통합 회귀 검증 완료
- REQ-20260428-10: Flutter QA 자동화 하네스 1차 구축 완료
- REQ-20260428-24: 일기 CRUD 회귀 시나리오 및 자동화 확장 완료
- REQ-20260428-35: MVP 릴리스 회귀 체크리스트와 신규 개선 검증 계획 대기

### FE 개발자
- REQ-20260428-03: Flutter 로그인 화면 실제 입력 플로우 전환 완료, remote 통합 검증은 REQ-06에서 확인
- REQ-20260428-07: 일기 목록에서 상세 진입 플로우 구현 완료
- REQ-20260428-09: 일기 생성/수정/삭제 Flutter 구현 완료
- REQ-20260428-23: REQ-09에 흡수되어 보류
- REQ-20260428-26: CRUD 이후 앱 사용성 개선 후보 설계 완료
- REQ-20260428-28: 캘린더 날짜 탭에서 일기 확인/작성 진입 플로우 구현 완료
- REQ-20260428-33: 일기 작성 UX 잔여 개선 완료
- REQ-20260428-38: Flutter 딥링크 라우터 1차 구현 대기
- REQ-20260428-39: 위젯 요약 데이터 앱 연동 경계 구현 대기

### BE 개발자
- REQ-20260428-04: 백엔드 인증/소유권 검증 테스트 보강 완료
- REQ-20260428-08: 전역 예외 응답 표준화 완료
- REQ-20260428-22: API 검증 오류 계약 보강 완료
- REQ-20260428-27: 사용성 개선용 API 후보 설계 완료
- REQ-20260428-34: 오늘/위젯 요약 API 1차 구현 완료

### 후속 QA
- REQ-20260428-29: API 검증 오류 계약 회귀 검증 완료
- REQ-20260428-30: 캘린더 날짜 탭 UX 회귀 검증 완료
- REQ-20260428-37: 오늘/위젯 요약 API 실제 서버 회귀 검증 대기

## 다음 우선 후보
1. QA: `REQ-20260428-37` 오늘/위젯 요약 API 실제 서버 회귀 검증
2. FE: `REQ-20260428-38` Flutter 딥링크 라우터 1차 구현
3. FE: `REQ-20260428-39` 위젯 요약 데이터 앱 연동 경계 구현
4. QA: `REQ-20260428-35` MVP 릴리스 회귀 체크리스트와 신규 개선 검증 계획
5. PM: `REQ-20260428-40` 네이티브 위젯 shell 범위 결정

## 개발 환경 참고 상태
- 2026-04-28 기준 개발 환경 점검 완료
- Flutter 검증: `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter analyze`, `HOME=/tmp/mongtory-flutter-home /tmp/flutter/bin/flutter test` 통과
- 백엔드 검증: `bash ./mvnw -Dmaven.repo.local=/home/msyeo/workspace/mongtorydiary/.m2 test` 통과
- 백엔드 테스트 안정화를 위해 시드 초기화 순서를 `UserDataInitializer` -> `DiaryDataInitializer`로 고정
- REQ-20260428-04 기준 인증 성공/실패, refresh token, invalid access token, 타 사용자 일기 상세 접근 차단 테스트 보강 완료
- REQ-20260428-07 기준 Flutter 일기 목록에서 상세 진입 플로우와 위젯 테스트 완료
- REQ-20260428-08 기준 전역 예외 응답 `ApiResponse` 표준화와 Maven 테스트 완료
- REQ-20260428-06 기준 실제 서버 API remote 통합 회귀 검증과 Flutter analyze/test 완료
- REQ-20260428-10 기준 Flutter QA 자동화 하네스 구현/검증 완료
- REQ-20260428-09 기준 Flutter 일기 생성/수정/삭제 구현과 PM 재검증 완료
- REQ-20260428-24 기준 Flutter QA 하네스 CRUD 회귀 자동화 확장과 실제 서버 CRUD API 검증 완료
- REQ-20260428-25 기준 위젯/딥링크 1차 설계 문서 작성 완료
- REQ-20260428-26 기준 CRUD 이후 사용성 개선 후보 설계 완료
- REQ-20260428-22 기준 API 검증 오류 계약 보강 구현과 Maven 테스트 통과 완료
- REQ-20260428-27 기준 사용성 개선용 API 후보 설계 완료
- REQ-20260428-34 기준 오늘/위젯 요약 API 구현, Maven 테스트, BE handoff 반영 완료
- REQ-20260428-36 기준 위젯/딥링크 구현 요청 분해 완료
- 다음 PM 확인 입력은 `REQ-20260428-37~40` 착수 상태와 완료 변경 커밋 판단이다.

## 인덱스 운영 메모
- 이 문서는 PM이 관리하는 공통 현황 인덱스다.
- 각 역할의 상세 진행 내용은 `roles/{role}/status.md`에 기록한다.
- PM은 역할별 현황을 모아 이 문서에 요약만 반영한다.
