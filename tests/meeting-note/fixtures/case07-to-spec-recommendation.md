---
case: case07
description: /to-spec 추천 trigger 발동. Dev 작업이 2일 이상 + 여러 컴포넌트 + owner·스펙 명확 + 신규 기능 후보 → "추가 제안"에 /to-spec 태그 출력. **자동 실행은 절대 안 함.** 추천만 정확히 표시되는지 검증.
client: dsa
project: Dsa
meeting_date: 2026-05-08
existing_match_count: 0
gate_choice: "0"
expected_buckets:
  action_items_count: 1
  out_of_scope_count: 0
  memo_only_count: 0
  to_spec_recommendation: yes
notes: |
  /meeting-note에서 회의록의 "결정"을 바로 스펙/태스크로 넘어가고 싶은 유혹이 큰데, /to-spec 자동 실행 절대 금지. 추천 태그만 정확히 뜨는지 검증.
---

# Meeting transcript (raw)

```
[Kim (Client)]
admin 페이지에 정산 리포트 화면을 새로 추가하고 싶습니다. 기간별 매출 / 환불 / 정산 예정 금액을 한 화면에서 보고 싶어요.

[Tuan (Dev)]
새 화면이고 데이터 집계 / 차트 / 다운로드 기능까지 들어가면 작업이 좀 됩니다. 화면 1개 + 백엔드 집계 API 1~2개 + 다운로드 처리. 한 3일 정도 보입니다.

[Kim]
좋습니다. 다음 라운드 시작 시점에 진행해주세요. 차트는 막대로 충분합니다. 다운로드는 CSV 우선입니다.

[Yoona]
범위 명확하니까 별도 스펙으로 만들어두겠습니다.
```

# PM input
```
/meeting-note --client dsa --date 2026-05-08
```

Dev 작업: 화면 1개 + API 1~2개 + 다운로드 = 2일 이상 / 여러 컴포넌트 / owner=Dev / 스펙 합의 명확. → /to-spec 추천 trigger 발동. 자동 실행 X, 추천 태그만 출력.
