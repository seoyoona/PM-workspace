---
description: PM 액션 빠르게 추가 → PM Action Hub DB 저장
argument-hint: [프로젝트] [할 일]
allowed-tools: Read, Glob, Grep, mcp__notion__*
---

# Quick Todo Add

## Arguments
사용자 입력: $ARGUMENTS

## Context
- PM이 빠르게 할 일을 추가하는 스킬
- 최소한의 입력으로 PM Action Hub DB에 저장
- 러프하게 입력해도 프로젝트/우선순위/액션 유형을 자동 감지

## Output Destination
- **Notion**: PM Action Hub DB (collection://3a13db31-882c-4a6c-bddf-660e15ea9cdd)
- **터미널**: 추가된 항목 확인

## Instructions

1. **입력 파싱**:
   - 프로젝트명 감지: [대괄호] 또는 --client 옵션 또는 알려진 프로젝트명
   - 우선순위 감지: "급함", "긴급", "urgent", "오늘" → High / 명시 없으면 Medium
   - 액션 유형 감지:
     - "회신", "전달", "공유", "카톡", "메시지" → 고객 커뮤니케이션
     - "sync", "확인", "체크", "follow-up" → 내부 follow-up
     - "등록", "업데이트", "정리", "작성" → 운영 체크
   - 나머지 = 제목

2. **Notion 저장**:
   - 제목: **반드시 `[ProjectName] short description` 형태**. 프로젝트명은 대괄호, 설명은 짧고 명확하게.
   - 프로젝트: 감지된 프로젝트
   - 상태: 기본 "미착수" / "오늘"이 감지되면 "오늘"
   - 우선순위: 감지된 우선순위
   - 액션 유형: 감지된 유형 / 감지 안 되면 비움
   - 출처: "manual"

3. **터미널 출력**:
   ```
   ✅ 추가 완료: [프로젝트] 할 일 내용
   상태: 미착수 | 우선순위: Medium
   ```

## Examples

**단일 항목:**
```
/todo [Koboom] 피드백 업데이트 전달
→ 제목: [Koboom] 피드백 업데이트 전달
→ 프로젝트: Koboom, 상태: 미착수, 액션 유형: 고객 커뮤니케이션
```

**긴급:**
```
/todo 급함 [RCK] 타임라인 정리해서 고객에게 공유
→ 제목: [RCK] 타임라인 정리해서 고객에게 공유
→ 프로젝트: RCK, 상태: 오늘, 우선순위: High, 액션 유형: 고객 커뮤니케이션
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

- 프로젝트명이 없으면 PM에게 확인
- 여러 줄 입력 시 각 줄을 별도 항목으로 추가
- 이미 동일 제목 항목이 있으면 중복 알림 (추가는 진행)
- 한국어 입력 → 한국어로 저장
- 최대한 빠르게 — 불필요한 확인 질문 없이 바로 추가
