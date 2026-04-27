---
description: 프로젝트별 daily scrum 로그 → Notion DB 저장 + 개발팀 dev-chat 메시지 생성
argument-hint: --client <name> [추가 내용]
allowed-tools: Read, Glob, Grep, Bash, mcp__notion-cigro__notion-create-pages, mcp__notion-cigro__notion-fetch
---

# Daily Scrum Log

## Arguments
사용자 입력: $ARGUMENTS

## Context
- 매일 5분 daily scrum / daily check-in 내용을 Notion DB에 기록 + 개발팀에 공유
- PM Action Hub DB에 등록된 해당 프로젝트의 "오늘"/"진행 중" 태스크를 **자동 추출**하여 기본 오늘 할 일로 사용
- PM이 러프하게 입력한 추가 내용(블로커, 메모 등)은 별도로 분류
- 매일 1건씩 누적되어 프로젝트별 히스토리 형성

## Output Destinations
1. **Notion**: Daily Scrum Log DB (data_source_id: `9e03aae9-a894-8377-bbaf-0717f5d7f2ef`) — `mcp__notion-cigro__notion-create-pages`
2. **Teams**: 개발팀 dev 채팅 (`TEAMS_CHAT_{CLIENT}_DEV`) — 영어 status update 메시지
3. **터미널**: 저장/전송 확인

## Data Sources
1. **PM Action Hub DB** (`ff43aae9a89482ea8c57815a65ac9f5b`, data_source_id `a183aae9-a894-8379-8708-87cf507ec8e8`)
   - 상태 = "오늘" OR "진행 중"
   - 프로젝트 = {client의 프로젝트명}
   - **"미착수"/"완료"는 제외**
2. **사용자 추가 입력** — $ARGUMENTS에서 `--client` 제외한 나머지

## Instructions

### Step 1. 인자 파싱
- `--client` 추출 → 클라이언트명 확정
  - 누락 시 `templates/client-default.md` 규칙 적용 (24h 내 activity-log의 client가 1개면 보수적 default 제안, 2+개면 숫자 선택지, 0개면 PM 확인)
- `--client` 이후의 나머지 텍스트 = 추가 입력 (blocker/메모/수동 할 일)

### Step 2. 컨텍스트 로드 (병렬 호출 가능)
다음 항목은 서로 독립이므로 동일 턴에 병렬로 호출:
- `clients/{client-name}/CLAUDE.md` — **프로젝트명 확정** (PM Action Hub 필터에 사용)
- `glossary/{client-name}.md` — 용어 일관성 (dev-chat 번역 시)
- **PM Action Hub 조회** (`mcp__notion-cigro__notion-fetch`, data_source_id `a183aae9-a894-8379-8708-87cf507ec8e8`):
  ```json
  {"and": [
    {"property": "프로젝트", "select": {"equals": "<project-name>"}},
    {"or": [
      {"property": "상태", "select": {"equals": "오늘"}},
      {"property": "상태", "select": {"equals": "진행 중"}}
    ]}
  ]}
  ```
- **같은 날짜 중복 체크** — Daily Scrum Log DB에서 `날짜 == today AND 클라이언트 == {client}` 조회 (`mcp__notion-cigro__notion-fetch`, data_source_id `9e03aae9-a894-8377-bbaf-0717f5d7f2ef`)

### Step 3. 항목 분류
**PM Action Hub에서 가져온 태스크:**
- 각 항목의 제목에서 `[ProjectName]` prefix 제거 → 본문만 "오늘 할 일"에 배치
- 상태 "오늘" → 오늘 완료 목표 / 상태 "진행 중" → 계속 진행
- 상태값을 inline으로 표시: `{제목} ({오늘}/{진행 중})`

**사용자 추가 입력:**
| 분류 | 감지 신호 |
|------|----------|
| **오늘 할 일 (추가)** | "오늘", "할 예정", "진행 중", "작업 중", "완료 예정", 구현/수정/개발 관련 |
| **Blocker** | "blocked", "대기", "막힘", "응답 없음", "확인 필요", "못함" |
| **메모** | 근태, 휴가, 일정, 참고사항, 위 두 분류에 해당하지 않는 것 |

### Step 4. Notion 페이지 구조 생성

**Properties:**
- 제목: `Daily — {YYYY-MM-DD}`
- 클라이언트: {client-name}
- 프로젝트: {project-name}
- 날짜: {today}
- 상태: `Blocker 있음` (blocker 존재 시) / `정상` (그 외)

**Page Content:**
```
## 오늘 할 일
- {PM Action Hub 항목 1} (오늘)
- {PM Action Hub 항목 2} (진행 중)
- {사용자 추가 할 일}

## Blocker
- {blocker 내용} — {원인/대기 대상}

## 메모
- {추가 정보, 공유 사항, 근태 등}
```

- PM Action Hub에서 0건이고 사용자 입력도 비어 있으면 → PM에게 확인 ("오늘 처리할 태스크가 없습니다. 그대로 기록할까요?")
- Blocker 없으면 Blocker 섹션 생략
- 메모 없으면 메모 섹션 생략

### Step 5. Dev-chat 메시지 생성 (영어)

Daily scrum dev-chat은 **요약(narrative summary) + 투두(action list)** 구조. Basecamp heartbeat / Amazon 6-pager 방식을 차용 — dev가 스크롤 없이 맥락을 잡도록 narrative를 앞에 배치.

---

#### Light 모드 (blocker 0-1개 AND todo ≤ 4개 AND team side 추출 없음)

```
[{Project}] — {Mon Day}

{1줄 narrative summary — 오늘의 핵심 한 문장}

PM today
• {todo 1}
• {todo 2}
• {todo 3}
```

#### Standard 모드 (blocker 2+ OR todo 5+ OR team side 추출 있음)

```
📌 [{Project}] — {Mon Day}

{2줄 narrative summary — 현재 상황 + 오늘 focus}

Blockers
• {item} — waiting on {who/what}

PM today
• {todo 1}
• {todo 2}

Team today  ← 선택: scrum 녹취/dev 이름 멘션 있을 때만
• {Dev A}: {오늘 할 일}
• {Dev B}: {오늘 할 일}

Heads-up  ← 선택: 임박 deadline/milestone 있을 때만
• {event} — {date}
```

---

#### Summary 생성 규칙

**포함 조건** (하나라도 해당하면 summary 작성):
- Blocker가 있음
- 외부(client) 응답 대기 중인 todo가 있음
- 오늘 미팅/deadline이 있음
- 마일스톤 전환 (phase 넘어가기, 배포일 등)
- Todo 5개 이상 → 테마 그룹핑으로 1-2줄

**생략 조건:**
- Todo 3개 이하 + 같은 테마 + 특별 맥락 없음 → summary 생략, bullet만 출력

**작성 규칙:**
- 최대 2문장, 각 문장 20단어 이하
- **행동 중심 서술** — "Chasing A, B while unblocking C" / "Client meeting this afternoon, collecting team input on X in parallel"
- PM 주체 서술 ("PM is chasing..." / "We're waiting on...")
- bullet list의 반복이 아닌, **테마/우선순위/이유** 제시
- 감정어/filler 금지 ("We're excited", "It's been a busy day" 등 금지)
- Closing 금지

**예시:**

| Todos | Summary 예시 |
|---|---|
| Phase 4 scope 확인 / Jina 테스트 요청 / Simon follow-up / ticket 34 재확인 / 보드 status 매칭 / quant sign-off 체크 | "Lock is idle until Simon confirms Phase 4 scope — chasing that first. Tickets 2/3/7 still pending Jina's quant sign-off." |
| Toss 키 요청 / Shipping API 독촉 / 주문 취소 디자인 확인 / 환불 옵션 제안 | "Two client-side deps (Toss key, Shipping API) blocking integration — chasing both today, plus refund/cancel UX follow-up." |
| AWS 요청 / Stripe DE 체크 / 리마인드 / QA 일정 재조율 | "Multiple client responses pending (AWS, Stripe DE, last week's answers) — full task review once they land." |

#### Team today 섹션 (선택)

**소스 우선순위:**
1. 사용자 입력에 daily scrum 녹취/메모 파일 첨부 → 파싱하여 dev별 오늘 할 일 추출
2. 없으면 → PM Action Hub todo 제목에서 멘션된 dev 이름 추출 (`Xavier`, `Lock`, `Binh` 등)
3. 둘 다 없으면 → **섹션 생략**

**포맷:** `• {Dev 이름}: {한 줄로}` — 간결하게, status update 톤

#### Heads-up 섹션 (선택)

**포함 조건:**
- 7일 이내 임박한 deadline (배포, 결제, 미팅 등)
- Todo 본문에 날짜가 명시된 경우 (`04-22 잔금 결제`, `04-29~30 스케줄` 등)

**없으면 섹션 자체를 생략** — 빈 섹션 금지

#### 번역/톤 규칙

- glossary에 정의된 용어 사용
- 도메인 특화 한국어 용어는 괄호로 병기: `reputation reviewers (평판조회 조회인)`
- 1인칭 주어 그대로 쓰지 않음 — PM 주체 서술로 전환
- Closing 문구 금지 ("Please review..." / "Let me know..." / "Thanks!" 등 금지)
- 전체가 한 화면 내로 (Light 8줄, Standard 15줄 이하)

#### Teams HTML 포맷

- Summary: 평문 + `<br><br>` (본문과 한 줄 띄움)
- 섹션 헤더: `<b>Section</b>` (볼드)
- Bullet: `<ul><li>...</li></ul>`
- 구분자: `•` 대신 HTML 사용 시 `<li>` 자동 렌더

### Step 6. 확인 프롬프트

Notion 페이지 구조와 dev-chat 메시지를 **둘 다 미리보기**로 터미널 출력 → 확인:

```
📝 Notion Daily Scrum Log (미리보기)
━━━━━━━━━━━━━━━━━━━━━━
제목: Daily — 2026-04-21
클라이언트: DSA / 프로젝트: DSA / 상태: 정상

## 오늘 할 일
- ... (PM Action Hub)
- ... (PM Action Hub)

## 메모
- ...

━━━━━━━━━━━━━━━━━━━━━━
💬 Dev-chat 메시지 (영어, Teams)
━━━━━━━━━━━━━━━━━━━━━━
Daily update on DSA:
- ...
- ...

━━━━━━━━━━━━━━━━━━━━━━

1. Notion 저장 + Teams 전송 (추천)
2. Notion 저장만 (dev-chat 복사해서 수동 전송)
3. 수정
4. 취소
추천: 1
```

- 1 → Step 7 (Notion 저장) + Step 8 (Teams 전송)
- 2 → Step 7만 실행. dev-chat은 복사 안내만 출력 + activity-log에 skill="daily-scrum" 1회 기록
- 3 → 수정 요청 받은 후 Notion/dev-chat 둘 다 재생성 → 다시 이 프롬프트
- 4 → 중단 (저장/전송/로그 모두 skip)

### Step 7. Notion 저장
- `mcp__notion-cigro__notion-create-pages`로 Daily Scrum Log DB에 새 페이지 생성
  - parent: `{"type": "data_source_id", "data_source_id": "9e03aae9-a894-8377-bbaf-0717f5d7f2ef"}`
- **Step 2 중복 체크에서 같은 날짜+클라이언트 기록이 있었으면** → 사용자에게 1회 확인: `오늘 {client} daily scrum이 이미 등록되어 있습니다. 새로 추가할까요? (1. 추가 / 2. 취소)`

### Step 8. Teams 전송 (옵션 1 선택 시)
- `.env.teams` 파일에서 `TEAMS_FLOW_URL`과 `TEAMS_CHAT_{CLIENT}_DEV` 로드
  - 클라이언트 디렉토리명 → 대문자 변환 → `TEAMS_CHAT_{CLIENT}_DEV` 키 조합
- chat_id가 없으면 → 복사 fallback으로 자동 전환 (전송 skip, 메시지 다시 출력 + 복사 안내)
- chat_id가 있으면: 공통 snippet `templates/teams-post.md` 패턴 사용.
  ```bash
  cat > /tmp/teams_msg.json << 'EOF'
  {"chat_id":"<chat_id>","message":"<메시지 HTML>"}
  EOF
  HTTP_CODE=$(curl -sS --connect-timeout 5 --max-time 30 \
    -o /tmp/teams_resp.txt -w "%{http_code}" \
    -X POST -H 'Content-Type: application/json' \
    -d @/tmp/teams_msg.json '<TEAMS_FLOW_URL>')
  CURL_EXIT=$?
  ```
- 성공 판정 (엄격, dev-chat과 동일):
  - `CURL_EXIT==0` AND `200 <= HTTP_CODE < 300` → `SEND_OK=1`, "✅ 전송 완료 (HTTP $HTTP_CODE)"
  - `CURL_EXIT==28` → "⚠️ 전송 시간 초과 (30s) — Flow가 응답을 못 줬지만 메시지는 전달됐을 가능성 높음. Teams에서 직접 확인 후 미수신이면 수동 재전송." + `SEND_OK=0`. **자동 재시도 금지** (중복 전송 방지).
  - 5xx만 1회 재시도. 재시도 후에도 실패면 포기.
  - 그 외 실패 → "⚠️ 전송 실패 (HTTP $HTTP_CODE)" + 응답 본문 500자 출력 + `SEND_OK=0`
- **`SEND_OK=0`일 때 절대 "전송 완료" 출력 금지**. 메시지 본문을 다시 출력하며 "복사해서 수동 전송" 안내.
- 4xx 에러는 재시도하지 않음.
- **timeout(CURL_EXIT=28)은 재시도하지 않음** — Power Automate Flow는 timeout이 나도 메시지를 이미 전달했을 가능성이 높아 재시도 시 중복 위험.
- 주의: JSON 내 특수문자 이스케이프 필수. bash `!` 문제 방지를 위해 반드시 파일 경유.
- **메시지 HTML 포맷 규칙**:
  - 줄바꿈: `\n` 대신 `<br>`
  - 글머리기호: `<ul><li>...</li></ul>`
  - 굵게: `<b>...</b>`

### Step 9. 활동 로그
```bash
# 옵션 1 성공 시
if [ "$SEND_OK" -eq 1 ]; then
  echo '{"date":"'$(date +%Y-%m-%d)'","skill":"daily-scrum","client":"{클라이언트명}","sent":true}' >> .claude/activity-log.jsonl
fi
# 옵션 2 (저장만) 시 — Notion 저장 성공 후 기록
echo '{"date":"'$(date +%Y-%m-%d)'","skill":"daily-scrum","client":"{클라이언트명}","sent":false}' >> .claude/activity-log.jsonl
```
- 옵션 3(수정)/4(취소) 시 미기록.

### Step 10. 터미널 최종 출력
```
✅ Daily Scrum 저장 완료

📅 {date} | {client} — {project}
상태: {정상 / Blocker 있음}

오늘 할 일:
- {item 1}
- {item 2}

Blocker:
- {blocker}

💬 Dev-chat: {✅ Teams 전송 완료 (HTTP 200) / ⚠️ 복사해서 수동 전송 / skip}
```

## Rules

### 필수
- PM Action Hub에서 가져온 항목은 **그대로 사용** — 제목 왜곡하지 않음 (대괄호 prefix만 제거)
- 사용자가 `--client`로 지정한 클라이언트의 태스크만 가져옴 (다른 프로젝트 섞지 않음)
- 오늘 할 일이 하나도 없으면 (PM Action Hub 0건 + 사용자 입력 없음) → 자동 생성 금지, PM에게 확인
- 같은 날짜+클라이언트 중복 기록 시 사용자 확인 (자동 덮어쓰기 금지)
- 한국어 입력 → Notion은 한국어로 저장, dev-chat은 영어로 번역
- dev-chat은 **status update 톤** — 구현 브리프가 아니라 "PM이 오늘 뭐 하고 있는지 공유"
- Closing 문구 금지 ("Please..." / "Let me know..." 사용 금지)
- `SEND_OK=0`일 때 "전송 완료" 출력 절대 금지

### 분류
- PM Action Hub 태스크 → "오늘 할 일" 기본 소스
- 사용자 추가 입력 → blocker/메모/추가 할 일로 분류 (상위 분류표 참고)
- Standard 승격 조건: blocker 2+ OR todo 5+ OR scrum 녹취로 team today 추출 가능

### Dev-chat 생성 규칙
- **구조: narrative summary (앞) + action bullets (뒤)** — bullet만 나열 금지
- Summary는 포함 조건 충족 시에만 작성 (blocker/외부 대기/미팅/마일스톤/todo 5+)
- Team today / Heads-up 섹션은 소스 있을 때만 — 빈 섹션 금지
- glossary 기준 용어 사용
- PM 주체 서술 (1인칭 → "PM has..." / "On our side..." 등)
- Closing 금지 ("Please..." / "Let me know..." / "Thanks!")
- 전체가 한 화면 내로 (Light 8줄, Standard 15줄 이하)
