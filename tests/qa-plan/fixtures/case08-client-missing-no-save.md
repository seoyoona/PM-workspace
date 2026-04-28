---
case: case08
description: client 미입력 → 저장 안 함, 화면 출력만 (3순위 fallback)
client: none
project: none
sources: []
expected_save: SCREEN_ONLY
notes: positional client 없고 --client 옵션도 없으면 저장 절대 X. outputs/case08-*.md 파일이 존재하면 FAIL.
---

# Input intent

PM 입력: `/qa-plan` (인자 없음)

# Expected behavior

- outputs/case08-*.md 파일 0개
- 화면 출력에 "client 입력 후 재실행" 안내
- 저장 자체가 일어나지 않음 (3순위 fallback)
