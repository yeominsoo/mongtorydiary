# 역할별 협업 문서 구조

## 목적
여러 AI 세션이 같은 협업 문서를 동시에 수정하면서 충돌하는 문제를 줄이기 위해 역할별 디렉토리를 둔다. 공통 문서(`requests.md`, `status.md`, `responses.md`)는 PM이 관리하는 인덱스이고, 각 세션은 자기 역할 디렉토리의 문서를 우선 수정한다.

## 디렉토리 구조
```text
.ai-work/msyeo/docs/collaboration/
  master-flow.md
  requests.md
  status.md
  responses.md
  roles/
    pm/
      requests.md
      inbox.md
      status.md
      responses.md
      handoff/
    qa/
      requests.md
      inbox.md
      status.md
      responses.md
      handoff/
    fe/
      requests.md
      inbox.md
      status.md
      responses.md
      handoff/
    be/
      requests.md
      inbox.md
      status.md
      responses.md
      handoff/
```

## 파일 의미
- `requests.md`: 해당 역할이 다른 역할에게 요청한 항목
- `inbox.md`: 해당 역할이 받은 요청
- `status.md`: 해당 역할의 진행 현황, 잠금 파일, 차단 이슈
- `responses.md`: 해당 역할이 완료한 응답과 검증 결과
- `handoff/YYYY-MM-DD.md`: 해당 역할이 작업 블록 종료 시 작성하는 인수인계

## 편집 규칙
- 각 역할 세션은 기본적으로 자기 역할 디렉토리만 수정한다.
- 공통 인덱스 문서(`../requests.md`, `../status.md`, `../responses.md`)는 PM이 최종 정리한다.
- 다른 역할에게 요청할 때는 자기 `requests.md`에 먼저 작성하고, PM이 공통 인덱스와 대상 역할 `inbox.md`에 반영한다.
- 긴 작업 결과는 자기 `responses.md`에 기록하고, 같은 내용을 요청자 역할의 `responses.md`에도 남긴다. 공통 `responses.md`에는 PM이 요약만 반영한다.
- 같은 요청 ID를 여러 파일에서 사용할 때 제목과 상태는 PM이 공통 인덱스를 기준으로 맞춘다.
- 커밋 메시지는 한글로 작성한다. 기존 커밋 메시지가 영어라면 PM이 가능한 범위에서 한글로 정정한다.

## 작업 시작 전 룰 확인 규칙
- 모든 역할은 매 작업 시작마다 변경된 룰이 없는지 확인한다.
- 확인 대상은 `AGENTS.md`, `collaboration/master-flow.md`, `roles/README.md`, 자기 역할 `inbox.md`, 자기 역할 `status.md`다.
- 확인 후 자기 역할 `status.md`에 `룰 확인 기록`을 남긴다.
- 기록이 없으면 PM은 해당 작업을 완료 처리하지 않고 확인 보완을 요청할 수 있다.

기록 형식:

```text
## 룰 확인 기록
- YYYY-MM-DD HH:MM: 작업 시작 전 AGENTS/master-flow/roles README/inbox/status 확인, 변경 룰 반영 여부: 예/아니오, 요청 ID: REQ-...
```

## 역할별 Handoff 규칙
- 요청 하나 또는 명확한 작업 블록 하나가 끝나면 자기 역할의 `handoff/YYYY-MM-DD.md`에 기록한다.
- 같은 날짜에 여러 블록이 끝나면 같은 파일 아래에 새 섹션을 추가한다.
- 요청자 responses에 처리 결과를 남겼는지 반드시 handoff에 표시한다.

## 요청자 응답 기록 규칙
- 요청을 처리한 역할은 자기 `responses.md`에 먼저 결과를 기록한다.
- 이어서 요청자 역할의 `responses.md`에도 같은 요청 ID로 처리 결과를 기록한다.
- 예: PM이 FE에게 요청한 `REQ-...`를 FE가 처리했다면 `roles/fe/responses.md`와 `roles/pm/responses.md` 둘 다에 결과를 남긴다.
- 요청자가 사용자/PM이면 PM responses에 기록한다.
- 요청자가 QA이고 BE가 처리했다면 BE responses와 QA responses에 기록한다.
