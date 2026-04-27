---
case: case03
description: SRS / Change Brief 모두 없이 PM 입력만 있는 상태 → partial-skip
client: Connectory
project: Connectory-1
srs: none
brief: none
expected_scenario_id: SCN-connectory-1-001
notes: PM이 검수가 필요한 화면을 자연어로만 설명. SRS·Brief 없이도 시나리오 작성 자체는 진행. Section 1 Source Linkage는 [확인 필요].
---

# Input intent

PM 메모: "비밀번호 찾기 링크 색상이 배경과 비슷해서 안 보인다고 고객 피드백. 검수 시나리오 필요."

# Expected behavior

- frontmatter srs_ref: missing
- frontmatter brief_ref: none
- Section 1에 "[확인 필요 — Nexus Agent / PM]" 명시
- 시나리오 자체는 정상 생성 (hard-fail X)
- Banner "Internal QA scenario draft" 포함
