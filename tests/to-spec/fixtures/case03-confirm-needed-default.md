---
case: case03
description: 애매한 대형 기능 → default Confirm-Needed (성급 In-Round 승급 방지)
client: Connectory
project: Connectory-1
srs: none
design: none
pm_confirm_choice: N/A (In-Round 0건이라 confirm gate skip)
expected_buckets:
  in_round: 0
  next_round: 0
  out_of_scope: 0
  confirm_needed: 1+
expected_spec_pages: []
notes: 어드민 점수 조정 기능. MVP 견적 명시 없음, 우선순위·공수 불명확. 기준 미일치 → default Confirm-Needed
---

# Input

어드민에서 회원 점수를 직접 조정할 수 있는 기능이 필요하다고 들었습니다. 어떤 회원에게 얼마를 더하거나 뺄지를 어드민이 정할 수 있게 해주세요.
구체적으로 어떤 회원 grade에서 가능한지, 한도가 있는지, 이력 추적이 필요한지 등은 아직 정해지지 않았습니다.
