---
case: case07
description: 단계 수가 12를 초과하면 출력에 경고 문구가 포함된다
client: Connectory
project: Connectory-4
srs: none
brief: none
expected_scenario_id: SCN-connectory-4-001
expected_step_count: 13
notes: 자동 자르기 X, 경고만. PM이 시나리오 분리 결정.
---

# Input intent

PM 메모: "복합 결제 → 환불 → 재결제 → 영수증 다운로드까지 한 번에 검수. 13단계 시나리오 필요."

# Expected behavior

- Section 5 표에 13개 row (단계 1~13)
- 출력 어딘가에 "단계 수가 12를 초과" 경고 문구 (스킬이 작성 후 경고 출력)
- 자동 자르기 X — 13단계 그대로 작성
