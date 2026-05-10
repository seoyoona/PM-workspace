---
case: case05
description: 비창작 원칙 회귀. KR 소스에 모호한 phrase ("나중에 정리 예정") + filler ("것 같다") + 미상세 항목이 있을 때, EN 번역은 원문 그대로 fidelity 유지하고 해석 / 추론 / 영문 보완 추가 ❌.
client: dsa
project: Dsa
source_type: text
source_ref: text inline (vague KR snippet)
existing_match_count: 0
gate_choice: "0"
expected_buckets:
  new_terms_count: 0
  translation_section_count: 2
notes: |
  비창작 핵심 회귀. AI가 "나중에 정리 예정"을 임의로 "TBD" / "to be detailed in the next round" 등으로 보완 번역하면 회귀 실패. 원문 그대로 EN으로 옮기되 해석 추가 X.
---

# Source SRS (KR, vague snippet)

```
3.5 푸시 알림
3.5.1 사용자에게 적절히 알림을 보낸다.
3.5.2 발송 조건은 나중에 정리 예정.
3.5.3 빈도는 너무 많지 않게 조절한다.
3.6 통계 (상세는 별도 회의에서 확정)
```

# PM input
```
/srs-translate --client dsa "<above text inline>"
```

비창작 원칙 검증.
