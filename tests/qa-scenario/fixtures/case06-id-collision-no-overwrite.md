---
case: case06
description: PM이 명시한 --scenario-id가 이미 존재하면 자동 덮어쓰지 않고 다음 가용 번호 제안 + 사용자 확인 후 진행
client: Connectory
project: Connectory-3
srs: none
brief: none
preexisting_scenario_files: ["SCN-connectory-3-005.md"]
pm_specified_id: SCN-connectory-3-005
expected_scenario_id: SCN-connectory-3-006
notes: 명시 ID 충돌 시 자동 덮어쓰기 절대 금지. 다음 번호(006) 제안 후 사용자가 1=다음 번호로 진행 선택했다고 가정. 기존 005는 그대로 유지.
---

# Input intent

PM이 `--scenario-id SCN-connectory-3-005`로 명시했으나 이미 존재. 시스템이 다음 가용 번호(006) 제안 후 PM 승인.

# Expected behavior

- 출력 시나리오 frontmatter scenario_id: SCN-connectory-3-006
- 출력 본문 또는 frontmatter에 충돌 알림 흔적 (예: "충돌로 자동 증가된 번호" 메모)
- 기존 SCN-connectory-3-005.md 파일은 손대지 않음 (덮어쓰기 0건)
