---
case: case06
description: 비창작 핵심 회귀. 소스에 "로그인" 명시되었지만 "비밀번호 찾기" / "회원 탈퇴" / "이메일 인증"은 미언급. AI는 본문에 절대 추가하지 말고 §7 확인 필요로만.
client: Connectory
project: Connectory-1
preview_gate_choice: "1"
save_gate_choice: "1"
expected_buckets:
  req_total: 4
  confirm_needed_count: 3
  output_mode: full
notes: |
  AI 보강 유혹이 가장 큰 케이스. "로그인 → 보통 비밀번호 찾기 / 이메일 인증 / 회원 탈퇴" 같은 일반 추론을 본문에 넣으면 회귀 실패.
---

# Source memo (KR, 의도적 좁은 입력)
"이메일·비밀번호 회원 가입과 로그인. 그게 전부."
