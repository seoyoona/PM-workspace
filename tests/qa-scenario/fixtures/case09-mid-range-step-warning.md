---
case: case09
description: 10~12단계 (mid-range) → "분리 검토 권장" 안내가 출력에 포함된다. cap 초과 경고는 X (13+에서만)
client: Connectory
project: Connectory-5
srs: none
brief: none
expected_scenario_id: SCN-connectory-5-001
expected_step_count: 10
notes: 3-tier 가이드 검증 (권장 6~9 / 10~12 분리 검토 / 13+ cap 초과). minor patch 추가 케이스.
---

# Input intent

PM 메모: "결제 → 환불 → 재결제 핵심 흐름 검수. 10단계 시나리오."
- 10단계는 권장 6~9 범위 밖이지만 cap 12 초과는 아님
- "분리 검토 권장" 안내가 의무 출력되어야 함
- "단계 수가 12를 초과" 경고는 절대 출력되면 안 됨

# Expected behavior

- Section 5에 10개 단계 row
- 출력에 "분리할지 검토하세요" / "자동 분리는 하지 않" 문구 포함
- "단계 수가 12를 초과" 문구 미포함 (10은 cap 초과 아님)
