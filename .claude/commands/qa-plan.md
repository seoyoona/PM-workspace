---
description: 프로젝트 전체 QA 플랜 1번 호출로 생성 — 9 섹션(Scope·Roles·Flow·P0·P1·Edge·Regression·Handoff Message·PM Review). 출력 영어. v1.1 staging URL 입력 시 read-only guided navigation으로 화면 탐색 (depth 2 / max 10 pages)
argument-hint: <client> [--project name] [--round R{N}] [--srs path|URL] [--brief path] [--scope text] [--url staging-url] [--inspect-depth N] [--max-pages N]
allowed-tools: Read, Glob, Grep, Bash, mcp__notion-cigro__notion-fetch, mcp__playwright__browser_navigate, mcp__playwright__browser_navigate_back, mcp__playwright__browser_click, mcp__playwright__browser_snapshot, mcp__playwright__browser_take_screenshot, mcp__playwright__browser_console_messages, mcp__playwright__browser_close, mcp__playwright__browser_type, mcp__playwright__browser_fill_form
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

1. **SRS / 기능명세** (`clients/<c>/<p>/srs.md` 또는 Notion 프로젝트 문서 DB) — **요구사항의 baseline truth**
2. **Change Brief** (`clients/<c>/<p>/change-briefs/*.md` 중 status=Dev-Handoff)
3. **기존 QA 피드백 / 버그 히스토리** (`clients/<c>/<p>/qa/` 또는 Notion 태스크 DB)
4. **client / project context** (`clients/<c>/CLAUDE.md`, `glossary/<c>.md`)
5. **Staging URL inspect** (`--url` 명시 시) — **현재 구현 상태 cross-check (read-only guided navigation, depth 2 / max 10 pages)**. SRS의 baseline 위에 "지금 화면이 어떻게 생겼나" 보조 정보. SRS와 충돌하면 SRS 우선
6. **design.md** — **UI/화면 표현 검증 보조 source만.** QA 범위·기능 흐름·권한·데이터 조건의 primary source로 사용 ❌

design.md를 1~4 대신 사용해 시나리오를 발명하면 no-invention 룰 위반. Staging URL은 "구현 현황 참고"이지 "기준 정답"이 아님 — 미구현·잘못 구현된 화면을 정답처럼 시나리오에 박지 말 것.

## Hard Boundaries (이 스킬은 절대 안 함)

1. SRS / Change Brief / design.md / 프로젝트 문서 편집 — read-only 참조만
2. Official 산출물(SRS / design.md / wireframe) 생성·편집
3. Notion 페이지 자동 생성 (커뮤니케이션 / 태스크 / 프로젝트 문서 DB 모두)
4. Notion DB property 추가·수정 (`/qa-feedback` Tasks DB property화는 v1.6 보류)
5. Nexus MCP 호출 (`mcp__nexus-os__*` 어떤 것이든) — read·write 모두 금지
6. Linear 이슈 생성
7. `/qa-feedback` / `/issue-ticket` / `/to-spec` / `/dev-chat` / `/client-chat` 자동 트리거 — "다음 단계" 안내만
8. **PM이 `--url` 명시 안 했으면 브라우저 실행 X.** `--url` 명시 시 read-only guided navigation만 허용 (자세한 룰은 §URL Inspection Boundaries)
9. 자동 스크린샷 / HAR 캡처 (단, `--url` 명시 시 페이지당 screenshot 1장은 inspection 결과 path 기록 목적으로 허용)
10. 구체 공수(MD/hour/day) AI 산정 — priority P0/P1/EDGE/REG만
11. 추측성 UI 위치·버튼·문구 위치 자동 제안 (source 근거 없으면 ❌)
12. source 없는 사용자 흐름·기대결과·권한·데이터 조건 발명
13. **design.md를 QA 범위·기능 흐름의 primary source로 사용** (UI/화면 표현 검증 보조만)
14. status 자동 승급 (Draft → Review → Final 자동 X)
15. 기존 QA plan 파일 자동 수정·삭제 (수정은 PM이 직접 편집)
16. 한 라운드 시나리오가 화면 수 × 1.5 초과 시 자동 작성 (경고만)
17. 한 시나리오가 13 단계 초과 시 자동 분리 (경고만)
18. `clients/*/`로 ignore되지 않는 경로에 QA plan 저장 — 항상 `clients/<c>/<p>/qa/plans/` 또는 fallback
19. 실제 QA plan 파일을 git add (정책상 ignored 유지)
20. `.gitignore` 수정
21. **Mermaid 다이어그램 기본 출력** (v1은 텍스트 트리·표만, `--diagram` 옵션은 향후 검토)
22. **9 섹션을 강제로 채우기** — source 부족 시 `[TBD]` 또는 `(none)`로 명시. 발명 X
23. §4~§7을 고객·개발팀에 그대로 전달 (§8만 전달용)
24. **qa-agent-skills 연동 / expect / 자동 QA 실행** (v3 영역, v1.1에서도 금지)

## URL Inspection Boundaries (`--url` 명시 시만 적용 / v1.1)

**허용 (read-only guided navigation):**
- 같은 도메인 내 이동만 (`browser_navigate`로 cross-domain 진입 X)
- `<a>` 태그 / nav / menu / tab / 상세 페이지 진입 click
- `browser_navigate_back` (뒤로가기)
- `browser_snapshot` (DOM 텍스트 / 구조 추출)
- `browser_take_screenshot` (페이지당 1장, path만 frontmatter `pages_inspected`에 기록)
- `browser_console_messages` (에러 로그 cross-check)
- 기본 `--inspect-depth 2` / `--max-pages 10` (override 가능, v1.1 cap)
- GET 성격 navigation만

**금지 (상태 변경 가능성):**
- `<form>` submit / `<button>` 중 다음 텍스트·라벨 매칭은 **절대 click X** (단, **로그인 단계 1회는 §Login Exception 룰로 예외**):
  - 한국어: 저장, 제출, 삭제, 취소, 신청, 등록, 결제, 주문, 환불, 발송, 업로드, 추가, 수정, 적용, 변경, 동의, 확인, 보내기, 가입, 탈퇴, 로그아웃, 비활성화, 활성화, 즐겨찾기, 좋아요, 신고
  - 영어: save, submit, delete, cancel, apply, register, pay, order, refund, send, upload, add, update, edit, modify, agree, confirm, sign up, sign out, log out, deactivate, activate, like, favorite, report, follow, unfollow, subscribe, unsubscribe
- `<input>` / `<textarea>` 입력 X (단, **로그인 폼의 email·password 필드는 §Login Exception 룰로 예외**)
- 체크박스 / 라디오 / 토글 / 슬라이더 변경 X
- production URL (`*.com`이지만 staging/test/dev 도메인 아닌 모든 prod 도메인) **hard-block** — `browser_navigate` 거부 + 사용자 경고
- 결제 모듈 / OAuth provider / 외부 redirect 진입 X (Toss, KakaoPay, Stripe, Google OAuth 등)
- 같은 페이지 ≥2회 방문 시 자동 skip (loop 방지)

**Login Exception (단일 허용 — 로그인 1회만):**

`--login-as <mock_account>` 명시 + credentials 파일 존재 시 **로그인 form 입력·submit을 1회만** 허용. 그 외 모든 destructive 룰은 그대로 적용.

**Credentials 파일 형식 (`clients/<c>/<p>/qa/credentials/<mock_account>.yaml`, `clients/*/` 룰로 자동 git ignored):**
```yaml
account: mock_admin_dsa01
role: org_admin
login_url: https://staging.example/admin/login   # optional, 미지정 시 inspect 중 발견된 첫 로그인 wall URL 사용
email: mock_admin_dsa01@example.com
password: <staging-only mock password>
login_selectors:                                  # optional, custom form 일 때만
  email_input: 'input[name="email"]'
  password_input: 'input[name="password"]'
  submit_button: 'button[type="submit"]'
notes: |
  staging-only credentials. Do NOT use for production.
```

**로그인 처리 룰:**
1. 로그인 wall 도달 (HTTP 401, `/login` redirect, "로그인" / "Sign in" 라벨 발견) 시:
   - `--login-as` 명시되어 있고 credentials 파일 존재 → **자동 로그인 시도** (예외 발동)
   - `--login-as` 미명시 또는 파일 부재 → 기존 PM 4지선다 fallback (1 진행 — PM이 미리 세션 만들어둔 경우 / 2 비인증 페이지만 / 3 mock 계정 정보 입력 / 4 inspection 중단)
2. 자동 로그인 시도:
   - email 필드 fill → password 필드 fill → submit button click — 이 3개 액션만 허용
   - selectors 미지정 시 표준 selector 시도 순서: `input[type="email"]` / `input[name*="email" i]` / `input[name*="login" i]` / `input[name*="user" i]` → password는 `input[type="password"]` → submit은 `button[type="submit"]` / `button:has-text("로그인")` / `button:has-text("Sign in")`
   - **OAuth / SSO 버튼 (Google / Kakao / Naver / Apple 등) 절대 click X** — 외부 redirect 금지
   - 캡차 / 2FA 발견 시 즉시 중단 + PM에게 "수동 로그인 후 다시 호출" 안내
3. 로그인 성공 검증:
   - URL이 로그인 페이지 외로 변경 OR `로그아웃` / `Sign out` / `Logout` 버튼 발견 → 성공
   - 3회 시도 실패 시 inspection 중단 + PM에게 credentials 점검 요청
4. **로그인 후에도 destructive 룰은 그대로 적용** — 로그인 성공이 다른 form submit / 저장 / 삭제 / 결제 click 허용을 의미하지 않음. PM이 명시적으로 다른 예외를 추가 도입하기 전까지 read-only navigation만
5. 로그인 시도는 **세션 1회**. inspection 중 추가 로그인 wall (재인증 등) 도달 시 시도 X (loop 방지)
6. credentials 파일은 staging-only. production 도메인 인증 시도는 hard-block 대상 (URL 자체가 production이면 그 전에 차단됨)
7. inspection 종료 시 `mcp__playwright__browser_close()`로 세션 즉시 폐기 (자격증명 잔존 X)

**보안 / 감사 룰:**
- credentials 파일 내용은 plan markdown에 임베드 X (frontmatter `auth_used`에 mock_account 식별자만 기록)
- 비밀번호 / 토큰을 `[추론]` 또는 인용 블록에 노출 X
- 로그인 시도·결과는 §9 PM Review Items에 1줄 로그 ("auth: mock_admin_dsa01 — success / 1회 / post-login pages: N개")

**SRS와 충돌 처리:**
- URL inspection 결과가 SRS와 다르면 **SRS 우선** + §9 PM Review에 "URL inspect: <page> 미구현 또는 SRS와 불일치 — dev/PM 확인 필요" 표시
- "지금 화면에 있는 것"을 P0/P1 시나리오 기대결과로 박지 말 것 (구현 미완 가능성)

**Inspection 종료 / 정리:**
- 종료 시 `browser_close` 의무 호출
- 화면 출력에 inspect 요약: "방문 페이지 N/10, screenshot N개, 발견 console error N건"

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
- `--url <staging URL>` — staging 환경 read-only inspect 활성화 (v1.1). 미명시 시 브라우저 실행 X
- `--inspect-depth N` — `--url` 동반 사용. 클릭 깊이 cap (default 2, v1.1 max 2)
- `--max-pages N` — `--url` 동반 사용. 방문 페이지 cap (default 10, v1.1 max 10)
- `--login-as <mock_account>` — `--url` 동반 사용 (선택). 로그인 wall 통과를 위한 단일 예외. credentials 파일 `clients/<c>/<p>/qa/credentials/<mock_account>.yaml` 자동 read (`clients/*/` 룰로 git ignored). 파일 부재 시 PM 4지선다로 fallback. 로그인 1회만 허용 — 로그인 후 다른 form submit / save / delete는 여전히 금지

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

### Step 3.5. Staging URL Inspection (`--url` 명시 시만, v1.1)

PM이 `--url <staging URL>` 명시한 경우에만 활성화. 미명시 시 이 step 전체 skip.

**Pre-flight check (의무):**
1. URL이 production 도메인 패턴인지 확인 — 다음 중 하나라도 매칭되면 **hard-block** (browser_navigate 호출 X):
   - `prod.`, `production.`, `www.` 시작 + 명백한 staging/test/dev 키워드 부재
   - 메인 서비스 도메인(예: `*.toss.im`, `*.kakao.com` 등 외부)
   - PM에게 "이 URL은 production 가능성. staging URL인지 확인 부탁드립니다." 출력 후 inspection 중단
2. URL host 추출 → `inspect_host` 변수에 저장 (이 호스트만 navigation 허용)
3. PM에게 진행 의도 confirm 1줄 미리보기:
   ```
   [확인 필요]
   staging URL inspect 시작:
   - URL: <user input>
   - host: <inspect_host>
   - depth cap: <N> / page cap: <M>
   - read-only (form submit / save / delete / payment 등 금지)

   1. 진행
   2. 비인증 페이지만
   3. 취소 (URL 무시하고 SRS만으로 plan 작성)

   추천: 1
   ```

**Inspection loop (PM이 1 또는 2 선택 시):**
- `mcp__playwright__browser_navigate(url)` 진입 페이지
- `mcp__playwright__browser_snapshot()` DOM 텍스트 / 구조 추출
- `mcp__playwright__browser_take_screenshot()` 1장, path: `clients/<c>/<p>/qa/plans/inspect/<YYYYMMDD>-<page-slug>.png` (clients/*/  rule로 자동 ignored)
- `mcp__playwright__browser_console_messages()` console error log 1회 수집
- 다음 페이지 결정 — DOM에서 `<a>` / `<nav>` / role=tab / role=menu 후보 추출 후 우선순위:
  1. nav / menu / sidebar 항목 (전체 플로우 노출)
  2. 상세 페이지 link (list → detail)
  3. tab 전환
- 클릭 직전 텍스트 매칭으로 **금지 단어 hard-block** (§URL Inspection Boundaries 참조). 매칭 시 해당 link skip + 다음 후보로
- depth cap / page cap 도달하면 종료
- 같은 URL 재방문 시 skip (loop 방지)
- 로그인 wall 도달 (HTTP 401 / "로그인" 라벨 / `/login` redirect) 시:
  - `--login-as <mock_account>` 명시되어 있고 `clients/<c>/<p>/qa/credentials/<mock_account>.yaml` 존재 → §Login Exception 룰로 자동 로그인 1회 시도
  - 둘 중 하나라도 부재 → PM 4지선다 fallback (§URL Inspection Boundaries 로그인 처리 룰)
  - 자동 로그인 성공 시 frontmatter `auth_used: <mock_account>` 기록, §9에 1줄 로그

**Inspection 종료:**
- `mcp__playwright__browser_close()` 의무
- frontmatter `staging_url`, `pages_inspected` 기록
- §3 Flow Map / §4 P0 시나리오 단계 작성에 반영 — 단, **SRS와 충돌 시 SRS 우선** + §9에 불일치 항목 표기
- screenshot path는 §9 PM Review Items에 list로 안내 (개별 임베드 X)

**SRS 미연결 + URL만 있는 경우:**
- design.md만 있는 case04와 같은 처리: primary source 부족으로 plan 작성 멈추고 PM에게 SRS / Change Brief 요청
- URL inspection 결과는 §9 PM Review Items에 raw 정보로 첨부 (시나리오 발명 X — no-invention 룰)

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
- frontmatter 요약 (qa_plan_id / status / round / srs_ref / brief_refs 수 / design_md / staging_url / pages_inspected 수)
- **URL inspection 요약 (`--url` 명시 시):** 방문 페이지 N/cap, screenshot 저장 N개, 발견 console error N건, hard-block된 클릭 N건
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
