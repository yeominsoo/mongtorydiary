# 문서 루트

이 디렉토리는 Mongtory Diary 프로젝트의 단일 문서 관리 위치다. 앞으로 운영 문서, 기획 문서, API 계약, 아키텍처 문서, handoff, AI 보조 개발 분석 문서는 모두 `.ai-work/msyeo/docs/` 아래에서 관리한다.

## 현재 구성
- `project-status.md`: 현재 구조, 구현 범위, 미해결 이슈, 다음 우선순위
- `project-analysis.md`: 바이브코딩용 프로젝트 분석과 추천 작업 순서
- `delivery-roadmap.md`: 목표 달성을 위한 단계적 업무계획과 역할별 후속 요청
- `source-doc-audit.md`: 실제 소스와 문서 정합성 점검 결과
- `session-continuity.md`: 새 세션에서 맥락을 복구하기 위한 상세 인수인계
- `planning.md`: 제품 비전 및 로드맵
- `platform-direction.md`: Flutter 중심 플랫폼 방향
- `flutter-architecture.md`: Flutter 앱 아키텍처 방향
- `api-spec.md`: 백엔드-앱 공용 API/DTO 초안
- `api-contract.md`: API/DTO 계약 초안
- `collaboration/master-flow.md`: PM/QA/FE/BE 세션 협업 마스터 플로우
- `collaboration/requests.md`: PM이 관리하는 역할 간 요청 인덱스
- `collaboration/status.md`: PM이 관리하는 역할별 진행 상태와 파일 잠금 인덱스
- `collaboration/responses.md`: PM이 관리하는 요청별 응답 인덱스
- `collaboration/roles/README.md`: 역할별 디렉토리와 요청자별 문서 운영 규칙
- `collaboration/roles/{pm|qa|fe|be}/`: 역할별 요청, 수신함, 현황, 응답 문서
- `collaboration/roles/{pm|qa|fe|be}/handoff/`: 역할별 작업 블록 종료 기록
- `collaboration/roles/pm/monitoring.md`: PM 모니터링 절차와 오류 감지 체크리스트
- `multiwindow-dev-prep.md`: 멀티 터미널 개발 역할 분담과 충돌 방지 기준 보조 문서
- `pm-collaboration-board.md`: 이전 PM 중심 협업 보조 문서
- `windows-flutter-app-guide.md`: 윈도우에서 Flutter 앱 타깃으로 확인하는 절차
- `handoff/`: 날짜별 작업 종료 기록

## 운영 원칙
- 루트 `docs/` 디렉토리는 사용하지 않는다.
- AI 세션 협업의 공식 기준은 `collaboration/master-flow.md`다.
- 현재 역할은 PM, QA, FE 개발자, BE 개발자 4개로 운영한다.
- 의미 있는 작업 후에는 `project-status.md`와 `.ai-work/msyeo/docs/handoff/YYYY-MM-DD.md`를 갱신한다.
- handoff 디렉토리가 없으면 `.ai-work/msyeo/docs/handoff/`를 먼저 생성한 뒤 날짜별 파일을 작성한다.
- 비밀번호, 토큰, 개인 인증 정보는 문서에 기록하지 않는다.
- PM, QA, FE 개발자, BE 개발자 세션은 `collaboration/master-flow.md`를 공통룰로 따르고 실제 요청/현황/응답은 자기 역할 디렉토리인 `collaboration/roles/{role}/`에 남긴다.
- 공통 `collaboration/requests.md`, `status.md`, `responses.md`는 PM이 관리하는 인덱스다.
- 요청 처리 결과는 수행자 `responses.md`와 요청자 `responses.md` 양쪽에 남긴다.
- 모든 역할은 작업 블록 종료 시 자기 역할의 `handoff/YYYY-MM-DD.md`를 작성한다.
- 커밋 메시지는 한글로 작성한다.
