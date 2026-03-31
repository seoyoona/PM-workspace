---
description: 요청/버그를 Linear 이슈 티켓으로 생성
argument-hint: --client <name> [요청 내용] --priority <high|medium|low>
allowed-tools: Read, Glob, Grep, mcp__claude_ai_Notion__notion-fetch, mcp__claude_ai_Linear__save_issue, mcp__claude_ai_Linear__list_teams, mcp__claude_ai_Linear__list_issue_labels, mcp__claude_ai_Linear__list_issue_statuses
---

# Issue Ticket (Linear)

## Arguments
사용자 입력: $ARGUMENTS

## Context
- 이슈 티켓 템플릿: !`cat /Users/yoona/Documents/yoona-workspace/templates/issue-ticket.md`

## Instructions

1. **인자 파싱**: 요청 내용, 클라이언트명, 우선순위(선택) 추출
2. **컨텍스트 로드**:
   - `clients/{client-name}/CLAUDE.md` 도메인 컨텍스트
   - `glossary/{client-name}.md` 용어집
3. **티켓 작성**: `templates/issue-ticket.md`의 출력 포맷을 따름
   - Title: 간결한 영어 액션 기반 제목
   - What: 무엇을 해야 하는지
   - Why: 비즈니스 컨텍스트
   - Acceptance Criteria: 체크리스트
   - Technical Notes: 구현 힌트/제약사항
   - Labels: bug / feature / improvement
   - Priority: Urgent / High / Medium / Low
4. **영어로 작성**: 개발팀이 읽는 티켓
5. **한국어 원문 요청이면**: Original Request 섹션에 원문 보존
6. **Linear에 생성**: 사용자에게 내용 확인 후 Linear에 이슈 생성
   - 팀/라벨/우선순위 설정
