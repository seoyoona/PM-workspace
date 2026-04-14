---
description: 클라이언트 요청/변경사항을 개발팀 티켓으로 변환
argument-hint: --client <name> [요청 내용 또는 Notion 링크]
allowed-tools: Read, Glob, Grep, mcp__notion-cigro__notion-create-pages, mcp__notion-cigro__notion-fetch, mcp__notion-cigro__notion-update-page, mcp__notion-cigro__notion-search
---

# Client Request → Dev Ticket

## Arguments
사용자 입력: $ARGUMENTS

## Context
- 요청→스펙 템플릿: !`cat /Users/yoona/Documents/yoona-workspace/templates/request-to-spec.md`

## Instructions

1. **인자 파싱**: 클라이언트 요청 내용(텍스트/Notion 링크)과 클라이언트명 추출
   - `--client` 누락 시 `templates/client-default.md` 규칙 적용 (24h 내 activity-log의 client가 1개면 보수적 default 제안, 2+개면 숫자 선택지, 0개면 PM 확인)
2. **컨텍스트 로드** (아래 항목은 병렬 호출 가능 — 서로 독립):
   - `glossary/{client-name}.md` 용어집
   - `clients/{client-name}/CLAUDE.md` 클라이언트 컨텍스트 (도메인 이해용)
3. **소스 가져오기**: Notion 링크면 `mcp__notion-cigro__notion-fetch`으로 블록 읽기, 텍스트면 그대로 사용
4. **요청 분석**:
   - 클라이언트가 실제로 원하는 것 추출 (불만/맥락과 요청 분리)
   - 암묵적 요구사항 식별
   - 여러 요청이 섞여 있으면 자동 분리

### Part 1: 스펙 페이지 생성 (커뮤니케이션 DB)

5. **스펙 페이지 작성**:
   - **Title**: 한 줄로 뭘 해야 하는지 명확하게
   - **Context**: 왜 필요한지 1-2문장
   - **Scope Summary**: 기능 영역별 설명 테이블 (참고용 — 태스크 추적은 Part 2에서)
   - **Constraints**: Edge case + 제한사항 통합 (있을 때만)
   - **Open Questions**: 개발팀 확인 필요사항 (있을 때만)
   - **SRS Impact**: 아래 Step 6 참조
   - **Ref**: 한국어 원문 보존
6. **SRS 영향도 분석**: 프로젝트 문서 DB에서 해당 클라이언트의 SRS를 찾아 읽고 분석:
   - Affects: [REQ ID(s) or section name]
   - Type: Scope change / Scope clarification / New requirement
   - SRS가 없거나 영향 없으면 "No SRS impact" 표기
   - SRS를 직접 수정하지 않음 — PM 판단 후 직접 실행
7. **Notion에 저장**: `mcp__notion-cigro__notion-create-pages`로 커뮤니케이션 DB (`3793aae9a894836e8a200120b24454e4`)에 페이지 생성
   - 유형: 개발 스펙
   - 방향: Client→Dev
   - 상태: 진행 중
   - 클라이언트/프로젝트 속성 설정

### Part 2: 태스크 생성 (태스크 DB) + 스펙 페이지에 링크드 뷰 삽입

8. **태스크 분리**: Scope의 각 구현 항목을 개별 태스크로 분리
   - 한 태스크 = 개발자가 독립적으로 완료할 수 있는 단위
   - 너무 크면 쪼개고, 너무 작으면 합침
9. **태스크 DB에 생성**: `mcp__notion-cigro__notion-create-pages`로 태스크 DB (`b9f3aae9a8948322abee81e151af9831`)에 각 태스크를 페이지로 생성
   - 태스크: 구체적 구현 항목 (한 줄, 영어)
   - 상태: 시작 전
   - 우선순위: High / Medium / Low (요청 맥락에서 판단)
   - 클라이언트: 해당 클라이언트
   - 프로젝트: 해당 프로젝트명
   - 스펙 출처: Part 1에서 생성한 스펙 페이지 URL
   - AC: When/Then 형식, 이 태스크만의 acceptance criteria
   - 비고: edge cases, technical notes (있을 때만)
10. **스펙 페이지에 태스크 요약 테이블 삽입**: 태스크 생성 후, Part 1 스펙 페이지 하단에 태스크 요약 테이블을 추가
    - update_content로 스펙 페이지 맨 아래에 `## Tasks` 섹션 추가
    - 테이블 형식: Task (태스크 DB 페이지 링크) | Priority | AC | Notes
    - 각 태스크명은 `[태스크명](태스크 DB 페이지 URL)` 형식으로 링크
    - 테이블 위에 "상태 관리는 태스크 DB에서 진행합니다." 안내 문구 포함
    - **결과**: 스펙 문서 안에서 해당 태스크를 한눈에 확인하고, 클릭하면 태스크 DB로 이동

### Part 3: linked view 안내

11. **linked view 수동 설정 안내**: API로 relation 필터를 설정할 수 없으므로, 사용자에게 수동 단계를 안내:
    ```
    📋 마지막 단계 (수동, 40초):
    1. 스펙 페이지 하단에서 /linked view → 태스크 DB 추가
    2. 필터 설정: 스펙 출처 = {이 스펙 페이지 제목}
    → 개발자가 이 스펙의 태스크만 티켓으로 확인 가능
    ```

### 마무리

12. **사용자에게 결과 보고**:
    - 스펙 페이지 링크
    - 생성된 태스크 목록 요약 (태스크명 + 우선순위)
    - Open Questions가 있으면 강조
    - linked view 수동 설정 안내 (위 Step 11)

## Rules
- 영어로 작성: 개발팀이 읽는 문서 — 간결하고 직접적으로
- 용어는 glossary 기준 사용
- 한 요청에 여러 기능이 섞여 있으면 스펙은 1개, 태스크는 기능별로 분리
- 태스크 granularity: "API endpoint 하나" 또는 "UI 컴포넌트 하나" 수준
- 스크린샷 입력도 지원
