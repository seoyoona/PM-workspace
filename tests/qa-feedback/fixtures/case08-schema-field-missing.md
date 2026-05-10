---
case: case08
description: 내부 Tasks DB 스키마에 `Priority` 필드가 없음. AI는 임의 enum 추정 ❌, hard-fail ❌, 잘못된 write preview ❌. status: Confirm-Needed로 라우팅 + §8 Notes에 schema gap 명시. lightweight schema mock — heavy DB schema fetch 없음.
client: dsa
project: Dsa
customer_qa_db: collection://mock-dsa-qa-2026r1
internal_qa_page: notion://mock-dsa-internal-qa
internal_tasks_db: collection://mock-dsa-tasks-no-priority
schema:
  fields: [Title, Description, QA Category, Role, Source URL, From Customer, Round]
  missing_fields: [Priority]
existing_tickets_in_tasks_db: []
gate_choice: "pending"
expected_buckets:
  new_count: 0
  duplicate_skip_count: 0
  status_update_count: 0
notes: |
  Tests lightweight schema-gap handling per Wave 1-A correction. Skill must (a) NOT invent a Priority value, (b) NOT proceed to gate=1/2/3, (c) status: Confirm-Needed, (d) §8 names the missing field and asks PM for direction. No tickets generated, no status updates.
---

# Customer QA DB row (대기중)

## Row 1
- 페이지: 결제
- 수정내용: 결제 완료 후 영수증 화면이 멈춥니다. 환불도 안 되는 것 같아요.
- 검수회차: 1
- Source URL: https://notion.so/mock-dsa-qa/row-schema-gap-001

# PM input
```
/qa-feedback --qa-db collection://mock-dsa-qa-2026r1 --project Dsa --internal notion://mock-dsa-internal-qa
```

내부 Tasks DB 스키마를 fetch한 결과 `Priority` 필드가 부재. 이 row는 정황상 Critical로 분류될 가능성이 큰데, AI가 임의로 priority 값을 박지 않고 PM 확인 요청.
