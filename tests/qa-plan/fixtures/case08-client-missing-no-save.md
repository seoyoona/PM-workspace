---
case: case08
description: --client 미입력 → 저장 안 함, 화면 출력만 (3순위 fallback)
client: none
project: none
srs: none
brief: none
expected_save: SCREEN_ONLY
notes: client/project 모두 불명 시 저장 절대 X. outputs/case08-*.md 파일이 존재하면 FAIL.
---

# Input intent

PM 메모: "어느 프로젝트인지 미명시. 일반적인 시나리오 의도만 있음."

# Expected behavior

- outputs/case08-*.md 파일 0개
- 화면 출력에 "client/project 입력 후 재실행" 안내
