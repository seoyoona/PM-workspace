---
description: "[DEPRECATED — /to-spec 4-bucket triage gate로 흡수됨] 진행 중 변경 요청 triage"
argument-hint: --client <name> [--project <name>] [--srs <path|URL>] [--design <path>] [요청 내용 또는 Notion URL]
allowed-tools: Read, Glob, Grep, Bash, mcp__notion-cigro__notion-fetch
deprecated: true
---

# ⚠️ DEPRECATED — `/change-brief` is now `/to-spec` 4-Bucket Triage Gate

> **이 스킬은 deprecate 진행 중입니다.** v1 자산(4-bucket 분류 / Section 5 고객 확인 질문 / Section 6 개발팀 전달 문구 / Hard Boundaries / partial-skip / no-invention / 추측성 UI 자동 제안 금지 / 구체 공수 AI 산정 금지)은 모두 `/to-spec`에 흡수되었습니다.
>
> **권장 흐름:** 진행 중 변경 요청은 `/to-spec --client <name> [요청 내용 또는 Notion URL]` 단일 호출. `/to-spec`이 4-bucket triage → In-Round PM confirm gate → Notion 자동 생성까지 한 흐름으로 처리합니다.
>
> 본 스킬은 deprecate 기간 동안 호출 가능하나, 신규 사용은 `/to-spec` 권장. 1-2주 후 제거 예정.

# Change Brief — Mid-Project Scope Triage (DEPRECATED)

## Arguments
사용자 입력: $ARGUMENTS

## Context
- 출력 템플릿: !`cat /Users/yoona/Documents/yoona-workspace/templates/change-brief.md`
- 진행 중 프로젝트의 클라이언트 추가 요구 / 미팅 결정 / QA 피드백을 4 버킷(In-Round / Next-Round / Out-of-Scope / Confirm-Needed)으로 분류한 Markdown 1장 생성
- **로컬 markdown 저장만**. Notion / Nexus / Linear 자동 write 없음
- design.md / SRS 부재 시 hard-fail 금지 — 해당 섹션만 "확인 필요"로 표시
- ⚠️ **DEPRECATED**: 본 스킬은 `/to-spec` 4-bucket triage gate로 흡수되었습니다. 신규 사용은 `/to-spec` 권장

## Hard Boundaries (이 스킬은 절대 안 함)

1. Official SRS 페이지 / 파일 편집
2. design.md 편집·생성
3. 와이어프레임 / 이미지 / prototype 생성 (yes/no 플래그만)
4. Nexus MCP 호출 (`mcp__nexus-os__*` 어떤 것이든) — read·write 모두 금지
5. Notion 페이지 자동 생성 (커뮤니케이션 / 태스크 / 프로젝트 문서 DB 모두)
6. Linear 이슈 생성
7. `/to-spec` / `/dev-chat` / `/client-chat` 자동 트리거 — "다음 단계" 안내만 출력
8. 구체 공수(MD/hour/day) 임의 산정 — Impact: Low/Medium/High/Unknown만
9. design.md / SRS 부재 시 스킬 전체 hard-fail (해당 섹션만 partial-skip)

## Instructions

### Step 1. 인자 파싱
- `--client` 추출 (필수). 누락 시 `templates/client-default.md` 규칙 적용
- `--project` 추출 (선택). 미입력 시 frontmatter에 `project: unknown`
- `--srs <path or URL>` 추출 (선택)
- `--design <path>` 추출 (선택). 미지정 시 `clients/<client>/<project>/design.md` 자동 탐색
- 나머지 입력: free-text 또는 Notion URL (단일)

### Step 2. 컨텍스트 로드 (병렬 가능, 서로 독립)
- `glossary/{client-name}.md` — 용어집
- `clients/{client-name}/CLAUDE.md` — 클라이언트 컨텍스트
- 위 둘은 부재해도 진행 (best-effort)

### Step 3. 입력 소스 가져오기

**Notion URL 입력 시:**
- `mcp__notion-cigro__notion-fetch`로 페이지 블록 읽기
- **fetch 실패 시 hard-fail 금지** — 다음 메시지 출력 후 free-text 모드로 전환:
  ```
  ⚠️ Notion 페이지를 읽지 못했습니다. meeting-note 내용을 직접 붙여넣어 주세요.
  ```
  사용자가 텍스트를 붙여넣을 때까지 대기 (single-prompt fallback)

**free-text 입력 시:** 그대로 사용

**source 분류:**
- 입력에 `## Action Items` 또는 미팅노트 구조가 보이면 `source: meeting-note`
- 그 외는 `source: free-text`

### Step 4. SRS / design.md 참조 (read-only, partial-skip)

**SRS:**
- `--srs` 경로/URL이 주어지면 read 시도
- 로컬 파일 → `Read` tool / Notion URL → `mcp__notion-cigro__notion-fetch`
- read 성공 시 frontmatter `srs_ref`에 경로/URL 기록, Section 2에 영향 섹션 추출
- read 실패 또는 미지정 시 frontmatter `srs_ref: missing`, Section 2에 다음 한 줄:
  > SRS 미연결 — Nexus Agent / PM 확인 필요

**design.md:**
- `--design` 경로 또는 자동 탐색 (`clients/<client>/<project>/design.md`)
- 파일 존재 시 Read로 로드, frontmatter `design_md`에 경로 기록
- 부재 또는 read 실패 시 frontmatter `design_md: missing`, Section 3에 다음 한 줄:
  > design.md 부재 — UI 영향 상세 판단은 design owner / Nexus Agent 확인 필요
- design.md를 임의 생성·수정 절대 금지

### Step 5. 4-Bucket 분류

각 변경 항목을 다음 기준에 따라 분류. **기준 미일치 항목은 기본 Confirm-Needed로 보낸다. 애매한 걸 In-Round로 올리지 않는다.**

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

빈 버킷은 `(현재 항목 없음)`으로 명시 (CLAUDE.md "빈 섹션 생성 금지" 룰과 충돌 회피).

### Step 6. Impact 표기

- 각 In-Round / Next-Round 항목에 `Impact: Low | Medium | High | Unknown` 부여
- **구체 공수 (MD / hour / day) 임의 산정 절대 금지**
- 명확하지 않으면 `Unknown` 또는 `Dev 확인 필요`

### Step 7. Section 5 / Section 6 생성

**Section 5 (고객 확인 질문):**
- Confirm-Needed 버킷의 항목들로부터 한국어 합니다체 질문 자동 생성
- client-chat 톤 (CLAUDE.md `feedback_client_chat_tone.md` 참조)
- Confirm-Needed가 비어 있으면 `(현재 확인 필요 항목 없음)`
- **추측성 UI 제안 금지.** source / SRS / design.md에 근거 없는 구체 UI 위치, 버튼 위치, 화면 배치, 문구 위치를 먼저 제안하지 않는다. 위치/문구가 불명확하면 "어느 화면/단계에 노출할지 확인 필요" / "별도 선호가 있으신지 확인 필요"처럼 중립적으로 묻는다.
  - 금지 예: `"결제하기 버튼 위로 봐도 될까요?"` (특정 위치 추측)
  - 허용 예: `"결제 전 안내 문구를 어느 화면/단계에 노출할지 확인이 필요합니다."` (중립 질문)

**Section 6 (개발팀 전달 문구):**
- frontmatter `status:`가 `Dev-Handoff`일 때만 채움
- `Draft` 또는 `PM Review`면 비워 둠 (또는 "status가 Dev-Handoff가 되면 자동 생성됩니다." 안내만)
- In-Round 버킷 기준으로 English summary + AC 후보 작성
- 구체 공수 산정 금지

### Step 8. 로컬 저장 (3단 fallback)

**저장 경로 우선순위:**
1. `clients/<client>/<project>/change-briefs/YYYY-MM-DD-<slug>.md` — 디렉토리 없으면 `mkdir -p`로 생성
2. (project 없거나 unknown) `clients/<client>/change-briefs/YYYY-MM-DD-<slug>.md` — 디렉토리 없으면 생성
3. (client도 불명확) **저장하지 않고 화면 출력만**. 사용자에게 "client/project를 지정해 주세요" 안내

**slug 생성 규칙:** Section 1의 "한 줄 요약"을 lowercase + 공백→hyphen + 특수문자 제거. 30자 이내.

**중복 방지:** 같은 날 같은 slug가 이미 존재하면 `-2`, `-3` 등 suffix 추가.

### Step 9. 화면 출력 + "다음 단계" 안내

**화면에 출력:**
- 생성된 파일 경로
- Section 1 (변경 요청 요약)
- Section 4 4-bucket 요약 (각 버킷 항목 수)
- "다음 단계" 안내 블록 (자동 실행 없음, 명령어 안내만)

**"다음 단계" 블록 의무 포함:**
```
📋 다음 단계 (자동 실행 안 함, 안내만):
- 고객 확인이 필요하면: /client-chat에 Section 5 사용
- 개발팀 전달이 필요하면: /dev-chat에 Section 6 사용
- 티켓 분해가 필요하면, PM 검토 후: /to-spec --client <client> --source change-brief <path> 별도 실행
- 상태 변경: 파일 frontmatter status: 직접 수정 (Draft → PM Review → Dev-Handoff)
```

**In-Round 의미 안내 (의무 포함, 마지막 줄):**
```
⚠️ In-Round로 분류되었더라도, status가 `Dev-Handoff`로 변경되기 전까지 개발팀 전달 확정안이 아닙니다.
```

## Rules

### 필수
- 한국어 출력 (Section 6 English summary 제외)
- "원문 인용" 블록은 1-3줄로 짧게, 원본 그대로 (수정/요약 금지)
- 추론은 `[추론]` 태그로 명시 (CLAUDE.md L135)
- 4-bucket 분류는 기준 명시적 — 애매하면 무조건 Confirm-Needed
- design.md / SRS는 read-only, 절대 수정·생성 안 함
- Notion / Nexus / Linear 자동 write 절대 안 함

### 금지
- 자동 chain 트리거 (`/to-spec`, `/dev-chat`, `/client-chat` 호출 안 함)
- 구체 공수 (1MD, 3시간 등) 임의 산정
- design.md / SRS 부재 시 hard-fail
- Section 6을 status<Dev-Handoff에서 채우는 것
- 와이어프레임 / 이미지 생성

### PM 판단이 불가능할 때
- 입력이 모호해 4-bucket 분류 자체가 어려우면 모든 항목을 `Confirm-Needed`로 보내고 Section 5에서 PM/고객에게 명확화 질문 작성
