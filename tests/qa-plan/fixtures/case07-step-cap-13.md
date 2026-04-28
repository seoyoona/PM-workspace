---
case: case07
description: 시나리오 1개가 13단계 → cap 초과 경고 + 자동 자르기 X
client: dsa
project: DSA
sources: [SRS]
expected_qa_plan_id: QA-DSA-20260428
notes: P0-01 시나리오가 13단계로 작성됨. 출력에 cap 초과 경고 문구 의무 포함, 단계는 13개 그대로 보존 (자동 자르기 X).
---

# Input intent

DSA R1 QA 플랜:
- SRS REQ-DSA-01: 보고서 작성→미리보기→편집→제출→검수 대기→승인→환불 시나리오 (긴 흐름, 13단계)

# Expected behavior

- §4 P0-01 단계 13개 모두 보존 (자동 자르기 X)
- 같은 시나리오 안에 또는 §9에 "단계 cap 초과 (현재 13)" 또는 "분리 권장" 경고 문구
- 자동 시나리오 분리 X — PM 수동 결정
