# PM 모니터링 절차

## 목적
역할별 문서가 분산되면서 발생할 수 있는 소통 누락, 상태 불일치, 파일 충돌, 요청/응답 단절을 PM이 정기적으로 확인하기 위한 체크리스트다. PM은 공통 인덱스만 보지 않고 모든 역할 디렉토리의 문서를 확인한다.

## 모니터링 범위
PM은 아래 문서를 모두 모니터링 대상으로 본다.

```text
.ai-work/msyeo/docs/collaboration/master-flow.md
.ai-work/msyeo/docs/collaboration/requests.md
.ai-work/msyeo/docs/collaboration/status.md
.ai-work/msyeo/docs/collaboration/responses.md
.ai-work/msyeo/docs/collaboration/roles/README.md
.ai-work/msyeo/docs/collaboration/roles/pm/**
.ai-work/msyeo/docs/collaboration/roles/qa/**
.ai-work/msyeo/docs/collaboration/roles/fe/**
.ai-work/msyeo/docs/collaboration/roles/be/**
```

PM은 각 역할의 `requests.md`, `inbox.md`, `status.md`, `responses.md`, `handoff/`를 모두 확인해 역할 간 소통 흐름이 끊겼는지 판단한다.

## 모니터링 순서
1. 공통 `../requests.md`, `../status.md`, `../responses.md`에서 전체 요청 흐름을 확인한다.
2. `roles/pm`, `roles/qa`, `roles/fe`, `roles/be`의 모든 `requests.md`를 확인해 새 요청이나 질문이 있는지 본다.
3. 각 역할의 `inbox.md`에서 받은 요청이 누락 없이 들어갔는지 확인한다.
4. 각 역할의 `status.md`에서 잠금 경로, 진행 상태, 차단 이슈를 확인한다.
5. 각 역할의 `responses.md`에서 새 응답을 확인한다.
6. 각 역할의 `handoff/` 디렉토리와 날짜별 handoff를 확인한다.
7. 수행자 responses와 요청자 responses 양쪽에 같은 요청 ID가 있는지 확인한다.
8. 공통 인덱스와 역할별 문서의 요청 상태, 담당자, 완료 기준이 일치하는지 확인한다.
9. 각 역할의 `status.md`에 작업 시작 전 룰 확인 기록이 있는지 확인한다.
10. `git status --short`로 실제 변경 파일과 역할별 status의 잠금 경로가 일치하는지 확인한다.
11. 소통 문제가 발견되면 원인을 분류하고 필요한 협업룰 조정안을 작성한다.
12. 공통 `requests.md`, `status.md`, `responses.md` 인덱스를 필요한 만큼 갱신한다.
13. 의미 있는 작업이면 `.ai-work/msyeo/docs/project-status.md`와 `.ai-work/msyeo/docs/handoff/YYYY-MM-DD.md`를 갱신한다.
14. 완료된 요청 중 커밋 가능한 단위가 있으면 PM이 관련 파일을 취합해 직접 커밋한다.

## 오류 감지 기준
| 감지 항목 | 오류 판단 | PM 조치 |
| --- | --- | --- |
| 상태 불일치 | 공통 status와 역할별 status의 요청 상태가 다름 | 최신 응답/hand off 기준으로 정정 |
| 응답 누락 | 수행자 responses만 있고 요청자 responses가 없음 | 수행자에게 보완 요청 또는 PM이 요약 추가 |
| handoff 누락 | 요청 완료 응답은 있으나 역할별 handoff가 없음 | 해당 역할에 handoff 보완 요청 |
| 파일 잠금 불일치 | 역할별 status의 잠금 경로와 실제 변경 경로가 다름 | 충돌 위험 표시 후 담당자 조정 |
| 차단 장기화 | 차단 상태인데 질문/요청이 없음 | PM이 차단 사유 재작성 요청 |
| 공통 인덱스 미반영 | 역할별 문서에는 변경이 있는데 공통 인덱스가 낡음 | PM이 공통 인덱스 갱신 |
| 커밋 범위 혼합 | 완료 요청 파일과 진행중 요청 파일이 섞임 | 요청 ID 단위로 파일을 선별하거나 커밋 보류 |
| 요청 전달 누락 | 요청자 requests에는 있으나 대상 inbox에는 없음 | PM이 대상 inbox와 공통 인덱스에 반영 |
| 응답 전달 누락 | 수행자 responses에는 있으나 요청자 responses에는 없음 | 요청자 responses에 보완하고 수행자에게 규칙 재공지 |
| handoff 단절 | 역할별 handoff에 다음 확인자가 명시되지 않음 | PM이 다음 확인자를 지정하고 handoff 보완 요청 |
| 담당 경로 모호 | 요청에는 대상 역할이 있으나 파일 범위가 모호함 | PM이 요청 완료 기준과 담당 경로를 재작성 |
| 역할 간 ping-pong | 같은 이슈가 FE/BE/QA 사이에서 반복 반려됨 | PM이 triage 요청을 만들고 단일 owner 지정 |
| 규칙 반복 위반 | 같은 유형의 누락이 반복됨 | PM이 master-flow 또는 roles/README 룰을 조정 |
| 룰 확인 누락 | 작업은 시작됐으나 역할별 status에 룰 확인 기록이 없음 | PM이 완료 처리를 보류하고 담당자에게 기록 보완 요청 |

## 빠른 확인 명령
```bash
find .ai-work/msyeo/docs/collaboration/roles -maxdepth 3 -type f | sort
rg -n "진행중|검토중|차단|완료|REQ-" .ai-work/msyeo/docs/collaboration
rg -n "룰 확인 기록|누락|차단|질문|요청|응답|handoff|검증|미실행" .ai-work/msyeo/docs/collaboration/roles
git status --short
```

## 소통 문제 Triage
PM은 문서 모니터링 중 소통 문제가 보이면 아래 기준으로 분류한다.

| 분류 | 예시 | PM 처리 |
| --- | --- | --- |
| 요청 불명확 | 완료 기준, 담당 파일, 대상 역할이 모호함 | 요청 재작성 후 대상 inbox 갱신 |
| 응답 불충분 | 변경 파일/검증/남은 이슈가 없음 | 수행자에게 responses 보완 요청 |
| 전달 누락 | 요청자 문서에는 있으나 대상 문서에는 없음 | PM이 양쪽 문서를 연결하고 공통 인덱스 갱신 |
| 상태 불일치 | 한쪽은 완료, 한쪽은 진행중 | 최신 handoff/responses 기준으로 정정 |
| 충돌 위험 | 두 역할이 같은 파일을 수정 중 | PM이 owner를 지정하고 다른 역할 작업 보류 |
| 룰 부재 | 기존 규칙으로 판단 불가 | PM이 협업룰 조정 요청을 생성 |

## 협업룰 조정 절차
1. PM이 문제 유형과 발생 요청 ID를 `roles/pm/requests.md`에 기록한다.
2. 필요한 경우 새 PM 요청 ID를 발급한다.
3. `master-flow.md` 또는 `roles/README.md` 중 어느 문서의 룰을 바꿀지 결정한다.
4. 룰을 수정한 뒤 공통 인덱스와 PM responses에 변경 근거를 남긴다.
5. 전체 handoff에 룰 변경 목적과 다음 세션 체크포인트를 기록한다.
6. 반복 문제인지 확인하기 위해 다음 모니터링 때 같은 유형을 다시 검색한다.

## PM 판정 규칙
- 완료 판정은 요청의 완료 기준, 수행자 응답, 검증 결과, handoff 기록이 모두 맞을 때 한다.
- 검증을 실행하지 못한 요청은 완료할 수 있지만, `남은 이슈`와 `미실행 사유`가 있어야 한다.
- 수행자와 요청자 responses 중 하나라도 비어 있으면 `검토중`으로 둔다.
- 역할별 문서 중 하나라도 상태가 상충하면 완료 처리하지 않고 PM이 먼저 정정한다.
- 작업 시작 전 룰 확인 기록이 없으면 완료 처리하지 않고 보완 요청한다.

## PM 커밋 절차
1. `git status --short`로 전체 변경을 확인한다.
2. 완료 요청 ID와 관련된 변경 파일 목록을 responses/handoff에서 확인한다.
3. 진행중 요청의 파일과 섞여 있으면 커밋을 보류하거나 파일을 선별한다.
4. 필요한 검증 결과가 responses에 있는지 확인한다.
5. 요청 ID 단위로 `git add <files>`를 수행한다.
6. 아래 형식으로 커밋한다.

```bash
git commit -m "<type>: <요약> (<요청ID>)"
```

7. 커밋 해시를 수행자 responses, 요청자 responses, 공통 responses에 기록한다.
8. 공통 status와 역할별 status에 커밋 완료 여부를 반영한다.

## 커밋 타입 기준
- `docs`: 협업 문서, 상태 문서, handoff 등 문서 변경
- `feat`: 사용자 기능 추가
- `fix`: 버그 수정
- `test`: 테스트 추가/수정
- `refactor`: 동작 변경 없는 구조 개선
- `chore`: 빌드/환경/도구 설정
