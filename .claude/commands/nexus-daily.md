---
description: Nexus OS 일별 기록 — 기존 태스크 row에 근무시간/메모 자동 입력 (8h = 100%)
argument-hint: (인자 없이 실행 = 자동 / --manual DSA 4 메모, RCK 4 메모)
allowed-tools: Read, Glob, Grep, Bash, mcp__notion-cigro__notion-fetch, mcp__notion-cigro__notion-search
---

# Nexus Daily Entry

## Arguments
사용자 입력: $ARGUMENTS

## Context
- Nexus OS "내 태스크 > 일별 기록" 화면의 **기존 태스크 row**에 hours/memo를 채우는 스킬
- 새 태스크를 생성하지 않음 — 이미 존재하는 row의 hours/memo 칸을 채우고 row별 저장
- 목표: 하루 총합 8시간 = 100%
- **자동 모드(메인)**: Notion에서 오늘 활동을 자동 수집 → 프로젝트/시간/메모 생성 → 확인만
- **수동 모드(fallback)**: `--manual` 옵션으로 직접 입력
- Nexus MCP 도구 직접 호출 불가 → Bash + curl

## Constants
- WORKFORCE_ID: `q57f6mhcy8zg5fgzqq30t36azd83cvsr`
- API_URL: `https://nexus-os-iota.vercel.app/api/mcp`
- AUTH_TOKEN: `nxs_3d3173c4a8a2b14510a9ae73c6260adc`
- ALIAS_FILE: `.claude/nexus-alias.md` (워크스페이스 루트 기준)

## Mode Detection
- `$ARGUMENTS`가 비어있음 → **자동 모드** (Step A)
- `$ARGUMENTS`가 `--manual`로 시작 → **수동 모드** (Step M)
- 그 외 → **수동 모드** (Step M) — 프로젝트명을 직접 입력한 것으로 간주

---

# 자동 모드 (Step A) — 메인 흐름

인자 없이 `/nexus-daily`만 실행했을 때.

## Step A1: 날짜 계산
Bash로 오늘(KST) 0시의 unix milliseconds timestamp 계산:
```bash
python3 -c "from datetime import datetime, timezone, timedelta; kst=timezone(timedelta(hours=9)); print(int(datetime.now(kst).replace(hour=0,minute=0,second=0,microsecond=0).timestamp()*1000))"
```

## Step A2: Notion에서 오늘 활동 수집

**메인 소스 2개** (시간 분배 가중치에 사용):

### 소스 1: PM Action Hub
`mcp__notion-cigro__notion-search`로 검색:
- `data_source_url`: `collection://a183aae9-a894-8379-8708-87cf507ec8e8`
- `query`: "오늘 진행"
- `page_size`: 25

결과에서 각 page의 title을 파싱하여 `[프로젝트명]` 패턴 추출.
title에 `[프로젝트명]`이 없으면 → `mcp__notion-cigro__notion-fetch`로 page 조회하여 `프로젝트` property 읽기.

### 소스 2: 커뮤니케이션 DB
`mcp__notion-cigro__notion-search`로 검색:
- `data_source_url`: `collection://47d3aae9-a894-83bf-8db8-071dd9a16fcd`
- `query`: "미팅 스펙 업데이트 리포트 이슈 질의"
- `filters`: `{"created_date_range": {"start_date": "YYYY-MM-DD"}}` (오늘 날짜)
- `page_size`: 25

결과에서 각 page를 `mcp__notion-cigro__notion-fetch`로 조회하여 `프로젝트` property 읽기.

### 보조 소스 A: Activity Log (로컬)
Notion에 기록이 안 남는 스킬(dev-chat, client-chat, sync-note) 사용 시 자동 기록된 lightweight signal.
공수 누락 보완용이며, audit log가 아님.

Bash로 오늘 날짜 항목 추출 후 python으로 client 파싱:
```bash
grep "$(date +%Y-%m-%d)" .claude/activity-log.jsonl 2>/dev/null | \
  python3 -c "import sys,json; [print(json.loads(l)['client']) for l in sys.stdin]"
```
파일 없거나 오늘 항목 없으면 0건 — 에러 없이 진행.

### 보조 소스 B: Teams (기본 OFF)
- 시간 분배 가중치에 포함하지 않음
- 메인 소스에서 프로젝트가 감지된 후, 해당 프로젝트 키워드로만 보조 검색
- 메모 보강 용도로만 사용 (활동 요약에 Teams 내용 추가)

### 수집 결과 집계
```
프로젝트별:
  DSA: 4건 (Action Hub 1 + 커뮤니케이션 2 + Activity Log 1)
  RCK: 2건 (Action Hub 1 + Activity Log 1)
  Koboom: 1건 (Action Hub 1)
```

## Step A3: 수집 결과가 적을 때 보정 유도

수집 후 감지된 프로젝트 수에 따라 분기:

### 0건 감지 시
```
📋 오늘 Notion 활동 기록 없음

활성 태스크 row:
  1. DSA-4월 구독
  2. Koboom - PM
  3. Connectory - PM
  ...

번호로 선택 (쉼표로 여러 개) / --manual로 직접 입력 / c=취소
추천: 활성 태스크에서 오늘 작업한 항목 번호로 선택
```
사용자가 번호를 선택하면 해당 프로젝트들로 진행. 시간은 균등 분배, 메모는 "프로젝트 관리".

### 1건 감지 시
```
📋 자동 수집 — 1개 프로젝트만 감지

  DSA (3건)

다른 프로젝트 추가?
활성 태스크 row:
  1. Koboom - PM
  2. Connectory - PM
  3. Muchang - PM
  ...

추가할 번호 (쉼표로 여러 개 / 엔터=DSA만 진행)
추천: 엔터 (DSA만 진행)
```
추가된 프로젝트는 활동 1건으로 취급 (수동 추가이므로).

### 2건 이상 감지 시
바로 Step A4로 진행 (충분한 데이터).

## Step A4: Nexus 태스크 row 조회
Bash + curl로 tasks_list 호출 (timeout 필수):
```bash
curl -sS --connect-timeout 5 --max-time 30 \
  "https://nexus-os-iota.vercel.app/api/mcp" \
  -H "Authorization: Bearer nxs_3d3173c4a8a2b14510a9ae73c6260adc" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","method":"tools/call","params":{"name":"tasks_list","arguments":{"workforceId":"q57f6mhcy8zg5fgzqq30t36azd83cvsr","overlapsDate":TODAY_TIMESTAMP}},"id":1}' \
  > /tmp/nexus_tasks.json
NEXUS_EXIT=$?
```
`NEXUS_EXIT != 0`이면 에러 표시 후 중단 (timeout=28, 네트워크 오류=6/7). 응답은 `/tmp/nexus_tasks.json`을 python3로 파싱.

## Step A5: 계층형 매칭

각 감지된 프로젝트명에 대해 아래 순서로 매칭 시도.

### 1순위: Alias Registry
`.claude/nexus-alias.md`를 Read 도구로 읽고 파싱.
약칭 → projectName 조회 → 활성 태스크 row 중 해당 projectName 필터.
- 1개 매칭 → **자동 확정**
- 복수 row → 상태 우선순위 (IN_PROGRESS > TODO > SCHEDULED > COMPLETED) 적용
  - 1개로 좁혀지면 자동 확정
  - 여전히 복수면 사용자 선택 요청

### 2순위: projectName 정확 일치
입력값 == row.projectName (case-insensitive)
- 1개 → **자동 확정**

### 3순위: 정규화 일치
공백/하이픈/대소문자 제거 후 비교. 한글↔영문 변환 (glossary 참조 가능).
- 1개 → **자동 확정**

### 4순위: substring 매칭
입력값이 row.projectName 또는 row.name에 포함.
- **1개여도 자동 확정하지 않음** → 사용자 확인 요청:
```
⚠️ "Muchang" — alias 미등록, substring 매칭:
  → Muchang-Muchang-1: Muchang - PM (Yuna Seo) [IN_PROGRESS]

이 row가 맞나요? (y/n)
```
y 선택 시 → "alias에 등록할까요? (y/n)" 제안 → y면 `.claude/nexus-alias.md`에 추가.

- 복수 매칭 → 번호 선택 요청:
```
⚠️ "DSA" — 복수 후보:
  1. DSA-DSA-Apr: DSA-4월 구독         TODO
  2. DSA-DSA-mar: DSA-3월 구독          COMPLETED

번호 선택:
```

### 5순위: 매칭 실패
```
❌ "XYZ" — 매칭 실패

활성 태스크 row:
  1. DSA-4월 구독
  2. Koboom - PM
  ...

번호로 선택 / s=건너뛰기:
```

## Step A6: 8시간 분배

매칭 완료된 프로젝트에 대해 활동량 비례 분배:
```
가중치 = 프로젝트별 활동 건수
         메인: PM Action Hub + 커뮤니케이션 DB
         보조: Activity Log (Notion 미기록 스킬 보정용, v1에서는 동일 1건 취급 — 초기 운영 정책, 향후 가중치 조정 가능)
         제외: Teams
         수동 추가 프로젝트 = 1건 취급
시간 = round_to_half(8 * 가중치 / 총가중치)
최소 = 0.5h
0.5h 단위 반올림
마지막 항목 = 8 - 나머지 합
```

## Step A7: 메모 자동 생성
프로젝트별 수집된 활동 제목에서 핵심 추출:
- 각 활동의 title에서 `[프로젝트명]` 제거 후 핵심 키워드 추출
- 슬래시(/)로 연결, 최대 50자
- 활동 없는 프로젝트 (수동 추가): "프로젝트 관리"

## Step A8: 기존 기록 확인
매칭된 각 row에 대해 task_daily_entry_get (curl)으로 기존 기록 확인.
기존 기록이 있으면 미리보기에 "(덮어씀)" 표시.

## Step A9: 미리보기

```
📋 일별 기록 — YYYY-MM-DD (자동 수집)

#  입력        매칭 row                   매칭방식    시간   활동   메모
── ────────── ───────────────────────── ──────── ───── ───── ──────────────────
1  DSA        DSA-4월 구독               alias    4.0h   3건   개발 내역 파악 / 디자인 확인
2  RCK        CareerPlan-RCK-2 - PM     alias    2.5h   2건   잔금처리 / QA 티켓 싱크
3  Koboom     Koboom - PM               alias    1.5h   1건   admin 피드백 전달
── ────────── ───────────────────────── ──────── ───── ───── ──────────────────
   합계                                          8.0h   ✅

수정? (번호 / 엔터=저장 / n=취소)
```

기존 기록이 있는 row: "(덮어씀)" 표시 추가.
총합이 8h가 아니면: ⚠️ {총합}h (목표 8.0h) 표시.

### 번호 수정 (P3)
번호 입력 시 해당 row의 시간과 메모를 수정:
```
1 입력 →
  DSA 현재: 4.0h / 개발 내역 파악 / 디자인 확인
  새 시간 (엔터=유지): 3h
  새 메모 (엔터=유지): 핸드오버 싱크
  → 나머지 자동 재분배 (잔여 5.0h를 RCK, Koboom에)
```
수정 후 미리보기 다시 출력.

## Step A10: row별 저장
확인 후 매칭된 각 row에 대해 task_daily_entry_upsert (curl, timeout 필수):
```bash
curl -sS --connect-timeout 5 --max-time 30 \
  "https://nexus-os-iota.vercel.app/api/mcp" \
  -H "Authorization: Bearer nxs_3d3173c4a8a2b14510a9ae73c6260adc" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","method":"tools/call","params":{"name":"task_daily_entry_upsert","arguments":{"taskId":"TASK_ID","date":TODAY_TIMESTAMP,"hours":HOURS,"memo":"MEMO"}},"id":N}' \
  > /tmp/nexus_upsert_$N.json
```
각 row별 독립 저장. 응답 파일을 python3로 파싱하여 성공 여부 확인. exit code ≠ 0이면 해당 row 실패로 표시하고 다음 row로 진행.

## Step A11: 저장 검증
각 row별 task_daily_entry_get으로 저장 확인.
총합 체크.

## Step A12: 완료 출력
```
✅ 일별 기록 저장 완료 — YYYY-MM-DD (N건, X.Xh)
```

---

# 수동 모드 (Step M) — fallback

`--manual` 옵션 또는 프로젝트명을 직접 입력했을 때.

## Step M1: 인자 파싱
`--manual`을 제거한 나머지를 쉼표 또는 슬래시(/)로 분리.
각 항목: 첫 토큰 = 프로젝트명, `Nh` 패턴 = 시간, 나머지 = 메모.

## Step M2: 날짜 계산 + 태스크 row 조회
Step A1, A4와 동일.

## Step M3: 계층형 매칭
Step A5와 동일한 매칭 로직 적용.

## Step M4: 시간 분배
시간 미지정 시 균등 분배 (8 / n, 0.5h 단위).
일부만 지정 시 나머지에 잔여 균등 분배.

## Step M5: 메모
미지정 시 "프로젝트 관리".

## Step M6~M9: 기존 기록 확인 → 미리보기 → 저장 → 검증
Step A8~A12와 동일.

---

# Nexus API curl 패턴

모든 Nexus API 호출은 아래 패턴 사용. 응답은 반드시 파일에 저장 후 python3로 파싱 (bash 변수 대입 시 제어문자 깨짐 방지). **timeout 필수** — Nexus 서버 지연 시 무한 대기 방지.

```bash
curl -sS --connect-timeout 5 --max-time 30 \
  "https://nexus-os-iota.vercel.app/api/mcp" \
  -H "Authorization: Bearer nxs_3d3173c4a8a2b14510a9ae73c6260adc" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","method":"tools/call","params":{"name":"TOOL","arguments":{ARGS}},"id":N}' \
  > /tmp/nexus_result.json
EXIT=$?
# EXIT == 28 → timeout / EXIT == 6,7 → DNS/연결 실패 / EXIT != 0 → 실패 처리 후 재시도 또는 중단
```

파싱:
```python
import json
with open('/tmp/nexus_result.json') as f:
    r = json.load(f)
data = json.loads(r['result']['content'][0]['text'])
```

---

# Rules

- 새 태스크 생성 절대 금지 — 기존 row의 hours/memo 업데이트만
- 한국어 출력
- 1~3순위 매칭만 자동 확정. 4순위(substring)는 반드시 사용자 확인
- 복수 후보는 어떤 단계에서든 절대 자동 선택 안 함
- 시간은 0.5h 단위로 반올림
- Teams는 시간 분배 가중치에 포함하지 않음 — 메모 보강 전용
- API 실패 시 에러 메시지 보여주고 재시도 안내
- alias 등록 제안은 substring 매칭 성공 시에만 (강제 아님)
