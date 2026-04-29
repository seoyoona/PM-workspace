# PM Workspace

> Claude Code 기반 PM 워크플로우 자동화 — 아웃소싱 개발사에서 **한국 클라이언트 ↔ 베트남 개발팀** 사이 PM 반복 업무를 `/커맨드` 한 줄로 처리합니다.

## 이 워크스페이스가 해결하는 문제

| Before (수동) | After (자동화) |
|---|---|
| 미팅 후 노션 정리 30분 + Teams 메시지 15분 + 카톡 10분 | `/meeting-note` 한 번이면 3개 동시 생성 |
| 고객 요청을 매번 영어로 번역하고 구조화 | `/dev-chat` 또는 `/to-spec`으로 자동 변환 |
| 개발팀 영어 메시지를 고객 카톡으로 매번 다시 작성 | `/client-chat`이 톤/용어 맞춰서 자동 변환 |
| 매일 "오늘 뭐하지?" 머리로 조합 | `/today-brief`로 아침 브리핑 |
| 할 일이 여러 곳에 흩어져 누락 | PM Action Hub + `/todo`로 통합 관리 |

## 사용 예시

```
# 고객 미팅 끝나면 — 러프한 메모만 넣으면 됨
/meeting-note --client rck
대표님이 질문지 삭제 안 된다고 하셨음
외부 QA 금요일 종료
질문지 안정화 최우선

→ Notion 미팅노트 자동 저장
→ Teams 영어 메시지 생성 (복붙용)
→ 카톡 한국어 메시지 생성 (복붙용)
```

## 20개 스킬

| 상황 | 스킬 | 출력 |
|------|------|------|
| 미팅 끝남 | `/meeting-note` | Notion 미팅노트 (한눈에 보기 + 확정 사항 + Action Items 불릿 + 범위 밖 + 메모 이슈 + PM 배경) + Teams(EN) + 카톡(KR) |
| 개발팀에 전달 | `/dev-chat` | 영어 Teams 메시지 (Light: 클라 원문→`Client ...` 중계 / 내부 메모→직접 번역 / Standard: 브리프) |
| 고객에게 전달 | `/client-chat` | 한국어 카톡 메시지 |
| 진행 중 변경 요청 / 큰 요청 / 스펙화 | `/to-spec` | 4-bucket triage gate (In-Round/Next-Round/Out-of-Scope/Confirm-Needed) → In-Round만 PM confirm 후 Notion 스펙 + 태스크 DB 자동 생성 |
| QA 플랜 작성 | `/qa-plan` | 프로젝트 전체 QA 9-section 플랜 (로컬, gitignored, **출력 영어**) — Scope / Roles·Accounts / Flow / P0·P1·EDGE·REG / Handoff Message / Review. v1.1: `--url <staging>` 명시 시 read-only guided navigation으로 화면 cross-check (depth 2 / max 10 pages) |
| 검수 요청 | `/qa-request` | 카톡 검수 요청 메시지 |
| QA 피드백 전달 | `/qa-feedback` | 내부 Tasks DB 영문 티켓 |
| 주간 보고 | `/weekly-report` | Notion 주간 리포트 |
| SRS 번역 | `/srs-translate` | 영어 구조화 번역 (Notion) — 비창작 원칙, Inferred 섹션 없음 |
| 킥오프 준비 | `/kickoff-prep` | 고객 안건(KR) + 내부 노트(EN) |
| 이슈 티켓 | `/issue-ticket` | Linear 티켓 |
| 데일리 스크럼 | `/daily-scrum` | Notion Daily Scrum Log + 영어 dev-chat Teams 전송 + PM 할 일 자동 PM Action Hub 등록 |
| 내부 싱크 | `/sync-note` | 영어 Teams 메시지 |
| 아침 브리핑 | `/today-brief` | 오늘 할 일 + Google Calendar 미팅 요약 |
| 할 일 추가 | `/todo` | PM Action Hub DB |
| SRS 초안 생성 | `/create-srs` | 한국어 SRS/기능명세 초안 (Notion) |
| Nexus 일별 기록 | `/nexus-daily` | Nexus OS row별 hours/memo 자동 입력 |
| 새 프로젝트 | `/new-project` | 로컬 파일 + Notion 뷰 자동 생성 |
| 워크스페이스 세팅 | `/setup-workspace` | Notion DB 5개 + 허브 페이지 + ID 교체 자동 (최초 1회) |

> **모바일:** Telegram Bot은 현재 Notion 연동 비활성 (cigro API 토큰 미발급)

## 설계 구조

### 워크스페이스 아키텍처

```
yoona-workspace/
├── CLAUDE.md                    # 전체 규칙 — 역할, 번역 원칙, Notion DB 연결
├── clients/{name}/CLAUDE.md     # 고객사별 컨텍스트 — 톤, 도메인, 담당자 성향
├── glossary/{name}.md           # 고객사별 용어집 — KR↔EN 매핑
├── templates/                   # 출력 구조 템플릿 — 스킬이 내부적으로 참조
├── telegram-bot/                # Telegram 봇 — 모바일 PM 스킬 (AWS Lambda)
├── scripts/migrate-pm.sh        # PM 마이그레이션 (수동 fallback)
├── docs/pm-onboarding.md        # → 세팅 가이드에 통합됨 (deprecated)
└── .claude/commands/            # 20개 스킬 파일
```

### 레이어드 컨텍스트 자동 로드

```
CLAUDE.md (전체 규칙)           → 항상 자동 로드
  └── clients/CLAUDE.md         → clients/ 진입 시 로드
      └── clients/{name}/CLAUDE.md → 해당 고객사 작업 시 로드
```

스킬 실행 시 `--client` 옵션으로 고객사를 지정하면, 해당 고객사의 톤/용어/도메인이 자동 적용됩니다. PM이 매번 설명할 필요 없이 한 번 세팅하면 모든 스킬에 반영됩니다.

### Notion DB 구조

| DB | 용도 | 사용 스킬 |
|---|---|---|
| 프로젝트 문서 | SRS, 킥오프, 핸드오프 | `/srs-translate`, `/kickoff-prep` |
| 커뮤니케이션 | 미팅노트, 주간리포트, 스펙 | `/meeting-note`, `/weekly-report`, `/to-spec` |
| 태스크 | 개발팀 구현 태스크 (스펙 출처 relation으로 스펙 페이지와 연결) | `/to-spec`, `/qa-feedback` |
| Daily Scrum Log | 프로젝트별 일일 체크인 | `/daily-scrum` |
| PM Action Hub | PM 운영 액션 (투두) | `/todo`, `/today-brief` |

### 프로젝트 구분 방식

- **클라이언트**(고객사) vs **프로젝트**(개발 건) 2계층 — 현재 1:1 매핑, 구조적 1:N 가능
- 모든 DB에 `클라이언트` + `프로젝트` 필드 → linked view 필터로 프로젝트별 분리 표시
- `--client`로 스킬 실행 시 `clients/{name}/CLAUDE.md` + `glossary/{name}.md` 자동 로드
- `/new-project` 한 번으로 로컬 파일 + DB 옵션 + PM Workspace 토글 자동 생성

### 스킬 간 관계

```
/meeting-note = source of truth (한눈에 보기 + 확정 사항 + Action Items 불릿 + 범위 밖 + 메모 이슈 + PM 배경)
  → /dev-chat (개발팀 전달)은 바로 진행할 일/확인 후 회신할 일 쿼리 → 서술 bullet
  → /client-chat (고객 전달)은 확인 후 회신할 일 WHERE owner=Client 쿼리 → 합니다체 서술

/create-srs = SRS 초안 생성
  → 여러 소스 → 한국어 SRS/기능명세 초안
  → /srs-translate, /kickoff-prep의 upstream

/to-spec = 진행 중 변경 요청 + 큰 요청 + 스펙화 단일 진입점 (in-flight delta)
  → 4-bucket triage gate (In-Round / Next-Round / Out-of-Scope / Confirm-Needed)
  → In-Round 항목 → PM Confirm Gate → Notion 스펙 페이지 + 태스크 DB 자동 생성
  → Next-Round / Out-of-Scope / Confirm-Needed → 로컬 markdown만 (Notion auto-write X)
  → 구 /change-brief는 본 스킬로 흡수 (deprecated)

/qa-plan = 프로젝트 전체 QA 플랜 (in-flight delta, 출력 영어)
  → /qa-plan dsa 한 번 호출 → 9-section 단일 Markdown → clients/<c>/<p>/qa/plans/QA-DSA-YYYYMMDD.md
  → P0/P1/EDGE/REG 시나리오 ID 통합 (구 SCN-* 폐기)
  → v1.1 --url <staging URL> 명시 시 Playwright read-only guided navigation
    (같은 도메인 / depth 2 / max 10 pages / destructive click 금지 / SRS와 충돌 시 SRS 우선)
  → 검수 후 PM이 /qa-feedback에 "QA Plan: QA-..." 또는 "Scenario: P0-NN" 메타 보존 (수동)
  → design.md는 §3 화면명 인용 보조만, primary source X

/today-brief = 아침 브리핑
  → PM Action Hub "오늘" + "진행 중" + Google Calendar 오늘 미팅 조회 (평일 10:30 자동)

/nexus-daily = Nexus OS 일별 기록
  → Notion 활동(PM Action Hub + 커뮤니케이션 DB) + Activity Log 자동 수집
  → Activity Log = dev-chat/client-chat/sync-note 사용 시 자동 기록 (.claude/activity-log.jsonl)
  → 프로젝트/시간/메모 생성 → Nexus row별 저장
  → 계층형 매칭 + alias registry (.claude/nexus-alias.md)

/qa-feedback = 고객 QA DB → 내부 티켓
  → 고객 피드백 읽기 → 번역 + 분류 → 내부 Tasks DB 생성
```

## 설계 원칙

- **언어 자동 분리** — 고객: 한국어(존댓말) / 개발팀: 영어(간결체)
- **모호함 플래그** — 임의 해석 없이 "Ambiguities" 섹션에 표시
- **번역 ≠ 추론** — 원문 번역과 Claude 추론을 명확히 분리 (`[추론]` 태그)
- **용어 일관성** — 고객사별 glossary 기반, 동의어 금지
- **복붙 가능** — 출력물을 그대로 Teams/카톡에 붙여넣기
- **PM Action ≠ Dev Task** — PM 운영 액션(회신, follow-up)과 개발 태스크 분리
- **전송 신뢰도** — Teams 전송은 HTTP code 검증 후에만 "전송 완료" 보고. timeout 15s + 실패 시 복사 fallback
- **중복 방지 (멱등성)** — 같은 주차/날짜/URL/제목 기준 중복 페이지 생성 차단. 덮어쓰기는 반드시 사용자 확인 후에만
- **보수적 자동화** — `--client` 자동 default는 24h 활동 기준 1개일 때만 + 명시 통보. `/todo` 프로젝트 자동 확정은 Notion select 옵션과 exact match일 때만
- **확인 프롬프트 표준** — 3~4지 선택지 + "추천: N" 명시 + 한 번에 하나의 확인 포인트만
- **Nexus PM Agent와 역할 경계** — 사내 공식 PM 에이전트가 sales→SRS→design.md→wireframe→handoff까지 Official source-of-truth 담당. 이 워크스페이스는 in-flight delta 레이어 (진행 중 변경 처리, QA, 운영 자동화). PM 산출물은 항상 `Draft / PM Review / Dev-Handoff` 라벨, **Official 산출물 생성·편집 금지**. Nexus MCP는 현재 메타데이터(project/task/contract) read만 가능, 문서 콘텐츠(SRS / design.md / 녹음) read 불가 → 그런 입력은 로컬·Notion에서 받는다.
- **Hard-fail 최소화** — 외부 의존성(SRS, design.md) 부재 시 스킬 전체 실패 대신 partial-skip (해당 섹션만 "확인 필요"). Notion URL fetch 실패 시 free-text fallback.
- **자동 chain 금지** — 신규 스킬은 다음 스킬을 자동 트리거하지 않음. "다음 단계" 안내만 출력. PM 수동 게이트.
- **AI 공수 산정 금지** — 구체 수치(MD/hour/day) 임의 산정 금지, Impact 레벨만(Low/Medium/High/Unknown).

## 고도화 운영 방식

이 워크스페이스의 모든 개선은 3단계 프로세스로 진행됩니다:

### 1. Planning
- 현재 상태 진단 + 문제 정의
- PM 실제 업무 흐름 기준으로 병목/중복/누락 점검
- "지금 바꿔야 하는 것" vs "나중에 해도 되는 것" 구분
- 외주 개발사 PM 운영 전문가 관점에서 판단 — 기술적으로 가능해 보이는 것보다, 팀이 바로 도입할 수 있는지를 우선

### 2. Execution
- 승인된 범위만 수정
- 파일/문서/스킬/DB 변경 사항 명확히 보고
- 문서 3개 (guide.md / Notion Guide / Notion Construction) 항상 동기화

### 3. Evaluation
- 목표 달성 여부 냉정하게 검토
- 실제 테스트된 것과 설계 가정을 구분
- 다음 라운드 개선 항목 정리

## 연동 서비스

| 서비스 | 용도 | 연결 방식 |
|---|---|---|
| **Notion** | 문서, 미팅노트, 리포트, PM Action Hub, 프로젝트/QA/Tasks | `notion-cigro` MCP 단일 경로 (cigro 워크스페이스, OAuth) — 모든 DB가 cigro에 위치 |
| **Linear** | 이슈 티켓 | MCP (브라우저 인증) |
| **Google Workspace** | 스프레드시트, 드라이브, **캘린더** | MCP (서비스 계정) |
| **Nexus OS** | 일별 근무시간 기록 | MCP (HTTP) + curl fallback |
| **Microsoft Teams** | 개발팀 그룹채팅 직접 전송 | Power Automate (HTTP trigger) |
| **Figma** | 디자인 파일 스펙 확인, 컴포넌트 정보 조회 (선택) | MCP (npx figma-developer-mcp, Personal Access Token) |
| **Telegram Bot** | 비활성 — cigro API 토큰 미발급으로 Notion 연동 불가 | AWS Lambda (아카이브) |

## License

MIT
