---
description: 요청/버그를 Linear 이슈 티켓으로 생성
argument-hint: --client <name> [요청 내용] --priority <high|medium|low>
allowed-tools: Read, Glob, Grep, Bash
---

# Issue Ticket (Linear)

## Arguments
사용자 입력: $ARGUMENTS

## Context
- 이슈 티켓 템플릿: !`cat /Users/yoona/Documents/yoona-workspace/templates/issue-ticket.md`

## Instructions

1. **인자 파싱**: 요청 내용, 클라이언트명, 우선순위(선택) 추출
   - `--client` 누락 시 `templates/client-default.md` 규칙 적용 (24h 내 activity-log의 client가 1개면 보수적 default 제안, 2+개면 숫자 선택지, 0개면 PM 확인)
2. **컨텍스트 로드** (아래 항목은 병렬 호출 가능 — 서로 독립):
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
