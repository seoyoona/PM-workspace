---
case: case01
description: 같은 프로젝트+유형="SRS 번역"+언어="KR→EN" 매치 0건 → gate prompt 미발동, 바로 새 페이지 생성. Glossary 적용 + New Terms 0건 (이미 정의됨).
client: dsa
project: Dsa
source_type: notion
source_ref: notion://mock-dsa-srs-r1
existing_match_count: 0
gate_choice: "0"
glossary_terms_loaded: 8
expected_buckets:
  new_terms_count: 0
  translation_section_count: 4
notes: |
  Standard fresh translation. Source 1.0 KR SRS Notion page (mocked). Glossary 8 terms preloaded. AI 비창작 원칙 준수 — 소스 텍스트만 충실 번역.
---

# Source SRS (KR, mock — for fixture)

```
1. 개요
이 시스템은 조직 관리자(org admin)가 회원을 초대·관리하는 백오피스이다.

2. 사용자 역할
- org_admin: 조직의 전체 관리 권한
- member: 일반 회원, dashboard 읽기만 가능

3. 기능 요구사항
3.1 로그인
3.2 멤버 초대
3.3 권한 경계 검증
```

# PM input
```
/srs-translate --client dsa notion://mock-dsa-srs-r1
```

같은 프로젝트의 KR→EN 번역본 부재 → bare 생성.
