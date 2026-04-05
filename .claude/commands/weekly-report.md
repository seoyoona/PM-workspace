---
description: 클라이언트용 주간 리포트 작성
argument-hint: --client <name> [이번 주 업데이트]
allowed-tools: Read, Glob, Grep, Bash
---

# Weekly Status Report

## Arguments
사용자 입력: $ARGUMENTS

## Context
- 주간 리포트 템플릿: !`cat /Users/yoona/Documents/yoona-workspace/templates/weekly-report.md`

## Instructions

1. **인자 파싱**: 클라이언트명과 이번 주 업데이트 내용 추출
2. **컨텍스트 로드**:
   - `clients/{client-name}/CLAUDE.md` 클라이언트 컨텍스트
   - `glossary/{client-name}.md` 용어집
3. **정보 수집** (가능한 경우):
   - Linear에서 이번 주 업데이트된 이슈 확인
   - 사용자가 제공한 업데이트 내용 활용
4. **리포트 작성**: `templates/weekly-report.md`의 출력 포맷을 따름
   - 이번 주 주요 성과
   - 진행 현황 요약 (테이블)
   - 이슈 및 리스크 (반드시 대응 방안 함께)
   - 다음 주 계획
   - 클라이언트 확인 요청 사항
5. **톤**: 클라이언트 CLAUDE.md 기반 — 한국어 존댓말, 해요체
6. **날짜 기준**: 오늘 날짜 기준으로 "~주차" 자동 표기
7. **Notion에 저장**: 커뮤니케이션 DB (`339823375b0c8121a8dff7225284bbad`) — Bash curl API로 페이지 생성
   - 유형: 주간 리포트
   - 방향: Dev→Client
   - 상태: 진행 중
