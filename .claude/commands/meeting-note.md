---
description: 미팅 녹취/메모 → 미팅노트(Notion) + 개발팀 메시지 + 고객사 카톡 한번에 생성
argument-hint: --client <name> [미팅 메모 또는 녹취 파일]
allowed-tools: Read, Glob, Grep, Bash, mcp__notion__notion-fetch, mcp__notion__notion-create-pages, mcp__notion__notion-update-data-source
---

# Meeting Note

## Arguments
사용자 입력: $ARGUMENTS

### Named Arguments (선택)
- `--client` / `-c`: 클라이언트명 (필수)
- `--attendee` / `-a`: 참석자 (쉼표 구분)
- `--location` / `-l`: 장소
- `--date` / `-d`: 미팅 날짜 (기본값: 오늘)
- `--ref`: 참고 파일 경로 (PPT, PDF 등 — 복수 가능)

인자가 생략되면 PM에게 확인 요청. 메모 내용은 named arguments 뒤에 자유롭게 입력.

## Design Principle
Part 1 (미팅 노트)은 **source of truth** — Part 2와 Part 3는 Part 1에서 직접 추출하여 생성.
- Part 2 (dev-chat)는 Part 1의 `이번 라운드 반영사항` + `후순위/유지보수`에서 dev 항목만 추출
- Part 3 (client-chat)는 Part 1의 `핵심 요약` + `이번 라운드 반영사항` (고객 가시 항목만) + `고객/PM 확인 필요`에서 추출
- Part 1을 잘 쓰면 Part 2, 3은 추가 분석 없이 섹션 매핑만으로 생성 가능해야 함

## Instructions

### Step 1: 입력 파싱 + 컨텍스트 로드
1. **인자 파싱**:
   - Named arguments 추출: --client, --attendee, --location, --date, --ref
   - 나머지 텍스트 = 녹취록/메모 내용
   - `--ref` 파일이 있으면 Read 또는 Bash로 텍스트 추출 (PPT는 unzip+XML 파싱, PDF는 Read)
   - 텍스트 파일 경로가 주어지면 Read로 읽기
   - `--client`가 없으면 PM에게 확인 요청
   - `--attendee`, `--location` 없으면 [확인 필요]로 표기
2. **컨텍스트 로드**:
   - `clients/{client-name}/CLAUDE.md` — 프로젝트 도메인, 고객사 성향
   - `glossary/{client-name}.md` — 용어 일관성
   - `templates/meeting-note.md` — 출력 구조 참조

### Step 2: 미팅 내용 분석
녹취록/메모에서 아래를 추출하되, **추출 단계에서는 분류만 하고 중복 생성하지 않음**:
1. **미팅 메타**: 일시, 참석자, 장소
2. **모든 합의/변경/요구사항**: 한 곳에 모아서 우선순위 정렬 → `이번 라운드 반영사항`으로
3. **명시적으로 미룬 항목**: → `후순위/유지보수`로
4. **고객/PM이 해야 할 것**: → `고객/PM 확인 필요`로
5. **큰 건 판별**: /to-spec 수준의 큰 기능/변경이 있는지 판단

**핵심: 하나의 항목은 하나의 섹션에만 존재.** 분류 기준:
- 개발팀이 이번 라운드에 반영해야 할 것 → `이번 라운드 반영사항`
- 명시적으로 나중에 하기로 한 것 → `후순위/유지보수`
- 고객사나 PM이 해야 할 것 → `고객/PM 확인 필요`
- 겹치면 가장 실행에 가까운 섹션에 배치

### Step 3: Part 1 — 미팅 노트 (Notion 저장)
`templates/meeting-note.md`의 구조로 작성:

**## 미팅 정보** — 메타데이터만

**## 핵심 요약** — 3-4줄. 이것만 읽어도 미팅 결과 파악 가능.
- 가장 중요한 결정/방향
- 블로커/일정 영향
- 이번 라운드 vs 유지보수 구분

**## 이번 라운드 반영사항** — 메인 섹션. 긴급·결정·액션을 통합.
- 🔴 긴급 항목은 맨 위에 (블로커, 고장난 것, 수정 안 된 것)
- 나머지는 우선순위순으로
- 각 항목: 무엇을 + (왜 필요한지 inline) + 누가/언제

**## 후순위 / 유지보수** — 명시적으로 미룬 것만

**## 고객/PM 확인 필요** — 고객 액션 + PM 판단 필요 + 미결 사항

Notion 커뮤니케이션 DB 저장:
- 제목: "미팅 노트 — [날짜]"
- 클라이언트 / 프로젝트 / 유형: "미팅 노트" / 방향: "Client→Dev" / 작성일: 오늘

### Step 4: Part 2 — 개발팀 전달용 (터미널 출력, 영어)
**Part 1에서 직접 추출** — 새로 분석하지 않음:

| Part 1 섹션 | → Part 2 섹션 | 추출 규칙 |
|-------------|--------------|----------|
| 이번 라운드 반영사항 (🔴 항목) | Critical context | 긴급 블로커만, 상황+이유 포함 |
| 이번 라운드 반영사항 (일반 항목) | This round | dev 구현 항목만 (PM 항목 제외) |
| 후순위/유지보수 | Maintenance later | dev 항목만 |
| 고객/PM 확인 필요 | (포함하지 않음) | 개발팀 대상이 아닌 항목은 제외 |

포맷: /dev-chat 구현 브리프 포맷
- Critical context → This round → Maintenance later → (Open question — 기본 생략)
- 마지막 줄: "Please review and let me know if anything needs more effort than expected."
- 해당 없는 섹션은 생략
- dev 전달 사항이 전혀 없으면 "(개발팀 전달 사항 없음)" 표시

### Step 5: Part 3 — 고객사 전달용 (터미널 출력, 한국어)
**Part 1에서 직접 추출** — 새로 분석하지 않음:

| Part 1 섹션 | → Part 3 섹션 | 추출 규칙 |
|-------------|--------------|----------|
| 핵심 요약 | 오늘 논의된 핵심 내용 | 고객이 알아야 하는 항목만 |
| 이번 라운드 반영사항 | 확정된 사항 + 진행 예정 사항 | 고객 가시 항목만. 내부 기술 디테일 제외. |
| 고객/PM 확인 필요 | 추가 확인 부탁드리는 사항 | Client 항목만 (PM 내부 항목 제외) |

**필터링 규칙** — Part 3에 포함하지 않는 것:
- 내부 버그 수정 디테일 (결과만 전달: "수정 완료 후 안내드리겠습니다")
- PM 내부 액션 (타임라인 정리 등)
- 개발팀 내부 기술 변경 (DB 변경, API 수정 등)
- 일정 지연 사유, 팀 리소스 관련

톤: 합니다체. 클라이언트 CLAUDE.md 기반 추가 조정.

### Step 6: 최종 출력
```
━━━ Part 1: 미팅 노트 (Notion 저장 완료) ━━━
[Notion 링크]

━━━ Part 2: 개발팀 전달용 (Teams 복붙) ━━━
[영어 메시지]

━━━ Part 3: 고객사 전달용 (카톡 복붙) ━━━
[한국어 메시지]

━━━ 추가 제안 ━━━
- /to-spec 추천 항목 (있을 때만)
- PM 액션 리마인더 (있을 때만)
```

## Rules

### 핵심 원칙
- **Part 1 = source of truth** — Part 2, 3은 Part 1에서 추출. 별도 재분석 없음.
- **각 항목은 하나의 섹션에만 존재** — 섹션 간 중복 절대 금지
- **1분 내 스캔 가능** — 실행 중심 브리프
- **"긴급 / 결정 / 액션"을 별도 섹션으로 분리하지 않음** — `이번 라운드 반영사항`으로 통합

### 작성 규칙
- 녹취록이 러프해도 구조화 — 키워드만 있어도 맥락 추론
- 애매한 내용은 추측하지 않음 — `고객/PM 확인 필요`로 분류하거나 추가 제안에서 PM에게 확인 요청
- 추론으로 채운 내용은 [추론] 태그
- Dev 액션 중 2일 이상 / 여러 컴포넌트 → /to-spec 추천 태그
- 해당 없는 섹션은 생략
- 용어는 glossary 기준

### Part별 언어/톤
- Part 1: 한국어. 간결체.
- Part 2: 영어. Direct, practical.
- Part 3: 한국어. 합니다체. 내부 사정 노출 금지.
