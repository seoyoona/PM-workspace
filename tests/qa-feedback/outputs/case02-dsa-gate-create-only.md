---
status: Confirmed-2
case: case02
client: dsa
project: Dsa
created: 2026-05-10
customer_qa_db: collection://mock-dsa-qa-2026r1
internal_qa_page: notion://mock-dsa-internal-qa
internal_tasks_db: collection://mock-dsa-tasks-r1
gate_choice: "2"
new_count: 3
duplicate_skip_count: 0
status_update_count: 0
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
- Selected: 2
- Resulting actions: create only (status update skipped)

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

(none — gate=2 chosen, customer QA DB Status preserved at 대기중)

## 8. Notes

- Mode rationale: TICKET-1 Mode A / TICKET-2 Mode B / TICKET-3 Mode C — same as case01 baseline.
- UI element preservation applied.
- gate=2 chosen by PM — customer QA DB Status sync deferred. PM should run a manual status sync or re-invoke with gate=1 once dev acknowledges.
