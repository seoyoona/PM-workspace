---
case: case09
description: 시나리오 수 (P0+P1+EDGE+REG 합계)가 화면 수 × 1.5 초과 → §9 PM 확인 필요로 안내, 작성 차단 X
client: connectory
project: Connectory-1
sources: [SRS with 10 화면, Change Brief In-Round 다수]
expected_total_scenarios: 20+ (cap = 10 × 1.5 = 15 초과)
notes: 시나리오 수 cap (화면 × 1.5) 초과 시 §9에 분리·통합 검토 권장 안내. 작성 자체는 차단 X.
---

# Input intent

Connectory R1 QA 플랜:
- SRS REQ 20개+, 화면 10개
- Change Brief In-Round 5개
- 따라서 P0/P1/EDGE/REG 합산 시 20개+ 시나리오 필요

# Expected behavior

- §4 P0 + §5 P1 + §6 EDGE + §7 REG 합계가 15(화면 10 × 1.5) 초과
- §9 PM 확인 필요에 "시나리오 수 cap 초과 — 분리·통합 검토 권장" 안내 의무 포함
- 작성 자체는 차단 X (모든 시나리오 그대로 보존)
