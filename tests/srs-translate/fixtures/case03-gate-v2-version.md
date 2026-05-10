---
case: case03
description: 같은 프로젝트의 EN 번역본 1건 매치 + PM이 "2 새 버전으로 생성" 선택 (기존 유지). 제목에 (v2) suffix 추가.
client: dsa
project: Dsa
source_type: notion
source_ref: notion://mock-dsa-srs-experimental
existing_match_count: 1
existing_match_url: https://notion.so/cigroio/dsa-srs-en-r1
gate_choice: "2"
expected_buckets:
  new_terms_count: 0
  translation_section_count: 4
notes: |
  실험적 SRS 변형판 — 기존 EN 번역본은 보존, 신 버전 (v2) 별도 생성. archive 발생 X.
---

# Source SRS (KR, experimental variant)

```
1. 개요 (변형판)
2. 사용자 역할
3. 기능 요구사항 (재구성됨)
4. 비기능 요구사항
```

# PM input
```
/srs-translate --client dsa notion://mock-dsa-srs-experimental
```

PM이 "2 새 버전으로 생성" 선택 → 기존 R1 페이지는 보존, 새 페이지는 (v2) suffix.
