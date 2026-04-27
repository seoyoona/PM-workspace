---
case: case02
description: 신규 어드민 기능 요청, MVP 견적 미확정 → Confirm-Needed (또는 Next-Round)
client: Connectory
project: Connectory-1
srs: none
design: none
expected_buckets:
  in_round: 0
  next_round: 0
  out_of_scope: 0
  confirm_needed: 1
notes: "MVP 견적 포함 여부 확인 필요" 명시 → Confirm-Needed가 정답. 신규 기능이고 견적 미확정 상태에서 In-Round 또는 Next-Round로 가면 안 됨.
---

# Input

어드민 페이지에서 사용자별 포인트를 수동으로 조정할 수 있는 기능을 추가해달라는 요청.
운영팀이 환불/보상 처리할 때 포인트를 직접 차감/증가시킬 수 있어야 한다고 함.
이 기능이 기존 MVP 견적/SRS에 포함되어 있는지 확인이 필요하다.
