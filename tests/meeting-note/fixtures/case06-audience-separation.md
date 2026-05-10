---
case: case06
description: audience separation 강제. 녹취에 (a) PM 내부 액션 / (b) 기술 디테일 / (c) 고객 가시 합의 / (d) [추론] 후보 모두 혼재. Part 1: 모두 포함 / Part 2: 영어 + 의무 closing 라인 / Part 3: 합니다체 + 기술 디테일 부재 + [추론] tag 부재 + PM 내부 액션 부재.
client: dsa
project: Dsa
meeting_date: 2026-05-08
existing_match_count: 0
gate_choice: "0"
expected_buckets:
  action_items_count: 3
  out_of_scope_count: 0
  memo_only_count: 0
  to_spec_recommendation: no
notes: |
  Part 별 audience filtering 검증 핵심 회귀. PM 내부 액션 / 기술 디테일 / [추론] tag 가 Part 3에 새어나가면 회귀 실패.
---

# Meeting transcript (raw)

```
[Kim (Client)]
홈 화면 배너 영역 비율을 3:2로 맞춰주세요.

[Tuan (Dev)]
3:2면 mobile breakpoint(<480px)에서 image rendering 시 srcset 재정의가 필요합니다. picture element도 손봐야 할 것 같아요.

[Kim]
네 좋습니다. 그렇게 진행해주세요.

[Yoona]
저는 미팅 노트 정리해서 내일까지 공유드릴게요. 그리고 srcset 변경사항을 다음 라운드 SRS에 반영하는 것도 챙겨야 해서 별도 follow-up 잡아둘게요.

[Tuan]
배너 영역에 추후 동영상 자동재생 옵션 검토했으면 좋겠다는 얘기가 있었는데 이번엔 안 합니다.
```

# PM input
```
/meeting-note --client dsa --date 2026-05-08
```

녹취에 PM 내부 액션 (SRS follow-up 잡기), 기술 디테일 (srcset / picture element / mobile breakpoint), 고객 가시 합의 (3:2 비율 진행), [추론] 후보 ("동영상 자동재생 검토 얘기" — 정확한 발화자 불명) 혼재. Part 별 적절히 분리되어야 함.
