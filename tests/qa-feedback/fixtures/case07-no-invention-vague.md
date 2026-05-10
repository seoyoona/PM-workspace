---
case: case07
description: 모호한 phrase "뭔가 이상해요" 입력 → AI가 해석 추가 X. Description은 원문 인용 + Expected `[TBD — clarification needed]`.
client: dsa
project: Dsa
customer_qa_db: collection://mock-dsa-qa-2026r1
internal_qa_page: notion://mock-dsa-internal-qa
internal_tasks_db: collection://mock-dsa-tasks-r1
schema:
  fields: [Title, Description, Priority, QA Category, Role, Source URL, From Customer, Round]
existing_tickets_in_tasks_db: []
gate_choice: "1"
expected_buckets:
  new_count: 1
  duplicate_skip_count: 0
  status_update_count: 1
notes: |
  Tests no-invention rule: vague feedback "뭔가 이상해요" must NOT be expanded with fictitious phrases (예: "may be a database lag" / "perhaps related to" 등). Description quotes original + Expected = [TBD].
---

# Customer QA DB row (대기중)

## Row 1
- 페이지: 마이페이지
- 수정내용: 마이페이지 들어가면 뭔가 이상해요. 잘 안 돼요.
- 검수회차: 1
- Source URL: https://notion.so/mock-dsa-qa/row-vague-001

# PM input
```
/qa-feedback --qa-db collection://mock-dsa-qa-2026r1 --project Dsa --internal notion://mock-dsa-internal-qa
```

PM이 Step 3 미리보기 후 "1" 선택. AI는 vague phrase를 해석으로 보완하지 말고 원문 그대로 인용 + Expected = [TBD] 표시.
