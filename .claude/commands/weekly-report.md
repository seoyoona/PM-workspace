---
description: 클라이언트용 주간 리포트 작성
argument-hint: --client <name> [이번 주 업데이트]
allowed-tools: Read, Glob, Grep, Bash, mcp__notion-cigro__notion-create-pages, mcp__notion-cigro__notion-fetch, mcp__notion-cigro__notion-update-page
---

# Weekly Status Report

## Arguments
사용자 입력: $ARGUMENTS

## Context
- 주간 리포트 템플릿: !`cat /Users/yoona/Documents/yoona-workspace/templates/weekly-report.md`

## Instructions

1. **인자 파싱**: 클라이언트명과 이번 주 업데이트 내용 추출
   - `--client` 누락 시 `templates/client-default.md` 규칙 적용 (24h 내 activity-log의 client가 1개면 보수적 default 제안, 2+개면 숫자 선택지, 0개면 PM 확인)
2. **컨텍스트 로드** (아래 항목은 병렬 호출 가능 — 서로 독립):
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
7. **중복 체크 (C1 멱등성 가드)** — Notion 저장 직전에 반드시 실행:
   - **Unique key**: 클라이언트 + 유형="주간 리포트" + 현재 주차(월~일)
   - 현재 주차 시작/끝 계산 (Bash):
     ```bash
     python3 -c "
     from datetime import datetime, timezone, timedelta
     kst = timezone(timedelta(hours=9))
     today = datetime.now(kst).date()
     monday = today - timedelta(days=today.weekday())
     sunday = monday + timedelta(days=6)
     print(f'{monday}|{sunday}')
     "
     ```
   - 커뮤니케이션 DB(`data_source_url: collection://47d3aae9-a894-83bf-8db8-071dd9a16fcd`)에서 `mcp__notion-cigro__notion-fetch`로 필터 조회:
     ```json
     {"and": [
       {"property": "클라이언트", "select": {"equals": "<client>"}},
       {"property": "유형", "select": {"equals": "주간 리포트"}},
       {"property": "작성일", "date": {"on_or_after": "<monday>"}},
       {"property": "작성일", "date": {"on_or_before": "<sunday>"}}
     ]}
     ```
   - **결과 분기**:
     - **0건** → Step 8로 바로 이동 (새로 생성)
     - **1건** → 사용자 확인 (Confirmation Format 준수):
       ```
       ⚠️ 같은 주차 주간 리포트가 이미 있습니다:
       - [제목] (작성일: YYYY-MM-DD) — [링크]

       1. 업데이트 (기존 페이지 archive + 새로 생성) (추천)
       2. 새로 생성 (중복 허용)
       3. 취소
       추천: 1
       ```
       - 1 → 기존 페이지를 `mcp__notion-cigro__notion-update-page`로 `{"archived": true}` 설정 → Step 8에서 새로 생성
       - 2 → Step 8로 이동 (중복 허용)
       - 3 → 중단
     - **2건 이상** → 중복 경고 + 동일 프롬프트 (가장 최근 1개만 archive 대상):
       ```
       ⚠️ 같은 주차에 주간 리포트 N개 발견 (중복 상태)

       1. 가장 최근 1개만 archive + 새로 생성 (나머지 N-1개는 유지) (추천)
       2. 새로 생성만 (기존 N개 유지)
       3. 취소
       추천: 1
       ```

8. **Notion에 저장**: `mcp__notion-cigro__notion-create-pages`로 커뮤니케이션 DB (data_source_id: `47d3aae9-a894-83bf-8db8-071dd9a16fcd`)에 페이지 생성
   - 클라이언트: {client-name}
   - 프로젝트: {project-name}
   - 유형: 주간 리포트
   - 방향: Dev→Client
   - 상태: 진행 중
   - 작성일: 오늘

## Rules (C1 관련)

- **"업데이트" = archive 후 재생성** — Notion MCP가 content block in-place 교체를 지원하지 않으므로 이 방식이 안전. archive된 페이지는 Notion 휴지통에서 30일간 복구 가능.
- **archive 전 반드시 사용자 확인** — 자동 archive 금지. "업데이트" 선택은 명시적 동의여야 함.
- **2건 이상 발견 시 자동 archive는 가장 최근 1개만** — 나머지는 건드리지 않음 (사용자가 수동 정리).
- **archive 실패 시 생성 중단** — "업데이트" 선택했는데 archive가 실패하면 새 페이지 생성하지 않고 에러 보고.
