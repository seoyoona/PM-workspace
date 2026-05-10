---
status: Confirmed-1
case: case04
client: dsa
project: Dsa
created: 2026-05-10
customer_qa_db: collection://mock-dsa-qa-2026r1
internal_qa_page: notion://mock-dsa-internal-qa
internal_tasks_db: collection://mock-dsa-tasks-r1
gate_choice: "1"
new_count: 2
duplicate_skip_count: 1
status_update_count: 2
qa_plan_meta_in_input: none
round: R1
---

## 1. Input Summary
- Customer QA DB rows (대기중): 3
- Existing tickets (idempotency check, by source URL): 1 (row 2 source URL has prior ticket)
- QA Plan/Scenario meta in input: none

## 2. Preview Table

| # | 원문 요약 | → Title (EN) | Priority | QA Category | 상태 |
|---|----------|-------------|----------|-------------|------|
| 1 | 홈 배너 안 보임 / 비율 | [Home] Banner not displaying — ratio should be 3:2 | Middle | UI Bug | 신규 |
| 2 | 선택 정지 처리 무효 | — | — | — | ⏭️ 중복 skip ([기존 링크](https://notion.so/mock-dsa-tasks/existing-suspend-bug)) |
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
- Resulting actions: create (2 new) + status update (2 rows; row 2 skipped from both create and status update)

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

### TICKET-3
- Title: `[Worksheet] Image upload intermittently fails`
- Priority: High
- QA Category: Logic Bug
- Role: User
- From Customer: true
- Source URL: https://notion.so/mock-dsa-qa/row-003
- Description (Mode C):
  ```
  Issue: Image upload sometimes fails — 5 attempts yield 1–2 successes.
  Expected: Image should upload reliably every time.

  Context: Intermittent. Reproduction details requested from client.
  ```

## 6. Duplicates Skipped

- Row 2 ("선택 정지 처리" suspend issue) — source URL `https://notion.so/mock-dsa-qa/row-002` matches existing ticket `https://notion.so/mock-dsa-tasks/existing-suspend-bug` (in-progress). Skipped from both create and status update per C1 idempotency guard. PM may amend the existing ticket manually if customer note adds new info.

## 7. Customer QA DB Status Updates

- Row 1 (홈 배너): 대기중 → 진행중
- Row 3 (이미지 업로드): 대기중 → 진행중
- Row 2: skipped (duplicate)

## 8. Notes

- C1 idempotency rule applied — exact source URL match on internal Tasks DB.
- TICKET-2 NOT generated (would have overwritten dev work in progress).
- new_count = 2 (row 1, row 3) / duplicate_skip_count = 1 (row 2).
