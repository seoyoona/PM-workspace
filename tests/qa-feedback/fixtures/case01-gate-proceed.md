---
case: case01
description: gate=1 happy path. 3건 신규 (Mode A/B/C 1건씩) → 티켓 3개 생성 + 고객 QA DB Status "진행중" 업데이트.
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
  new_count: 3
  duplicate_skip_count: 0
  status_update_count: 3
notes: |
  Tests gate=1 path: create + status update. Mode A / Mode B / Mode C 분포 검증.
---

# Customer QA DB rows (대기중)

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

PM이 Step 3 미리보기 후 "1" 선택.
