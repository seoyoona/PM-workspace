---
case: case02
description: SRS 미연결 → §1·§9에서 [확인 필요], 나머지 정상 진행 (partial-skip)
client: connectory
project: Connectory-1
sources: [no SRS, change-brief 1건, no design.md]
expected_qa_plan_id: QA-CONNECTORY-20260428
expected_round: R1
notes: SRS 부재 → §1 검수 대상 SRS REQ ID에 [확인 필요] 표시, §9에 누락 명시. 시나리오는 Change Brief 기반으로 작성.
---

# Input intent

Connectory R1 QA 플랜:
- SRS 없음 (clients/connectory/Connectory-1/srs.md 없음, Notion에도 없음)
- Change Brief In-Round: 결제 화면 통화 안내 문구 추가
- design.md 없음

# Expected behavior

- frontmatter srs_ref: missing
- §1: SRS REQ ID는 "[확인 필요 — SRS 미연결]", 화면 list는 Change Brief에서 추출
- §3: 텍스트 트리만 (Mermaid X), design.md 화면명 인용 X (없음)
- §4 P0 시나리오: Change Brief In-Round 기반 1-2개
- §9: SRS 부재 명시 + design.md 부재 명시
- partial-skip 정상 동작 (hard-fail X)
