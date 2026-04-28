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
진행 중 변경 요청 / 큰 요청 / 스펙화 → /to-spec
QA 플랜 작성        → /qa-plan
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

## 커맨드 레퍼런스 (20개)

한 줄 요약. 입력 옵션 · 동작 단계 · Hard Boundaries · 예시는 `.claude/commands/{커맨드명}.md` 본문 참조.

| 커맨드 | 한 줄 설명 |
|---|---|
| `/setup-workspace` | 워크스페이스 초기 세팅 — Notion DB 5개 + 허브 페이지 + ID 교체 (최초 1회) |
| `/new-project` | 새 프로젝트 셋업 — 로컬 파일 + Notion 뷰 + Project management |
| `/create-srs` | 여러 소스 → 한국어 SRS/기능명세 초안 (Notion 프로젝트 문서 DB) |
| `/srs-translate` | 한국어 SRS → 영어 구조화 번역 (Notion) |
| `/kickoff-prep` | 킥오프 미팅 안건(KR) + 내부 노트(EN) 2페이지 |
| `/meeting-note` | 미팅 녹취/메모 → Notion 미팅노트 + Teams + 카톡 한번에 |
| `/dev-chat` | 고객 요청/미팅 결과 → 영어 Teams 메시지 (Light/Standard 자동) |
| `/client-chat` | 개발팀 메시지 → 한국어 카톡 메시지 (질문/업데이트 자동 감지) |
| `/sync-note` | 내부 sync 미팅 → 개발팀 Teams 메시지 |
| `/to-spec` | 클라이언트 요청 4-bucket triage gate (In-Round/Next-Round/Out-of-Scope/Confirm-Needed) → In-Round만 PM confirm 후 Notion 스펙 + 태스크 DB 자동 생성 |
| `/change-brief` | (deprecated — `/to-spec`으로 흡수됨, 1-2주 후 제거 예정) |
| `/qa-plan` | 프로젝트 전체 QA 9-section 플랜 (범위·역할·플로우·P0/P1/EDGE/REG·전달·확인) — 자동 git ignored |
| `/qa-request` | 검수 요청 카톡 메시지 (web/admin/apk/program/testflight 자동 감지) |
| `/qa-feedback` | 고객 QA DB → 내부 Tasks DB 영문 티켓 (번역+분류) |
| `/issue-ticket` | Linear 이슈 티켓 (한/영 입력) |
| `/daily-scrum` | 프로젝트별 daily check-in → Notion + 영어 dev-chat Teams + PM 할 일 자동으로 PM Action Hub 등록 |
| `/today-brief` | 아침 브리핑 — PM Action Hub + Google Calendar |
| `/todo` | PM 액션 빠르게 추가 → PM Action Hub DB |
| `/weekly-report` | 주간 리포트 (Notion 커뮤니케이션 DB) |
| `/nexus-daily` | Nexus OS 일별 근무시간 자동 기록 |

---

## 업무별 흐름 가이드

상황별로 어떤 커맨드를 어떤 순서로 쓰는지. 각 커맨드의 옵션·세부 동작은 위 [커맨드 레퍼런스](#커맨드-레퍼런스-20개) 안내대로 `.claude/commands/{커맨드명}.md` 본문 참조.

### 1. 새 프로젝트 시작

```
영업팀 인계
  ↓ /new-project --client <name> --project <name>
SRS 받음 (한국어)
  ↓ /create-srs (소스 → 한국어 SRS 초안)
  ↓ PM 검토
  ↓ /srs-translate (영어 구조화)
킥오프 준비
  ↓ /kickoff-prep (한국어 안건 + 영어 내부 노트)
```

### 2. 미팅이 끝났다

```
녹취록/메모
  ↓ /meeting-note (3-part: Notion 미팅노트 + Teams + 카톡)
미팅에서 큰 변경 요청 발생
  ↓ /to-spec (4-bucket triage gate + In-Round만 PM confirm 후 Notion 자동 생성)
결정된 dev 액션 (자동 추출)
  ↓ /dev-chat
고객 follow-up (자동 추출)
  ↓ /client-chat
```

### 3. 진행 중 변경 요청 / 추가 기획

```
클라/미팅/QA 피드백 (scope·design 영향 가능성)
  ↓ /to-spec --client <name> [요청 내용 또는 Notion URL]
4-bucket triage (In-Round / Next-Round / Out-of-Scope / Confirm-Needed)
  ↓ In-Round 항목 → PM Confirm Gate (1 진행 / 2 수정 / 3 취소)
PM 진행 선택 시
  ↓ Notion 스펙 페이지 + 태스크 DB 자동 생성 + linked view 수동 안내
Confirm-Needed 항목
  ↓ §5 → /client-chat 별도 실행
Out-of-Scope 항목
  ↓ §5 거절·견적 안내 → /client-chat 별도 실행
Next-Round 항목
  ↓ 로컬 markdown 기록만, 다음 라운드 진입 시 재검토
```

> 구 `/change-brief`는 `/to-spec`으로 흡수됨 (deprecated, 1-2주 후 제거 예정).

### 4. QA 라운드

```
SRS / Change Brief In-Round / QA history / 클라 컨텍스트 기준 전체 QA 플랜 작성 (PM/QA 내부)
  ↓ /qa-plan <client>   (positional, 대소문자 무관, project/round/srs/brief 모두 자동 탐색)
검수 시작 안내 (고객 카톡)
  ↓ /qa-request
고객 QA 피드백 들어옴
  ↓ /qa-feedback (번역+분류 → 내부 Tasks DB)
  ↓ 본문 첫 줄에 "시나리오 ID: SCN-..." 메타 보존 (수동)
정식 티켓이 필요한 큰 버그
  ↓ /issue-ticket → Linear
```

### 5. 매일 / 매주 운영

- 아침 브리핑 (평일 10:30 자동): `/today-brief`
- 데일리 스크럼: `/daily-scrum --client <name>`
- 빠른 할 일 추가: `/todo [project] 내용`
- 주간 보고: `/weekly-report --client <name>`
- 퇴근 전 시간 기록: `/nexus-daily`

### 6. 통신 변환 보조 (수시)

- 고객 → 개발팀: `/dev-chat` (Light = 클라 원문 중계 / Standard = 브리프)
- 개발팀 → 고객: `/client-chat` (질문/업데이트 자동 감지)
- 내부 sync → 개발팀: `/sync-note`

---

## 개별 커맨드 상세

각 커맨드의 입력 옵션 · 동작 단계 · Hard Boundaries · 출력 예시 · 안전장치는 본문 파일 참조:

```
.claude/commands/{커맨드명}.md
```

핵심 공통 정책은 아래 [공통 최적화 규칙](#공통-최적화-규칙-배치-abc) 섹션 + 다음 invariant 참조.

**모든 신규 in-flight delta 스킬에 적용되는 invariant:**

- **Official 산출물 생성·편집 금지** (Nexus PM Agent 영역) — Draft / PM Review / Dev-Handoff 라벨 산출물만 생성 가능
- **Hard-fail 최소화** — 외부 의존(SRS, design.md) 부재 시 partial-skip (해당 섹션만 "확인 필요")
- **자동 chain 트리거 금지** — 다음 단계는 안내만, PM 수동 게이트
- **AI 공수 산정 금지** — 구체 MD/hour/day 임의 산정 X, Impact / priority 레벨만
- **Nexus MCP는 메타데이터 only** — SRS / design.md / 녹음 / transcript은 Nexus MCP로 read 불가, 로컬·Notion에서 받음
- **추측성 UI 위치 자동 제안 금지** — source(SRS/design.md/Change Brief) 근거 없으면 `[확인 필요]`

---

## 공통 최적화 규칙 (배치 A/B/C)

모든 스킬에 일관 적용되는 동작 규칙.

### `--client` 보수적 default 제안 (B1)

`--client` 인자를 완전히 누락하면 `.claude/activity-log.jsonl` 최근 24h 기록을 참조:
- 단일 client → "최근 활동 기준 `--client=Koboom`으로 진행합니다" 명시 후 진행 (사용자가 Ctrl+C로 중단 가능)
- 2개 이상 → 숫자 선택지 (자동 적용 금지)
- 0개 → PM에게 `--client` 확인 요청

적용 스킬: `client-chat`, `dev-chat`, `daily-scrum`, `weekly-report`, `issue-ticket`, `qa-request`, `sync-note`, `to-spec`.  
전문: `templates/client-default.md`

### 중복 페이지 생성 방지 (C1 멱등성 가드)

| 스킬 | Unique key | 정책 |
|------|-----------|------|
| `weekly-report` | 클라 + 주차(월~일) | archive + 재생성 (3지선다) |
| `meeting-note` | 회의명 + 날짜 + 클라 | archive + 재생성 또는 중복 허용 |
| `srs-translate` | 프로젝트 + 유형 + 언어(KR→EN) | archive + 재생성 또는 v2 생성 |
| `todo` | 제목 + 프로젝트 + 작성일 | skip + 알림 |
| `qa-feedback` | 원본 QA URL | skip + 알림 (덮어쓰기 금지) |
| `nexus-daily` | 날짜 + 태스크 ID | 이미 upsert 구조 (미리보기에 "(덮어씀)" 표시) |

공통 안전장치: archive 실패 시 생성 중단 / 자동 archive 금지 / 2건+ 중복 시 가장 최근 1건만 대상.

### Teams 전송 신뢰도 (U1/U2)

- curl에 `--max-time 15 --connect-timeout 5` 강제 (224~296초 hang 방지)
- HTTP code 검증 후에만 "✅ 전송 완료 (HTTP $CODE)" 보고
- 5xx/timeout → 1회 자동 재시도 / 4xx → 재시도 없음
- 실패 시 `SEND_OK=0` → activity-log 기록 안 함 + "복사해서 수동 전송" fallback 안내
- 공통 snippet: `templates/teams-post.md`

### 확인 프롬프트 표준 (A6)

- 3~4개 이내 숫자 선택지 (4개는 필수 옵션이 4개일 때만)
- 반드시 `추천: N` 표시
- 한 번에 하나의 확인 포인트 (결정 2개가 늘 세트면 조합 옵션으로)
- 자유서술 확인은 예외 (수정 요청처럼 본질적 free-form인 경우만)

### 컨텍스트 로드 병렬화 (A4)

`clients/{name}/CLAUDE.md` + `glossary/{name}.md` + (선택) Notion fetch는 서로 독립 → 12개 스킬에서 병렬 호출 hint 주석으로 표시.

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
| Notion DB 4개 (프로젝트 SELECT: 프로젝트 문서 / 커뮤니케이션 / 태스크 / Daily Scrum Log) | 페이지 생성 시 프로젝트 태깅 + linked view 필터 | `/new-project` 자동 |
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
├── templates/teams-post.md      # Teams 전송 공통 snippet (U1/U2)
├── templates/client-default.md  # --client 보수적 default 규칙 (B1)
└── .claude/commands/            # 스킬 파일 (20개)
    ├── meeting-note.md
    ├── dev-chat.md
    ├── client-chat.md
    ├── change-brief.md          # (deprecated — /to-spec으로 흡수, 1-2주 후 제거)
    ├── qa-plan.md
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
    ├── nexus-daily.md
    └── setup-workspace.md
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

## Figma MCP (선택)

- 디자인 파일 스펙 확인, 컴포넌트 정보 조회 시 사용
- 연결: `claude mcp add figma -e FIGMA_API_KEY="토큰" -- npx -y figma-developer-mcp`
- 토큰 발급: Figma → Settings → Security → Personal access tokens → Generate new token

## Telegram Bot (비활성)

- cigro workspace API 토큰 발급 불가로 Notion 연동 비활성
- dev_chat, client_chat, sync_note는 Notion 불필요라 작동 가능하나, todo/today_brief의 Notion 접근 불가
- 코드: `telegram-bot/` 디렉토리 (아카이브)
