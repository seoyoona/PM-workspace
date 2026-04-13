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

## 18개 스킬

| 상황 | 스킬 | 출력 |
|------|------|------|
| 미팅 끝남 | `/meeting-note` | Notion 미팅노트 + Teams(EN) + 카톡(KR) |
| 개발팀에 전달 | `/dev-chat` | 영어 Teams 메시지 (Light: 번역만 / Standard: 브리프) |
| 고객에게 전달 | `/client-chat` | 한국어 카톡 메시지 |
| 큰 요청 | `/to-spec` | Notion 스펙 + 태스크 DB |
| 검수 요청 | `/qa-request` | 카톡 검수 요청 메시지 |
| QA 피드백 전달 | `/qa-feedback` | 내부 Tasks DB 영문 티켓 |
| 주간 보고 | `/weekly-report` | Notion 주간 리포트 |
| SRS 번역 | `/srs-translate` | 영어 구조화 번역 (Notion) — 비창작 원칙, Inferred 섹션 없음 |
| 킥오프 준비 | `/kickoff-prep` | 고객 안건(KR) + 내부 노트(EN) |
| 이슈 티켓 | `/issue-ticket` | Linear 티켓 |
| 데일리 스크럼 | `/daily-scrum` | Notion Daily Scrum Log |
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
└── .claude/commands/            # 18개 스킬 파일
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
/meeting-note = source of truth
  → /dev-chat (개발팀 전달)은 여기서 추출
  → /client-chat (고객 전달)은 여기서 추출

/create-srs = SRS 초안 생성
  → 여러 소스 → 한국어 SRS/기능명세 초안
  → /srs-translate, /kickoff-prep의 upstream

/to-spec = 큰 요청 처리
  → 스펙 페이지 + 태스크 DB 동시 생성

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
| **Telegram Bot** | 비활성 — cigro API 토큰 미발급으로 Notion 연동 불가 | AWS Lambda (아카이브) |

## License

MIT
