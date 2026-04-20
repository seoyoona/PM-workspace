---
description: 고객 요청 → 개발팀 Teams 채팅 메시지 생성
argument-hint: --client <name> [요청 내용]
allowed-tools: Read, Glob, Grep, Bash
---

# Dev Chat Message

## Arguments
사용자 입력: $ARGUMENTS

## Context
- 고객 요청/변경사항/미팅 결과를 개발팀 Teams 그룹챗에 복붙할 영어 메시지로 변환
- PM이 해석하고 판단한 결과를 개발팀 구현 브리프로 전달
- 노션 저장 없음 — 터미널에 바로 출력

## Message Weight Detection
입력을 분석하여 **Light / Standard** 무게를 자동 판단:

### Light — 단순 전달, 공유, FYI, 상태 업데이트
**감지 신호:**
- 짧은 입력 (항목 1-3개)
- PM 판단/결정 없음
- 블로커/긴급 없음
- "보내드립니다", "전달합니다", "공유합니다", "알려드립니다" 류
- FYI 성격 (자료 전달, 일정 공유, 단순 확인)

**입력 타입 감지 → 프레이밍 결정:**

1. **클라 메시지 원문 복붙** (기본 케이스): 한국어 존댓말체 그대로, "~입니다/~해요/~부탁드립니다/~문의입니다" 등 → **PM 중계 프레이밍 적용**
   ```
   Client confirmed X... / Client reports X... / Client shared a user inquiry — ...
   They're asking if... / They want to...
   ```
   - 주어를 "Client"로 명확히 해서 dev팀이 PM을 행위 주체로 오해하지 않도록
   - "I"/"we" 같은 1인칭 주어를 그대로 옮기지 않음 → "Client confirmed..." / "Client tested..."로 전환
   - PM이 직접 확인한 내용(DB 조회, 라이브 테스트 등)은 "Client checked..." / "On client's side..." 또는 필요 시 "On our side..."로 구분

2. **PM 내부 메모/이미 영어로 정리된 내용**: 프레이밍 없이 번역/정리만
   - 예: "dev팀에 xxx 배포해달라고 해줘", "테스트 끝났으니 라이브 올려달라고 전달" 같은 내부 지시
   - 감지: 한국어 반말/명령체, PM이 직접 쓴 메모 톤

**출력:**
```
{PM 중계 프레이밍 또는 직접 번역 — 입력 타입에 따라 선택}
```
- 타이틀/closing 없음
- 메시지 출력 후 수정할 부분 있는지 확인 → 수정 반영 후 Teams 전송

### Standard — 구현 요구, 미팅 follow-up, 복잡한 맥락
**감지 신호:**
- 항목 4개 이상 또는 복잡한 맥락
- PM 해석/판단 포함
- 블로커/긴급 있음
- 미팅 결과, Q&A, 변경 요청, 기술적 결정

**출력:** 기존 구조화된 포맷
```
📌 [{project}] {short title}

Critical context:
- {긴급 블로커, 고객 측 배경 등 — 필요 없으면 생략}

This round:
- {모든 구현 요구사항 — 통합 블록}

Maintenance later:
- {유지보수/후순위로 미룬 항목 — 없으면 생략}

Open question:
- {구체적이고 필요한 질문 — 기본은 생략}
```

**출력 원칙:**
- Standard ≠ 길다. 각 bullet은 1줄로.
- Critical context는 2줄 이내.
- 전체 메시지가 화면 한 페이지를 넘지 않도록.
- Closing 문구 금지 — "Please review..." / "Let me know..." 류 사용하지 않음. 마지막 섹션에서 끝냄.

## Meeting-note Input Detection
입력에 `## Action Items` 섹션(meeting-note 구조)이 있으면 아래 쿼리 기반 매핑 적용:

| 쿼리 | → dev-chat 섹션 | 추출 규칙 |
|---|---|---|
| 바로 진행할 일 WHERE owner IN (Dev, Dev+*) + 긴급 | Critical context | "상황 + 왜 긴급한지" 2~3줄 bullet. |
| 바로 진행할 일 WHERE owner IN (Dev, Dev+*) + 비긴급 + 이번 미팅에서 확정된 것(dev 대상) | This round | 3~5 bullet. due 있으면 inline `— by Apr 23`. |
| 메모해둘 이슈 WHERE dev 대상 | Open question (기본 생략) | "아직 결정 아님"을 알아야 할 경우만 1~2줄. |
| 이번 라운드 범위 밖 WHERE owner=Dev | Maintenance later | 해당 시만. |
| 확인 후 회신할 일 WHERE owner=Client OR owner=PM | (제외) | dev 대상 아님. |
| PM 참고 배경 | (제외) | — |

**톤 규칙 (중요):**
- 각 항목을 자연스러운 영어 bullet 서술로 풀어쓴다.
- Critical context는 2~3줄 이내, This round는 3~5 bullet 각 1줄.
- "Change X to Y" 직접 서술. "This likely means..." 추측 금지.

**공통 제외 대상:** PM 내부 액션, Client 액션, 전략/방향성 판단, 고객 불만 관련

## Instructions

1. **인자 파싱**: 클라이언트명과 요청 내용 추출
   - `--client` 누락 시 `templates/client-default.md` 규칙 적용 (24h 내 activity-log의 client가 1개면 보수적 default 제안, 2+개면 숫자 선택지, 0개면 PM 확인)
2. **컨텍스트 로드** (아래 항목은 병렬 호출 가능 — 서로 독립):
   - `clients/{client-name}/CLAUDE.md` — 프로젝트 도메인, 기술 스택 이해
   - `glossary/{client-name}.md` — 용어 일관성
3. **PM 판단**:
   - 고객 답변/미팅 결과를 읽고, 개발팀이 구현해야 할 것을 정리
   - 프로젝트 맥락(CLAUDE.md)을 참고하여 구현 영향을 판단
   - "확정된 결정"과 "액션 아이템"을 분리하지 않음 — 개발팀 입장에서는 둘 다 구현 요구사항
   - 우선순위 높은 것을 위에 배치
4. **섹션 구성**:
   - **Critical context**: 긴급 블로커, 고장난 것, 고객 측 배경 등 작업 전 필수 인지 사항. 필요 없으면 생략.
   - **This round**: 현재 라운드의 모든 구현 요구사항을 하나의 블록으로. 항상 포함.
   - **Maintenance later**: 명시적으로 유지보수/후순위로 미룬 항목. 없으면 생략.
   - **Open question**: 조건부. 아래 규칙 참고.
5. **톤**: 개발팀 구현 브리프 — clear, direct, practical. 요구사항을 직접 서술. "This likely means X needs to change" 대신 "Change X to Y" 또는 "X should be Y". 개발자가 바로 작업 목록으로 쓸 수 있는 수준.
6. **영어로 작성** — 단, 도메인 특화 한국어 용어는 괄호로 병기
   - 한국어 UI/코드베이스에서 검색해야 하는 용어: "reputation reviewers (평판조회 조회인)"
   - glossary에 있는 용어는 glossary의 영어 표기 + 괄호 한국어
   - 일반적인 단어 (예: "user", "admin")는 병기 불필요
7. **출력**: 터미널에 메시지 출력
8. **출력 직후 확인 프롬프트** — 모드에 따라 분기 (Confirmation Format 준수: 3~4지선다, 추천 표시, 단일 확인 포인트):

   **Light 모드** — 수정 가능성 낮음, 즉시 전송 흐름 통합 (4지선다):
   ```
   ---
   1. 전송 (추천)
   2. 수정
   3. 복사만
   4. 취소
   추천: 1
   ```
   - 1 → 곧바로 Step 9 전송. chat_id 없으면 3(복사만)으로 자동 fallback.
   - 2 → 수정 요청 받은 후 반영 → 메시지 재출력 → 다시 이 프롬프트
   - 3 → 전송 skip, 복사 안내만 표시 (사용자 확정 후 activity-log 1회 기록)
   - 4 → 중단 (activity-log 미기록)

   **Standard 모드** — 구조 복잡, 수정 확률 높음 (3지선다):
   ```
   ---
   1. 전송 (추천)
   2. 수정
   3. 취소
   추천: 1
   ```
   - 1 → 곧바로 Step 9 전송. chat_id 없으면 복사 fallback.
   - 2 → 수정 요청 받은 후 반영 → 메시지 재출력 → 다시 이 프롬프트
   - 3 → 중단 (activity-log 미기록)
9. **Teams 전송**:
   - `.env.teams` 파일에서 `TEAMS_FLOW_URL`과 `TEAMS_CHAT_{CLIENT}_DEV` 로드
   - 클라이언트 디렉토리명 → 대문자 변환 → `TEAMS_CHAT_{CLIENT}_DEV` 키 조합
   - chat_id가 없으면 → 복사 fallback (전송 옵션 표시하지 않음)
   - chat_id가 있으면: 공통 snippet `templates/teams-post.md` 패턴 사용.
     ```bash
     cat > /tmp/teams_msg.json << 'EOF'
     {"chat_id":"<chat_id>","message":"<메시지 HTML>"}
     EOF
     HTTP_CODE=$(curl -sS --connect-timeout 5 --max-time 15 \
       -o /tmp/teams_resp.txt -w "%{http_code}" \
       -X POST -H 'Content-Type: application/json' \
       -d @/tmp/teams_msg.json '<TEAMS_FLOW_URL>')
     CURL_EXIT=$?
     ```
   - 성공 판정 (엄격):
     - `CURL_EXIT==0` AND `200 <= HTTP_CODE < 300` → `SEND_OK=1`, "✅ 전송 완료 (HTTP $HTTP_CODE)"
     - `CURL_EXIT==28` → "⚠️ 전송 시간 초과 (15s)" + `SEND_OK=0`
     - 5xx 또는 timeout → 1회만 재시도 (동일 명령). 재시도 후에도 실패면 포기
     - 그 외 실패 → "⚠️ 전송 실패 (HTTP $HTTP_CODE)" + 응답 본문 500자 출력 + `SEND_OK=0`
   - **`SEND_OK=0`일 때 절대 "전송 완료" 출력 금지**. 메시지 본문을 다시 출력하며 "복사해서 수동 전송" 안내.
   - 4xx 에러는 재시도하지 않음 (Flow 설정/chat_id 오류 가능성 → 사용자 확인 필요).
   - 주의: JSON 내 특수문자 이스케이프 필수. bash `!` 문제 방지를 위해 반드시 파일 경유.
   - **메시지 HTML 포맷 규칙**: Teams에서 렌더링되려면 반드시 HTML 사용
     - 줄바꿈: `\n` 대신 `<br>`
     - 글머리기호: `<ul><li>...</li></ul>`
     - 하이퍼링크: `<a href="URL">텍스트</a>`
     - 굵게: `<b>...</b>`
10. **활동 로그**: **반드시 `SEND_OK=1`일 때만** 기록 (취소/에러/timeout 시 미기록 — nexus-daily 오인 방지)
    ```bash
    if [ "$SEND_OK" -eq 1 ]; then
      echo '{"date":"'$(date +%Y-%m-%d)'","skill":"dev-chat","client":"{클라이언트명}"}' >> .claude/activity-log.jsonl
    fi
    ```
    - 복사 fallback(chat_id 없음) 선택 시에도 활동으로 1회 기록 (사용자가 "복사만" 확정한 경우만).

## Rules

### 필수
- 용어는 glossary 기준 사용
- "확정 결정"과 "액션 아이템"을 분리하지 않음 — 통합된 "This round" 블록
- 우선순위 높은 항목을 위에 배치
- 별도 closing 없이 마지막 섹션에서 끝냄. "Please review..." / "Let me know..." 류 리뷰 요청 문구 사용 금지.
- 미팅 노트처럼 느껴지면 안 됨 — 구현 브리프처럼 느껴져야 함
- 각 항목은 직접적이고 실행 가능하게 서술
- 클라이언트 메시지 길이 ≠ 출력 길이. 클라이언트가 길게 쓴 경우 핵심만 추출:
  - 무엇이 문제인지 (1줄)
  - 무엇을 해야 하는지 (구현 항목)
  - 불필요한 배경/감정/반복 설명은 제거
- 클라이언트가 말하지 않은 요구사항을 추가하지 않음. 원문에 없는 bullet은 넣지 않는다. 개발 편의를 위한 제안이 있으면 별도로 "(PM note: ...)" prefix로 분리.

### "Critical context:" 포함 조건
- 포함: 긴급 블로커, 수정했다고 했는데 여전히 안 되는 것, 레거시 맥락, MVP 범위 변경, 고객 측 기술적 배경
- 생략: 단순 요청, 추가 설명 없이도 개발팀이 이해 가능할 때

### "Maintenance later:" 포함 조건
- 포함: 명시적으로 유지보수/후순위로 미룬 항목이 있을 때
- 생략: 해당 항목이 없을 때

### "Open question:" 포함 조건
- 포함: 구체적이고, 필요하고, 개발팀만 답할 수 있는 질문이 있을 때만
- 생략: 기본값. 애매한 질문, 개발팀이 알아서 물어볼 질문은 넣지 않음

### PM 판단이 불가능할 때
- 고객 답변이 모호하거나 PM이 해석할 근거가 부족하면, 메시지를 생성하지 말고 사용자에게 확인 요청
