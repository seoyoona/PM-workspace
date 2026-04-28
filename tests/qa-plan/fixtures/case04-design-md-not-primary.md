---
case: case04
description: design.md만 있고 primary source(SRS/Change Brief/QA history) 모두 부재 → no-invention 강제 — design.md만으로 시나리오 발명 X
client: connectory
project: Connectory-2
sources: [no SRS, no change-brief, no QA history, design.md only]
expected_qa_plan_id: QA-CONNECTORY-20260428
notes: design.md primary source 사용 금지 룰 검증. AI가 design.md UI 토큰만 보고 "버튼 클릭 → ..." 같은 시나리오 발명하면 FAIL. Section 1·4·5 전부 [확인 필요]여야 정상.
---

# Input intent

Connectory R1 QA 플랜:
- SRS 없음
- Change Brief 없음
- QA history 없음
- **design.md만 있음** (디자인 토큰·컴포넌트만 정의)

# Expected behavior

- frontmatter srs_ref: missing, brief_refs: [], design_md: <path>
- §1: 검수 대상 모두 [확인 필요] (SRS·Change Brief 부재로 범위 확정 불가)
- §3 전체 플로우 맵: design.md 화면명 인용은 가능하지만 "사용자 흐름"은 [확인 필요]
- §4 P0: 시나리오 0개, "(현재 항목 없음)" 또는 [확인 필요 — primary source 부족]
- §5 P1: 동일
- §6 EDGE: 동일
- §9 PM 확인 필요: SRS·Change Brief·QA history 모두 부재 명시 + "design.md만으로 시나리오 발명 X" 룰 인용
- 시나리오에 "버튼 클릭", "화면 이동" 같은 design.md 추론 흐름 0건
- partial-skip 통과
