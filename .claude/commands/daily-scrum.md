---
description: 프로젝트별 daily scrum 로그 → Notion DB 저장
argument-hint: --client <name> [오늘 업데이트]
allowed-tools: Read, Glob, Grep, Bash
---

# Daily Scrum Log

## Arguments
사용자 입력: $ARGUMENTS

## Context
- 매일 5분 daily scrum / daily check-in 내용을 Notion DB에 기록
- PM이 러프하게 입력한 내용을 구조화하여 저장
- 기록 중심 스킬 — 전달용 메시지 생성이 아님
- 매일 1건씩 누적되어 프로젝트별 히스토리 형성

## Output Destination
- **Notion**: Daily Scrum Log DB (`339823375b0c81908969c064880c8113`) — Bash curl API
- **터미널**: 저장된 내용 요약 출력 (본인 확인용)

## Instructions

1. **인자 파싱**: 클라이언트명과 scrum 내용 추출
2. **컨텍스트 로드**:
   - `clients/{client-name}/CLAUDE.md` — 프로젝트명 확인
   - `glossary/{client-name}.md` — 용어 일관성
3. **내용 분류**: 입력을 아래 섹션으로 자동 분류
4. **Notion 저장**: Daily Scrum Log DB에 새 페이지 생성
5. **터미널 출력**: 저장된 내용 요약

## Notion Page Structure

### Properties
- 제목: "Daily — {YYYY-MM-DD}"
- 클라이언트: {client-name}
- 프로젝트: {project-name}
- 날짜: {today}
- 상태: "정상" 또는 "Blocker 있음" (blocker 유무에 따라 자동 판단)

### Page Content

```
## 오늘 할 일
- {담당 파트}: {할 일} ({상태/예상 완료 시점})
- {담당 파트}: {할 일}

## Blocker
- {blocker 내용} — {원인/대기 대상}

## 메모
- {추가 정보, 공유 사항, 근태 등}
```

## Classification Rules

입력 내용을 아래 기준으로 분류:

| 분류 | 감지 신호 |
|------|----------|
| **오늘 할 일** | "오늘", "할 예정", "진행 중", "작업 중", "완료 예정", 구현/수정/개발 관련 |
| **Blocker** | "blocked", "대기", "막힘", "응답 없음", "확인 필요", "못함" |
| **메모** | 근태, 휴가, 일정, 참고사항, 위 두 분류에 해당하지 않는 것 |

## Rules

- Blocker가 없으면 Blocker 섹션 생략
- 메모가 없으면 메모 섹션 생략
- 오늘 할 일은 항상 포함 (입력이 너무 짧아도 최소 1개는 추출)
- 같은 날짜 + 같은 클라이언트로 이미 기록이 있으면 PM에게 알리고 확인 요청
- 한국어 입력 → 한국어로 저장 (영어 변환 불필요)
- 담당 파트(FE/BE/디자인/QA 등)가 입력에 있으면 보존, 없으면 생략
- 간결하게 — bullet당 1줄, 설명 최소화

## Terminal Output Format

```
✅ Daily Scrum 저장 완료

📅 {date} | {client} — {project}
상태: {정상 / Blocker 있음}

오늘 할 일:
- {item 1}
- {item 2}

Blocker:
- {blocker}
```
