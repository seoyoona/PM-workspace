---
case: case05
description: 기존 SCN 파일이 SCN-{slug}-001 / 002 / 003이 있을 때 새 시나리오는 -004로 생성
client: Connectory
project: Connectory-2  # Connectory-1과 분리해서 다른 디렉토리 가정
srs: none
brief: none
preexisting_scenario_files: ["SCN-connectory-2-001.md", "SCN-connectory-2-002.md", "SCN-connectory-2-003.md"]
expected_scenario_id: SCN-connectory-2-004
notes: scenario_id 충돌 방지 룰 (Step 5) 검증 — max NNN +1
---

# Input intent

PM 메모: "장바구니에 상품 추가 후 주문 흐름 시나리오 추가."

# Expected behavior

- frontmatter scenario_id: SCN-connectory-2-004
- 출력 파일명에 -004 포함
- 기존 001/002/003 파일에는 손대지 않음
