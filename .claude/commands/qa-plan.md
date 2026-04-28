---
description: 프로젝트 전체 QA 플랜 1번 호출로 생성 — 9 섹션(Scope·Roles·Flow·P0·P1·Edge·Regression·Handoff Message·PM Review). 출력 영어 (Vietnamese QA 팀용)
argument-hint: <client> [--project name] [--round R{N}] [--srs path|URL] [--brief path] [--scope text]
allowed-tools: Read, Glob, Grep, Bash, mcp__notion-cigro__notion-fetch
---

# QA Plan — 프로젝트 전체 QA 플로우 / 시나리오 세트

## Arguments
사용자 입력: $ARGUMENTS

## Context
- 출력 템플릿: !`cat /Users/yoona/Documents/yoona-workspace/templates/qa-plan.md`
- 한 라운드 검수에 필요한 9-section QA 플랜을 단일 Markdown으로 생성. PM이 §8을 그대로 QA / 고객사에 전달
- **출력 언어: 영어 (Vietnamese QA 팀이 읽음).** 사용자 명시 한국어 인용(원문) 외에는 모두 영어로 작성
- **로컬 markdown 저장만** (`clients/<c>/<p>/qa/plans/QA-<CLIENT>-YYYYMMDD.md`, `clients/*/` 룰로 자동 git ignored)
- SRS / Change Brief / design.md 부재 시 **hard-fail 금지** — partial-skip (해당 영역만 `[TBD]` 또는 `(none)`)
- AI는 source 기반 작성. **source에 없는 사용자 흐름·기대결과·권한·데이터 조건 발명 금지**
- v1.5 단일 시나리오 도구는 본 스킬로 통합·대체됨 (deprecate 기간 0). 흡수된 룰: Scenario ID(P0/P1/EDGE/REG-NN) / 단계 수 가이드 / no-invention / partial-skip / git ignored / Internal banner / 자동 ticketing 금지 / 자동 브라우저 금지

## Source 우선순위 (중요)

QA 범위·기능 흐름의 **primary source**는 다음 순서:

1. **SRS / 기능명세** (`clients/<c>/<p>/srs.md` 또는 Notion 프로젝트 문서 DB)
2. **Change Brief** (`clients/<c>/<p>/change-briefs/*.md` 중 status=Dev-Handoff)
3. **기존 QA 피드백 / 버그 히스토리** (`clients/<c>/<p>/qa/` 또는 Notion 태스크 DB)
4. **client / project context** (`clients/<c>/CLAUDE.md`, `glossary/<c>.md`)
5. **design.md** — **UI/화면 표현 검증 보조 source만.** QA 범위·기능 흐름·권한·데이터 조건의 primary source로 사용 ❌

design.md를 1~4 대신 사용해 시나리오를 발명하면 no-invention 룰 위반.

## Hard Boundaries (이 스킬은 절대 안 함)

1. SRS / Change Brief / design.md / 프로젝트 문서 편집 — read-only 참조만
2. Official 산출물(SRS / design.md / wireframe) 생성·편집
3. Notion 페이지 자동 생성 (커뮤니케이션 / 태스크 / 프로젝트 문서 DB 모두)
4. Notion DB property 추가·수정 (`/qa-feedback` Tasks DB property화는 v1.6 보류)
5. Nexus MCP 호출 (`mcp__nexus-os__*` 어떤 것이든) — read·write 모두 금지
6. Linear 이슈 생성
7. `/qa-feedback` / `/issue-ticket` / `/to-spec` / `/dev-chat` / `/client-chat` 자동 트리거 — "다음 단계" 안내만
8. 자동 브라우저 실행 / Playwright / qa-agent-skills 연동 / expect 호출 (v3 영역)
9. 자동 스크린샷 / HAR 캡처
10. 구체 공수(MD/hour/day) AI 산정 — priority P0/P1/EDGE/REG만
11. 추측성 UI 위치·버튼·문구 위치 자동 제안 (source 근거 없으면 ❌)
12. source 없는 사용자 흐름·기대결과·권한·데이터 조건 발명
13. **design.md를 QA 범위·기능 흐름의 primary source로 사용** (UI/화면 표현 검증 보조만)
14. status 자동 승급 (작성중 → 검토 → 확정 자동 X)
15. 기존 QA plan 파일 자동 수정·삭제 (수정은 PM이 직접 편집)
16. 한 라운드 시나리오가 화면 수 × 1.5 초과 시 자동 작성 (경고만)
17. 한 시나리오가 13 단계 초과 시 자동 분리 (경고만)
18. `clients/*/`로 ignore되지 않는 경로에 QA plan 저장 — 항상 `clients/<c>/<p>/qa/plans/` 또는 fallback
19. 실제 QA plan 파일을 git add (정책상 ignored 유지)
20. `.gitignore` 수정
21. **Mermaid 다이어그램 기본 출력** (v1은 텍스트 트리·표만, `--diagram` 옵션은 향후 검토)
22. **9 섹션을 강제로 채우기** — source 부족 시 `[확인 필요]` 또는 `(현재 항목 없음)`로 명시. 발명 X
23. §4~§7을 고객·개발팀에 그대로 전달 (§8만 전달용)

## Instructions

### Step 1. 인자 파싱

**Positional:**
- 첫 번째 positional argument = `client` (대소문자 무관 — `dsa` / `DSA` / `Dsa` 모두 같은 client로 매칭). `--client` 명시 옵션도 지원

**Options (모두 선택, 미입력 시 자동 처리):**
- `--project <name>` — 자동 탐색 결과 override
- `--round R{N}` — 미입력 시 자동 결정 (Step 4)
- `--srs <path|URL>` — 자동 탐색 override
- `--brief <change-brief path>` — 특정 brief 1개만 사용
- `--scope <free-text>` — 이번 라운드 검수 범위를 PM이 좁히고 싶을 때

**client 미입력 시:**
- `templates/client-default.md` 24h activity-log 기준 default 제안. activity-log 0건이면 사용자에게 client 입력 요청 (저장 안 하고 화면 출력만 — 3순위 fallback)

### Step 2. Project Resolution

`clients/<client>/` 하위 project 디렉토리 탐색:
- **1개 발견** → 자동 선택. preview에 `선택된 project: X (근거: 1개만 존재)` 1줄 출력
- **여러 개** → 최근 mtime · 활성 상태 · `clients/<c>/CLAUDE.md`의 `프로젝트명` 일치 등으로 정렬 후 추천 1개 + 숫자 선택지:
  ```
  [확인 필요] 다음 project 중 선택해 주세요:
  1. <prj1>  (근거: 최근 수정 2일 전, client CLAUDE.md 프로젝트명과 일치) ← 추천
  2. <prj2>  (근거: 최근 수정 14일 전)
  추천: 1
  ```
- **0개** → frontmatter `project: unknown`, 2순위 경로(`clients/<client>/_unsorted/qa/plans/`)로 저장 + `[확인 필요 — project 미식별]` §1·§9에 표기. hard-fail 금지

자동 선택 시 preview에 선택 근거 의무 표시.

### Step 3. Source 자동 탐색 (병렬, best-effort)

다음 5개 source를 동시 탐색:

1. **SRS** (primary):
   - `clients/<c>/<p>/srs.md` (로컬, 자동 탐색)
   - PM이 `--srs <Notion URL>` 명시한 경우 `mcp__notion-cigro__notion-fetch`로 read
   - 둘 다 없으면 `srs_ref: missing` + Section 1·§9에 `[확인 필요]`. v1.1에서 Notion 자동 search 추가 검토 (현재 v1은 명시 URL fetch만)
2. **Change Briefs** (primary):
   - `clients/<c>/<p>/change-briefs/*.md` 모두 read
   - frontmatter `status: Dev-Handoff`인 것만 In-Round source로 사용
   - 없으면 `brief_refs: []`
3. **QA history** (primary):
   - `clients/<c>/<p>/qa/feedback-*.md` 또는 Notion 태스크 DB 검색 (best-effort)
   - 이전 라운드 FAIL 시나리오를 §7 Regression Checklist에 활용
4. **client / project context** (primary):
   - `clients/<c>/CLAUDE.md` + `glossary/<c>.md`
5. **design.md** (보조):
   - `clients/<c>/<p>/design.md`
   - **UI/화면 표현 검증 보조에만 사용.** §3 전체 플로우 맵·§4·§5 단계별 행동의 화면명 인용·§9 판단에 보조. QA 범위·기능 흐름·권한 발명에 사용 ❌

### Step 4. Round 자동 결정

`clients/<c>/<p>/qa/plans/QA-<CLIENT>-*.md` 디렉토리 스캔:
- 가장 최근 파일의 `round` 추출 → +1 (예: 마지막이 R3이면 R4)
- 디렉토리 비어 있으면 R1
- PM이 `--round R{N}` 명시했으면 그대로 사용

QA Plan ID = `QA-<CLIENT>-YYYYMMDD` (CLIENT는 대문자, 날짜는 created date)

### Step 5. 9 섹션 작성 (모두 영어로 출력)

**원칙: source 기반 작성. source 부족 시 `[TBD]` 또는 `(none)`. 발명 ❌. 9 섹션은 모두 존재해야 하지만 모두 채워야 하는 건 아님.**

**언어: 모든 본문은 영어. 한국어 원문 인용이 필요한 경우만 quote block에 보존하고 곧바로 영어 번역 추가.**

#### Section 1. QA Scope
- This round's test targets: SRS REQ IDs / screens / Change Brief In-Round items
- Out of scope: Out-of-Scope items / Confirm-Needed items (acknowledged, not tested)
- Mark `[TBD]` when source is insufficient

#### Section 2. Test Roles / Accounts
- Role list: only roles declared in SRS / glossary (e.g., regular member, org admin, external user)
- Accounts: mock identifiers + role mapping (no real credentials)
- External dependencies: payment mock / email mock / push tokens / etc.

#### Section 3. End-to-End Flow Map
- **Text tree or table** (no Mermaid — `--diagram` flag not available)
- User journey from entry → core flow → exit
- Reference design.md screen names if available (UI representation cross-check only)
- Annotate per-flow priority

#### Section 4. P0 Critical Scenarios (mandatory regression)
Compact 5-line block per scenario:

```
### P0-NN: <one-line title>
- Role: <primary role>
- Preconditions: <environment / account / external deps in one line>
- Steps (≤9 recommended):
  1. ...
  2. ...
- Expected outcome: <UI / DB / External — single block>
```

P0 = direct link to SRS REQ ID or Change Brief In-Round, high-regression area.

**Step-count 3-tier guidance (per scenario):**
- **Recommended 6–9** (sweet spot)
- **10–12**: append `ℹ️ Consider splitting (currently N steps)` at end of scenario. No auto-split.
- **13+**: `⚠️ Step cap exceeded (currently N) — split recommended.` PM decides manually. No auto-truncation.

#### Section 5. P1 Supporting Scenarios (per-round)
Same format as P0; priority is P1.

#### Section 6. Edge / Negative Cases
- Input validation failures
- Permission boundaries
- Concurrency / race conditions
- External mock failures
- ID format: `EDGE-NN`
- **Source-grounded only.** No speculation.

#### Section 7. Regression Checklist
- Re-run prior-round FAIL scenarios
- Impact areas from this round's Change Brief In-Round items
- ID format: `REG-NN`
- If empty: `(no regression items in this round)`

#### Section 8. QA Handoff Message
Copy/paste-ready block for QA / client transmission. **English only** (Vietnamese QA team reads it):
- Brief intro line
- Scenario ID list + priorities (P0-NN, P1-NN, EDGE-NN, REG-NN)
- Staging URL / mock accounts / deadline
- Failure report convention: "preserve `QA Plan: QA-<CLIENT>-YYYYMMDD`, `Scenario: P0-NN` meta on the first line of the report body"

#### Section 9. PM Review Items
- `[TBD]` items caused by missing SRS / Change Brief / design.md
- Musing-tone items (not promoted to Decision)
- Items with external effects (email / push) lacking source
- Scenario count cap (screens × 1.5) exceeded — split/consolidate review prompt
- Project resolution = 0 → input request

### Step 6. 시나리오 수 cap 점검
- 화면 수 × 1.5를 초과하면 §9 PM 확인 필요로 안내
- 작성 차단 X. PM 결정

### Step 7. 로컬 저장 (3단 fallback)

1. **client + project 명확:** `clients/<c>/<p>/qa/plans/QA-<CLIENT>-YYYYMMDD.md` — 디렉토리 없으면 `mkdir -p`
2. **client만 명확, project unknown:** `clients/<c>/_unsorted/qa/plans/QA-<CLIENT>-YYYYMMDD-unknown.md`
3. **client 불명:** 저장 안 함, 화면 출력만 + client 입력 요청

`.gitignore` 정책: `.gitignore` 자체 수정 X. `clients/*/` 룰로 자동 git 추적 제외 (검증: `git check-ignore -v clients/<c>/<p>/qa/plans/QA-<CLIENT>-YYYYMMDD.md` → ignored면 정상).

**중복 방지:** 같은 날 같은 client에 이미 plan이 있으면 `-2`, `-3` suffix. PM 명시 ID 충돌 시 자동 덮어쓰기 ❌, 다음 가용 번호 제안 후 PM 확인.

### Step 8. 화면 출력 + "다음 단계" 안내

**화면에 출력 (PM-facing, 한국어 요약 가능):**
- 생성된 파일 경로 (또는 3순위 fallback 시 "저장 안 됨, 화면 출력만")
- frontmatter 요약 (qa_plan_id / status / round / srs_ref / brief_refs 수 / design_md)
- §1 QA Scope 요약 (검수 대상 시나리오 N개, P0=X / P1=Y / EDGE=Z / REG=W)
- §8 QA Handoff Message (영어, PM이 그대로 복사해 QA에 전달)
- "다음 단계" 안내 블록

**"다음 단계" 블록 의무 포함:**
```
📋 다음 단계 (자동 실행 안 함, 안내만):
- §8 QA Handoff Message → /qa-request 또는 /client-chat에 사용
- 검수 후 발견된 버그 → /qa-feedback (본문 첫 줄에 "QA Plan: QA-<CLIENT>-YYYYMMDD" 또는 "Scenario: P0-NN" 메타 보존)
- 큰 버그 → /issue-ticket → Linear
- status 변경: 파일 frontmatter status: 직접 수정 (Draft → Review → Final)
```

**내부 검수용 의무 안내 (마지막 줄):**
```
⚠️ This QA plan is for PM/QA internal validation. Do not forward §1–§7 to client or dev team directly. §8 is the only client/QA-facing section.
```

## Rules

### 필수
- **출력은 영어** (Vietnamese QA 팀이 읽음). 한국어 원문 인용이 필요한 경우 quote block 안에 보존하고 영어 번역 추가
- frontmatter status 기본 `Draft` (Draft → Review → Final, 자동 승급 X)
- "Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket." banner 의무 포함
- source 없는 흐름·기대결과·권한·데이터 조건 발명 금지 — 부족 시 `[TBD]`
- 추론은 `[inferred]` 태그 명시 (영어 출력이므로 한국어 `[추론]` 대신)
- 9 섹션 모두 존재. 빈 섹션은 `[TBD]` 또는 `(none)`로 명시
- 시나리오별 단계 cap 3-tier 가이드 적용 (6~9 / 10~12 / 13+)
- 시나리오 ID 형식: `P0-NN` / `P1-NN` / `EDGE-NN` / `REG-NN` (zero-pad 2자리)
- QA Plan ID 형식: `QA-<CLIENT>-YYYYMMDD` (CLIENT는 대문자)
- design.md는 §3 화면명 인용 / UI 표현 검증 보조에만. QA 범위·기능 흐름 발명 X

### 금지
- 자동 chain 트리거 (`/qa-feedback` / `/issue-ticket` / `/to-spec` / `/dev-chat` / `/client-chat`)
- Notion / Nexus / Linear 자동 write
- 자동 브라우저 실행 / Playwright / qa-agent-skills / expect 연동 (v3 영역)
- 자동 스크린샷 / HAR 캡처
- 구체 공수(MD/hour/day) AI 산정
- 추측성 UI 위치·버튼·문구 위치 제안
- 기존 QA plan 파일 자동 수정·삭제
- 실제 QA plan 파일을 git add
- `.gitignore` 수정
- design.md를 QA 범위·기능 흐름 primary source로 사용
- Mermaid 다이어그램 기본 출력 (v1)
- 9 섹션을 강제로 채우기 (source 부족 시 [확인 필요])
- §4~§7을 고객·개발팀 직접 전달 (§8만)

### PM 판단이 불가능할 때
- primary source(SRS / Change Brief / QA history) 모두 부족 + design.md만 있을 때 → QA plan 작성 자체를 멈추고 PM에게 source 입력 요청. design.md만으로 시나리오 발명 ❌
- project resolution 0개 → 저장하지 않고 화면 출력만 + 입력 요청
- client 0개 → 저장하지 않고 화면 출력만
