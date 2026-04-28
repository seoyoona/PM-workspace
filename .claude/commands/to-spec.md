---
description: 클라이언트 요청 4-bucket triage gate → In-Round만 PM confirm 후 Notion 스펙·태스크 생성
argument-hint: --client <name> [--project name] [--srs path|URL] [--design path] [--source change-brief path] [요청 내용 또는 Notion URL]
allowed-tools: Read, Glob, Grep, Bash, mcp__notion-cigro__notion-create-pages, mcp__notion-cigro__notion-fetch, mcp__notion-cigro__notion-update-page
---

# Client Request → Triage → Dev Ticket

## Arguments
사용자 입력: $ARGUMENTS

## Context
- 출력 템플릿: !`cat /Users/yoona/Documents/yoona-workspace/templates/request-to-spec.md`
- 클라이언트 추가 요청 / 미팅 결정 / QA 피드백을 단일 진입점으로 받아 4-bucket triage(In-Round / Next-Round / Out-of-Scope / Confirm-Needed) → **In-Round만 PM confirm gate 통과 후 Notion 스펙 페이지 + 태스크 자동 생성**
- 그 외 버킷(Next-Round / Out-of-Scope / Confirm-Needed)은 **로컬 markdown 저장만**. Notion / Nexus / Linear 자동 write 없음
- SRS / design.md 부재 시 hard-fail 금지 — 해당 섹션만 partial-skip
- v1 `/change-brief` 단독 스킬은 본 스킬에 통합·대체됨 (deprecate 진행 중). 흡수된 룰: 4-bucket 분류 기준 / Section 5 고객 확인 질문 / Section 6 개발팀 전달 문구 / partial-skip / no-invention / 추측성 UI 자동 제안 금지 / 구체 공수 AI 산정 금지

## Source 우선순위

요청 분석·분류·스펙화의 **primary source**는 다음 순서:

1. **사용자 입력** (요청 본문 또는 Notion URL fetch 내용)
2. **SRS / 기능명세** (`clients/<c>/<p>/srs.md` 또는 `--srs <Notion URL>`로 읽은 내용)
3. **`--source change-brief <path>`로 명시된 기존 Change Brief** (deprecate 기간 호환 — 신규 brief 생성 X, 이미 status=Dev-Handoff 항목만 In-Round source로 사용)
4. **client / project context** (`clients/<c>/CLAUDE.md`, `glossary/<c>.md`)
5. **design.md** — UI/화면 표현 검증 보조 source만. 4-bucket 분류·In-Round 승급·AC 발명에 primary로 사용 ❌

## Hard Boundaries (이 스킬은 절대 안 함)

1. Official SRS / design.md / wireframe 편집·생성 — read-only 참조만
2. Nexus MCP 호출 (`mcp__nexus-os__*` 어떤 것이든) — read·write 모두 금지
3. Linear 이슈 자동 생성 — PM이 별도 `/issue-ticket`
4. 자동 chain 트리거 (`/dev-chat` / `/client-chat` / `/qa-feedback` / `/qa-plan`) — "다음 단계" 안내만
5. Notion DB property 추가·수정 (커뮤니케이션 / 태스크 / 프로젝트 문서 DB select 옵션 추가 X)
6. **PM confirm gate 우회 Notion 자동 write** — In-Round 버킷도 PM 미리보기 + 명시 confirm 후에만 Notion 페이지·태스크 생성
7. **Next-Round / Out-of-Scope / Confirm-Needed 버킷의 Notion 자동 write** — 영원히. 로컬 markdown 저장만
8. SRS / design.md 부재로 hard-fail (해당 섹션만 partial-skip)
9. **source 없는 사용자 흐름·기대결과·권한·데이터 조건 발명** — 부족 시 `[확인 필요]`
10. **추측성 UI 위치·버튼·문구 위치 자동 제안** — source 근거 없으면 중립 질문(§5)으로
11. **구체 공수(MD/hour/day) AI 산정** — Impact: Low/Medium/High/Unknown만. dev 산정은 별도
12. 와이어프레임 / 이미지 / prototype 생성 (yes/no 플래그만)
13. `.gitignore` 수정
14. `clients/*/`로 ignore되지 않는 경로에 triage markdown 저장 — 항상 `clients/<c>/<p>/change-briefs/` 또는 fallback

## Instructions

### Step 1. 인자 파싱

**Required:**
- `--client <name>` (필수). 누락 시 `templates/client-default.md` 24h activity-log 기준 default 제안. 0건이면 사용자 입력 요청 (저장 안 함, 화면 출력만)

**Options (모두 선택):**
- `--project <name>` — 자동 탐색 결과 override
- `--srs <path|URL>` — 자동 탐색 override
- `--design <path>` — 자동 탐색 override
- `--source change-brief <path>` — 기존 Change Brief에서 이어 받기 (deprecate 호환). 이 경우 brief frontmatter `status` 확인 후 Dev-Handoff 항목만 In-Round source로
- 나머지 입력: free-text 또는 Notion URL (단일)

### Step 2. Project Resolution

`clients/<client>/` 하위 project 디렉토리 탐색:
- **1개** → 자동 선택 + preview에 근거 1줄
- **여러 개** → 추천 1개 + 숫자 선택지 (`최근 mtime` / `client CLAUDE.md 프로젝트명 일치` 기준)
- **0개** → frontmatter `project: unknown`, 2순위 경로(`clients/<client>/_unsorted/change-briefs/`)로 저장 + §9 PM 확인 필요에 표기. hard-fail 금지

### Step 3. 컨텍스트 / 소스 로드 (병렬, best-effort)

다음 5개를 동시 탐색:

1. **사용자 입력 (primary)**:
   - free-text → 그대로 사용
   - Notion URL → `mcp__notion-cigro__notion-fetch`로 페이지 블록 read
   - **Notion fetch 실패 시 hard-fail 금지** — 다음 메시지 출력 후 free-text 모드로 전환:
     ```
     ⚠️ Notion 페이지를 읽지 못했습니다. 요청 내용을 직접 붙여넣어 주세요.
     ```
2. **SRS** (primary):
   - `clients/<c>/<p>/srs.md` (자동 탐색)
   - `--srs <URL>` 명시 시 `mcp__notion-cigro__notion-fetch`
   - 부재 시 frontmatter `srs_ref: missing`, §2에 `[확인 필요] SRS 미연결 — Nexus Agent / PM 확인 필요`
3. **Change Brief** (primary, optional):
   - `--source change-brief <path>` 명시 시 read-only로 그대로 사용
   - 미명시면 skip
4. **client / project context** (primary):
   - `clients/<c>/CLAUDE.md` + `glossary/<c>.md`
5. **design.md** (보조):
   - `--design <path>` 또는 자동 탐색 (`clients/<c>/<p>/design.md`)
   - 부재 시 frontmatter `design_md: missing`, §3에 `[확인 필요] design.md 부재 — UI 영향 상세 판단은 design owner / Nexus Agent 확인 필요`

### Step 4. 요청 분석

- 클라이언트가 실제로 원하는 것 추출 (불만/맥락과 요청 분리)
- 암묵적 요구사항 식별 — 단, 추론은 `[추론]` 태그 명시
- 여러 요청이 섞여 있으면 자동 분리

### Step 5. 4-Bucket Triage (최우선 분류)

각 항목을 다음 기준에 따라 분류. **기준 미일치 항목은 default Confirm-Needed.** 애매한 걸 In-Round로 올리지 않는다.

```
In-Round:
- 기존 SRS / 현재 라운드 목표에 직접 연결됨
- 추가 개발이 작거나 이미 합의된 수정
- 고객·PM·Dev 중 최소 하나의 명확한 근거 있음

Next-Round:
- 필요성은 있으나 현재 라운드 목표와 직접 관련 없음
- 추가 개발 / 일정 영향이 있음
- 유지보수 / 추가계약 후보

Out-of-Scope:
- 계약 / SRS 범위 밖
- 신규 기능이지만 고객 컨펌 / 견적 없음
- 개발팀에 바로 전달하면 안 됨

Confirm-Needed:
- 의도 / 스펙 / 우선순위 / 공수 / 책임 중 하나라도 불명확
- 고객 확인 필요
- 또는 내부 PM / Dev 판단 필요
```

빈 버킷은 `(현재 항목 없음)`로 명시.

### Step 6. Impact 표기

- 각 In-Round / Next-Round 항목에 `Impact: Low | Medium | High | Unknown`
- **구체 공수(MD/hour/day) AI 산정 절대 금지**
- 명확하지 않으면 `Unknown` 또는 `Dev 확인 필요`

### Step 7. 9 섹션 작성

**원칙: source 기반 작성. source 부족 시 `[확인 필요]` 또는 `(현재 항목 없음)`. 발명 ❌. 9 섹션은 모두 존재해야 하지만 모두 채워야 하는 건 아님.**

#### Section 1. 변경 요청 요약
- 누가 / 언제 / 어떤 채널
- 원문 인용 1-3줄 (수정 X)
- PM 1-line 정규화

#### Section 2. 기존 범위 대비 영향도
- SRS 참조 섹션 또는 `[확인 필요] SRS 미연결`
- 영향 분류: 신규 기능 / 기존 변경 / 명확화 / 비범위
- 전체 Impact: Low | Medium | High | Unknown

#### Section 3. 화면·UX 영향
- design.md 있으면 충돌·확장하는 token / component / pattern 인용
- 부재 시 `[확인 필요] design.md 부재`
- design.md 갱신 필요 여부 / wireframe 필요 여부 (불필요 / 필요 / 판단 보류)

#### Section 4. 4-Bucket Triage
각 버킷별 항목 list. 빈 버킷은 `(현재 항목 없음)`.

```
### In-Round
- [ ] <항목> / <근거> / Impact: <Low|Medium|High|Unknown>

### Next-Round
- [ ] <항목> / <근거> / 보류 사유: <reason>

### Out-of-Scope
- [ ] <항목> / <근거> / 거절 사유: <reason>

### Confirm-Needed
- [ ] <항목> / 어떤 정보가 더 필요한가: <missing info>
```

#### Section 5. 고객 확인 / 거절 안내 (Confirm-Needed + Out-of-Scope에서 자동 생성)
- 한국어 합니다체 (CLAUDE.md `feedback_client_chat_tone.md` 참조)
- Confirm-Needed → 명확화 질문 (중립 톤, 추측성 UI 위치 제안 ❌)
  - 금지 예: `"결제하기 버튼 위로 봐도 될까요?"` (특정 위치 추측)
  - 허용 예: `"결제 전 안내 문구를 어느 화면/단계에 노출할지 확인이 필요합니다."`
- Out-of-Scope → 거절 + 추가 견적·별도 계약 안내
- 둘 다 비어 있으면 `(현재 확인 필요·거절 안내 항목 없음)`

#### Section 6. 개발팀 전달 문구 (In-Round, Notion 생성 후 채움)
- English summary
- 영향 SRS section ID
- AC 후보 (When/Then)
- Impact: Low | Medium | High | Unknown (구체 공수는 dev 확인)
- In-Round 비어 있으면 `(In-Round 항목 없음 — 개발팀 전달 없음)`

#### Section 7. PM Confirm Gate (In-Round 항목 있을 때만)

**Notion 자동 write 직전 의무 단계.** In-Round 항목이 0건이면 이 게이트 skip.

화면에 다음 형식으로 미리보기 + 4지선다 출력:

```
[확인 필요]
다음 In-Round 항목을 Notion 스펙 페이지 + 태스크 N개로 생성합니다:

스펙 페이지:
- Title: <한 줄 요약>
- Scope summary: <table preview>
- AC: <preview>
- Tasks: N개 (<task1>, <task2>, ...)

1. 진행 (Notion 페이지 + 태스크 생성)
2. 수정 (4-bucket 분류 다시 검토)
3. 취소 (Notion 생성 안 함, 로컬 triage markdown만)

추천: 1
```

PM이 1을 명시 선택하기 전까지 Notion API 호출 ❌.

#### Section 8. Notion 스펙 + 태스크 (PM confirm 후 자동 채움)

**조건: §7 PM confirm gate에서 1번 선택 + In-Round 항목 ≥ 1개**

- **Part A 스펙 페이지 (커뮤니케이션 DB `3793aae9a894836e8a200120b24454e4`)**:
  - 유형: 개발 스펙 / 방향: Client→Dev / 상태: 진행 중
  - 클라이언트·프로젝트 속성 필수
  - Title / Context / Scope Summary 표 / Constraints / Open Questions / SRS Impact / Ref(한국어 원문)
- **Part B 태스크 (태스크 DB `b9f3aae9a8948322abee81e151af9831`)**:
  - 각 In-Round 항목을 개별 태스크로 분리 (한 태스크 = 개발자가 독립적으로 완료할 수 있는 단위)
  - 상태: 시작 전 / 우선순위: High|Medium|Low (요청 맥락 기반)
  - 클라이언트·프로젝트·스펙 출처 URL·AC·비고
- **Part C 스펙 페이지 update**:
  - `mcp__notion-cigro__notion-update-page`로 스펙 페이지 하단에 `## Tasks` 섹션 추가
  - 표: Task (link) | Priority | AC | Notes
  - 표 위에 "상태 관리는 태스크 DB에서 진행합니다." 안내
- **Part D 결과 frontmatter `spec_pages`에 스펙 페이지 URL 기록**

#### Section 9. PM 다음 단계
- In-Round (Notion 생성됨): /dev-chat에 §6 사용 / linked view 수동 설정 안내
- Confirm-Needed: /client-chat에 §5 사용
- Out-of-Scope: /client-chat에 거절 안내 사용
- Next-Round: 로컬 기록만, 다음 라운드 진입 시 본 항목 검토

### Step 8. 로컬 저장 (3단 fallback)

triage markdown은 항상 로컬 저장 (Notion 생성 여부와 별도):

1. **client + project 명확:** `clients/<c>/<p>/change-briefs/YYYY-MM-DD-<slug>.md` — 디렉토리 없으면 `mkdir -p`
2. **client만 명확:** `clients/<c>/_unsorted/change-briefs/YYYY-MM-DD-<slug>.md`
3. **client 불명:** 저장 안 함, 화면 출력만 + client 입력 요청

`.gitignore` 정책: `.gitignore` 자체 수정 X. `clients/*/` 룰로 자동 git 추적 제외 (검증: `git check-ignore -v clients/<c>/<p>/change-briefs/<file>` → ignored면 정상).

**slug 생성 규칙:** §1 한 줄 요약을 lowercase + 공백→hyphen + 특수문자 제거. 30자 이내.

**중복 방지:** 같은 날 같은 slug 존재 시 `-2`, `-3` suffix.

### Step 9. linked view 수동 설정 안내 (In-Round Notion 생성 시만)

```
📋 마지막 단계 (수동, 40초):
1. 스펙 페이지 하단에서 /linked view → 태스크 DB 추가
2. 필터 설정: 스펙 출처 = {이 스펙 페이지 제목}
→ 개발자가 이 스펙의 태스크만 티켓으로 확인 가능
```

### Step 10. 화면 출력 + "다음 단계" 안내

**화면에 출력:**
- 생성된 triage 파일 경로
- frontmatter 요약 (status / client / project / srs_ref / design_md / spec_pages)
- §1 요약 + §4 4-bucket 항목 수
- In-Round Notion 생성 결과 (성공 시 스펙 URL + 태스크 N개) 또는 "Notion 생성 안 함 (PM cancel 또는 In-Round 0건)"
- §5 / §6 본문 (PM 복사 가능)
- "다음 단계" 안내 블록

**"다음 단계" 블록 의무 포함:**
```
📋 다음 단계 (자동 실행 안 함, 안내만):
- In-Round 페이지: /dev-chat에 §6 사용 + linked view 수동 설정
- Confirm-Needed: /client-chat에 §5 사용
- Out-of-Scope: /client-chat에 거절 안내 사용
- Next-Round: 다음 라운드 진입 시 본 triage 파일 재검토
- 상태 변경: triage 파일 frontmatter status 직접 수정 (Triaged → Dev-Handoff)
```

**In-Round 의미 안내 (의무, In-Round 항목 ≥ 1개일 때):**
```
⚠️ In-Round로 분류·생성된 Notion 스펙은 PM이 §7 confirm gate에서 명시 진행한 항목만 포함합니다. PM 미확인 In-Round 항목은 Notion으로 가지 않았습니다.
```

## Rules

### 필수
- 한국어 출력 (§6 English summary 제외)
- frontmatter `status` 기본 `Triaged` (In-Round-only / Confirm-Needed-only / Mixed / Out-of-Scope-only / 모두 빈경우 Empty)
- "원문 인용" 블록은 1-3줄, 원본 그대로
- 추론은 `[추론]` 태그 (CLAUDE.md L135)
- 4-bucket 분류는 기준 명시 — 애매하면 무조건 Confirm-Needed
- design.md / SRS는 read-only, 절대 수정·생성 X
- §6 영어 작성: 개발팀 가독성
- 용어는 glossary 기준 (`glossary/<c>.md`)
- 한 요청에 여러 기능이 섞여 있으면 In-Round 스펙은 1개, 태스크는 기능별 분리
- 태스크 granularity: "API endpoint 하나" 또는 "UI 컴포넌트 하나" 수준
- PM confirm gate 4지선다 의무 (1 진행 / 2 수정 / 3 취소 — `CLAUDE.md` 확인 요청 형식 룰 준수)
- 9 섹션 모두 존재. 빈 섹션은 `[확인 필요]` 또는 `(현재 항목 없음)` 명시

### 금지
- 자동 chain 트리거 (`/dev-chat` / `/client-chat` / `/qa-feedback` / `/qa-plan` / `/issue-ticket`)
- PM confirm gate 우회 Notion auto-write
- Next-Round / Out-of-Scope / Confirm-Needed 버킷의 Notion auto-write (영원히)
- Linear 이슈 자동 생성
- Nexus MCP 호출
- 구체 공수(MD/hour/day) AI 산정
- 추측성 UI 위치·버튼·문구 위치 자동 제안
- source 없는 흐름·기대결과·권한·데이터 조건 발명
- design.md를 4-bucket 분류·In-Round 승급·AC 발명의 primary로 사용
- 와이어프레임 / 이미지 생성
- `.gitignore` 수정
- `clients/*/`로 ignore되지 않는 경로에 triage 저장
- 9 섹션 강제 채우기 (source 부족 시 `[확인 필요]`)

### PM 판단이 불가능할 때
- 입력이 모호해 4-bucket 분류 자체가 어려우면 모든 항목을 `Confirm-Needed`로 보내고 §5에서 명확화 질문 작성
- primary source(사용자 입력 / SRS / Change Brief / context) 모두 부족 + design.md만 있으면 작성 멈추고 PM에게 source 요청. design.md만으로 4-bucket 분류 / In-Round 승급 ❌
- project resolution 0개 → 2순위 경로 + §9에 표기
- client 0개 → 저장 안 함, 화면 출력만
