---
description: 킥오프 미팅 안건 및 내부 준비 자료 작성
argument-hint: --client <name> [SRS Notion 링크]
allowed-tools: Read, Glob, Grep, Bash
---

# Kickoff Preparation

## Arguments
사용자 입력: $ARGUMENTS

## Context
- 킥오프 준비 템플릿: !`cat /Users/yoona/Documents/yoona-workspace/templates/kickoff-prep.md`

## Instructions

1. **인자 파싱**: 클라이언트명과 SRS 번역본 링크 추출
2. **컨텍스트 로드**:
   - `glossary/{client-name}.md` 용어집
   - `clients/{client-name}/CLAUDE.md` 클라이언트 컨텍스트
3. **SRS 번역본 가져오기**: Notion 링크면 Bash curl로 blocks 읽기 (`GET https://api.notion.com/v1/blocks/{page_id}/children`), 없으면 사용자에게 요청
4. **킥오프 자료 작성**: `templates/kickoff-prep.md`의 프로세스와 출력 포맷을 정확히 따름
   - **Part A**: 킥오프 안건 (한국어, 클라이언트용)
     - 클라이언트 CLAUDE.md의 커뮤니케이션 스타일에 맞춰 톤 조절
     - 프로젝트 개요 확인 → 요구사항 확인 사항 → 기술/디자인 논의 → 커뮤니케이션 방식 → 다음 단계
   - **Part B**: Internal Prep Notes (영어, PM용)
     - Key Risks / Blocking Questions / Glossary Gaps / Timeline Discussion Points
5. **SRS Ambiguities 반영**: SRS 번역본의 "Ambiguities & Open Questions"을 킥오프 안건에 자동 포함
6. **Notion에 저장**: 프로젝트 문서 DB (`339823375b0c8182a853f7695648de84`) — Bash curl API로 **2개 페이지** 각각 생성
   - **Part A 페이지**: 킥오프 안건 (고객사용)
     - 문서명: "고객사 킥오프"
     - 유형: Kickoff 자료 / 단계: Kickoff / 상태: 진행 중 / 언어: KR
   - **Part B 페이지**: Internal Prep Notes (PM용)
     - 문서명: "Dev kick-off"
     - 유형: Kickoff 자료 / 단계: Kickoff / 상태: 진행 중 / 언어: EN
   - 한 페이지에 합치지 않음 — 고객 전달 및 내부 관리 용이
