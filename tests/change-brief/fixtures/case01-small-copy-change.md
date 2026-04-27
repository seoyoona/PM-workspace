---
case: case01
description: 작은 UI 문구 변경 → In-Round
client: Connectory
project: Connectory-1
srs: none
design: none
expected_buckets:
  in_round: 1
  next_round: 0
  out_of_scope: 0
  confirm_needed: 0
notes: source가 명확히 "추가해 주세요" 단일 요청. SRS 미연결이지만 "현재 라운드 화면 내" 근거 + 작은 변경 + 고객 명확 근거 모두 충족.
---

# Input

고객이 결제 완료 화면에서 주문번호 표시 형식이 헷갈린다고 피드백.
"주문번호: 12345"가 아니라 "주문번호 #12345"처럼 # 기호를 앞에 붙여서 일관성 있게 보여달라고 요청함.
다른 화면들은 이미 # 형식으로 표시되고 있어서 결제 완료 화면만 다른 상태.
