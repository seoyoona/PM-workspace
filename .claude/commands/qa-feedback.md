---
description: 고객 QA 피드백 → 내부 개발팀 티켓 자동 생성 (번역 + 분류 + Notion 연동)
argument-hint: --qa-db <고객 QA DB 링크> --project <프로젝트명> [--internal <내부 QA 페이지 링크>]
allowed-tools: Read, Glob, Grep, mcp__notion__notion-fetch, mcp__notion__notion-create-pages, mcp__notion__notion-update-page, mcp__notion__notion-search, mcp__notion__notion-update-data-source
---

# QA Feedback → Dev Ticket

## Arguments
사용자 입력: $ARGUMENTS

## Context
- 고객사가 검수 페이지의 QA DB에 남긴 피드백을 읽어서, 내부 Tasks DB에 영문 티켓으로 생성
- 고객 QA DB → 읽기 (한국어 피드백)
- 내부 Tasks DB → 쓰기 (영문 티켓)
- 핵심 가치: 번역 + 분류 + 티켓 생성을 한 번에

## DB References

### 고객 QA DB (소스 — 프로젝트마다 다름)
- 사용자가 링크 또는 collection:// ID 제공
- 공통 스키마: 페이지(title), 수정내용(text), 스크린샷(file), 요청일자(date), Status(status), 검수회차(select)
- Status 값: 대기중, 진행중, 검수요청, 재검수요청, 해결안됨, 완료, 기획 필요, 추가개발

### 내부 Tasks DB (타겟 — 프로젝트마다 다름)
- **하드코딩하지 않음** — 내부 QA 페이지를 fetch하여 하위 Tasks DB의 data source URL과 스키마를 동적으로 읽음
- 프로젝트마다 필드명과 옵션이 다를 수 있음 (예: Title vs Tittle, Summary vs Description)
- 반드시 fetch한 스키마 기준으로 필드 매핑

### 내부 QA 페이지 찾기 (2가지 방법)
**방법 1: --project로 검색**
- Projects DB (collection://98c3ff93-01f1-4b2e-a490-d827ac079ffc)에서 프로젝트명 검색
- 검색 결과에서 내부 QA 페이지 URL 확보

**방법 2: --internal 링크 직접 제공**
- 사용자가 내부 QA 페이지 링크를 직접 제공
- 검색 실패 시 fallback으로 사용

**매핑 실패 처리:**
- 검색 결과 0건 → 사용자에게 내부 QA 페이지 링크 요청
- 검색 결과 2건 이상 → 목록 보여주고 선택 요청
- 검색 결과 1건 → 사용자에게 확인 후 진행

## Instructions

### Step 1: 입력 파싱 + DB 접근 확인
1. 사용자 입력에서 고객 QA DB 링크, 프로젝트명, (선택) 내부 QA 페이지 링크 추출
2. 고객 QA DB를 fetch하여 data source URL(collection://) 확보
3. 내부 QA 페이지 찾기:
   - `--internal` 제공됨 → 해당 링크 사용
   - `--project`만 제공됨 → Projects DB에서 검색
     - 결과 0건 → 사용자에게 내부 QA 페이지 링크 직접 요청
     - 결과 2건 이상 → 목록 보여주고 선택 요청
     - 결과 1건 → 확인 후 진행
4. 내부 QA 페이지를 fetch → 하위 Tasks DB의 data source URL과 스키마 동적 확보
5. 스키마에서 title 필드명, description 필드명, status 옵션, feature 옵션 등 파악
6. 접근 실패 시 사용자에게 알리고 중단

### Step 2: 고객 피드백 읽기
1. 고객 QA DB에서 미처리 항목 읽기
2. 대상 Status: **"대기중"** (기본) — 사용자가 다른 Status 지정 가능
3. 각 항목에서 추출: 페이지(위치), 수정내용, 스크린샷 유무, 요청일자, 검수회차

### Step 3: 미리보기 (필수)
**티켓을 바로 생성하지 않음.** 먼저 변환 결과를 테이블로 보여줌:

```
## QA 피드백 변환 미리보기 ({n}건)

| # | 원문 요약 | → Title (EN) | Priority | QA Category |
|---|----------|-------------|----------|-------------|
| 1 | 홈화면 배너 안보임 | Home banner not displaying | High | UI Bug |
| 2 | 결제 오류 | Payment error on checkout | 🔥Highest🔥 | Logic Bug |
```

사용자가 확인 후:
- "생성해줘" / "진행" → Step 4로
- 수정 요청 → 반영 후 다시 미리보기
- "취소" → 중단

### Step 4: 티켓 생성
각 항목을 내부 Tasks DB에 생성:

**필드 매핑 (동적):**
Step 1에서 확보한 내부 Tasks DB 스키마를 기준으로 매핑. 필드명은 프로젝트마다 다를 수 있으므로 하드코딩하지 않음.

| 고객 QA DB | → | 내부 Tasks DB (필드명은 스키마에서 확인) |
|-----------|---|--------------------------------------|
| 페이지 + 수정내용 | → | title 필드 (영문 변환, 간결하게) |
| 수정내용 상세 | → | description/summary 필드 (영문, 모드 A/B/C) |
| (Claude 분류) | → | status 필드 → 스키마의 to_do 그룹 첫 번째 값 |
| (Claude 분류) | → | feature/category 필드가 있으면 → 스키마 옵션에서 가장 적합한 값 매핑 |
| (Claude 분류) | → | role 필드가 있으면 → User / Admin 구분 |
| (Claude 분류) | → | priority 필드가 있으면 → 스키마 옵션에서 매핑 |
| — | → | from customer / 고객 요청 관련 checkbox가 있으면 → true |
| — | → | 프로젝트 relation이 있으면 → 내부 QA 페이지 URL |

**핵심: 내부 DB에 없는 필드는 스킵. 있는 필드만 채움.**

**Title 작성 규칙:**
- 영어, 50자 이내
- 형식: `[Page] Issue description`
- 예: `[Home] Banner image not displaying on first load`

**Description 작성 규칙:**

Title 필드에 이미 페이지명 + 요약이 있으므로, Description에는 타이틀을 반복하지 않음.

**모드 판단 기준:**
Issue가 Expected와 다른 정보를 담는가?
- No → 모드 A (Expected만)
- Yes → 모드 B (Issue + Expected)
- Yes + 재현 조건/빈도/환경 → 모드 C (Issue + Expected + Context)

**모드 A — 단순 변경 (Expected만 충분한 경우):**
```
Expected: "대표 사진" (main photo) should be 3:2 aspect ratio
```
```
Expected: Auto-complete timer should be 30min, not 5min
```

**모드 B — 버그/오작동 (현재 동작 설명이 필요한 경우):**
```
Issue: Tapping "선택 정지 처리" (suspend) does not block the user — they can still use the app
Expected: Suspended user should be blocked immediately
```

**모드 C — 버그 + 맥락:**
```
Issue: Image upload sometimes fails — select photo/video → tap "완료" (Done) → no change
Expected: Image should upload reliably every time

Context: Intermittent. Reproduction details requested from client.
```

핵심 원칙:
- **타이틀 중복 금지** — Description에 페이지명/제목 헤더 넣지 않음
- **UI 요소명은 한국어 원문 + 영어 괄호**: `"선택 정지 처리" (suspend)`, `"완료" (Done)`
- **각 줄 1-2줄** — 스캔 가능하게
- **Context는 optional** — 없으면 섹션 자체 생략
- **추론 금지** — 고객이 말한 것만 번역. 해석 추가하지 않음
- **번역 오차 0 목표** — 애매한 표현은 원문 그대로 인용하고 영어 괄호 병기
- 불필요한 filler 없음: "Please", "It seems", "There is a problem with" 등 삭제
- **간결 우선** — Expected만으로 충분하면 Issue를 쓰지 않음

**Priority 분류 기준:**
| Priority | 기준 |
|----------|------|
| ⚠️ Critical ⚠️ | 서비스 불가, 데이터 손실, 결제 오류 |
| 🔥Highest🔥 | 핵심 기능 장애, 사용 불가 |
| High | 기능 오작동, UX 심각 |
| Middle | UI 깨짐, 비핵심 기능 |
| Low | 오타, 미세 UI, 개선 제안 |

**QA Category 분류:**
- **UI Bug**: 레이아웃, 텍스트, 이미지, 스타일 문제
- **Logic Bug**: 기능 오작동, 데이터 불일치, 에러
- **UX / Non-functional Optimization**: 성능, 사용성 개선

### Step 5: 고객 QA DB 상태 업데이트 (선택)
미리보기에서 사용자에게 확인:
```
고객 QA DB의 처리된 항목 Status를 "진행중"으로 변경할까요?
1. 변경 (추천)
2. 유지
```

### Step 6: 결과 보고
```
## QA 피드백 처리 완료

- 처리: {n}건
- 생성된 티켓:
  1. [Title] — Priority — [링크]
  2. [Title] — Priority — [링크]
- 고객 DB 상태 업데이트: ✅ / ⏭️ 스킵
```

## Rules
- **미리보기 필수** — 바로 생성하지 않음
- **원문 보존** — UI 요소명, 버튼명 등은 한국어 원문 + 영어 괄호 병기. 번역 오차 0 목표
- **스크린샷** — 파일 자동 이전 불가. Description에 스크린샷 언급하지 않음
- **중복 방지** — 이미 같은 수정내용으로 생성된 티켓이 있으면 스킵하고 알림
- **glossary 확인** — `glossary/{client-name}.md` 있으면 용어 일관성 유지
- **비고(개발자) 필드** — 고객 QA DB에 개발자 메모가 있으면 Summary에 포함
- **검수회차 표시** — 2차 이상이면 Title에 `[Round N]` 접두사 추가
