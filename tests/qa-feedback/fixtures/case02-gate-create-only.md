---
case: case02
description: gate=2 (create only). 동일 입력 (case01과 같은 3 rows) — PM이 "2"를 선택해서 티켓은 생성하지만 고객 QA DB Status는 유지 ("대기중" 그대로).
client: dsa
project: Dsa
customer_qa_db: collection://mock-dsa-qa-2026r1
internal_qa_page: notion://mock-dsa-internal-qa
internal_tasks_db: collection://mock-dsa-tasks-r1
schema:
  fields: [Title, Description, Priority, QA Category, Role, Source URL, From Customer, Round]
existing_tickets_in_tasks_db: []
gate_choice: "2"
expected_buckets:
  new_count: 3
  duplicate_skip_count: 0
  status_update_count: 0
notes: |
  Tests gate=2 path: tickets created but customer QA DB Status NOT updated (PM defers status sync).
---

# Customer QA DB rows (same as case01)

## Row 1
- 페이지: 홈
- 수정내용: 홈 화면 배너 안 보여요. 비율도 3:2여야 할 것 같아요.
- 검수회차: 1
- Source URL: https://notion.so/mock-dsa-qa/row-001

## Row 2
- 페이지: 멤버 관리
- 수정내용: 멤버 상세에서 "선택 정지 처리" 버튼을 눌러도 차단이 안 됩니다. 정지된 사용자가 계속 앱을 쓸 수 있어요.
- 검수회차: 1
- Source URL: https://notion.so/mock-dsa-qa/row-002

## Row 3
- 페이지: 활동지 등록
- 수정내용: 이미지 업로드가 가끔 실패합니다. 사진 선택 후 "완료" 누르면 변화가 없어요. 5번 시도하면 1-2번 성공.
- 검수회차: 1
- Source URL: https://notion.so/mock-dsa-qa/row-003

# PM input
```
/qa-feedback --qa-db collection://mock-dsa-qa-2026r1 --project Dsa --internal notion://mock-dsa-internal-qa
```

PM이 Step 3 미리보기 후 "2" 선택.
