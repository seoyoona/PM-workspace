---
status: Confirmed-1
case: case06
client: koboom
project: Koboom
created: 2026-05-10
source_type: text
source_ref: text inline (Koboom KR SRS section)
project_doc_db: collection://bd33aae9-a894-82a9-b8e2-87387e7fbf47
gate_choice: "0"
existing_match_count: 0
archive_target: none
new_page_url: https://notion.so/cigroio/koboom-srs-en-r1
version_suffix: none
new_terms_count: 4
translation_section_count: 3
glossary_terms_used: 0
---

## 1. Source Summary

- Source: text inline — Koboom KR SRS (서비스 개요 / 핵심 흐름 / 크레딧 정책)
- Sections detected: 3
- 첫 번째 SRS 번역 (이 클라이언트 신규)

## 2. Glossary Lookup

- glossary/koboom.md 부재 — 0개 용어 로드.
- 도메인 신규 용어 4건 발견 — see §6.

## 3. Confirm Gate

(중복 체크) 같은 프로젝트의 EN 번역본 매치 0건 → gate prompt 미발동.

## 4. PM Choice

- gate_choice: "0"
- Resulting actions: Notion 프로젝트 문서 DB 새 페이지 생성

## 5. Translation Output

(preview — Notion에 동일 본문 저장됨)

```
# SRS — Koboom (EN translation, R1)

## 1. Service Overview
Koboom is an AI-driven worksheet generation service for children.

## 2. Core Flow
2.1 Collection entry
2.2 Keyword input → Gatekeeper validation
2.3 Pass through Classifier → Generator pipeline → PDF output

## 3. Credit Policy
- Free worksheet: fixed content on the index page.
- Paid worksheet: 1 credit.
- Promotion code expiry: 90 days after issuance.
```

## 6. New Terms

도메인 신규 용어 4건 — `glossary/koboom.md` 신규 작성 권고:

| Korean term | English term | Notes |
|---|---|---|
| 활동지(워크시트) | worksheet | 어린이 학습용 PDF 단위 |
| 컬렉션 | collection | 사전 정의된 키워드 묶음 |
| 게이트키퍼 | Gatekeeper | 키워드 입력 검증 단계 |
| 클래시파이어 / 제너레이터 | Classifier / Generator | AI 파이프라인 단계 (별도 항목 권장) |

이번 라운드는 위 mapping으로 진행. PM이 검토 후 `glossary/koboom.md` 생성 + 위 항목 commit 권고.

## 7. Notes

- glossary/koboom.md 부재 — 첫 번역 라운드. New Terms 4건은 AI가 추출한 mapping 후보.
- 비창작 원칙 준수 — 소스 텍스트만 충실 번역, 해석·예시·확장 추가 X.
- 다음 라운드부터는 glossary 적용으로 일관성 자동 보장.
