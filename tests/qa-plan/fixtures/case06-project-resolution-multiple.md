---
case: case06
description: project N개 → 추천 1개 + 숫자 선택지 + 선택 근거
client: connectory
project: (auto, 여러 개)
sources: [clients/connectory/Connectory-1/, Connectory-2/, Connectory-3/]
expected_resolved_project: Connectory-1 (가정: 가장 최근 mtime + CLAUDE.md 일치)
notes: 자동 선택 X, PM에게 추천 1개 + 선택지. 출력에 [확인 필요] 또는 사용자 선택 후 진행한 경우 근거 명시.
---

# Input intent

PM 입력: `/qa-plan connectory`
- clients/connectory/ 하위 project: Connectory-1, Connectory-2, Connectory-3 3개
- 가장 최근 mtime은 Connectory-1, CLAUDE.md `프로젝트명`도 Connectory

# Expected behavior

- 출력 어딘가에 다음 패턴:
  ```
  [확인 필요] 다음 project 중 선택해 주세요:
  1. Connectory-1  ...  ← 추천
  2. Connectory-2  ...
  3. Connectory-3  ...
  추천: 1
  ```
- 또는 PM 선택 후 진행한 경우 frontmatter project: Connectory-1 + 출력에 선택 근거 (예: 최근 mtime + CLAUDE.md 일치)
- hard-fail 안 함
