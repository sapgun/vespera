# VESPERA - Claude Code Project Context

## 현재 버전
v0.2 완료 / v0.3 진행 중

## 실행
py core/vespera.py <command>
py run.py <command>
py -m core.vespera <command>

## 파일 구조
core/vespera.py     - CLI 진입점 + 모든 cmd_xxx 함수
core/router.py      - 8개 라우트 키워드 매칭
core/storage.py     - storage.yaml 파서 + get_max_backups()
core/audit.py       - 감사 로그
core/task_intake.py - Obsidian 노트 생성
core/paths.py       - 기본 경로
core/github_client.py - (예정) GitHub API 연결
config/             - agents.yaml, permission_matrix.yaml, routing_rules.yaml, storage.yaml
run.py              - 루트 진입점

## 개발 규칙
1. 파일 쓸 때 반드시 encoding=utf-8, BOM 없이
2. PowerShell Set-Content는 BOM 붙음 - Python write_text 사용
3. 파일 수정 후 __pycache__ 삭제
4. 새 명령어 추가 = cmd_xxx 함수 + build_parser 등록 세트
5. Permission Level 2+ 작업은 반드시 사용자 확인 로직 포함

## 핵심 원칙 (절대 깨지 말 것)
- AI tools are workers, not owners
- Human approval for Level 2+
- Local-first, Markdown is source of truth
- 파일 삭제/발행/공유는 Level 3 이상

## 다음 작업 (v0.3)
- [x] doctor 명령어 실제 진단 로직 강화
- [x] backup 고도화 (retention max_backups, config/storage.yaml)
- [x] status 명령어 실제 데이터 출력 (Approval Queue / Inbox / Audit / Backup)
- [ ] github-issue 명령어 실제 연결 (core/github_client.py 예정)
- [ ] n8n daily_project_brief.json 실제 워크플로우

## 테스트 방법
py core/vespera.py healthcheck
py core/vespera.py route 테스트
py core/vespera.py backup

## 주의사항
- BOM 문제 자주 발생 - 항상 Python write_text로 파일 쓸 것
- __pycache__ 는 파일 수정 후 항상 삭제
- Korean 포함 파일은 encoding utf-8 명시 필수
