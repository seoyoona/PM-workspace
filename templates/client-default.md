# `--client` 보수적 Default 제안 규칙 (공통)

`--client` 인자가 **완전히 누락된** 경우에만 적용. 부분 입력(`--client` 뒤에 값 없음 등)은 기존대로 사용자 확인.

## 판단 순서 (엄격)

1. **`--client` 완전 누락 확인** — 누락이 아니면 이 로직 건너뛰고 기존 흐름
2. **최근 24시간 activity-log 읽기**:
   ```bash
   python3 -c "
   import json, sys
   from datetime import datetime, timezone, timedelta
   cutoff = (datetime.now(timezone.utc) - timedelta(hours=24))
   clients = set()
   try:
       with open('.claude/activity-log.jsonl') as f:
           for line in f:
               try:
                   r = json.loads(line)
                   d = datetime.fromisoformat(r['date']).replace(tzinfo=timezone.utc)
                   # date는 YYYY-MM-DD만 있어 24h 추정 — 오늘/어제 기록 모두 포함
                   if (datetime.now(timezone.utc).date() - d.date()).days <= 1:
                       clients.add(r['client'])
               except Exception: pass
   except FileNotFoundError: pass
   print('|'.join(sorted(clients)))
   "
   ```
3. **분기**:
   - **결과 1개**: 그 client를 **보수적 default로 제안**. 실행 전에 1줄 명시:
     > `최근 활동 기준 --client=Koboom 으로 진행합니다 (다르면 Ctrl+C)`
     사용자가 즉시 중단하지 않으면 진행. 자동 확정 아님 — 명시 통보 + 사용자 개입 가능.
   - **결과 2개 이상**: 자동 적용 금지. 숫자 선택지 제시:
     ```
     최근 활동한 클라이언트:
     1. Koboom (오늘)
     2. Booktails (오늘)
     3. DSA (오늘)
     4. 다른 클라이언트 직접 입력
     추천: 1 (가장 최근 또는 가장 빈번)
     ```
     사용자 선택 후 진행.
   - **결과 0개 (24h 내 기록 없음)**: 기존대로 PM에게 `--client` 확인 요청.

## 금지사항

- activity-log 없는 상태에서 "가장 흔히 쓰는 client" 같은 추측 자동 적용 금지
- 사용자에게 묻지 않고 조용히 적용 금지 (반드시 1줄 명시)
- `--client Koboom` 같이 값은 있지만 오타로 보이는 경우 자동 수정 금지 (명시 통보 + 사용자 확인)
- "최근" 범위를 임의로 48h/72h로 확장 금지

## 적용 스킬

client-chat, dev-chat, daily-scrum, weekly-report, issue-ticket, qa-request, sync-note, to-spec

## 미적용 스킬 (의도적 제외)

- **todo**: 대괄호 포맷으로 프로젝트명 입력받음 (B2 보수적 자동 프로젝트 확정 참조)
- **today-brief / nexus-daily**: --client 인자 자체가 없음
- **meeting-note**: --client 필수, 누락 시 명시적 확인 필요
- **qa-feedback**: --project 인자 사용 (다른 인자 체계)
- **create-srs / srs-translate / kickoff-prep / new-project / setup-workspace**: 프로젝트 라이프사이클 초기 단계, 맥락 혼동 리스크 높아 보수적 default 미적용
