---
description: 내부 sync 미팅 → 개발팀 Teams 메시지 생성
argument-hint: --client <name> [싱크 미팅 내용]
allowed-tools: Read, Glob, Grep, Bash
---

# Sync Note Message

## Arguments
사용자 입력: $ARGUMENTS

## Context
- 목적 있는 내부 sync 미팅 결과를 개발팀 Teams에 복붙할 영어 메시지로 변환
- 예: 수정사항 상세 설명, scope 변경, 진행상황 체크, 일정 재조정
- /dev-chat과 동일한 톤/포맷이나, "sync follow-up"이라는 맥락이 명시됨
- 노션 저장 없음 — 터미널에 바로 출력
- 내부 전용 — client-chat 파생 없음

## Message Weight Detection

/dev-chat과 동일한 Light / Standard 감지 적용:

### Light — 단순 sync, 짧은 확인
**감지 신호:**
- 짧은 내용 (1-3 항목)
- scope/schedule 변경 없음
- blocker 없음

**출력:**
```
📌 [{project}] Sync follow-up

{자연스러운 문장 2-5줄}

Let me know if anything needs clarification.
```

### Standard — 복잡한 sync, scope/schedule 변경 포함
**감지 신호:**
- 항목 4개 이상 또는 복잡한 맥락
- scope 변경, 일정 변경, blocker
- 여러 담당자에게 영향

**출력:**
```
📌 [{project}] Sync follow-up

Context:
- {왜 이 sync를 했는지 1-2줄}

This round:
- {이번에 반영할 내용}
- {우선순위 높은 항목 먼저}
- {scope/schedule 영향 있으면 포함}

Open points:
- {dev가 추가 확인 필요한 것만}

Let me know if anything needs clarification.
```

## Instructions

1. **인자 파싱**: 클라이언트명과 sync 내용 추출
2. **컨텍스트 로드**:
   - `clients/{client-name}/CLAUDE.md` — 프로젝트명, 도메인
   - `glossary/{client-name}.md` — 용어 일관성
3. **무게 감지**: Light / Standard 자동 판단
4. **메시지 작성**: 영어, Teams 복붙용
5. **출력**: 터미널에 메시지 출력
6. **Teams 전송 (선택)**:
   - `.env.teams` 파일에서 `TEAMS_FLOW_URL`과 `TEAMS_CHAT_{CLIENT}_DEV` 로드
   - 클라이언트 디렉토리명 → 대문자 변환 → `TEAMS_CHAT_{CLIENT}_DEV` 키 조합
   - chat_id가 없으면 → 복사 fallback (전송 옵션 표시하지 않음)
   - chat_id가 있으면 사용자에게 확인:
     ```
     [Teams 전송]
     1. 전송
     2. 복사만
     3. 취소
     추천: 1
     ```
   - 1 선택 시: 메시지를 JSON 파일로 저장 후 curl POST
     ```bash
     cat > /tmp/teams_msg.json << 'EOF'
     {"chat_id":"<chat_id>","message":"<메시지 내용>"}
     EOF
     curl -s -o /tmp/teams_resp.txt -w "%{http_code}" \
       -X POST -H 'Content-Type: application/json' \
       -d @/tmp/teams_msg.json '<TEAMS_FLOW_URL>'
     ```
   - 202면 "전송 완료", 그 외면 에러 출력 + 메시지 복사 안내
   - 주의: JSON 내 특수문자 이스케이프 필수. bash `!` 문제 방지를 위해 반드시 파일 경유

## Rules

- **scope 변경**: 반드시 명시. "moved to Phase 2", "added to scope", "descoped" 등 명확하게
- **schedule 변경**: 날짜가 있으면 구체적으로. "QA starts Friday" not "QA starts soon"
- **Context 섹션**: Standard에서만. sync의 배경/목적을 1-2줄로. 없으면 생략
- **Open points 섹션**: dev에게 확인/판단이 필요한 것만. 없으면 생략
- **This round**: 가장 중요한 섹션. 우선순위순 정렬. 🔴 긴급 항목은 맨 위
- **톤**: /dev-chat과 동일 — casual, short, Slack DM feel
- **PM/client action item 제외**: dev 구현 항목만 포함
- **용어**: glossary 기준
- **한국어 입력 → 영어 출력**: 기술 용어는 원어 보존, 비즈니스 맥락은 번역
