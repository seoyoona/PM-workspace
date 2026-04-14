---
description: PM 액션 빠르게 추가 → PM Action Hub DB 저장
argument-hint: [프로젝트] [할 일]
allowed-tools: Read, Glob, Grep, mcp__notion-cigro__notion-create-pages, mcp__notion-cigro__notion-fetch
---

# Quick Todo Add

## Arguments
사용자 입력: $ARGUMENTS

## Context
- PM이 빠르게 할 일을 추가하는 스킬
- 최소한의 입력으로 PM Action Hub DB에 저장
- 러프하게 입력해도 프로젝트/액션 유형을 자동 감지

## Output Destination
- **Notion**: PM Action Hub DB (`ff43aae9a89482ea8c57815a65ac9f5b`) — `mcp__notion-cigro__notion-create-pages`
- **터미널**: 추가된 항목 확인

## Instructions

1. **입력 파싱**:
   - **프로젝트명 감지 (보수적 자동 확정 — B2)**:
     1. 입력에서 `[대괄호]` 추출 시도
     2. 대괄호가 있으면 그 값을 Notion `프로젝트` select 옵션과 **exact match**로 비교 (대소문자·공백 완전 일치)
        - Exact match 성공 → **자동 확정** + 사용자에게 1줄 명시:
          > `[Koboom] 으로 인식했습니다`
        - Exact match 실패 → 숫자 선택지로 이동 (아래)
     3. 대괄호가 없으면 → 숫자 선택지로 이동 (아래)
     4. **substring / 유사도 / case-insensitive 매칭 자동 확정 금지.** 후보가 1개여도 exact가 아니면 사용자 확인 필수
   - **매칭 실패 시 숫자 선택지**:
     ```
     프로젝트를 지정해주세요:
     1. 최근 사용 프로젝트 (activity-log 또는 최근 PM Action Hub 기록 기준)
     2. 전체 목록 보기
     3. 취소
     추천: 1
     ```
     - 1 선택 → 최근 프로젝트 3~5개 숫자 선택지
     - 2 선택 → Notion select 옵션 전체 목록 숫자 선택지
     - 3 선택 → 중단
   - **액션 유형 감지**:
     - "회신", "전달", "공유", "카톡", "메시지" → 고객 커뮤니케이션
     - "sync", "확인", "체크", "follow-up" → 내부 follow-up
     - "등록", "업데이트", "정리", "작성" → 운영 체크
   - 나머지 = 제목

2. **중복 체크 (C1 멱등성 가드)** — 저장 직전에 반드시 실행:
   - **Unique key**: 제목(title exact) + 프로젝트 + 작성일(오늘)
   - PM Action Hub DB(`data_source_url: collection://a183aae9-a894-8379-8708-87cf507ec8e8`)에서 `mcp__notion-cigro__notion-fetch`로 필터 조회:
     ```json
     {"and": [
       {"property": "제목", "title": {"equals": "<title with [ProjectName] prefix>"}},
       {"property": "프로젝트", "select": {"equals": "<project>"}},
       {"property": "작성일", "date": {"equals": "<today YYYY-MM-DD>"}}
     ]}
     ```
   - **결과 분기**:
     - **0건** → Step 3 신규 생성
     - **1건 이상** → **skip + 알림** (retry loop 대응):
       ```
       ⏭️ 같은 항목이 오늘 이미 등록됨: [Koboom] 피드백 업데이트
         → 기존: [링크]
         추가하지 않음. 필요하면 수정: /todo [Koboom] 피드백 업데이트 - 추가 (다른 제목)
       ```
   - **재시도 루프 대응 원칙**: 동일 세션에서 Bash/MCP timeout으로 재호출되는 경우에도 중복 페이지 생성 방지.
   - 여러 줄 입력 시 각 줄마다 개별적으로 중복 체크 (한 줄만 중복이어도 나머지는 정상 생성).

3. **Notion 저장** (`mcp__notion-cigro__notion-create-pages` — DB ID: `ff43aae9a89482ea8c57815a65ac9f5b`) — Step 2에서 신규로 판단된 항목만:
   - 제목: **반드시 `[ProjectName] short description` 형태**. 프로젝트명은 대괄호, 설명은 짧고 명확하게.
   - parent: `{"type": "data_source_id", "data_source_id": "a183aae9-a894-8379-8708-87cf507ec8e8"}`
   - properties:
     - `제목` (title): `[ProjectName] short description`
     - `프로젝트` (select): 감지된 프로젝트
     - `상태` (select): "미착수" 기본 / "오늘"이 감지되면 "오늘"
     - `액션 유형` (select): 감지된 유형 / 없으면 생략
     - `출처` (select): "manual"

4. **터미널 출력**:
   ```
   ✅ 추가 완료: [프로젝트] 할 일 내용
   상태: 미착수
   ```
   중복 skip 있으면 별도 블록으로 표시:
   ```
   ⏭️ Skip: [Koboom] 피드백 업데이트 (오늘 이미 등록됨 — [링크])
   ```

## Examples

**단일 항목:**
```
/todo [Koboom] 피드백 업데이트 전달
→ 제목: [Koboom] 피드백 업데이트 전달
→ 프로젝트: Koboom, 상태: 미착수, 액션 유형: 고객 커뮤니케이션
```

**오늘 할 일:**
```
/todo 오늘 [RCK] 타임라인 정리해서 고객에게 공유
→ 제목: [RCK] 타임라인 정리해서 고객에게 공유
→ 프로젝트: RCK, 상태: 오늘, 액션 유형: 고객 커뮤니케이션
```

**여러 개 한번에:**
```
/todo
[Koboom] admin figma update
[RCK] timeline 정리
[BaraeCNP] 문의내용 회신
→ 3개 항목 각각 추가
```

## Rules

- 프로젝트명이 없거나 Notion select 옵션과 exact match가 아니면 **절대 자동 확정 금지** — 숫자 선택지로 PM에게 확인
- 자동 확정된 경우에만 `[Koboom] 으로 인식했습니다` 명시 통보
- 여러 줄 입력 시 각 줄을 별도 항목으로 추가 (각각 중복 체크)
- **중복 체크 (C1)**: 같은 제목+프로젝트+작성일이 이미 있으면 skip. 덮어쓰기/업데이트 금지. 다른 항목으로 추가하려면 제목을 바꿔서 재실행.
- 한국어 입력 → 한국어로 저장
- 최대한 빠르게 — 불필요한 확인 질문 없이 바로 추가
