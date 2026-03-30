# PM Workspace — 가이드

> **이 파일은 로컬 백업입니다. 최신 가이드는 Notion을 참고하세요.**
>
> 📖 가이드 (사용법): https://www.notion.so/32c3aae9a8948142a142e7e95a77b9a8
> 🏗️ 설계 문서 (구조/규칙): https://www.notion.so/32c3aae9a89480a9b71cead34358cc0f

---

## Quick Start

```
미팅 끝났다        → /meeting-note
개발팀에 전달      → /dev-chat
고객에게 전달      → /client-chat
고객 요청이 크다   → /to-spec
검수 요청이다      → /qa-request
주간 보고          → /weekly-report
새 프로젝트        → /new-project
SRS 번역          → /srs-translate
킥오프 준비        → /kickoff-prep
이슈 티켓         → /issue-ticket
```

모든 스킬 공통: `/스킬명 [내용] --client [고객사명]`

---

## 핵심 구조

- **meeting-note** = source of truth → dev-chat / client-chat은 downstream
- **dev-chat**: Light (단순 전달) / Standard (복잡한 내용) 자동 감지
- **client-chat**: 질문형 / 업데이트형 / 혼합형 자동 감지
- **qa-request**: 검수/전달 요청 전용 (client-chat과 분리)
- **to-spec**: 큰 기능/변경사항 → 스펙 페이지 + 태스크 DB

---

## 폴더 구조

```
yoona-workspace/
├── CLAUDE.md                    # 전체 규칙 (항상 자동 로드)
├── guide.md                     # 이 파일 (로컬 백업)
├── clients/{name}/CLAUDE.md     # 고객사별 컨텍스트
├── glossary/{name}.md           # 고객사별 용어집
├── templates/                   # 문서 구조 템플릿
├── handoffs/CLAUDE.md           # 개발팀 전달 체크리스트
└── .claude/commands/            # 스킬 파일 (10개)
    ├── meeting-note.md
    ├── dev-chat.md
    ├── client-chat.md
    ├── to-spec.md
    ├── qa-request.md
    ├── weekly-report.md
    ├── new-project.md
    ├── srs-translate.md
    ├── kickoff-prep.md
    └── issue-ticket.md
```

---

## Notion 연동

- PM Workspace: https://www.notion.so/32c3aae9a8948001bf49fba5b9c4c34a
- 프로젝트 문서 DB / 커뮤니케이션 DB / 태스크 DB
- MCP 연결: `/mcp` → Notion 인증
