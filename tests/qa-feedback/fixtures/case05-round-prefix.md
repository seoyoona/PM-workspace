---
case: case05
description: 검수회차 = 2 → Title에 [Round 2] prefix 추가. 1 row, gate=1.
client: dsa
project: Dsa
customer_qa_db: collection://mock-dsa-qa-2026r2
internal_qa_page: notion://mock-dsa-internal-qa
internal_tasks_db: collection://mock-dsa-tasks-r2
schema:
  fields: [Title, Description, Priority, QA Category, Role, Source URL, From Customer, Round]
existing_tickets_in_tasks_db: []
gate_choice: "1"
expected_buckets:
  new_count: 1
  duplicate_skip_count: 0
  status_update_count: 1
notes: |
  Tests Round prefix rule (검수회차 ≥ 2): Title prefixed with [Round N].
---

# Customer QA DB row (대기중) — 2회차 검수

## Row 1
- 페이지: 결제
- 수정내용: 결제 완료 후 영수증 화면에서 "확인" 버튼 누르면 빈 화면이 잠깐 보입니다.
- 검수회차: 2
- Source URL: https://notion.so/mock-dsa-qa-r2/row-001

# PM input
```
/qa-feedback --qa-db collection://mock-dsa-qa-2026r2 --project Dsa --internal notion://mock-dsa-internal-qa
```

PM이 Step 3 미리보기 후 "1" 선택.
