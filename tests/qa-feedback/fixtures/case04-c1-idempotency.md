---
case: case04
description: C1 멱등성 가드. 3건 입력 중 row 2의 Source URL이 내부 Tasks DB에 이미 존재하는 ticket과 매치 → skip + 알림. row 1·3은 신규로 생성.
client: dsa
project: Dsa
customer_qa_db: collection://mock-dsa-qa-2026r1
internal_qa_page: notion://mock-dsa-internal-qa
internal_tasks_db: collection://mock-dsa-tasks-r1
schema:
  fields: [Title, Description, Priority, QA Category, Role, Source URL, From Customer, Round]
existing_tickets_in_tasks_db:
  - notion_url: https://notion.so/mock-dsa-tasks/existing-suspend-bug
    source_url: https://notion.so/mock-dsa-qa/row-002
    title: "[Member] suspend not blocking — investigation in progress"
gate_choice: "1"
expected_buckets:
  new_count: 2
  duplicate_skip_count: 1
  status_update_count: 2
notes: |
  Tests C1 idempotency: row 2 source URL exact match with existing ticket → skip (not overwrite). row 1·3 still go through.
---

# Customer QA DB rows (대기중)

## Row 1
- 페이지: 홈
- 수정내용: 홈 화면 배너 안 보여요. 비율도 3:2여야 할 것 같아요.
- 검수회차: 1
- Source URL: https://notion.so/mock-dsa-qa/row-001

## Row 2 (DUPLICATE — already has ticket in internal Tasks DB)
- 페이지: 멤버 관리
- 수정내용: 멤버 상세에서 "선택 정지 처리" 버튼을 눌러도 차단이 안 됩니다.
- 검수회차: 1
- Source URL: https://notion.so/mock-dsa-qa/row-002

## Row 3
- 페이지: 활동지 등록
- 수정내용: 이미지 업로드가 가끔 실패합니다. 5번 시도하면 1-2번 성공.
- 검수회차: 1
- Source URL: https://notion.so/mock-dsa-qa/row-003

# PM input
```
/qa-feedback --qa-db collection://mock-dsa-qa-2026r1 --project Dsa --internal notion://mock-dsa-internal-qa
```

PM이 Step 3 미리보기 (row 2 = ⏭️ 중복 skip 표시) 후 "1" 선택. row 2는 ticket 생성도 status update도 X.
