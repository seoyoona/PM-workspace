---
description: 미팅 녹취/메모 → 미팅노트(Notion) + 개발팀 메시지 + 고객사 카톡 한번에 생성
argument-hint: --client <name> [미팅 메모 또는 녹취 파일]
allowed-tools: Read, Glob, Grep, Bash, mcp__notion-cigro__notion-create-pages, mcp__notion-cigro__notion-fetch, mcp__notion-cigro__notion-update-page
---

# Meeting Note

## Arguments
사용자 입력: $ARGUMENTS

### Named Arguments
- `--client` / `-c`: 클라이언트명 (필수)
- `--attendee` / `-a`: 참석자
- `--location` / `-l`: 장소
- `--date` / `-d`: 미팅 날짜 (기본값: 오늘)
- `--ref`: 참고 파일 경로

## Design Principle
**Part 1 = source of truth.** Part 2/3은 Part 1의 Action Items 테이블 + 결정/합의 섹션에서 쿼리해 생성.

**핵심 철학**: 이 스킬의 목적은 "더 많은 액션을 만드는 것"이 아니라 "실제 액션이 더 선명하게 보이게 하는 것". Action Item 개수가 줄어드는 건 회귀가 아니라 개선이다.

## Instructions

### Step 1: 입력 파싱 + 컨텍스트 로드
1. Named arguments 추출.
2. `--ref` 파일 Read 또는 Bash로 텍스트 추출 (PPT는 unzip+XML, PDF는 Read, DOCX는 unzip word/document.xml + regex).
3. 컨텍스트 병렬 로드: `clients/{client-name}/CLAUDE.md`, `glossary/{client-name}.md`, `templates/meeting-note.md`.

### Step 2A — Phase A: Raw 후보 추출 (내부, Notion 저장 안 함)
녹취에서 **actionable 후보**를 모두 수집. 이 단계에서는 분류·압축·요약 금지.

**수집 규칙:**
- 누군가 "해야 한다 / 하기로 했다 / 확인해달라 / 고쳐야 한다 / 전달하겠다" 등의 발화를 한 문장을 모두 후보로 나열.
- "네 그렇게 하죠" / "좋습니다" 같은 **상호 합의 암시**가 포함된 주변 2~3줄도 후보로 허용.
- 각 후보는 반드시 다음 필드를 갖는다:
  - `source_quote`: 녹취 원문에서 복사 (최대 2줄). 원문에 없으면 후보 자체를 만들지 않는다.
  - `raw_text`: 후보 내용 요약 (1줄)
  - `owner_hint` (선택): 녹취에 owner가 명시된 경우만
  - `due_hint` (선택): 녹취에 기한/날짜가 명시된 경우만
- 중복 제거·우선순위 판정·카테고리 분류는 이 단계에서 하지 않는다. 같은 주제가 여러 번 나오면 모두 별도 후보로 기록.

**금지:**
- 녹취에 없는 내용 추가 금지.
- "이건 아마 개발팀이 해야 할 것" 같은 모델 자체 판단 금지 — 발화 주체가 있을 때만 후보.
- owner/due를 추정으로 채우지 말 것. 명시되지 않으면 null.

### Step 2B — Phase B: 분류·스키마 매핑 (사용자 노출)
Phase A 후보를 아래 결정 트리로 분류하고, Action Item 스키마를 채운다.

**결정 트리:**
```
[후보]
  ├─ source_quote 없음 → 폐기
  ├─ 실행 동사 없음, 사실/상태 서술 → (a) PM 참고 배경
  ├─ "어떨까 / 고민 / 의논 중" 논의 상태 → (b) 메모해둘 이슈
  ├─ 합의·방침 명시, 실행 주체 없어도 됨 → (c) 이번 미팅에서 확정된 것
  ├─ 실행 동사 + owner 명시 or 문맥상 분명 → (d) Action Items
  │    ├─ 블로커/"오늘/당장/최우선" 명시 → 바로 진행할 일
  │    ├─ "검토·판단·확인·승인" + 명시적 요청 주체 → 확인 후 회신할 일
  │    └─ 나머지 → 바로 진행할 일
  ├─ "이번엔 안 함 / 나중에" 명시 + 신규 기능 + 스코프 미확정 → (e) 이번 라운드 범위 밖
  └─ owner/action/요청 주체 중 2개 이상 불명 → (f) 메모해둘 이슈 (Action 승격 금지)
```

**Action Item 내부 스키마 (전부 채움, 근거 없으면 null):**

| 필드 | 필수/선택 | 비고 |
|---|---|---|
| `priority` | 필수 | 🔴긴급 / 🟡실행 / 🔵확인. 판단 불가면 Action 미등록 → `논의 메모`로 |
| `owner` | 강권장 | Dev / Client / PM / 복합. 근거 없으면 `[확인 필요]` + conf=low |
| `action` | 필수 | 실행 단위 평서문 |
| `due` | 선택 | 녹취에 명시 시에만. 추정 금지 |
| `status` | 선택 | 녹취에 명시 시에만 |
| `confidence` | 필수 | high(명시합의) / medium(맥락추론) / low(불확실) |
| `source_quote` | 필수 | 없으면 Action 생성 금지 |
| `context` | 선택 | 왜 필요한지 한 줄 |

**승격 보수 규칙:**
- **바로 진행할 일**: 블로커·긴급 명시 + 실행 동사 + owner 확정. 나머지 일반 실행도 여기.
- **확인 후 회신할 일**: "누군가가 확인·정리·응답·승인해야 하는 **명시 요청**"일 때만. 단순 "owner 불명"으로 여기에 넣지 않음.
- **Action Item 미등록**: owner/action/요청 주체 중 2개 이상 불명확하면 `메모해둘 이슈`로. 억지 승격 금지.

**공통 금지사항:**
- 녹취에 없는 내용 추가 금지. 추론 필요 시 `[추론]` + 근거 quote 병기. 근거 자체 없으면 null.
- '~일 것 같다' / '~해야 할 것이다' 같은 모델 자체 판단은 Action이 아니다.
- 하나의 액션은 Action Items 테이블에 **단 한 번**만 등장. 본문 prose에서 재서술 금지.

### Step 3: Part 1 — 미팅 노트 (Notion 저장)

`templates/meeting-note.md`의 구조로 작성.

**섹션 구성 (Notion 렌더 최적화):**

```
## 미팅 정보
일시 / 참석자 / 장소 (인라인 2-3줄)

## 한눈에 보기
- [결론 1]
- [결론 2]
- [결론 3]
(3-4줄. Action Items + 확정 사항에서만 도출. 새 내용 창작 금지.
 아래 섹션에서 같은 문장 반복 금지.)

## 이번 미팅에서 확정된 것
- [명시 합의된 방향/사양]
(결정·합의만. 진행 상태 bullet 금지. 액션 없어도 기록.)

## Action Items

### 바로 진행할 일
- **[Owner]**
  [액션 문장 — 1줄, 실행 단위]
  기한: [있을 때만]
  이유: [필요할 때만, sub-bullet 1줄]

### 확인 후 회신할 일
- **[Owner]**
  [확인/정리/승인 요청 — 1줄]
  기한: [있을 때만]
  비고: [필요할 때만]

(불릿 형식. 표 사용 금지.
 owner 볼드로 먼저 → 액션 문장 → sub-bullet로 기한/이유/비고.
 한 bullet에 현상+원인+결정+액션 복합 금지.
 confidence/status/source_quote는 내부 보관, 본문 미노출.
 `[추론]`은 액션 문장 끝에 인라인 태그로만.
 해당 없는 하위 그룹은 통째로 생략.)

## 이번 라운드 범위 밖
- [신규 기능 후보 / 명시적으로 미룬 항목]
  - [부연 설명 sub-bullet]
("지금 착수 아님" 선언. 기존 후순위/유지보수도 여기 통합.)

## 메모해둘 이슈
- [미결 논의 / in-flight / 재발 방지 기록]
  - [부연 sub-bullet]
(owner/action 불명확하여 Action 승격 안 된 항목도 여기.)

## PM 참고 배경
- [전략 맥락, 고객 감정, 관계 이슈]
(Part2/3에 노출하지 않음.)
```

**각 섹션은 내용 없으면 생략.**

**source_quote는 Notion에 저장하지 않음** — Phase B 내부 검증용으로만 사용.

**중복 체크 (C1 멱등성 가드)** — 저장 직전 실행:
- Unique key: 회의명 + 날짜 + 클라이언트.
- 커뮤니케이션 DB(`collection://47d3aae9-a894-83bf-8db8-071dd9a16fcd`)에서 `mcp__notion-cigro__notion-fetch`로 필터 조회:
  ```json
  {"and": [
    {"property": "클라이언트", "select": {"equals": "<client>"}},
    {"property": "유형", "select": {"equals": "미팅 노트"}},
    {"property": "작성일", "date": {"equals": "<meeting-date>"}}
  ]}
  ```
- 결과 분기:
  - 0건 → 바로 생성.
  - 1건 이상 → 사용자 확인:
    ```
    ⚠️ 같은 날짜의 미팅 노트가 이미 있습니다:
    - [제목] (작성일: YYYY-MM-DD) — [링크]

    1. 덮어쓰기 (기존 archive + 새로 생성) (추천)
    2. 새로 생성 (다른 미팅이면)
    3. 취소
    추천: 1
    ```
    - 1 → 최근 1건 archive → 새로 생성.
    - 2 → 중복 허용 새로 생성.
    - 3 → 중단.
- archive 실패 시 생성 중단.

Notion 저장 (`mcp__notion-cigro__notion-create-pages`, data_source_id: `47d3aae9-a894-83bf-8db8-071dd9a16fcd`):
- 제목: "미팅 노트 — [날짜]"
- 클라이언트 / 프로젝트 / 유형: "미팅 노트" / 방향: "Client→Dev" / 작성일: 오늘.

### Step 4: Part 2 — 개발팀 전달용 (영어, Teams 복붙)

**Part 1의 Action Items + 이번 미팅에서 확정된 것 + 메모해둘 이슈에서 쿼리해 생성.** Teams 톤 서술 bullet로 풀어쓴다.

| 쿼리 | → Part 2 섹션 |
|---|---|
| 바로 진행할 일 WHERE owner IN (Dev, Dev+*) + 긴급 | Critical context (2~3줄 bullet) |
| 바로 진행할 일 WHERE owner IN (Dev, Dev+*) + 비긴급 + 이번 미팅에서 확정된 것 dev 대상 | This round (3~5 bullet) |
| 메모해둘 이슈 WHERE dev 대상 | Discussion/open (1~2줄, 기본 생략) |
| 이번 라운드 범위 밖 WHERE owner=Dev | Maintenance later (해당 시만) |

**제외:** owner=Client만, owner=PM만, PM 참고 배경.

**톤 규칙:**
- 표 복제 금지. 쿼리 결과를 자연스러운 서술 bullet로.
- 각 bullet 1줄. Critical context는 "상황 + 왜 긴급한지" 2줄 이내.
- due가 있으면 inline `— by Apr 23` 형태로.
- 마지막 줄: `Please review and let me know if anything needs more effort than expected.`

포맷:
```
📌 [{project}] Meeting follow-up — {date}

Critical context:
- ...

This round:
- ...

Discussion/open: (있을 때만)
- ...

Maintenance later: (있을 때만)
- ...

Please review and let me know if anything needs more effort than expected.
```

### Step 5: Part 3 — 고객사 전달용 (한국어, 카톡 복붙)

**Part 1에서 쿼리.** 표 복제 금지 — 합니다체 서술문으로 풀어쓴다.

| 쿼리 | → Part 3 섹션 |
|---|---|
| 한눈에 보기 (고객 가시) | 오늘 논의된 핵심 내용 |
| 이번 미팅에서 확정된 것 (고객 가시) | 확정된 사항 |
| 바로 진행할 일 WHERE owner IN (Dev, PM) + 고객 가시 | 진행 예정 사항 |
| 확인 후 회신할 일 WHERE owner=Client | 추가 확인 부탁드리는 사항 |
| 이번 라운드 범위 밖 | "진행 예정" 끝에 한 줄로 녹임 |

**제외:** 내부 버그 수정 디테일, PM 내부 액션, 개발팀 내부 기술 변경, 일정 지연 사유, 팀 리소스, PM 참고 배경, [추론] 태그.

**톤 규칙:**
- 합니다체. 결과 중심 한 줄 서술.
- 체크박스·표·기술 디테일 금지.
- `추가 확인 부탁드리는 사항`은 번호 목록 허용 (2개 이상일 때).

### Step 6: 최종 출력
```
━━━ Part 1: 미팅 노트 (Notion 저장 완료) ━━━
[Notion 링크]

━━━ Part 2: 개발팀 전달용 (Teams 복붙) ━━━
[영어 메시지]

━━━ Part 3: 고객사 전달용 (카톡 복붙) ━━━
[한국어 메시지]

━━━ 추가 제안 ━━━
- /to-spec 추천 (있을 때만): priority=🔵 + 신규 기능 후보 + 요청 주체 명확
- PM 액션 리마인더 (있을 때만)
```

## Rules

### 핵심 원칙
- **Action Items가 single source of truth** — 모든 액션은 여기에만, 다른 섹션에서 재서술 금지.
- **근거 없는 필드는 null** — `source_quote` 없는 액션은 생성 금지. owner/due는 녹취 명시 시에만.
- **Action Item 승격 문턱 높게** — 모호하면 `메모해둘 이슈`로. 개수가 줄어드는 건 회귀 아님.
- **각 항목은 하나의 섹션에만 존재** — 섹션 간 중복 절대 금지. 특히 `한눈에 보기`와 아래 섹션 간 같은 문장 반복 금지.
- **Part 1 = source of truth** — Part 2/3은 쿼리만.

### Notion 렌더 규칙
- **불릿 중심**: Action Items는 표가 아닌 불릿/체크리스트형. owner 볼드 → 액션 1줄 → sub-bullet 기한/이유.
- **한 bullet = 한 성격**: 현상+원인+결정+액션을 한 bullet에 넣지 않음. main bullet = 실행 단위, sub-bullet = 부연.
- **짧은 bullet**: 2줄 이상 넘어가면 분리.
- **내부 정보 미노출**: confidence, status, source_quote는 본문에 노출하지 않음. `[추론]`만 인라인.
- **해당 없는 섹션은 생략.**

### 작성 규칙
- 녹취 러프해도 구조화하되 **발화 없는 액션 창작 금지**.
- 추론은 `[추론]` 태그 + 근거 quote. 근거 없으면 Action 미등록.
- `confidence=low` 액션이 신규·스펙 미확정 성격이면 Action Items 대신 `이번 라운드 범위 밖`으로 보내는 것을 우선 검토.
- Dev 액션 중 2일 이상 / 여러 컴포넌트 + owner·스펙 명확 → /to-spec 추천 태그.
- 용어는 glossary 기준.

### Part별 언어/톤
- Part 1: 한국어, 간결체. 불릿 중심, 블록 구조.
- Part 2: 영어, Direct/practical. 서술 bullet.
- Part 3: 한국어, 합니다체. 결과 중심. 기술 디테일·표·체크박스 금지.

### 내부 검증 (선택 실행)
- Action Item 각 행의 `source_quote`가 녹취 원문에 있는지 확인.
- 자동: (i) exact substring match, (ii) 실패 시 공백·문장부호 정규화 재시도, (iii) 3-gram 겹침률 ≥70%.
- 수동: 무작위 3~5건 PM이 녹취와 대조.
- 성공 기준: exact ≥80%, exact+근접 ≥95%, 샘플 왜곡 0.
