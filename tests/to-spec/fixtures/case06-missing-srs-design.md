---
case: case06
description: SRS / design.md 모두 부재 → partial-skip (해당 섹션만 [확인 필요])
client: Connectory
project: Connectory-1
srs: missing
design: missing
pm_confirm_choice: N/A (In-Round 0건 → confirm gate skip)
expected_buckets:
  in_round: 0
  next_round: 0
  out_of_scope: 0
  confirm_needed: 1+
expected_spec_pages: []
notes: 비밀번호 재설정 링크 색상 변경 요청. SRS / design.md 모두 부재. UI 영향 판단 보류 + Confirm-Needed
---

# Input

비밀번호 재설정 링크 색깔을 좀 더 눈에 띄게 바꿔주세요. 현재 회색이라 눈에 잘 안 들어옵니다.
어떤 색으로 바꿀지, 다른 화면들의 링크 색상과 관계는 어떻게 할지는 디자인 가이드 확인이 필요합니다.
