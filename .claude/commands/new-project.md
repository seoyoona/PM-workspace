---
description: 새 프로젝트 셋업 (로컬 파일 + Notion 뷰 + Project management)
argument-hint: --client <name> --project <project-name>
allowed-tools: Read, Write, Glob, Grep, mcp__notion-cigro__notion-fetch, mcp__notion-cigro__notion-update-page, mcp__notion-cigro__notion-update-view, mcp__notion-cigro__notion-update-data-source, mcp__notion-cigro__notion-create-pages
---

# New Project Setup

## Arguments
사용자 입력: $ARGUMENTS

## Instructions

새 프로젝트를 셋업합니다. 아래 단계를 순서대로 실행하세요.

### Step 1: 고객사 정보 수집
사용자에게 아래 정보를 확인합니다 (인자로 제공되지 않은 항목만):
- 고객사명
- 프로젝트명
- 프로젝트 설명
- 담당자 (이름, 직급)
- 커뮤니케이션 스타일 (특이사항)
- 주요 도메인 용어

### Step 2: 로컬 파일 생성
1. `clients/{client-name}/CLAUDE.md` 생성
   - Overview: 고객사명, 프로젝트명, 설명, 담당자
   - Communication Style: 담당자 성향, 주의사항
   - Tone: 기본 해요체, 공식 문서 합쇼체 + 고객사 맞춤 톤
   - Domain Context: 비즈니스 도메인 설명

2. `glossary/{client-name}.md` 생성
   - Korean | English | Notes 테이블
   - 수집된 도메인 용어 매핑

### Step 3: Notion DB에 프로젝트 옵션 추가 (MCP)
1. 각 DB의 현재 schema 조회: `mcp__notion-cigro__notion-fetch`로 기존 SELECT 옵션 확인
2. 프로젝트 문서 DB (`d7f3aae9a894831a96b2013549196181`)의 "프로젝트" SELECT 컬럼에 새 프로젝트명 옵션 추가
3. 커뮤니케이션 DB (`3793aae9a894836e8a200120b24454e4`)의 "프로젝트" SELECT 컬럼에 새 프로젝트명 옵션 추가
4. 태스크 DB (`b9f3aae9a8948322abee81e151af9831`)의 "클라이언트" SELECT 컬럼에 새 클라이언트명 옵션 추가
5. Daily Scrum Log DB (`26b3aae9a89483b79de3810dce151383`, data_source_id `9e03aae9-a894-8377-bbaf-0717f5d7f2ef`)의 "프로젝트" SELECT 컬럼에 새 프로젝트명 옵션 추가, "클라이언트" SELECT 컬럼에 새 클라이언트명 옵션 추가
- API: `mcp__notion-cigro__notion-update-data-source` 사용
6. 필요 시 각 DB의 "클라이언트" SELECT 컬럼에도 옵션 추가

**주의:** 기존 옵션을 유지하면서 새 옵션만 추가할 것. UPDATE 시 기존 옵션도 모두 포함해야 함. **4개 DB 모두** (프로젝트 문서 / 커뮤니케이션 / 태스크 / Daily Scrum Log) 빠짐없이 업데이트할 것. Daily Scrum Log에 옵션이 미리 등록돼 있지 않으면 Step 4의 view 필터가 silent fail함.

### Step 4: PM Workspace에 프로젝트 토글 + 필터 뷰 추가
PM Workspace (CLAUDE.md의 PM Workspace 페이지 ID 참조) 페이지의 "프로젝트별" 섹션에:

**구현 방법 (검증 완료):**

1. **토글 + linked view 삽입** — update_content로 아래 구조를 삽입:
   ```
   ### {project-name} {toggle="true"}
   	<database inline="true" data-source-url="collection://bd33aae9-a894-82a9-b8e2-87387e7fbf47">프로젝트 문서 보기</database>
   	<database inline="true" data-source-url="collection://47d3aae9-a894-83bf-8db8-071dd9a16fcd">커뮤니케이션 보기</database>
   	<database inline="true" data-source-url="collection://9e03aae9-a894-8377-bbaf-0717f5d7f2ef">Daily Scrum Log</database>
   ```
   **핵심: `url` 속성 생략, `data-source-url`만 사용.** Notion이 자동으로 새 linked view를 생성하고 고유 database ID를 할당함.
   **heading 블록 (#### 문서, #### 커뮤니케이션, #### Daily Scrum) 삽입 금지** — DB 자체 제목으로 충분.

2. **생성 확인** — PM Workspace를 다시 fetch하여 새 linked view의 database URL 확인

3. **각 linked view의 기본 뷰 ID 확인** — 각 linked view database를 fetch하여 view ID 확인

4. **update-view로 필터/정렬/표시 속성 적용:**
   - 프로젝트 문서: `name: "{project-name}"; FILTER "프로젝트" = "{project-name}"; SORT BY "작성일" DESC; SHOW "문서명", "단계", "상태", "언어", "유형", "작성일", "전달일"`
   - 커뮤니케이션: `name: "{project-name}"; FILTER "프로젝트" = "{project-name}"; SORT BY "작성일" DESC; SHOW "제목", "방향", "상태", "유형", "작성일"`
   - Daily Scrum: `name: "{project-name}"; FILTER "프로젝트" = "{project-name}"; SORT BY "날짜" DESC; SHOW "제목", "날짜", "상태"`

   **주의:** 3개 view 모두 필터 기준은 **"프로젝트"** 컬럼으로 통일. (Daily Scrum도 "클라이언트"가 아닌 "프로젝트" 사용 — 한 클라이언트에 여러 프로젝트가 생길 수 있고, view name과 filter 기준의 mismatch가 update-view 자연어 파싱 silent fail의 원인이 됐음.)

5. **검증 (필수):** update-view 호출 직후 각 linked view database를 다시 `mcp__notion-cigro__notion-fetch`로 조회하여 filter가 실제로 박혔는지 확인.
   - filter가 비어있거나 다른 값이면 → 동일한 instruction으로 update-view 1회 재시도
   - 재시도 후에도 비어있으면 → Step 7 보고에 "Daily Scrum 필터 미적용" 명시 (성공으로 보고 금지)
   - 특히 Daily Scrum view는 inline 생성 직후 default view ID 할당 race로 인해 첫 호출이 silent fail하는 케이스가 있음

**금지 사항:**
- source DB의 `url`을 `<database>` 태그에 넣지 않음 — 원본 DB가 삽입되고 삭제 시 다른 linked view에 cascade 영향
- 안내문/수동 설정 텍스트를 페이지에 삽입하지 않음
- 성공하지 못한 상태를 성공으로 보고하지 않음

**성공 기준:**
- 새 프로젝트 토글이 기존 프로젝트(Koboom, PaperERP 등)와 동일한 UX
- 각 linked view가 고유 database ID를 가짐 (source DB ID와 다름)
- 필터/정렬/표시 속성이 적용됨

### Step 5: Project management 등록
현재 MCP는 개인 워크스페이스(yoona-workspace)에만 연결되어 있어 cigroio Project management DB에는 자동 등록 불가.

사용자에게 안내:
```
[Project management 등록]
cigroio Project management에 수동으로 등록이 필요합니다:
https://www.notion.so/cigroio/Project-management-e22197abb0874209ac0aa93bb732c939

등록 정보:
- Project name: {project-name}
- Company: {client-name}
- Status: Backlog
- People: Yoona
- Type: Litmers
```

### Step 6: Teams 채팅 등록
사용자에게 개발팀 Teams 그룹채팅 ID 등록을 안내합니다.

```
[Teams 채팅 등록]
이 프로젝트의 개발팀 Teams 그룹채팅을 등록하면
/dev-chat, /sync-note에서 Teams 직접 전송이 가능합니다.

1. Teams 웹 앱에서 해당 그룹채팅 열기
2. URL에서 "19:xxx@thread.v2" 부분 복사
3. 여기에 붙여넣기

(나중에 등록하려면 "스킵")
```

- 사용자가 chat ID를 주면 → `.env.teams`에 `TEAMS_CHAT_{CLIENT}_DEV={chat_id}` 추가
- 클라이언트 디렉토리명 대문자 변환 규칙 적용 (예: koboom → TEAMS_CHAT_KOBOOM_DEV)
- "스킵"하면 등록하지 않음 — 이후 수동으로 `.env.teams`에 추가 가능
- `.env.teams` 파일이 없으면 생성 (`.gitignore`에 포함되어 있는지 확인)

### Step 7: 완료 보고
```
## 자동 생성 결과
- 로컬 파일: ✅ / ❌
- DB 옵션 추가 (3개 DB): ✅ / ❌
- linked view 생성 (문서/커뮤니케이션/Daily Scrum): ✅ / ❌
- 필터/정렬 설정: ✅ / ❌
- Project management 등록: ⏭️ 수동 등록 필요 (cigroio 워크스페이스)
- Teams 채팅 등록: ✅ / ⏭️ 스킵

## 최종 상태
- 기존 프로젝트와 동일한 구조 완성 여부: ✅ / ❌
- Project management 뷰에서 확인: [프로젝트 URL]
```
