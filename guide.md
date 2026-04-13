# PM Workspace — 가이드

> **이 파일은 로컬 백업입니다. 최신 가이드는 Notion을 참고하세요.**
>
> 📖 세팅 가이드: https://www.notion.so/cigroio/2733aae9a89482a0a3d481db51977159
> 🏗️ 설계 문서 (구조/규칙): https://www.notion.so/cigroio/3ca3aae9a8948251afa68142d0de3f54

---

## Quick Start

```
워크스페이스 세팅   → /setup-workspace
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
SRS 초안 생성      → /create-srs
Nexus 일별 기록    → /nexus-daily
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
- **today-brief**: 아침 브리핑 — PM Action Hub "오늘" + "진행 중" 조회 + Google Calendar 오늘 미팅 조회. "오늘 뭐해야돼"로 수동 실행
- **todo**: PM 액션 빠르게 추가 → PM Action Hub DB — 제목만 저장 (속성 없음)
- **qa-feedback**: 고객 QA DB → 번역 + 분류 → 내부 Tasks DB 티켓 자동 생성
- **create-srs**: 여러 소스 자료 → 한국어 SRS/기능명세 초안 생성 → Notion 프로젝트 문서 DB 저장. 비창작 원칙(소스에 없는 기능 추가 금지). 미리보기 필수
- **nexus-daily**: Nexus OS 일별 기록 자동화 — Notion 활동(PM Action Hub + 커뮤니케이션 DB) + Activity Log(dev-chat/client-chat/sync-note 사용 기록) 자동 수집 → 프로젝트/시간/메모 자동 생성 → 미리보기 확인 → Nexus row별 저장. 계층형 매칭(alias→exact→normalized→substring) + `.claude/nexus-alias.md` 프로젝트 매핑

---

## 프로젝트 구분 방식

프로젝트가 시스템 전체에서 어떻게 구분되고 관리되는지 설명합니다.

### 클라이언트 vs 프로젝트
- **클라이언트** = 고객사 (회사 단위). 예: Koboom, RCK, 21gram
- **프로젝트** = 해당 고객사의 개발 건 (서비스 단위). 예: Koboom, CareerPlan
- 현재 **1:1 매핑**이지만, 구조적으로 1:N 가능 (1:N 시 `--project`로 명시)

### 프로젝트가 등록되는 곳

| 위치 | 역할 | 등록 방법 |
|---|---|---|
| `clients/{name}/CLAUDE.md` | 톤·도메인·담당자 컨텍스트 | `/new-project` 자동 |
| `glossary/{name}.md` | 용어집 (KR↔EN) | `/new-project` 자동 |
| Notion DB 3개 (프로젝트 SELECT) | 페이지 생성 시 프로젝트 태깅 | `/new-project` 자동 |
| PM Workspace 토글 | 프로젝트별 linked view 모음 | `/new-project` 자동 |
| `.claude/nexus-alias.md` | Nexus OS 프로젝트 매핑 | 수동 추가 |
| `.env.teams` | Teams 그룹채팅 ID | `/new-project` 안내 (선택) |

### 스킬에서의 프로젝트 라우팅
- `--client koboom` → `clients/koboom/CLAUDE.md` + `glossary/koboom.md` 자동 로드
- Notion 페이지 생성 시 `클라이언트` + `프로젝트` 속성 자동 세팅
- 프로젝트명 미지정 시 CLAUDE.md의 `프로젝트명` 사용
- **페이지 생성 시 클라이언트·프로젝트 둘 다 필수** — 하나라도 빠지면 linked view에서 누락

### 새 프로젝트 추가
`/new-project --client acme --project acme-v2` → 위 항목 자동 생성. Nexus alias + Teams chat ID만 수동.

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
├── scripts/migrate-pm.sh        # PM 마이그레이션 (수동 fallback)
├── docs/pm-onboarding.md        # → 세팅 가이드에 통합됨 (deprecated)
└── .claude/commands/            # 스킬 파일 (17개)
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
    ├── qa-feedback.md
    ├── create-srs.md
    └── nexus-daily.md
```

### Nexus OS 연동 파일
```
.claude/
├── nexus-alias.md               # 프로젝트 약칭 → Nexus projectName 매핑 (PM별)
├── activity-log.jsonl           # 스킬 사용 로그 (nexus-daily 보조 소스, gitignored)
└── commands/nexus-daily.md      # /nexus-daily 스킬
```

---

## Notion 연동

- 모든 DB가 **cigro 워크스페이스**에 위치 (PM Action Hub 포함)
- PM Workspace 페이지: cigro 워크스페이스 내 YOONA Workspace 하위
- 프로젝트 문서 DB / 커뮤니케이션 DB / 태스크 DB / Daily Scrum Log DB / PM Action Hub DB
- 연결 방식: **`notion-cigro` MCP 단일 경로**
  - Notion 공식 HTTP MCP (`https://mcp.notion.com/mcp`), OAuth 인증
  - 페이지 생성: `notion-create-pages` (data_source_id 사용)
  - 페이지 읽기: `notion-fetch`
  - 페이지 수정: `notion-update-page`
  - DB schema 수정: `notion-update-data-source`
  - REST API (`NOTION_API_KEY`) 불필요 — 완전 제거됨

## Google Calendar 연동

- `/today-brief`에서 오늘 미팅 자동 조회
- Teams 캘린더를 Google Calendar에 ICS 구독하면 Teams 일정도 포함
- Claude Code 운영: Google Workspace MCP
- Telegram Bot: OAuth2 (GOOGLE_CLIENT_ID/SECRET/REFRESH_TOKEN Lambda 환경변수 — MCP 토큰 파일에서 소싱)

## Nexus OS 연동

- `/nexus-daily`에서 일별 근무시간 기록 자동화
- Nexus MCP 파싱 이슈로 Bash + curl fallback 사용
- 프로젝트 매핑: `.claude/nexus-alias.md` — 약칭 → Nexus projectName 1:1 매핑
- 계층형 매칭: alias(자동확정) → exact(자동확정) → normalized(자동확정) → substring(확인요청) → 실패(선택요청)
- Activity Log: `.claude/activity-log.jsonl` — Notion에 기록이 안 남는 스킬(dev-chat/client-chat/sync-note) 사용 시 자동 기록 → nexus-daily 보조 소스로 활용
- PM 온보딩: `/setup-workspace` 스킬 (DB 5개 + 허브 페이지 + ID 교체 자동화)
- 수동 마이그레이션 fallback: `scripts/migrate-pm.sh`

## Teams 연동

- Power Automate flow로 그룹채팅 직접 전송 (선택)
- 설정: `.env.teams`에 flow URL + 프로젝트별 chat ID
- 대상 스킬: `/dev-chat`, `/sync-note`
- 미설정 시 기존처럼 복사 모드로 동작

## Telegram Bot (비활성)

- cigro workspace API 토큰 발급 불가로 Notion 연동 비활성
- dev_chat, client_chat, sync_note는 Notion 불필요라 작동 가능하나, todo/today_brief의 Notion 접근 불가
- 코드: `telegram-bot/` 디렉토리 (아카이브)
