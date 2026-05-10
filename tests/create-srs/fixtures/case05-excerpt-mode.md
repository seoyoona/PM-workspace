---
case: case05
description: REQ 18건 (16건 이상) → Step 5 발췌 출력 모드. 전문은 PM 추가 요청 시. 양 게이트 모두 1.
client: Connectory
project: Connectory-2
preview_gate_choice: "1"
save_gate_choice: "1"
expected_buckets:
  req_total: 18
  confirm_needed_count: 4
  output_mode: excerpt
notes: |
  대형 SRS — 발췌 모드 출력 회귀. 출력 본문은 짧지만 §2 / §7은 그대로 유지.
---

# Source memo (KR, 큰 SRS)
회원·로그인·MFA·소셜로그인 / 프로필 / 결제 충전·환불·구독 / admin 회원·결제·통계·CSV / API 키 발급·관리 / system health.
