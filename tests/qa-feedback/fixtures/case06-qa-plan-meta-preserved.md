---
case: case06
description: 입력 본문 첫 줄에 "QA Plan: QA-DSA-20260510" + "Scenario: P0-02" 메타가 있을 때, 생성된 ticket Description 첫 줄에 같은 메타 라인을 그대로 보존하는지 검증.
client: dsa
project: Dsa
customer_qa_db: collection://mock-dsa-qa-2026r1
internal_qa_page: notion://mock-dsa-internal-qa
internal_tasks_db: collection://mock-dsa-tasks-r1
schema:
  fields: [Title, Description, Priority, QA Category, Role, Source URL, From Customer, Round]
existing_tickets_in_tasks_db: []
gate_choice: "1"
qa_plan_meta_in_input: "QA Plan: QA-DSA-20260510 / Scenario: P0-02"
expected_buckets:
  new_count: 1
  duplicate_skip_count: 0
  status_update_count: 1
notes: |
  Tests skill body L219-223: QA Plan / Scenario meta preservation. Input header carries QA Plan ID + Scenario ID; output ticket Description first line must keep the same meta line unchanged.
---

# Customer QA DB row (대기중)

## Row 1
- 페이지: 멤버 관리
- 수정내용:
  ```
  QA Plan: QA-DSA-20260510
  Scenario: P0-02

  멤버 상세에서 "선택 정지 처리" 버튼을 눌러도 차단이 안 됩니다.
  ```
- 검수회차: 1
- Source URL: https://notion.so/mock-dsa-qa/row-meta-001

# PM input
```
/qa-feedback --qa-db collection://mock-dsa-qa-2026r1 --project Dsa --internal notion://mock-dsa-internal-qa
```

PM이 Step 3 미리보기 후 "1" 선택. ticket Description 첫 줄에 input의 QA Plan / Scenario 메타가 그대로 보존되어야 함.
