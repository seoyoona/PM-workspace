---
case: case02
description: In-Round 분류 → PM confirm gate에서 진행 → Notion 스펙 + 태스크 생성, spec_pages 채워짐
client: Connectory
project: Connectory-1
srs: clients/connectory/Connectory-1/srs.md (mock)
design: none
pm_confirm_choice: 1 (진행)
expected_buckets:
  in_round: 1
  next_round: 0
  out_of_scope: 0
  confirm_needed: 0
expected_spec_pages: ["mock-spec-page-url"]
notes: 작은 UI 문구 변경. PM이 confirm gate에서 1 (진행) 선택 → Notion 스펙 페이지 + 태스크 1개 생성. Test fixture에서는 mock URL로 검증
---

# Input

결제 완료 화면 주문번호 표시 형식 통일 요청. 다른 화면은 모두 "#12345" 형식인데 결제 완료만 "12345"로 다름. # 붙여 통일 요망.
