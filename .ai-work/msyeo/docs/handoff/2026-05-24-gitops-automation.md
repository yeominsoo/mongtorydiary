# 2026-05-24 GitOps 자동화 handoff

이 저장소는 이번 작업에서 Docker FE/BE 배포와 GitHub Actions 자동 이미지 빌드 대상에 포함되었다.

상세 handoff 원본:

- `/home/msyeo/workspace/home-lab-gitops/docs/handoff/2026-05-24-gitops-automation.md`

이 저장소의 주요 변경:

- `Dockerfile.backend`
- `Dockerfile.frontend`
- `docker-compose.yml`
- `.dockerignore`
- `docker/frontend-nginx.conf`
- `frontend/package-lock.json`
- `frontend/src/App.tsx`
- `.github/workflows/publish-images.yml`
- `AGENTS.md`

검증:

- `docker compose config` 성공
- `docker build -t mongtorydiary-backend:test -f Dockerfile.backend .` 성공
- `docker build -t mongtorydiary-frontend:test -f Dockerfile.frontend .` 성공

다음 세션 시작 시:

1. `/root/.codex/memories/context-compaction-handoff.md`를 확인한다.
2. 중앙 handoff 원본을 확인한다.
3. `git status --short`로 루트 untracked `node_modules/`, `package.json`, `package-lock.json` 처리 여부를 확인한다.
4. 사용자가 승인하기 전 실제 비밀번호, 토큰, 개인 인증 정보는 문서나 Git에 기록하지 않는다.
