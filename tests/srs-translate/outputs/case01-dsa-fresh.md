---
status: Confirmed-1
case: case01
client: dsa
project: Dsa
created: 2026-05-10
source_type: notion
source_ref: notion://mock-dsa-srs-r1
project_doc_db: collection://bd33aae9-a894-82a9-b8e2-87387e7fbf47
gate_choice: "0"
existing_match_count: 0
archive_target: none
new_page_url: https://notion.so/cigroio/dsa-srs-en-r1
version_suffix: none
new_terms_count: 0
translation_section_count: 4
glossary_terms_used: 8
---

## 1. Source Summary

- Source: notion://mock-dsa-srs-r1 (Korean SRS, R1, last updated 2026-05-09)
- Sections detected: 1. 개요 / 2. 사용자 역할 / 3. 기능 요구사항 / 4. 비기능 요구사항
- Total length: ~12 paragraphs
- Diagrams / images: none

## 2. Glossary Lookup

- glossary/dsa.md found — 8 terms loaded
- Notable mappings used in this round:
  - 조직 관리자 → Organization admin (org_admin)
  - 회원 → Member
  - 권한 경계 → Permission boundary
  - 백오피스 → Back office
  - 대시보드 → Dashboard
  - 초대 → Invite
  - 인증 → Authentication
  - 역할 → Role

## 3. Confirm Gate

(중복 체크) 같은 프로젝트+유형="SRS 번역"+언어="KR→EN" 매치 0건 → gate prompt 미발동, 바로 생성.

## 4. PM Choice

- gate_choice: "0"
- Resulting actions: Notion 프로젝트 문서 DB 새 페이지 생성

## 5. Translation Output

(preview — Notion에 동일 본문 저장됨)

```
# SRS — Dsa (R1, EN translation)

## 1. Overview
This system is a back office where Organization admins (org_admin) invite
and manage Members.

## 2. User Roles
- org_admin: Full administration privileges for the organization.
- member: Regular member; can read the dashboard only.

## 3. Functional Requirements
### 3.1 Authentication / Login
### 3.2 Member Invite
### 3.3 Permission Boundary Validation

## 4. Non-functional Requirements
(translated as-is from source — no invention)
```

## 6. New Terms

- 0건 — 이번 라운드에서 도메인 신규 용어 발견 없음. glossary 추가 불필요.

## 7. Notes

- gate_choice="0" — 신규 SRS 번역, 기존 매치 0건.
- 비창작 원칙 준수 — 소스에 없는 섹션·요구사항·예시 추가 0건.
- glossary 8개 용어 모두 적용됨, 새 도메인 용어 발견 없음.
- archive_target: none / version_suffix: none.
