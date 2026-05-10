---
case: case03
description: gate=3 (cancel). 동일 입력 — PM이 "3"을 선택해서 모든 동작 중단 (티켓 생성 X, Status 변경 X).
client: dsa
project: Dsa
customer_qa_db: collection://mock-dsa-qa-2026r1
internal_qa_page: notion://mock-dsa-internal-qa
internal_tasks_db: collection://mock-dsa-tasks-r1
schema:
  fields: [Title, Description, Priority, QA Category, Role, Source URL, From Customer, Round]
existing_tickets_in_tasks_db: []
gate_choice: "3"
expected_buckets:
  new_count: 0
  duplicate_skip_count: 0
  status_update_count: 0
notes: |
  Tests gate=3 cancel path: nothing created, nothing updated. Snapshot preserves preview + cancel decision.
---

# Customer QA DB rows (same as case01, but PM cancels at the gate)

## Row 1, Row 2, Row 3
(same as case01 fixture; abbreviated here)

# PM input
```
/qa-feedback --qa-db collection://mock-dsa-qa-2026r1 --project Dsa --internal notion://mock-dsa-internal-qa
```

PM이 Step 3 미리보기 후 "3" 선택 → 즉시 중단.
