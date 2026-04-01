---
description: 아침 브리핑 — 오늘 할 일, 진행 중 현황 요약 (평일 10:30 자동 실행)
argument-hint: (인자 없이 실행 또는 "오늘 뭐해야돼")
allowed-tools: Read, Glob, Grep, mcp__notion__*, mcp__google-workspace__*
---

# Today Brief

## Arguments
사용자 입력: $ARGUMENTS

## Context
- 매일 아침 출근 후 첫 번째로 실행하는 브리핑 스킬
- PM이 "오늘 뭐해야하지?" 한마디로 전체 상황을 파악할 수 있게
- 평일 10:30 KST에 Remote Trigger로 자동 실행됨
- 수동으로도 실행 가능: `/today-brief` 또는 "오늘 뭐해야돼"
- 터미널 출력만 — Notion 저장 없음

## Data Sources

1. **PM Action Hub DB** (collection://3a13db31-882c-4a6c-bddf-660e15ea9cdd)
   - 상태 = "오늘" → 오늘 처리할 액션
   - 상태 = "진행 중" → 현재 진행 중인 액션
   - **다른 상태값(미착수, 완료, 대기)은 가져오지 않음**
2. **Google Calendar** (가능한 경우)
   - 오늘 미팅 목록

## Output Structure

```
☀️ {YYYY-MM-DD} ({요일}) — 오늘 브리핑

📋 오늘 ({n}건)
- [BaraeCNP] 문의내용 회신
- [RCK] timeline 정리
- [Koboom] admin figma update

🔄 진행 중 ({n}건)
- [Koboom] 피드백 업데이트
- [Koboom] latest APK check
- [TrendyLab] 앱말기

📅 오늘 미팅
- 14:00 [DSA] sync (내부)
- 16:00 [Koboom] 고객사 피드백 미팅 (외부)
```

## Instructions

1. **PM Action Hub 조회**:
   - 상태 = "오늘" 인 항목 전체 가져오기
   - 상태 = "진행 중" 인 항목 전체 가져오기
   - **이 2개 상태만 조회. 미착수/완료/대기 등 다른 상태는 무시**

2. **Google Calendar 조회** (연결되어 있는 경우):
   - 오늘 날짜 이벤트 목록
   - 시간순 정렬
   - 연결 안 되어 있으면 미팅 섹션 생략 (에러 표시 안 함)

3. **출력 구성**:
   - 📋 오늘: 상태 = "오늘" 항목
   - 🔄 진행 중: 상태 = "진행 중" 항목
   - 📅 오늘 미팅: Google Calendar 오늘 일정

## Rules

### 필수
- **"오늘"과 "진행 중" 상태만 가져온다** — 미착수, 완료, 대기 등 다른 상태는 절대 포함하지 않음
- **우선순위로 섹션을 나누지 않는다** — High/Medium/Low 구분 없이 상태별로만 분류
- 각 섹션에 항목이 없으면 해당 섹션 생략
- 항목이 하나도 없으면 "오늘은 등록된 액션이 없습니다. /todo로 추가하거나 PM Action Hub를 확인하세요." 출력
- 프로젝트명은 [대괄호]로 표시
- 간결하게 — bullet당 1줄
- 한국어 출력
- 인자 없이 실행 가능 (오늘 날짜 자동)

### 트리거
- `/today-brief` — 직접 실행
- "오늘 뭐해야돼", "오늘 할 일", "브리핑" 등 자연어 입력 시에도 이 스킬로 처리
- 평일 10:30 KST — Remote Trigger 자동 실행
