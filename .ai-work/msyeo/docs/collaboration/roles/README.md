# 역할별 협업 문서 보관 안내

## 현재 상태
2026-05-21부터 PM, QA, FE 개발자, BE 개발자 역할 분배는 활성 운영 방식에서 철회됐다. 이 디렉토리는 과거 다중 세션 협업 이력을 보관하기 위한 영역이다.

## 보관 대상
```text
.ai-work/msyeo/docs/collaboration/roles/
  pm/
  qa/
  fe/
  be/
```

각 하위 디렉토리의 `requests.md`, `inbox.md`, `status.md`, `responses.md`, `handoff/`는 과거 요청, 진행 상태, 검증 결과를 확인하는 용도로 유지한다.

## 신규 작업 기준
- 새 작업은 `.ai-work/msyeo/docs/single-session-worklist.md`와 공통 인덱스 문서에서 관리한다.
- 공통 인덱스 문서는 아래 세 파일이다.
  - `.ai-work/msyeo/docs/collaboration/requests.md`
  - `.ai-work/msyeo/docs/collaboration/status.md`
  - `.ai-work/msyeo/docs/collaboration/responses.md`
- 역할별 inbox/status/responses에는 새 요청을 추가하지 않는다.
- 기존 `REQ-...` ID는 추적을 위해 유지하되 현재 담당은 `단일 세션`으로 본다.

## 새 세션 시작 기준
단일 세션은 아래 문서를 먼저 확인한다.

1. `AGENTS.md`
2. `.ai-work/msyeo/docs/collaboration/master-flow.md`
3. `.ai-work/msyeo/docs/project-status.md`
4. `.ai-work/msyeo/docs/single-session-worklist.md`
5. 최신 `.ai-work/msyeo/docs/handoff/YYYY-MM-DD.md`

확인 기록은 공통 `.ai-work/msyeo/docs/collaboration/status.md`의 `룰 확인 기록`에 남긴다.
