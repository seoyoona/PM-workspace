---
case: case03
description: Change Brief 미연결 → §1·§7에서 (현재 항목 없음), 나머지는 SRS 기반
client: connectory
project: Connectory-1
sources: [SRS, no change-brief, design.md]
expected_qa_plan_id: QA-CONNECTORY-20260428
expected_round: R1
notes: Change Brief 자동 탐색 결과 0개. brief_refs는 [], §1·§7에서 (현재 항목 없음) 명시. SRS만으로 P0/P1 작성.
---

# Input intent

Connectory R1 QA 플랜:
- SRS 있음: REQ-CONNECTORY-01 ~ 05
- Change Brief 0건 (clients/connectory/Connectory-1/change-briefs/ 비어 있음)
- design.md 있음 (UI 표현 보조용으로만)

# Expected behavior

- frontmatter brief_refs: []
- §1: SRS REQ ID 5개 인용, "Change Brief In-Round 항목: (현재 항목 없음)"
- §3: SRS 기능 영역 기반 텍스트 트리, design.md 화면명 보조 인용
- §4 P0: SRS REQ 직접 연결 시나리오 2-3개
- §7 REG: "(현재 회귀 대상 없음)" — Change Brief 영향 영역 없음
- partial-skip 정상 (hard-fail X)
