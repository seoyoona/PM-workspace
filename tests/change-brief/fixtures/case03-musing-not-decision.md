---
case: case03
description: 고객의 musing("있으면 좋겠다") → Confirm-Needed (Decision 승급 금지)
client: Connectory
project: Connectory-1
srs: none
design: none
expected_buckets:
  in_round: 0
  next_round: 0
  out_of_scope: 0
  confirm_needed: 1
notes: "있으면 좋겠다" 표현은 musing 톤. 고객 명확 합의 없음 → 절대 Decision/In-Round 승급 금지. Confirm-Needed로 가야 함.
---

# Input

고객이 미팅 중에 "사용자 프로필에 즐겨찾기 같은 기능이 있으면 좋겠다"고 말함.
구체적인 요구사항이나 우선순위는 언급하지 않음.
"나중에 추가될 수도 있겠네요" 정도로만 흘리듯 언급.
