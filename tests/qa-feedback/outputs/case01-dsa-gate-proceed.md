---
status: Confirmed-1
case: case01
client: dsa
project: Dsa
created: 2026-05-10
customer_qa_db: collection://mock-dsa-qa-2026r1
internal_qa_page: notion://mock-dsa-internal-qa
internal_tasks_db: collection://mock-dsa-tasks-r1
gate_choice: "1"
new_count: 3
duplicate_skip_count: 0
status_update_count: 3
qa_plan_meta_in_input: none
round: R1
---

## 1. Input Summary
- Customer QA DB rows (대기중): 3
- Existing tickets (idempotency check, by source URL): 0
- QA Plan/Scenario meta in input: none

## 2. Preview Table

| # | 원문 요약 | → Title (EN) | Priority | QA Category | 상태 |
|---|----------|-------------|----------|-------------|------|
| 1 | 홈 배너 안 보임 / 비율 | [Home] Banner not displaying — ratio should be 3:2 | Middle | UI Bug | 신규 |
| 2 | 선택 정지 처리 무효 | [Member] "선택 정지 처리" (suspend) does not block user | 🔥Highest🔥 | Logic Bug | 신규 |
| 3 | 이미지 업로드 가끔 실패 | [Worksheet] Image upload intermittently fails | High | Logic Bug | 신규 |

## 3. Confirm Gate Prompt

```
1. 생성 + 고객 QA DB Status "진행중"으로 변경 (추천)
2. 생성만 (Status 유지)
3. 취소
추천: 1
```

## 4. PM Choice
- Selected: 1
- Resulting actions: create + status update

## 5. Generated Tickets

### TICKET-1
- Title: `[Home] Banner not displaying — ratio should be 3:2`
- Priority: Middle
- QA Category: UI Bug
- Role: User
- From Customer: true
- Source URL: https://notion.so/mock-dsa-qa/row-001
- Description (Mode A):
  ```
  Expected: Home banner image should display on first load with 3:2 aspect ratio.
  ```

### TICKET-2
- Title: `[Member] "선택 정지 처리" (suspend) does not block user`
- Priority: 🔥Highest🔥
- QA Category: Logic Bug
- Role: Admin
- From Customer: true
- Source URL: https://notion.so/mock-dsa-qa/row-002
- Description (Mode B):
  ```
  Issue: Tapping "선택 정지 처리" (suspend) on the member detail page does not block the user — they can still use the app.
  Expected: Suspended user should be blocked immediately.
  ```

### TICKET-3
- Title: `[Worksheet] Image upload intermittently fails`
- Priority: High
- QA Category: Logic Bug
- Role: User
- From Customer: true
- Source URL: https://notion.so/mock-dsa-qa/row-003
- Description (Mode C):
  ```
  Issue: Image upload sometimes fails — select photo → tap "완료" (Done) → no change.
  Expected: Image should upload reliably every time.

  Context: Intermittent (1–2 of 5 attempts succeed). Reproduction details requested from client.
  ```

## 6. Duplicates Skipped

(none)

## 7. Customer QA DB Status Updates

- Row 1 (홈 배너): 대기중 → 진행중
- Row 2 (선택 정지 처리): 대기중 → 진행중
- Row 3 (이미지 업로드): 대기중 → 진행중

## 8. Notes

- Mode rationale: TICKET-1 = Mode A (simple change, Expected suffices). TICKET-2 = Mode B (bug, current behavior needs description). TICKET-3 = Mode C (bug + intermittency context).
- UI element preservation applied: `"선택 정지 처리" (suspend)`, `"완료" (Done)`.
- glossary terms: none required for this round (DSA glossary checked).
- No Round prefix (검수회차 = 1 for all rows).
