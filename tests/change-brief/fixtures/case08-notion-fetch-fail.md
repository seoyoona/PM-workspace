---
case: case08
description: Notion URL fetch 실패 → free-text fallback (hard-fail 안 함)
client: Connectory
project: Connectory-1
srs: none
design: none
notion_url_simulated_fail: true
expected_buckets:
  in_round: 0
  next_round: 0
  out_of_scope: 0
  confirm_needed: 1
notes: Notion URL fetch 실패 시 "Notion 페이지를 읽지 못했습니다" 안내 + free-text 모드 전환. PM 붙여넣은 텍스트로 진행.
---

# Input (Notion URL — 시뮬레이션 실패)

https://www.notion.so/cigroio/INVALID-FAKE-URL-FOR-TEST-CASE-08

# Free-text fallback (PM이 붙여넣은 내용)

미팅에서 통화 환산율 표시 정확도에 대해 논의했음.
고객은 환율이 실시간으로 반영되어야 한다고 강력 주장하지만, 개발팀은 API 호출 비용/안정성 이슈로 5분 캐시를 제안.
이 정책 차이를 어느 쪽으로 갈지 PM이 결정해야 함.
