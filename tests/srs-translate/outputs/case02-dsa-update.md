---
status: Confirmed-1
case: case02
client: dsa
project: Dsa
created: 2026-05-10
source_type: notion
source_ref: notion://mock-dsa-srs-r2
project_doc_db: collection://bd33aae9-a894-82a9-b8e2-87387e7fbf47
gate_choice: "1"
existing_match_count: 1
archive_target: https://notion.so/cigroio/dsa-srs-en-r1
new_page_url: https://notion.so/cigroio/dsa-srs-en-r2-new
version_suffix: none
new_terms_count: 1
translation_section_count: 5
glossary_terms_used: 8
---

## 1. Source Summary

- Source: notion://mock-dsa-srs-r2 (R2 KR SRS, includes new audit log section)
- Sections detected: 1. 개요 / 2. 사용자 역할 / 3. 기능 요구사항 (3.1~3.4) / 4. 비기능 요구사항
- New section vs R1: 3.4 활동 로그 (audit log)

## 2. Glossary Lookup

- glossary/dsa.md found — 8 terms loaded
- 도메인 신규 용어 1건 발견 (활동 로그 → audit log) — see §6.

## 3. Confirm Gate

(중복 체크) 같은 프로젝트+유형="SRS 번역"+언어="KR→EN" 매치 1건 → gate prompt 발동.

```
⚠️ 같은 프로젝트의 EN 번역본이 이미 있습니다:
- DSA SRS (EN) — https://notion.so/cigroio/dsa-srs-en-r1

1. 업데이트 (기존 archive + 새로 생성) (추천 — 번역 갱신)
2. 새 버전으로 생성 (기존 유지, v2 등 버전 명시)
3. 취소
추천: 1
```

## 4. PM Choice

- gate_choice: "1"
- Resulting actions: 기존 R1 EN 페이지 archive + 새 R2 EN 페이지 생성. 제목 동일.

## 5. Translation Output

(preview — Notion에 동일 본문 저장됨)

```
# SRS — Dsa (EN translation)

## 1. Overview
## 2. User Roles
## 3. Functional Requirements
### 3.1 Authentication / Login
### 3.2 Member Invite
### 3.3 Permission Boundary Validation
### 3.4 Audit Log (new in R2)
## 4. Non-functional Requirements
```

## 6. New Terms

- 1건: 활동 로그 → **audit log**
  - 출처: 소스 §3.4 (R2 신규 추가)
  - 권고: `glossary/dsa.md`에 추가 (`활동 로그 | audit log | 활동 변경 이력 추적`)

## 7. Notes

- gate_choice="1" — R1 archive + R2 새로 생성. 제목 동일 유지.
- 비창작 원칙 준수 — 소스에 없는 섹션·요구사항 0건. R2 신규 §3.4만 추가.
- archive 실패 시 생성 중단 룰 적용 가능 (snapshot은 archive 성공 시나리오).
