# 단일 세션 현황 인덱스

## 현재 운영 상태
- 운영 방식: 단일 AI 세션 순차 처리
- 전환일: 2026-05-21
- 이전 역할 분배: PM, QA, FE 개발자, BE 개발자 4역할 비동기 협업
- 현재 담당: 단일 세션
- 공통 기준 문서: `.ai-work/msyeo/docs/collaboration/master-flow.md`
- 단일 작업 목록: `.ai-work/msyeo/docs/single-session-worklist.md`
- 요청 인덱스: `.ai-work/msyeo/docs/collaboration/requests.md`
- 응답 인덱스: `.ai-work/msyeo/docs/collaboration/responses.md`
- 과거 역할별 문서: `.ai-work/msyeo/docs/collaboration/roles/`
- 문서 루트: `.ai-work/msyeo/docs/`
- 루트 `docs/`: 사용하지 않음

## 현재 작업
- 작업 ID: `REQ-20260521-05`
- 상태: 진행중, 1차 구현/검증 완료, 2차 검색/태그/지난 오늘 구현/검증 완료, 3차 사진 업로드 구현/검증 완료, 4차 위치/날씨/앱 내 리마인더 구현/검증 완료
- 목적: 초기 로딩 진행 UI, PostgreSQL 전환 기반, 유명 다이어리 앱 기능 참조 기반 완성도 개선
- 담당: 단일 세션

## 룰 확인 기록
- 2026-05-21 00:46: 작업 시작 전 AGENTS/master-flow/roles README/PM inbox/PM status 및 공통 인덱스 확인, 변경 룰 반영 여부: 예, 작업 ID: SINGLE-MIGRATION-20260521-01
- 2026-05-21 01:20: 작업 시작 전 AGENTS/master-flow/project-status/single-session-worklist/handoff 확인, 변경 룰 반영 여부: 예, 작업 ID: REQ-20260428-37
- 2026-05-21 01:35: 작업 시작 전 AGENTS/master-flow/project-status/single-session-worklist/handoff 확인, 변경 룰 반영 여부: 예, 작업 ID: REQ-20260521-01
- 2026-05-21 02:00: 작업 시작 전 AGENTS/master-flow/project-status/single-session-worklist/handoff 확인, 변경 룰 반영 여부: 예, 작업 ID: REQ-20260521-02
- 2026-05-21 02:15: 작업 시작 전 AGENTS/master-flow/project-status/single-session-worklist/handoff 확인, 변경 룰 반영 여부: 예, 작업 ID: REQ-20260521-03
- 2026-05-21 02:33: 작업 시작 전 AGENTS/master-flow/project-status/single-session-worklist/handoff 확인, 변경 룰 반영 여부: 예, 작업 ID: REQ-20260521-04
- 2026-05-21 19:30: 작업 시작 전 AGENTS/master-flow/project-status/single-session-worklist/handoff 확인, 변경 룰 반영 여부: 예, 작업 ID: REQ-20260521-05
- 2026-05-21 19:42: 작업 시작 전 AGENTS/master-flow/project-status/single-session-worklist/handoff 확인, 변경 룰 반영 여부: 예, 작업 ID: REQ-20260521-05 검색/태그/지난오늘 후속
- 2026-05-21 19:56: 작업 시작 전 AGENTS/master-flow/project-status/single-session-worklist/handoff 확인, 변경 룰 반영 여부: 예, 작업 ID: REQ-20260521-05 사진 업로드 후속
- 2026-05-21 20:09: 작업 시작 전 AGENTS/master-flow/project-status/single-session-worklist/handoff 확인, 변경 룰 반영 여부: 예, 작업 ID: REQ-20260521-05 위치/날씨/리마인더 후속

## 이관된 대기 작업
| 순서 | 기존 요청 ID | 우선순위 | 이전 담당 | 현재 담당 | 상태 | 다음 액션 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | REQ-20260428-37 | P1 | QA | 단일 세션 | 완료 | 실제 서버 회귀 검증 완료, 후속 REQ-20260428-38 착수 가능 |
| 2 | REQ-20260428-38 | P1 | FE | 단일 세션 | 대기 | Flutter 내부 딥링크 route 구현과 테스트 |
| 3 | REQ-20260428-39 | P1 | FE | 단일 세션 | 대기 | today-summary Flutter DTO/model/repository 경계 구현 |
| 4 | REQ-20260428-40 | P2 | PM | 단일 세션 | 대기 | Android/iOS 네이티브 위젯 shell 범위 결정 |
| 5 | REQ-20260428-35 | P1 | QA | 단일 세션 | 대기 | MVP 릴리스 회귀 체크리스트와 신규 개선 검증 계획 작성 |
| 6 | SINGLE-20260521-OPS | P2 | PM | 단일 세션 | 대기 | 문서/커밋 정합성 정리 |

## 완료 또는 보류된 주요 요청
| 요청 ID | 상태 | 요약 |
| --- | --- | --- |
| REQ-20260428-33 | 완료 | 일기 작성 UX 잔여 개선, Flutter analyze/test 통과 |
| REQ-20260428-34 | 완료 | 오늘/위젯 요약 API 구현, Maven 테스트 통과 |
| REQ-20260428-36 | 완료 | 위젯/딥링크 구현 요청을 REQ-37~40으로 분해 |
| REQ-20260428-37 | 완료 | today-summary API 실제 서버 회귀 검증 통과 |
| REQ-20260521-01 | 완료 | 백엔드 30080, Flutter web 30081 포트 기준 반영 |
| REQ-20260521-02 | 완료 | Flutter SDK 3.41.7 설치 및 `mobile-flutter` analyze/test/web-server 30081 검증 통과 |
| REQ-20260521-03 | 완료 | systemd 임시 서비스로 백엔드 30080, Flutter web 30081 실행, CORS 허용 및 IP 기준 응답 확인 |
| REQ-20260521-04 | 완료 | 캘린더 TODO API/UI와 몽토리 메뉴 대시보드 구현, Flutter/Maven 검증, Git push, 30080/30081 재시작과 실제 서버 smoke 통과 |
| REQ-20260521-05 | 진행중, 4차 완료 | 초기 로딩 진행 UI, PostgreSQL 기본 설정, 일기 홈 회고 카드 1차 구현 완료. 2차로 검색/태그 API, Flutter 필터 UI, 지난 오늘 전용 API 구현과 실제 서버 smoke 완료. 3차로 사진 업로드 API와 Flutter 파일 선택 첨부 구현 및 실제 서버 smoke 완료. 4차로 위치/날씨 메타데이터와 앱 내 작성 리마인더 구현 및 실제 서버 smoke 완료 |
| REQ-20260428-23 | 보류 | REQ-20260428-09 Flutter CRUD 구현에 흡수 |

## 다음 작업 순서
1. `REQ-20260428-38` Flutter 딥링크 라우터 1차 구현
2. `REQ-20260428-39` 위젯 요약 데이터 앱 연동 경계 구현
3. `REQ-20260428-40` 네이티브 위젯 shell 범위 결정
4. `REQ-20260428-35` MVP 릴리스 회귀 체크리스트와 신규 개선 검증 계획
5. OS 알림 기반 작성 리마인더가 필요하면 Android/iOS 권한, 스케줄링, 저장 경계 구현
6. `SINGLE-20260521-OPS` 문서/커밋 정합성 정리

## 파일 충돌 및 Git 상태 메모
| 경로 | 상태 | 메모 |
| --- | --- | --- |
| `.ai-work/msyeo/docs/` | 진행중 | 단일 세션 운영, 검증 결과, 포트 기준 문서 정리 중 |
| `mobile-flutter/lib`, `mobile-flutter/test` | 진행중 | REQ-20260521-05 4차 위치/날씨 UI/API 연동과 앱 내 작성 리마인더 변경 적용, 후속 REQ-38/39에서 수정 가능 |
| `src/main/java`, `src/test/java`, `src/main/resources` | 진행중 | REQ-20260521-05 4차 위치/날씨 API/검색 변경 적용 |
| `.codex` | 미추적 | 이번 작업과 무관하면 건드리지 않음 |
| `node_modules/`, `package-lock.json`, `package.json` | 미추적 | 이번 작업과 무관하면 건드리지 않음 |

## 인덱스 운영 메모
- 이 문서는 단일 세션의 현재 작업 상태를 요약한다.
- 상세 작업 순서와 완료 기준은 `.ai-work/msyeo/docs/single-session-worklist.md`를 우선한다.
- 과거 역할별 status/inbox는 이력 확인용이며 신규 상태 갱신 대상이 아니다.
