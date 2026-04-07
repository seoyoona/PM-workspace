# PM Workspace — 가이드

> **이 파일은 로컬 백업입니다. 최신 가이드는 Notion을 참고하세요.**
>
> 📖 세팅 가이드: https://www.notion.so/339823375b0c804785bed2fc0da702a4
> 🏗️ 설계 문서 (구조/규칙): https://www.notion.so/339823375b0c80fe9a02f02713ac32be

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
데일리 스크럼      → /daily-scrum
내부 싱크 미팅     → /sync-note
오늘 뭐하지?      → /today-brief
할 일 추가        → /todo
QA 피드백 전달     → /qa-feedback
```

모든 스킬 공통: `/스킬명 [내용] --client [고객사명]`

---

## CLI vs Desktop 앱

- **세팅/운영**: CLI 사용 (`claude mcp add`, `claude mcp list`, workspace 이동 등)
- **일상 업무**: Desktop 앱 병행 가능 — `/dev-chat`, `/client-chat` 등 복붙용 메시지는 Desktop 앱에서 확인하는 게 더 편함
- 단, Desktop 앱도 `yoona-workspace` 폴더에서 열어야 스킬이 정상 동작

---

## 핵심 구조

- **meeting-note** = source of truth → dev-chat / client-chat은 downstream
- **dev-chat**: Light(번역만) / Standard(구조화 브리프) 자동 감지 + 수정 확인 후 Teams 전송
- **client-chat**: 질문형 / 업데이트형 / 혼합형 자동 감지
- **qa-request**: 검수/전달 요청 전용 (client-chat과 분리)
- **to-spec**: 큰 기능/변경사항 → 스펙 페이지 + 태스크 DB (linked view 수동 추가 후 개발자가 티켓으로 확인)
- **daily-scrum**: 프로젝트별 daily check-in → Notion DB 로그 누적
- **sync-note**: 내부 sync 미팅 → 개발팀 Teams 메시지 + 직접 전송 (선택)
- **today-brief**: 아침 브리핑 — PM Action Hub "오늘" + "진행 중" 조회 + Google Calendar 오늘 미팅 조회. 평일 10:30 AWS EventBridge → Lambda → 텔레그램 자동 푸시 (Claude Code 꺼져 있어도 동작). "오늘 뭐해야돼"로 수동 실행도 가능. Calendar: OAuth2 Lambda 환경변수로 연동
- **todo**: PM 액션 빠르게 추가 → PM Action Hub DB — 제목만 저장 (속성 없음)
- **qa-feedback**: 고객 QA DB → 번역 + 분류 → 내부 Tasks DB 티켓 자동 생성

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
├── telegram-bot/                # Telegram 봇 (AWS Lambda, 선택)
└── .claude/commands/            # 스킬 파일 (15개)
    ├── meeting-note.md
    ├── dev-chat.md
    ├── client-chat.md
    ├── to-spec.md
    ├── qa-request.md
    ├── weekly-report.md
    ├── new-project.md
    ├── srs-translate.md
    ├── kickoff-prep.md
    ├── issue-ticket.md
    ├── daily-scrum.md
    ├── sync-note.md
    ├── today-brief.md
    ├── todo.md
    └── qa-feedback.md
```

---

## Notion 연동

- PM Workspace: https://www.notion.so/339823375b0c8001ab28d33783105b8b
- 프로젝트 문서 DB / 커뮤니케이션 DB / 태스크 DB / Daily Scrum Log DB / PM Action Hub DB
- 연결 방식 (4-tier):
  1. `notion-cigro` — Notion 공식 MCP (HTTP, `https://mcp.notion.com/mcp`) — **cigro 워크스페이스** 접근 (프로젝트, QA, Tasks 등). 브라우저 OAuth 인증
  2. `notion-yoona` — Notion 공식 MCP (HTTP, `https://mcp.notion.com/mcp`) — **yoona 개인 워크스페이스** 접근 (PM Workspace, 프로젝트 문서/커뮤니케이션/태스크 DB 등). 브라우저 OAuth 인증
  3. `notion` (2.x) + `notion-v1` (1.9.1) — `@notionhq/notion-mcp-server` npm 패키지 — yoona 워크스페이스 접근. `notion-v1`은 `/new-project` view filter용으로만 유지
  4. REST API (`NOTION_API_KEY` 환경변수 + Bash curl) — DB select option 관리, Notion 페이지 블록 조작 등 MCP로 안 되는 작업용

## Google Calendar 연동

- `/today-brief`에서 오늘 미팅 자동 조회
- Teams 캘린더를 Google Calendar에 ICS 구독하면 Teams 일정도 포함
- Claude Code 운영: Google Workspace MCP
- Telegram Bot: OAuth2 (GOOGLE_CLIENT_ID/SECRET/REFRESH_TOKEN Lambda 환경변수 — MCP 토큰 파일에서 소싱)

## Teams 연동

- Power Automate flow로 그룹채팅 직접 전송 (선택)
- 설정: `.env.teams`에 flow URL + 프로젝트별 chat ID
- 대상 스킬: `/dev-chat`, `/sync-note`
- 미설정 시 기존처럼 복사 모드로 동작

## Telegram Bot (선택)

- 모바일에서 핵심 5개 스킬 사용 가능 (이동 중 시나리오 커버)
- AWS Lambda + API Gateway + Claude API 기반
- 대상 스킬: `/dev_chat`, `/client_chat`, `/sync_note`, `/todo`, `/today_brief`
- Teams 전송: `/dev_chat`, `/sync_note` 결과에 inline 버튼으로 전송 가능
- 코드: `telegram-bot/` 디렉토리
- 배포: SAM CLI (`template.yaml` + `deploy.sh`)
- 전체 활성: dev_chat, client_chat, sync_note, todo, today_brief + Teams 전송
- todo: 제목만 저장 / today_brief: Notion + Google Calendar 연동 완료, 평일 10:30 EventBridge 자동 푸시
