---
case: case02
description: 같은 프로젝트의 EN 번역본 1건 매치 → "1 업데이트 (기존 archive + 새로 생성)" 선택. 제목 동일 유지.
client: dsa
project: Dsa
source_type: notion
source_ref: notion://mock-dsa-srs-r2
existing_match_count: 1
existing_match_url: https://notion.so/cigroio/dsa-srs-en-r1
gate_choice: "1"
expected_buckets:
  new_terms_count: 1
  translation_section_count: 5
notes: |
  R2 입력 — 기존 R1 EN 번역본 archive 후 새로 생성. 새 SRS에 1개 도메인 용어 추가됨 (glossary 갱신 권고).
---

# Source SRS (KR, R2)

```
1. 개요
2. 사용자 역할
3. 기능 요구사항
3.1 로그인
3.2 멤버 초대
3.3 권한 경계 검증
3.4 활동 로그(audit log) — R2 신규 추가
4. 비기능 요구사항
```

# PM input
```
/srs-translate --client dsa notion://mock-dsa-srs-r2
```
