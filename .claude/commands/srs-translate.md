---
description: SRS/기획서를 한국어에서 영어로 번역 및 구조화
argument-hint: --client <name> [Notion 링크 또는 텍스트]
allowed-tools: Read, Glob, Grep, mcp__claude_ai_Notion__notion-fetch, mcp__claude_ai_Notion__notion-search, mcp__claude_ai_Notion__notion-create-pages, mcp__claude_ai_Notion__notion-update-page
---

# SRS Translation (KR → EN)

## Arguments
사용자 입력: $ARGUMENTS

## Context
- SRS 번역 템플릿: !`cat /Users/yoona/Documents/yoona-workspace/templates/srs-translation.md`

## Instructions

1. **인자 파싱**: 사용자 입력에서 소스(Notion 링크 또는 텍스트)와 클라이언트명을 추출
2. **용어집 로드**: `glossary/{client-name}.md` 파일이 있으면 읽어서 번역 시 참조
3. **클라이언트 컨텍스트 로드**: `clients/{client-name}/CLAUDE.md` 파일이 있으면 읽어서 도메인 이해에 활용
4. **소스 가져오기**: Notion 링크면 fetch, 텍스트면 그대로 사용
5. **번역 실행**: `templates/srs-translation.md`의 프로세스와 출력 포맷을 정확히 따름
   - 전체 SRS를 먼저 읽고 구조와 범위 파악
   - 용어집 기반으로 일관된 용어 사용
   - 충실한 번역 — 요구사항 추가/제거/재해석 금지
6. **필수 섹션 확인**:
   - ⚠️ Ambiguities & Open Questions (반드시 포함 — 0개면 다시 찾기)
   - New Terms (첫 번역 시 필수)
   - Inferred Requirements (Claude 추론은 원문과 명확히 분리)
7. **Notion에 저장**: 프로젝트 문서 DB (collection://58f9b49c-dd24-4ae5-a827-b954072c4b8b)에 페이지 생성
   - 유형: SRS 번역
   - 단계: SRS
   - 상태: 진행 중
   - 언어: KR→EN
   - 클라이언트/프로젝트 속성 설정
8. **용어집 업데이트 제안**: New Terms 섹션의 용어를 glossary 파일에 추가할지 사용자에게 확인
