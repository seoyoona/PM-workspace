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

**출력:** 타이틀 + 자연스러운 문장형 본문 + 간단한 closing. **섹션 헤더 없음.**
```
📌 [{project}] {short title}

{자연스러운 문장 2-5줄 — 핵심 내용 전달}

{간단한 closing: "Let me know if anything is needed." 또는 유사}
```

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

Please review and let me know if anything needs more effort than expected.
```

## Meeting-note Input Detection
입력에 meeting-note 구조 (미팅 정보/핵심 요약/이번 라운드 반영사항 등)가 포함되면 아래 추출 규칙 적용:

| meeting-note 섹션 | → dev-chat 섹션 | 추출 규칙 |
|---|---|---|
| 핵심 요약 | Critical context | 블로커/고장 관련만 1-2줄 발췌. 방향성/유지보수 구분 등 PM 판단은 제외. |
| 이번 라운드 (🔴) | Critical context | 상황+이유를 Critical context로. 구현 액션은 This round에. |
| 이번 라운드 (일반) | This round | dev 구현 항목만. `PM:` `Client:` prefix 항목 제외. |
| 후순위/유지보수 | Maintenance later | dev 항목만. |
| 고객/PM 확인 필요 | (제외) | dev 대상 아님. 단 dev가 답할 질문이 있으면 Open question으로. |

**제외 대상:** PM 내부 액션, Client 액션, 핵심 요약의 전략/방향성 판단, 고객 불만 관련

## Instructions

1. **인자 파싱**: 클라이언트명과 요청 내용 추출
2. **컨텍스트 로드**:
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
   - **마지막 줄**: "Please review and let me know if anything needs more effort than expected."
5. **톤**: 개발팀 구현 브리프 — clear, direct, practical. 요구사항을 직접 서술. "This likely means X needs to change" 대신 "Change X to Y" 또는 "X should be Y". 개발자가 바로 작업 목록으로 쓸 수 있는 수준.
6. **영어로 작성**
7. **출력**: 터미널에 메시지 출력
8. **Teams 전송 (선택)**:
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

### 필수
- 용어는 glossary 기준 사용
- "확정 결정"과 "액션 아이템"을 분리하지 않음 — 통합된 "This round" 블록
- 우선순위 높은 항목을 위에 배치
- 마지막 줄은 항상 리뷰 요청으로 마무리
- 미팅 노트처럼 느껴지면 안 됨 — 구현 브리프처럼 느껴져야 함
- 각 항목은 직접적이고 실행 가능하게 서술

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
