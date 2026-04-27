---
case: case05
description: SRS / design.md 없음 → partial-skip (해당 섹션만 "확인 필요", 나머지 정상)
client: Connectory
project: Connectory-1
srs: none
design: none
expected_buckets:
  in_round: 1
  next_round: 0
  out_of_scope: 0
  confirm_needed: 0
notes: 기능 자체는 In-Round로 분류 가능하지만 SRS/design.md 부재. partial-skip이 정상 동작하면 §2 §3 섹션만 "확인 필요" 표시되고 나머지는 정상 출력.
---

# Input

로그인 화면에서 "비밀번호 찾기" 링크가 안 보인다고 고객이 피드백.
실제 코드 확인하면 링크는 있는데 색상이 배경과 비슷해서 시각적으로 구분이 안 됨.
색상만 조정하면 되는 작은 UI 수정.
