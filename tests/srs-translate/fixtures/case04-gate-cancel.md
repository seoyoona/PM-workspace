---
case: case04
description: 같은 프로젝트의 EN 번역본 1건 매치 + PM이 "3 취소" 선택. 어떤 외부 write도 발생 X.
client: dsa
project: Dsa
source_type: notion
source_ref: notion://mock-dsa-srs-r2
existing_match_count: 1
existing_match_url: https://notion.so/cigroio/dsa-srs-en-r1
gate_choice: "3"
expected_buckets:
  new_terms_count: 0
  translation_section_count: 0
notes: |
  PM이 cancel 선택. 기존 R1 페이지 그대로, 새 페이지 미생성. Translation Output 미생성.
---

# Source SRS (KR, R2)

(녹취 받았으나 PM이 다음 라운드에서 다시 처리하기로 결정)

# PM input
```
/srs-translate --client dsa notion://mock-dsa-srs-r2
```

PM이 "3 취소" 선택 → 즉시 중단.
