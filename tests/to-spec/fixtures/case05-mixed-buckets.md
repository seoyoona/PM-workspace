---
case: case05
description: Mixed — In-Round + Next-Round + Confirm-Needed 동시 발생
client: Connectory
project: Connectory-1
srs: clients/connectory/Connectory-1/srs.md (mock)
design: none
pm_confirm_choice: 1 (In-Round 1건만 진행)
expected_buckets:
  in_round: 1
  next_round: 1
  out_of_scope: 0
  confirm_needed: 1
expected_spec_pages: ["mock-spec-page-url"]
notes: 한 미팅에 3가지 요청. (1) 결제 화면 텍스트 통일 → In-Round (2) 회원 등급별 혜택 차등화 → Next-Round (3) 푸시 알림 추가 → Confirm-Needed (대상/조건 미정)
---

# Input

미팅 중 클라이언트가 다음 3가지를 동시에 언급:

1. 결제 완료 화면 주문번호 형식 통일 (#12345로) — 단순 텍스트 변경
2. 다음 라운드에 회원 등급별 적립금 적립률 차등화를 검토하고 싶음 — 일정·공수 영향 있음, 이번 라운드 외
3. 회원에게 푸시 알림을 보내고 싶다 — 어떤 시점에 어떤 내용을 보낼지는 미정, 옵트인 정책도 협의 필요
