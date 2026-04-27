# PM 협업 보드 안내

## 현재 기준
이 문서는 이전 PM 중심 협업 보조 문서다. 현재 공식 협업 기준은 `.ai-work/msyeo/docs/collaboration/master-flow.md`이며, 역할은 PM, QA, FE 개발자, BE 개발자 4개로 운영한다.

역할 간 공식 소통은 아래 문서를 우선한다.

- 마스터 플로우: `.ai-work/msyeo/docs/collaboration/master-flow.md`
- 요청 문서: `.ai-work/msyeo/docs/collaboration/requests.md`
- 현황 문서: `.ai-work/msyeo/docs/collaboration/status.md`
- 응답 문서: `.ai-work/msyeo/docs/collaboration/responses.md`

## 역할 요약
- PM: 요청 ID 발급, 우선순위 조정, 파일 잠금 관리, 공통 문서와 handoff 최종 정리
- QA: API/DTO 계약, 화면 동작, 통합 실행, 회귀 위험 검증과 테스트 시나리오 정리
- FE 개발자: `mobile-flutter/lib`, `mobile-flutter/test` 중심의 Flutter 앱 구현
- BE 개발자: `src/main/java`, `src/test/java`, `src/main/resources` 중심의 Spring Boot 구현

이 대화의 AI 세션은 QA 역할이다.

## 역할별 첫 요청
- QA: `REQ-20260428-02` API/DTO 계약 재확인 및 통합 검증 시나리오 작성
- FE 개발자: `REQ-20260428-03` Flutter 로그인 실제 입력 플로우 구현
- BE 개발자: `REQ-20260428-04` 백엔드 인증/소유권 검증 테스트 보강

## 세션 시작 공통 안내
모든 역할 세션은 아래 순서로 문서를 읽고 시작한다.

```text
1. AGENTS.md
2. .ai-work/msyeo/docs/collaboration/master-flow.md
3. .ai-work/msyeo/docs/collaboration/requests.md
4. .ai-work/msyeo/docs/collaboration/status.md
```

작업 완료 후에는 `.ai-work/msyeo/docs/collaboration/responses.md`에 요청 ID 기준으로 결과를 남긴다.
