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

- **meeting-note** = source of truth → dev-chat / client-chat은 downstream. Notion 친화 **불릿 기반 구조**: `한눈에 보기` → `이번 미팅에서 확정된 것` → `Action Items` (바로 진행할 일 / 확인 후 회신할 일) → `이번 라운드 범위 밖` → `메모해둘 이슈` → `PM 참고 배경`. 2-phase 파이프라인(Phase A Raw 추출 → Phase B 분류 매핑). Action Items는 표 대신 owner 볼드 불릿, 모호하면 `메모해둘 이슈`로 보수 승격. Part2/3은 쿼리 → Teams/카톡 톤 서술.
- **dev-chat**: Light(번역만) / Standard(구조화 브리프) 자동 감지. **Light 입력 타입 감지**: 클라 메시지 원문(한국어 존댓말) 복붙이면 `Client confirmed... / Client reports... / Client is asking...` 중계 프레이밍 사용 (dev팀이 PM을 주체로 오해 방지), PM 내부 메모/반말은 프레이밍 없이 직접 번역. **출력 직후 선택지**: Light = 4지선다(`1.전송(추천) / 2.수정 / 3.복사만 / 4.취소`), Standard = 3지선다(`1.전송(추천) / 2.수정 / 3.취소`). Teams 전송은 HTTP code 검증 후에만 완료 보고 (timeout 15s). Closing 문구 없음. 클라이언트 장문은 핵심만 증류. 도메인 한국어 용어 괄호 병기.
- **client-chat**: 짧은 메시지 기본 (2-5문장). 합니다체. 섹션 헤더 금지. **인사+용건+질문 setup을 1줄에 병합**, 프로젝트명/완충 표현/의미 중복 금지. 느낌표는 메시지당 1개 이내(친근한 인사용). 구조화는 항목 5개 이상 시에만. CLAUDE.md 언어 지정 시 해당 언어로 출력.
- **qa-request**: 검수/전달 요청 전용 (client-chat과 분리)
- **to-spec**: 큰 기능/변경사항 → 스펙 페이지 + 태스크 DB (linked view 수동 추가 후 개발자가 티켓으로 확인)
- **daily-scrum**: 프로젝트별 daily check-in → Notion DB 로그 누적
- **sync-note**: 내부 sync 미팅 → 개발팀 Teams 메시지 + 직접 전송 (선택)
- **today-brief**: 아침 브리핑 — PM Action Hub "오늘" + "진행 중" **단일 OR 쿼리로 조회** (속도 개선) + Google Calendar와 병렬 호출. "오늘 뭐해야돼"로 수동 실행
- **todo**: PM 액션 빠르게 추가 → PM Action Hub DB. **`[브라켓]` 값이 Notion `프로젝트` select 옵션과 exact match일 때만 자동 확정**. 실패 시 숫자 3지선다. 같은 제목+프로젝트+작성일이 이미 있으면 skip (retry loop 대응).
- **qa-feedback**: 고객 QA DB → 번역 + 분류 → 내부 Tasks DB 티켓 자동 생성. **미리보기 후 단일 3지선다** (`1.생성+Status변경(추천) / 2.생성만 / 3.취소`). 원본 QA URL 기준 중복은 skip + 알림 (덮어쓰기 금지).
- **srs-translate**: 한국어 SRS/기획서 → 영어 구조화 번역 → Notion 프로젝트 문서 DB 저장. 비창작 원칙(소스에 없는 내용 추가 금지, Inferred Requirements 섹션 없음). Ambiguities는 실제 모호함 있을 때만 포함. PM이 링크+명시적 지시 첨부 시에만 추가 내용 반영.
- **create-srs**: 여러 소스 자료 → 한국어 SRS/기능명세 초안 생성 → Notion 프로젝트 문서 DB 저장. 비창작 원칙(소스에 없는 기능 추가 금지). 미리보기 필수
- **nexus-daily**: Nexus OS 일별 기록 자동화 — Notion 활동(PM Action Hub + 커뮤니케이션 DB) + Activity Log(dev-chat/client-chat/sync-note 사용 기록) 자동 수집 → 프로젝트/시간/메모 자동 생성 → 미리보기 확인 → Nexus row별 저장. 계층형 매칭(alias→exact→normalized→substring) + `.claude/nexus-alias.md` 프로젝트 매핑. Nexus API curl은 timeout 30s (hang 방지).

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
├── templates/teams-post.md      # Teams 전송 공통 snippet (U1/U2)
├── templates/client-default.md  # --client 보수적 default 규칙 (B1)
└── .claude/commands/            # 스킬 파일 (18개)
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

## Figma MCP (선택)

- 디자인 파일 스펙 확인, 컴포넌트 정보 조회 시 사용
- 연결: `claude mcp add figma -e FIGMA_API_KEY="토큰" -- npx -y figma-developer-mcp`
- 토큰 발급: Figma → Settings → Security → Personal access tokens → Generate new token

## Telegram Bot (비활성)

- cigro workspace API 토큰 발급 불가로 Notion 연동 비활성
- dev_chat, client_chat, sync_note는 Notion 불필요라 작동 가능하나, todo/today_brief의 Notion 접근 불가
- 코드: `telegram-bot/` 디렉토리 (아카이브)
