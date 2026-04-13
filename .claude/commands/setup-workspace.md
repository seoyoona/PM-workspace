---
description: 워크스페이스 초기 세팅 — Notion DB 5개 자동 생성 + 허브 페이지 구성 + 로컬 ID 교체
argument-hint: --name <PM이름>
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, mcp__notion-cigro__notion-fetch, mcp__notion-cigro__notion-update-page, mcp__notion-cigro__notion-create-database, mcp__notion-cigro__notion-create-view, mcp__notion-cigro__notion-duplicate-page, mcp__notion-cigro__notion-update-data-source
---

# Setup Workspace

fork한 yoona-workspace를 본인 환경으로 초기 세팅합니다.
**이 스킬은 최초 1회만 실행합니다.**

## Arguments
사용자 입력: $ARGUMENTS

## Pre-check

1. `notion-cigro` MCP가 connected 상태인지 확인 (아니면 안내 후 중단)
2. CLAUDE.md에서 기존 ID가 아직 유나 값인지 확인 (이미 교체되었으면 중복 실행 경고)

확인 방법: CLAUDE.md에서 `8163aae9a894838296b881e9d7952bf5` (유나 허브 페이지 ID) 검색
- 존재하면 → 아직 미세팅, 진행
- 없으면 → 이미 세팅됨, 경고 후 중단

## Step 1: PM 정보 수집

인자로 제공되지 않은 항목만 질문:
- PM 이름 (영문, 워크스페이스 이름에 사용)

## Step 2: 허브 페이지 준비

### Option A: Notion에서 빈 페이지 만들기 (권장)

사용자에게 요청:
```
[허브 페이지 필요]
cigro Notion 워크스페이스에서 빈 페이지를 하나 만들어주세요.
페이지 이름: "{PM이름} Workspace"

만든 후 URL을 여기에 붙여넣어주세요.
```

사용자가 URL을 주면 → page ID 추출

### Option B: 기존 페이지 ID가 있는 경우

사용자가 이미 page ID나 URL을 인자로 제공한 경우 그대로 사용.

→ 변수: `HUB_PAGE_ID`

## Step 3: Notion DB 5개 생성

모든 DB를 허브 페이지 하위에 생성합니다.
`클라이언트`와 `프로젝트` SELECT 옵션은 **빈 상태**로 생성 (`/new-project`에서 추가).
나머지 SELECT 옵션은 아래 정의대로 생성.

### 3-1. 프로젝트 문서 DB

```
mcp__notion-cigro__notion-create-database({
  parent: { page_id: "{HUB_PAGE_ID}" },
  title: "프로젝트 문서",
  schema: "CREATE TABLE (\"문서명\" TITLE, \"클라이언트\" SELECT(), \"프로젝트\" SELECT(), \"유형\" SELECT('SRS 번역':blue, '킥오프 안건':green, '기획 확인':yellow, '디자인 확인':purple, '핸드오프':orange, 'Kickoff 자료':gray, 'SRS':red), \"상태\" SELECT('진행 중':blue, '검토 중':yellow, '완료':green, '보류':gray, '시작 전':orange, 'Draft':brown), \"단계\" SELECT('SRS':blue, '기획':green, '디자인':purple, '개발':orange, 'QA':red, '런치':pink, 'Planning':brown, 'Kickoff':default), \"언어\" SELECT('KR':gray, 'EN':blue, 'KR→EN':purple), \"작성일\" DATE, \"전달일\" DATE)"
})
```

→ 저장: `PROJECT_DOC_DB_ID`, `PROJECT_DOC_DS_ID` (응답의 data-source URL에서 추출)

### 3-2. 커뮤니케이션 DB

```
mcp__notion-cigro__notion-create-database({
  parent: { page_id: "{HUB_PAGE_ID}" },
  title: "커뮤니케이션",
  schema: "CREATE TABLE (\"제목\" TITLE, \"클라이언트\" SELECT(), \"프로젝트\" SELECT(), \"유형\" SELECT('주간 리포트':blue, '클라이언트 업데이트':green, '개발 스펙':orange, '이슈 티켓':red, '질의응답':purple, '미팅 노트':yellow), \"상태\" SELECT('진행 중':blue, '완료':green, '보류':gray, '시작 전':default), \"방향\" SELECT('Client→Dev':blue, 'Dev→Client':green, 'Internal':gray), \"작성일\" DATE)"
})
```

→ 저장: `COMM_DB_ID`, `COMM_DS_ID`

### 3-3. 태스크 DB

```
mcp__notion-cigro__notion-create-database({
  parent: { page_id: "{HUB_PAGE_ID}" },
  title: "태스크",
  schema: "CREATE TABLE (\"태스크\" TITLE, \"상태\" SELECT('시작 전':gray, '진행 중':blue, '완료':green, '보류':yellow, '취소':red), \"우선순위\" SELECT('High':red, 'Medium':yellow, 'Low':gray), \"클라이언트\" SELECT(), \"프로젝트\" SELECT(), \"스펙 출처\" URL, \"AC\" RICH_TEXT, \"비고\" RICH_TEXT)"
})
```

→ 저장: `TASK_DB_ID`, `TASK_DS_ID`

### 3-4. Daily Scrum Log DB

```
mcp__notion-cigro__notion-create-database({
  parent: { page_id: "{HUB_PAGE_ID}" },
  title: "Daily Scrum Log",
  schema: "CREATE TABLE (\"제목\" TITLE, \"클라이언트\" SELECT(), \"프로젝트\" SELECT(), \"날짜\" DATE, \"상태\" SELECT('정상':green, 'Blocker 있음':red))"
})
```

→ 저장: `DAILY_DB_ID`, `DAILY_DS_ID`

### 3-5. PM Action Hub DB

```
mcp__notion-cigro__notion-create-database({
  parent: { page_id: "{HUB_PAGE_ID}" },
  title: "PM Action Hub",
  schema: "CREATE TABLE (\"제목\" TITLE, \"프로젝트\" SELECT(), \"상태\" SELECT('미착수':gray, '오늘':red, '진행 중':blue, '완료':green), \"액션 유형\" SELECT('고객 커뮤니케이션':blue, '내부 follow-up':purple, '운영 체크':green), \"출처\" SELECT('manual':gray, 'today-brief':blue, 'meeting-note':purple, 'telegram':brown), \"우선순위\" SELECT('High':red, 'Medium':yellow, 'Low':gray), \"메모\" RICH_TEXT)"
})
```

→ 저장: `ACTION_DB_ID`, `ACTION_DS_ID`

### 3-6. data_source_id 확인

각 DB 생성 응답에서 `collection://XXXX` 형태의 data_source_id를 추출.
만약 응답에 없으면 → `mcp__notion-cigro__notion-fetch`로 각 DB를 조회하여 확인.

최종 확보해야 할 값 (10개):
- `PROJECT_DOC_DB_ID`, `PROJECT_DOC_DS_ID`
- `COMM_DB_ID`, `COMM_DS_ID`
- `TASK_DB_ID`, `TASK_DS_ID`
- `DAILY_DB_ID`, `DAILY_DS_ID`
- `ACTION_DB_ID`, `ACTION_DS_ID`

## Step 4: 허브 페이지 레이아웃 구성

`mcp__notion-cigro__notion-update-page`의 `replace_content`로 허브 페이지 내용을 구성합니다.

**구성할 레이아웃:**

```markdown
## TO-DO
<database inline="true" data-source-url="collection://{ACTION_DS_ID}">PM Action Hub 보기</database>
---
## 프로젝트별

_프로젝트를 추가하려면 `/new-project --client 고객사명` 실행_

---
## Docs {toggle="true"}
	<page url="https://www.notion.so/2b93aae9a89482a18184817b9332bc46">PM Claude Code 세팅 가이드</page>
## DB {toggle="true"}
	<database url="{COMM_DB_URL}" inline="false" data-source-url="collection://{COMM_DS_ID}">커뮤니케이션</database>
	<database url="{PROJECT_DOC_DB_URL}" inline="false" data-source-url="collection://{PROJECT_DOC_DS_ID}">프로젝트 문서</database>
	<database url="{TASK_DB_URL}" inline="false" data-source-url="collection://{TASK_DS_ID}">태스크</database>
	<database url="{DAILY_DB_URL}" inline="false" data-source-url="collection://{DAILY_DS_ID}">Daily Scrum Log</database>
	<database url="{ACTION_DB_URL}" inline="false" data-source-url="collection://{ACTION_DS_ID}">PM Action Hub</database>
```

**DB URL 형식**: `https://www.notion.so/{DB_ID}` (하이픈 제거된 32자리)

**TO-DO 섹션의 PM Action Hub 뷰 설정:**
허브 페이지 업데이트 후, TO-DO에 생성된 linked view를 fetch하여 기본 뷰에 필터/정렬 적용:

```
mcp__notion-cigro__notion-create-view({
  ... 또는 기본 뷰를 update-view로 수정
  FILTER "상태" != "완료";
  SORT BY "상태" ASC;
  SHOW "제목", "프로젝트", "상태", "액션 유형", "메모"
})
```

## Step 5: 로컬 파일 ID 일괄 교체

CLAUDE.md와 .claude/commands/ 하위 모든 .md 파일에서 유나의 ID를 새 ID로 교체합니다.

### 교체 대상 ID 매핑

| 설명 | 기존 (유나) | 새 값 |
|------|------------|-------|
| 허브 페이지 | `8163aae9a894838296b881e9d7952bf5` | `{HUB_PAGE_ID}` |
| 프로젝트문서 DB | `d7f3aae9a894831a96b2013549196181` | `{PROJECT_DOC_DB_ID}` |
| 프로젝트문서 DS | `bd33aae9-a894-82a9-b8e2-87387e7fbf47` | `{PROJECT_DOC_DS_ID}` |
| 커뮤니케이션 DB | `3793aae9a894836e8a200120b24454e4` | `{COMM_DB_ID}` |
| 커뮤니케이션 DS | `47d3aae9-a894-83bf-8db8-071dd9a16fcd` | `{COMM_DS_ID}` |
| 태스크 DB | `b9f3aae9a8948322abee81e151af9831` | `{TASK_DB_ID}` |
| 태스크 DS | `4273aae9-a894-83fd-8d5e-87897d6d0570` | `{TASK_DS_ID}` |
| Daily Scrum DB | `26b3aae9a89483b79de3810dce151383` | `{DAILY_DB_ID}` |
| Daily Scrum DS | `9e03aae9-a894-8377-bbaf-0717f5d7f2ef` | `{DAILY_DS_ID}` |
| PM Action Hub DB | `ff43aae9a89482ea8c57815a65ac9f5b` | `{ACTION_DB_ID}` |
| PM Action Hub DS | `a183aae9-a894-8379-8708-87cf507ec8e8` | `{ACTION_DS_ID}` |

### 교체 방법

Bash의 sed로 일괄 교체합니다:

```bash
# 대상 파일 목록
FILES="CLAUDE.md $(find .claude/commands/ -name '*.md')"

# 각 ID 쌍에 대해 sed 실행
for file in $FILES; do
  sed -i '' \
    -e 's|8163aae9a894838296b881e9d7952bf5|{HUB_PAGE_ID}|g' \
    -e 's|d7f3aae9a894831a96b2013549196181|{PROJECT_DOC_DB_ID}|g' \
    -e 's|bd33aae9-a894-82a9-b8e2-87387e7fbf47|{PROJECT_DOC_DS_ID}|g' \
    -e 's|3793aae9a894836e8a200120b24454e4|{COMM_DB_ID}|g' \
    -e 's|47d3aae9-a894-83bf-8db8-071dd9a16fcd|{COMM_DS_ID}|g' \
    -e 's|b9f3aae9a8948322abee81e151af9831|{TASK_DB_ID}|g' \
    -e 's|4273aae9-a894-83fd-8d5e-87897d6d0570|{TASK_DS_ID}|g' \
    -e 's|26b3aae9a89483b79de3810dce151383|{DAILY_DB_ID}|g' \
    -e 's|9e03aae9-a894-8377-bbaf-0717f5d7f2ef|{DAILY_DS_ID}|g' \
    -e 's|ff43aae9a89482ea8c57815a65ac9f5b|{ACTION_DB_ID}|g' \
    -e 's|a183aae9-a894-8379-8708-87cf507ec8e8|{ACTION_DS_ID}|g' \
    "$file"
done
```

**주의:** `{변수}`는 실제 값으로 치환하여 실행할 것. 위 코드는 템플릿임.

### 교체 검증

교체 후 기존 유나 ID가 남아있지 않은지 확인:

```bash
grep -r "8163aae9a894838296b881e9d7952bf5\|d7f3aae9a894831a96b2013549196181\|bd33aae9-a894-82a9-b8e2-87387e7fbf47" CLAUDE.md .claude/commands/
```

결과가 없으면 성공.

## Step 6: Nexus Alias 초기화

`.claude/nexus-alias.md`를 빈 템플릿으로 초기화:

```markdown
# Nexus Project Alias Registry
# 사용자 약칭 → Nexus projectName (tasks_list 응답의 projectName 필드)
# 한 약칭 = 하나의 projectName (1:1 매핑)
#
# 확인 방법:
# 1. /nexus-daily 인자 없이 실행 → 활성 태스크 목록 출력
# 2. 각 태스크의 projectName 확인
# 3. 약칭 | projectName 형태로 등록

# --- 여기에 본인 프로젝트 등록 ---
```

## Step 7: Nexus OS 설정 안내

```
[Nexus OS 연동]
Nexus OS MCP를 등록하려면 관리자에게 API Token을 발급받으세요.

발급 후 터미널에서:
claude mcp add nexus-os --transport http "https://nexus-os-iota.vercel.app/api/mcp" \
  --header "Authorization: Bearer {발급받은_토큰}"

Workforce ID도 확인이 필요합니다:
Claude Code에서: "nexus-os workforces_list에서 내 이름으로 검색해줘"
확인 후 CLAUDE.md의 Workforce ID를 교체하세요.
```

## Step 8: 완료 보고

```
## 워크스페이스 세팅 결과

### Notion
- 허브 페이지: ✅ {HUB_PAGE_URL}
- 프로젝트 문서 DB: ✅ {PROJECT_DOC_DB_URL}
- 커뮤니케이션 DB: ✅ {COMM_DB_URL}
- 태스크 DB: ✅ {TASK_DB_URL}
- Daily Scrum Log DB: ✅ {DAILY_DB_URL}
- PM Action Hub DB: ✅ {ACTION_DB_URL}
- 허브 레이아웃: ✅ (TO-DO + 프로젝트별 + Docs + DB)

### 로컬 파일
- CLAUDE.md ID 교체: ✅ (11개 ID)
- 스킬 파일 ID 교체: ✅
- nexus-alias.md 초기화: ✅

### 남은 작업
1. Nexus OS MCP 등록 (관리자에게 토큰 발급)
2. `/new-project --client 고객사명` 으로 담당 고객사 등록
3. (선택) Teams 연동: .env.teams 파일 생성
4. (선택) Google Workspace MCP 연결
```

## 교체하지 않는 것 (공용)

아래는 모든 PM이 동일하게 사용하므로 교체 불필요:
- CLAUDE.md 규칙 (번역, 품질, 확인 방식 등)
- .claude/commands/*.md 스킬 로직 (ID 외)
- templates/ 디렉토리
- handoffs/ 디렉토리
