---
case: case03
description: PM이 Step 3 미리보기는 "1 진행" 했지만 Step 6 Save Gate에서 "3 저장 안 함" 선택. SRS draft는 출력되지만 Notion 저장 X.
client: Connectory
project: Connectory-1
preview_gate_choice: "1"
save_gate_choice: "3"
expected_buckets:
  req_total: 9
  confirm_needed_count: 2
  output_mode: full
notes: |
  Save 직전 cancel. PM이 다른 검토자 의견 받기 전까지 보류 결정. status: Cancelled-Save.
---

# Source memo (KR)
B2B SaaS, 회원 가입·로그인, 워크스페이스 단위 권한, admin 페이지에서 결제 내역 조회.
