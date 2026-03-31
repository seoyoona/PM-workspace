---
description: 새 프로젝트 셋업 (로컬 파일 + Notion 뷰)
argument-hint: --client <name> --project <project-name>
allowed-tools: Read, Write, Glob, Grep, Bash(mkdir:*), mcp__claude_ai_Notion__notion-fetch, mcp__claude_ai_Notion__notion-create-pages, mcp__claude_ai_Notion__notion-update-page, mcp__claude_ai_Notion__notion-create-view, mcp__claude_ai_Notion__notion-update-view, mcp__claude_ai_Notion__notion-update-data-source
---

# New Project Setup

## Arguments
사용자 입력: $ARGUMENTS

## Instructions

새 프로젝트를 셋업합니다. 아래 4단계를 순서대로 실행하세요.

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

### Step 3: Notion DB에 프로젝트 옵션 추가
1. 프로젝트 문서 DB (collection://58f9b49c-dd24-4ae5-a827-b954072c4b8b)의 "프로젝트" SELECT 컬럼에 새 프로젝트명 옵션 추가
2. 커뮤니케이션 DB (collection://f3ea2e0c-f3d3-40a5-8dd5-364723c2f0fb)의 "프로젝트" SELECT 컬럼에 새 프로젝트명 옵션 추가
3. 태스크 DB (collection://6406d6c7-99c8-4465-880a-40c95b94eafc)의 "클라이언트" SELECT 컬럼에 새 클라이언트명 옵션 추가
4. 필요 시 각 DB의 "클라이언트" SELECT 컬럼에도 옵션 추가

**주의:** 기존 옵션을 유지하면서 새 옵션만 추가할 것. ALTER COLUMN 시 기존 옵션도 모두 포함해야 함. **3개 DB 모두** 빠짐없이 업데이트할 것.

### Step 4: PM Workspace에 프로젝트 토글 + 필터 뷰 추가
PM Workspace (32c3aae9a8948001bf49fba5b9c4c34a) 페이지의 "프로젝트별" 섹션에:

**구현 방법 (검증 완료):**

1. **토글 + linked view 삽입** — update_content로 아래 구조를 삽입:
   ```
   ### {project-name} {toggle="true"}
   	#### 문서
   	<database inline="true" data-source-url="collection://58f9b49c-dd24-4ae5-a827-b954072c4b8b">프로젝트 문서 보기</database>
   	#### 커뮤니케이션
   	<database inline="true" data-source-url="collection://f3ea2e0c-f3d3-40a5-8dd5-364723c2f0fb">커뮤니케이션 보기</database>
   	#### Daily Scrum
   	<database inline="true" data-source-url="collection://eb2f7df2-0359-4c2c-85bb-6e12e3d73afc">Daily Scrum Log</database>
   	#### PM Action
   	<database inline="true" data-source-url="collection://3a13db31-882c-4a6c-bddf-660e15ea9cdd">PM Action Hub</database>
   ```
   **핵심: `url` 속성 생략, `data-source-url`만 사용.** Notion이 자동으로 새 linked view를 생성하고 고유 database ID를 할당함.

2. **생성 확인** — PM Workspace를 다시 fetch하여 새 linked view의 database URL 확인

3. **각 linked view의 기본 뷰 ID 확인** — 각 linked view database를 fetch하여 view ID 확인

4. **update-view로 필터/정렬/표시 속성 적용:**
   - 프로젝트 문서: `name: "{project-name}"; FILTER "프로젝트" = "{project-name}"; SORT BY "작성일" DESC; SHOW "문서명", "단계", "상태", "언어", "유형", "작성일", "전달일"`
   - 커뮤니케이션: `name: "{project-name}"; FILTER "프로젝트" = "{project-name}"; SORT BY "작성일" DESC; SHOW "제목", "방향", "상태", "유형", "작성일"`
   - Daily Scrum: `name: "{project-name}"; FILTER "클라이언트" = "{client-name}"; SORT BY "날짜" DESC; SHOW "제목", "날짜", "상태"`
   - PM Action: `name: "{project-name}"; FILTER "프로젝트" = "{project-name}"; SHOW "제목", "상태", "우선순위", "액션 유형"`

**금지 사항:**
- source DB의 `url`을 `<database>` 태그에 넣지 않음 — 원본 DB가 삽입되고 삭제 시 다른 linked view에 cascade 영향
- 안내문/수동 설정 텍스트를 페이지에 삽입하지 않음
- 성공하지 못한 상태를 성공으로 보고하지 않음

**성공 기준:**
- 새 프로젝트 토글이 기존 프로젝트(Koboom, PaperERP 등)와 동일한 UX
- 각 linked view가 고유 database ID를 가짐 (source DB ID와 다름)
- 필터/정렬/표시 속성이 적용됨

### Step 5: 완료 보고
```
## 자동 생성 결과
- 로컬 파일: ✅ / ❌
- DB 옵션 추가 (3개 DB): ✅ / ❌
- linked view 생성 (문서/커뮤니케이션/Daily Scrum/PM Action): ✅ / ❌
- 필터/정렬 설정: ✅ / ❌

## 최종 상태
- 기존 프로젝트와 동일한 구조 완성 여부: ✅ / ❌
```
