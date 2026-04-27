---
description: PM/QA 내부 시나리오 문서 1장 생성 — SRS / Change Brief / PM 입력 기반, source 없는 발명 ❌
argument-hint: --client <name> [--project <name>] [--srs <path|URL>] [--brief <change-brief path>] [--scenario-id SCN-X-NNN] [화면명 또는 시나리오 의도]
allowed-tools: Read, Glob, Grep, Bash, mcp__notion-cigro__notion-fetch
---

# QA Scenario — Manual Authoring (PM/QA Internal)

## Arguments
사용자 입력: $ARGUMENTS

## Context
- 출력 템플릿: !`cat /Users/yoona/Documents/yoona-workspace/templates/qa-scenario.md`
- 진행 중 프로젝트의 사용자 시나리오 1개를 SRS / Change Brief / PM 입력 기반으로 표준 템플릿대로 작성
- **로컬 markdown 저장만** (`clients/<client>/<project>/qa/scenarios/`). Notion / Nexus / Linear 자동 write 없음
- 자동 브라우저 실행 / Playwright / 스크린샷 자동 캡처 없음 (v3 영역)
- SRS / Change Brief 부재 시 hard-fail 금지 — 해당 항목만 `[확인 필요]`로 partial-skip
- AI는 source 기반 작성. **source에 없는 사용자 흐름·기대결과·권한·데이터 조건 발명 금지** — 부족하면 `[확인 필요]`
- 출력 banner: "Internal QA scenario draft — for PM/QA validation only. Not a client-facing spec or dev ticket." 의무 포함

## Hard Boundaries (이 스킬은 절대 안 함)

1. SRS 페이지·파일 편집 — read-only 참조만
2. Change Brief 페이지·파일 편집 — read-only 참조만
3. Official 산출물(SRS / design.md / wireframe) 생성·편집
4. Notion 페이지 자동 생성 (커뮤니케이션 / 태스크 / 프로젝트 문서 DB 모두)
5. Notion DB property 추가·수정 (`/qa-feedback` Tasks DB에 `시나리오 ID` property 추가 X — v1.6)
6. Nexus MCP 호출 (`mcp__nexus-os__*` 어떤 것이든) — read·write 모두 금지
7. Linear 이슈 생성
8. `/qa-feedback` / `/issue-ticket` / `/to-spec` / `/dev-chat` / `/client-chat` 자동 트리거 — "다음 단계" 안내만
9. 자동 브라우저 실행 / Playwright / qa-agent-skills 연동 (v3 영역)
10. 자동 스크린샷 / HAR 캡처
11. 구체 공수(MD/hour/day) AI 산정 — priority P0/P1/P2만
12. 추측성 UI 위치·버튼·문구 위치 자동 제안 (source 근거 없으면 X)
13. source 없는 사용자 흐름·기대결과·권한·데이터 조건 발명
14. status 자동 승급 (작성중 → 검토 → 확정 자동 X)
15. 기존 시나리오 파일 자동 수정·삭제 (수정은 PM이 직접 편집)
16. SRS / Change Brief 부재로 스킬 전체 hard-fail (해당 섹션만 partial-skip)
17. 한 라운드 시나리오가 화면 수 × 1.5 초과 시 자동 작성 (경고만)
18. 단계 수 10~12: 분리 검토 권장 안내 / 13 이상: cap 초과 경고 / 자동 자르기·자동 분리 모두 금지
19. `clients/*/`로 ignore되지 않는 경로에 시나리오 파일 저장 — 항상 `clients/<client>/<project>/qa/scenarios/` 또는 fallback
20. 실제 시나리오 파일을 git add (정책상 ignored 유지)
21. `.gitignore` 수정

## Instructions

### Step 1. 인자 파싱
- `--client` 추출 (필수). 누락 시 `templates/client-default.md` 24h activity-log 기준 default 제안. activity-log 0건이면 사용자에게 `--client` 입력 요청
- `--project` 추출 (선택). 미입력 시 frontmatter `project: unknown`, 2순위 경로(`clients/<client>/_unsorted/qa/scenarios/`)로 저장
- `--srs <path|URL>` 추출 (선택, read-only)
- `--brief <change-brief path>` 추출 (선택). 미입력 시 `clients/<client>/<project>/change-briefs/`에서 가장 최근 mtime 파일 + frontmatter `status: Dev-Handoff` 자동 탐색. 못 찾으면 frontmatter `brief_ref: none`
- `--scenario-id SCN-X-NNN` 추출 (선택). PM 명시 ID. 충돌 시 자동 덮어쓰지 않고 다음 가용 번호 제안
- 나머지 입력: 화면명 / 시나리오 의도 자연어

### Step 2. 컨텍스트 로드 (병렬, best-effort)
- `glossary/{client-name}.md` — 용어집
- `clients/{client-name}/CLAUDE.md` — 클라이언트 컨텍스트, 프로젝트명·도메인·tone
- 부재해도 진행

### Step 3. SRS 참조 (read-only, partial-skip)
- `--srs` path 또는 URL이 있으면 read 시도
  - 로컬 path → `Read` tool
  - Notion URL → `mcp__notion-cigro__notion-fetch`
- read 성공 시 frontmatter `srs_ref`에 REQ ID list 기록 (예: `REQ-PAY-01, REQ-AUTH-03`). Section 1 Source Linkage에 인용
- read 실패 또는 미지정 시 frontmatter `srs_ref: missing`, Section 1에 `[확인 필요 — Nexus Agent / PM]` 표시
- Notion fetch 실패 시 hard-fail 금지: `"⚠️ SRS Notion 페이지를 읽지 못했습니다. REQ ID list를 직접 입력해 주세요."` 안내 + free-text 모드로 진행
- SRS 본문을 임의로 편집·생성하지 않음 (read-only)

### Step 4. Change Brief 참조 (read-only, partial-skip)
- `--brief` path가 있으면 Read로 로드
- 미지정 시 `clients/<client>/<project>/change-briefs/`에서 자동 탐색:
  - 가장 최근 mtime 파일 + frontmatter `status: Dev-Handoff`인 것
  - 못 찾으면 frontmatter `brief_ref: none`
- Change Brief In-Round bucket 항목들을 시나리오 의도 source로 활용
- Change Brief In-Round가 비어 있고 Confirm-Needed만 있다면 **경고**:
  ```
  ⚠️ Change Brief In-Round가 비어 있습니다. 시나리오는 확정된 항목에 작성하는 것이 안전합니다.
  강제로 진행하시려면 다시 실행하세요. (작성 시 brief_ref에 "Confirm-Needed only" 표기 + status=작성중 유지)
  ```
- Change Brief가 status=Draft인 경우 경고만 표시 후 PM 강제 진행 가능
- Change Brief 본문을 임의로 편집·생성하지 않음 (read-only)

### Step 5. Scenario ID 결정 (충돌 방지)
1. 저장 대상 디렉토리 결정 (Step 8 참조)
2. 디렉토리 안의 `SCN-{project-slug}-*.md` 파일을 모두 스캔 (`Glob` 또는 `ls`)
3. 파일명에서 NNN 부분 추출 → 가장 큰 번호 찾음 → 그 + 1로 새 ID 생성
4. 디렉토리 비어 있거나 0개면 `001`부터 시작
5. PM이 `--scenario-id` 명시했으면 그 ID 사용. 단, 같은 ID가 이미 존재하면 **자동 덮어쓰지 않음** + 다음 가용 번호 제안 + PM 확인:
   ```
   ⚠️ SCN-X-001이 이미 존재합니다. 다음 가용 번호: SCN-X-{NNN+1}. 그대로 진행할까요?
   1. 다음 번호로 생성 (추천)
   2. 취소
   추천: 1
   ```
6. fallback 경로(`_unsorted/qa/scenarios/`)에서도 같은 룰. 단 project-slug = `unknown`
7. 기존 시나리오 파일을 자동 수정·삭제하지 않음 (PM이 직접 편집)

### Step 6. 시나리오 본문 작성

**원칙: AI는 source 기반 작성. source 없는 발명 금지.** source가 부족한 항목은 `[확인 필요]` 또는 `[추론]` 태그로 명시.

- **Section 1 Source Linkage**: SRS REQ ID / Change Brief path / 태스크 ID / 화면 링크 — source 부재 시 `[확인 필요]`. 우선순위는 PM 입력에서 추출하거나 default P1
- **Section 2 사용자 역할**: source에서 명시된 역할만. 추론 시 `[추론]` 태그
- **Section 3 사전 조건**: source(SRS / Change Brief)에 있는 환경·계정·외부 의존만 명시. 임의 추가 X. 미정인 항목은 `[확인 필요]`. **계정·credential은 redact 또는 mock 사용 권고**
- **Section 4 테스트 목표**: 1문장. source의 의도 그대로 정규화
- **Section 5 단계별 행동**: source의 흐름·UI 표현·인터랙션을 따름. 단계 수는 **3-tier 가이드**:
  - **권장: 6~9 단계** — PM/QA 실행성 기준 sweet spot. 별도 안내 없음
  - **10~12 단계: 분리 검토 권장** — 작성 정상 진행, 출력 하단에 의무 안내:
    ```
    ℹ️ 현재 시나리오는 N단계입니다. PM/QA 실행성을 위해 작성/제출/검수 등으로 분리할지 검토하세요. 자동 분리는 하지 않습니다.
    ```
  - **13 단계 이상: cap 초과 경고** — 작성 정상 진행, 출력 하단에 의무 경고:
    ```
    ⚠️ 단계 수가 12를 초과했습니다 (현재 N). 시나리오 분리를 권장합니다.
    ```
  - 자동 자르기 / 자동 분리 절대 금지. PM이 수동으로 분리 여부 결정
- **Section 6 최종 기대 결과**: UI / DB / 외부 모두 작성. 외부 효과가 source에 명시 안 된 경우 `[확인 필요]`
- **Section 7 실패 시 기록 체크리스트**: 표준 항목 그대로 (PM이 실행 시 채움)
- **Section 8 미디어 요구**: priority 따라 default 제안 — P0=모든 단계 스크린샷+영상 / P1=실패 시 스크린샷 / P2=불필요. PM이 변경 가능
- **Section 9 실행 로그**: 빈 헤더만, executor가 라운드별 append

**추측성 UI 위치 제안 금지:**
- ❌ "결제하기 버튼 위로 노출" (source 근거 없는 위치 제안)
- ❌ "메인 화면 상단에 배치" (배치 추측)
- ❌ "팝업으로 표시" (UI 패턴 추측)
- ✅ source에 명시된 위치만 그대로 인용
- ✅ 위치 불명확하면 `[확인 필요]` 또는 Section 5에서 화면 단위로만 기술 ("결제 정보 화면에서 ...")

### Step 7. 시나리오 수 cap 점검 (PM 자가 점검 안내)
- 같은 client/project의 이번 라운드 시나리오 수 = `Glob clients/<c>/<p>/qa/scenarios/SCN-*-*.md | wc -l`
- 화면 수는 PM이 정확히 알지 못하면 v1.5는 자가 점검 안내만:
  ```
  ⚠️ 이번 라운드 SCN 파일 수가 N개입니다. 화면 수 × 1.5 초과 시 시나리오 explosion 위험 — 분리·통합 검토 권장.
  ```
- 자동 작성 차단 X. PM이 결정

### Step 8. 로컬 저장 (3단 fallback)

**저장 경로 우선순위:**

1. `clients/<client>/<project>/qa/scenarios/SCN-<project-slug>-<NNN>.md` — 디렉토리 없으면 `mkdir -p`
2. (project 없거나 unknown) `clients/<client>/_unsorted/qa/scenarios/SCN-unknown-<NNN>.md` — 디렉토리 없으면 생성
3. (client 없거나 불명확) **저장 안 함, 화면 출력만**. 사용자에게 `--client --project`를 명확히 한 후 재실행 안내

**`.gitignore` 정책 (`.gitignore` 자체는 수정 안 함):**
- 1순위·2순위 경로는 `.gitignore`의 `clients/*/` 룰로 자동 git 추적 제외
- 검증: `git check-ignore -v clients/<c>/<p>/qa/scenarios/SCN-...md` → ignored면 정상
- **실제 시나리오 파일을 git add 절대 금지** — PM이 commit하려 해도 정책상 ignored 유지

**project-slug 변환 룰:** `Connectory-1` → `connectory-1` (lowercase + hyphen 유지). frontmatter `project` 값 그대로 사용

**중복 방지:** Step 5의 충돌 방지 룰 적용

### Step 9. 화면 출력 + "다음 단계" 안내

**화면에 출력:**
- 생성된 파일 경로 (또는 3순위 fallback 시 "저장 안 됨, 화면 출력만" 안내)
- frontmatter 요약 (scenario_id / status / priority / srs_ref / brief_ref)
- Section 4 테스트 목표
- Section 5 단계 수 (cap 12 경고 포함)
- "다음 단계" 안내 블록

**"다음 단계" 블록 의무 포함:**
```
📋 다음 단계 (자동 실행 안 함, 안내만):
- 검수 후 발견된 버그: PM 판단 후 /qa-feedback 또는 /issue-ticket 별도 실행 (본문 첫 줄에 "시나리오 ID: SCN-..." 메타 보존)
- status 변경: 파일 frontmatter status: 직접 수정 (작성중 → 검토 → 확정)
- 시나리오 자동화(qa-agent-skills wrapper)는 v3 — `확정` 상태 시나리오만 후보
```

**내부 검수용 의무 안내 (마지막 줄):**
```
⚠️ 이 시나리오는 PM/QA 내부 검수용입니다. 고객·개발팀에 그대로 전달하지 마세요.
```

## Rules

### 필수
- 한국어 출력 (Section 5 단계의 영어 UI 텍스트는 그대로 보존 가능)
- frontmatter status 기본 `작성중` (자동 승급 X)
- "Internal QA scenario draft — for PM/QA validation only. Not a client-facing spec or dev ticket." banner 의무 포함
- source 없는 흐름·기대결과·권한·데이터 조건 발명 금지 — 부족 시 `[확인 필요]`
- 추론은 `[추론]` 태그 명시 (CLAUDE.md L135)
- 단계 수 3-tier 가이드 강제: 6~9 권장 / 10~12 분리 검토 권장 안내 / 13+ cap 초과 경고. 자동 자르기·자동 분리 X
- scenario ID 충돌 시 자동 덮어쓰기 금지

### 금지
- 자동 chain 트리거 (`/qa-feedback` / `/issue-ticket` / `/to-spec` / `/dev-chat` / `/client-chat`)
- Notion / Nexus / Linear 자동 write
- 자동 브라우저 실행 / Playwright / qa-agent-skills 연동 (v3)
- 자동 스크린샷 / HAR 캡처
- 구체 공수(MD/hour/day) AI 산정
- 추측성 UI 위치·버튼·문구 위치 제안
- 기존 시나리오 파일 자동 수정·삭제
- 실제 시나리오 파일을 git add
- `.gitignore` 수정

### PM 판단이 불가능할 때
- source(SRS / Change Brief / PM 입력)가 모두 부족해서 시나리오 작성 자체가 어렵다고 판단되면, 시나리오 작성을 중단하고 PM에게 추가 source 입력 요청
- Change Brief In-Round가 없고 SRS도 없는 상태에서 PM이 강제 진행하면 frontmatter `srs_ref: missing` `brief_ref: none` 두 개 다 명시하고 시나리오를 status=`작성중` 으로만 저장 (확정 X)
