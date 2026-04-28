---
case: case01
description: 풀-소스 (SRS + Change Brief In-Round + design.md + QA history) → 9 섹션 모두 정상 작성
client: dsa
project: DSA
sources: [srs.md, change-brief 1건 status=Dev-Handoff, design.md, QA feedback R-1]
expected_qa_plan_id: QA-DSA-20260428
expected_round: R1
notes: P0/P1/EDGE/REG 모두 작성 가능. design.md는 §3 화면명 인용 보조만.
---

# Input intent

PM이 DSA 프로젝트 R1 QA 플랜 작성:
- SRS REQ-DSA-01 (보고서 작성), REQ-DSA-02 (보고서 검수), REQ-DSA-03 (운행일지)
- Change Brief In-Round: 보고서 미리보기 화면에 위험요인 강조 표시 추가
- design.md: 현재 디자인 토큰·컴포넌트 (UI 표현 보조)
- QA history R-1: 보고서 제출 시 status 미반영 FAIL 1건

# Expected behavior

- frontmatter qa_plan_id: QA-DSA-20260428, round: R1
- §1: REQ-DSA-01/02/03 + 보고서 미리보기 화면 (Change Brief In-Round 인용)
- §3: 텍스트 트리 (Mermaid X), design.md 화면명 보조 인용
- §4: P0 시나리오 2-3개 (REQ 직접 연결)
- §5: P1 시나리오
- §7 REG-01: 이전 라운드 FAIL (보고서 status 미반영)
- §8: QA 전달 메시지 (QA Plan ID + Scenario ID 메타 보존 안내 포함)
- Internal banner 포함
