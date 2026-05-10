---
status: Confirmed-2
case: case03
client: dsa
project: Dsa
created: 2026-05-10
source_type: notion
source_ref: notion://mock-dsa-srs-experimental
project_doc_db: collection://bd33aae9-a894-82a9-b8e2-87387e7fbf47
gate_choice: "2"
existing_match_count: 1
archive_target: none
new_page_url: https://notion.so/cigroio/dsa-srs-en-r1-v2
version_suffix: " (v2)"
new_terms_count: 0
translation_section_count: 4
glossary_terms_used: 8
---

## 1. Source Summary

- Source: notion://mock-dsa-srs-experimental (변형판, 기존 R1과 별도)
- Sections detected: 1. 개요 / 2. 사용자 역할 / 3. 기능 요구사항 (재구성) / 4. 비기능 요구사항

## 2. Glossary Lookup

- glossary/dsa.md found — 8 terms loaded
- 도메인 신규 용어 0건.

## 3. Confirm Gate

(중복 체크) 같은 프로젝트의 EN 번역본 1건 매치 → gate prompt 발동.

```
⚠️ 같은 프로젝트의 EN 번역본이 이미 있습니다:
- DSA SRS (EN) — https://notion.so/cigroio/dsa-srs-en-r1

1. 업데이트 (기존 archive + 새로 생성) (추천 — 번역 갱신)
2. 새 버전으로 생성 (기존 유지, v2 등 버전 명시)
3. 취소
추천: 1
```

## 4. PM Choice

- gate_choice: "2"
- Resulting actions: 기존 R1 페이지 보존, 새 페이지는 제목 끝에 ` (v2)` suffix로 생성.

## 5. Translation Output

(preview — Notion에 동일 본문 저장됨)

```
# SRS — Dsa (EN translation) (v2)

## 1. Overview (variant)
## 2. User Roles
## 3. Functional Requirements (restructured)
## 4. Non-functional Requirements
```

## 6. New Terms

- 0건 — 신규 도메인 용어 없음.

## 7. Notes

- gate_choice="2" — 기존 R1 EN 페이지 보존. 새 페이지는 (v2) suffix.
- archive_target: none — gate=2 경로는 archive 미발생.
- 제목 차별화: 기존 "SRS — Dsa (EN translation)" / 새 "SRS — Dsa (EN translation) (v2)".
