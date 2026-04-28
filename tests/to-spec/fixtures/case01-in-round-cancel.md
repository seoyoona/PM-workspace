---
case: case01
description: In-Round 분류 → PM confirm gate에서 취소 → Notion 생성 안 함, spec_pages 빈 상태
client: Connectory
project: Connectory-1
srs: none
design: none
pm_confirm_choice: 3 (취소)
expected_buckets:
  in_round: 1
  next_round: 0
  out_of_scope: 0
  confirm_needed: 0
expected_spec_pages: []
notes: 작은 UI 문구 변경. PM이 confirm gate에서 3 (취소) 선택 → triage markdown만 로컬 저장, Notion API 호출 X
---

# Input

고객이 결제 완료 화면에서 주문번호 표시 형식이 헷갈린다고 피드백.
"주문번호: 12345"가 아니라 "주문번호 #12345"처럼 # 기호를 앞에 붙여서 일관성 있게 보여달라고 요청함.
다른 화면들은 이미 # 형식으로 표시되고 있어서 결제 완료 화면만 다른 상태.
