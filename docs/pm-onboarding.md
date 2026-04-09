# PM Workspace 온보딩 가이드

이 워크스페이스를 fork해서 본인 환경으로 셋업하는 가이드입니다.

---

## 전체 흐름

```
1. 워크스페이스 복제
2. 마이그레이션 스크립트 실행 (ID 일괄 교체)
3. MCP 서버 등록
4. nexus-alias 본인 프로젝트 등록
5. Teams 연동 설정 (선택)
6. 검증
```

예상 소요: 30분~1시간

---

## Step 1: 워크스페이스 복제

```bash
git clone {repo-url} ~/Documents/{본인이름}-workspace
cd ~/Documents/{본인이름}-workspace
```

Claude Code가 설치되어 있어야 합니다.

---

## Step 2: 마이그레이션 스크립트 실행

```bash
bash scripts/migrate-pm.sh
```

대화형으로 아래 값을 입력받아 파일 전체에서 일괄 교체합니다:

### 필요한 값 (미리 준비)

#### Notion DB ID (5개 DB + 1개 허브 페이지)

cigro 워크스페이스에서 본인용 DB를 확인하세요.

| DB | 확인 방법 |
|----|----------|
| PM 허브 페이지 | 본인 PM 허브 페이지 URL → 끝 32자리가 ID |
| 프로젝트 문서 | 프로젝트 문서 DB 페이지 URL → 끝 32자리 |
| 커뮤니케이션 | 커뮤니케이션 DB 페이지 URL → 끝 32자리 |
| 태스크 | 태스크 DB 페이지 URL → 끝 32자리 |
| Daily Scrum Log | Daily Scrum Log DB 페이지 URL → 끝 32자리 |
| PM Action Hub | PM Action Hub DB 페이지 URL → 끝 32자리 |

#### data_source_id 확인 방법

DB ID와 data_source_id는 다릅니다. data_source_id는 MCP로 확인:

```
1. Claude Code에서 notion-cigro MCP 등록 후
2. mcp__notion-cigro__notion-fetch 호출 (id = DB ID)
3. 응답에서 <data-source url="collection://XXXX"> 태그의 XXXX가 data_source_id
```

또는 Claude에게 요청:
```
이 DB의 data_source_id를 알려줘: https://www.notion.so/{DB_URL}
```

#### Nexus OS

| 값 | 확인 방법 |
|----|----------|
| Workforce ID | Nexus 관리자에게 확인 또는 `workforces_list` API 호출 |
| API Token | Nexus 관리자에게 발급 요청 |

---

## Step 3: MCP 서버 등록

fork 후에는 MCP 서버 등록이 초기화됩니다. 본인 토큰으로 등록하세요.

### 필수

```bash
# Notion (cigro 워크스페이스)
# 토큰: Notion 설정 > 연결 > Internal Integration에서 발급
claude mcp add notion-cigro --transport http "https://mcp.notion.com/mcp" \
  --header "Authorization: Bearer {NOTION_CIGRO_TOKEN}"

# Nexus OS
claude mcp add nexus-os --transport http "https://nexus-os-iota.vercel.app/api/mcp" \
  --header "Authorization: Bearer {NEXUS_API_TOKEN}"
```

### 선택 (사용하는 서비스만)

```bash
# Notion (개인 워크스페이스 — 필요 시)
claude mcp add notion -- npx -y @notionhq/notion-mcp-server

# Google Workspace (캘린더 — today-brief에 필요)
claude mcp add google-workspace -- npx -y @piotr-agier/google-drive-mcp

# Linear (이슈 트래킹 — issue-ticket에 필요)
# claude.ai 설정에서 Linear MCP 활성화
```

### 연결 확인

```bash
claude mcp list
# 모든 서버가 ✓ Connected 인지 확인
```

---

## Step 4: Nexus Alias 등록

`.claude/nexus-alias.md`에 본인 담당 프로젝트를 등록합니다.

마이그레이션 스크립트에서 빈 템플릿으로 초기화했다면 직접 채워야 합니다.

### 본인 프로젝트 확인 방법

Claude Code에서:
```
nexus-os workforces_list로 내 workforce ID 확인 후,
tasks_list로 내 활성 태스크 목록 조회해줘
```

### 등록 형식

```markdown
# .claude/nexus-alias.md
약칭           | Nexus projectName

DSA           | DSA-DSA-Apr
Koboom        | Koboom-Koboom-2
MyProject     | ClientName-ProjectName-1
```

- 한 줄 = 하나의 매핑
- 약칭은 본인이 평소 부르는 이름
- projectName은 Nexus tasks_list 응답의 `projectName` 필드 값 그대로

---

## Step 5: Teams 연동 (선택)

Teams를 통해 개발팀과 소통하는 경우에만 설정합니다.

### .env.teams 수정

```bash
# Power Automate HTTP trigger URL
TEAMS_FLOW_URL=https://...your-flow-url...

# 프로젝트별 Teams 채팅 thread ID
# Teams 웹 → 채팅방 열기 → URL에서 19:{ID}@thread.v2 부분 복사
TEAMS_CHAT_PROJECTA_DEV=19:xxxx@thread.v2
TEAMS_CHAT_PROJECTB_DEV=19:yyyy@thread.v2
```

### Power Automate Flow 생성

Teams 메시지 전송을 위한 flow가 필요합니다. 기존 flow를 공유받거나 새로 생성하세요.
(상세 설정은 내부 문서 참조)

---

## Step 6: 검증

### 필수 테스트

```bash
# 1. Notion 연동
/today-brief
# → 오늘 브리핑이 정상 출력되면 성공

# 2. PM Action Hub 저장
/todo [TestProject] 온보딩 테스트
# → ✅ 추가 완료 메시지 뜨면 성공
# → Notion PM Action Hub DB에서 확인

# 3. Nexus 일별 기록
/nexus-daily
# → 활성 태스크 목록이 보이면 성공
# → 실제 저장은 프로젝트 alias 등록 후

# 4. Teams (설정한 경우)
/dev-chat --client {name} 테스트 메시지
# → Teams 채팅방에 메시지 도착 확인
```

### 체크리스트

```
□ claude mcp list — 모든 서버 ✓ Connected
□ /today-brief — Notion 연동 확인
□ /todo [Test] 테스트 — DB 저장 확인
□ /nexus-daily — Nexus 연동 확인
□ .claude/nexus-alias.md — 본인 프로젝트 등록
□ /dev-chat 테스트 — Teams 연동 확인 (선택)
```

---

## 교체하지 않는 것 (공용)

아래는 모든 PM이 동일하게 사용하므로 수정 불필요:

- `CLAUDE.md` 규칙 (번역, 품질, 확인 방식 등)
- `clients/` 디렉토리 (클라이언트별 정보)
- `glossary/` 디렉토리 (용어집)
- `templates/` 디렉토리
- `.claude/commands/*.md` 스킬 로직 (ID 외)

---

## 트러블슈팅

### MCP "Failed to parse JSON"
Nexus OS MCP 호출 시 발생할 수 있음. 스킬 내부에서 curl fallback으로 처리되므로 정상 동작합니다.

### "Could not find database" 에러
DB ID가 잘못되었거나, MCP integration에 DB 공유가 안 된 상태. Notion에서 해당 DB의 연결(Connections)에 본인 integration이 추가되어 있는지 확인하세요.

### data_source_id를 모르겠을 때
Claude에게 요청:
```
notion-cigro로 이 DB를 fetch해서 data_source_id를 알려줘: {DB_URL}
```

### Nexus workforce ID를 모르겠을 때
Claude에게 요청:
```
nexus-os workforces_list에서 내 이름으로 검색해줘
```
