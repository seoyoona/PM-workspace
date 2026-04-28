---
case: case05
description: project 1개 자동 선택 + 선택 근거 명시
client: dsa
project: (auto)
sources: [clients/dsa/DSA/만 존재]
expected_qa_plan_id: QA-DSA-20260428
expected_resolved_project: DSA
notes: client만 입력 → 하위 project 디렉토리 1개라 자동 선택. preview에 "선택된 project: DSA (근거: 1개만 존재)" 출력.
---

# Input intent

PM 입력: `/qa-plan dsa`
- clients/dsa/ 하위 project: DSA 1개
- SRS / Change Brief / design.md는 case01과 동일 가정

# Expected behavior

- frontmatter project: DSA
- 출력 어딘가에 "선택된 project: DSA (근거: 1개만 존재)" 1줄 명시
- 저장 경로: clients/dsa/DSA/qa/plans/QA-DSA-YYYYMMDD.md
- 9-section 정상 작성
