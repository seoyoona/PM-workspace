# Teams 전송 Snippet (공통)

dev-chat / sync-note / 기타 Teams 그룹챗 전송이 필요한 스킬에서 공통으로 사용하는 curl 패턴.
`!` bash expansion 방지를 위해 반드시 파일 경유 + timeout + HTTP code 검증 포함.

## 입력 변수
- `TEAMS_FLOW_URL` — `.env.teams`에서 로드
- `CHAT_ID` — `TEAMS_CHAT_{CLIENT}_DEV` 키에서 로드
- 메시지 본문(HTML 형식) — `/tmp/teams_msg.json`에 JSON으로 저장

## 전송 + 검증 절차

```bash
# 1) JSON payload 작성 (heredoc, 파일 경유 — ! 이스케이프 안전)
cat > /tmp/teams_msg.json << 'EOF'
{"chat_id":"<CHAT_ID>","message":"<HTML 메시지>"}
EOF

# 2) curl — timeout + HTTP code 캡처
HTTP_CODE=$(curl -sS \
  --connect-timeout 5 \
  --max-time 30 \
  -o /tmp/teams_resp.txt \
  -w "%{http_code}" \
  -X POST \
  -H 'Content-Type: application/json' \
  -d @/tmp/teams_msg.json \
  "<TEAMS_FLOW_URL>")
CURL_EXIT=$?

# 3) 결과 판정 (3가지 분기)
if [ "$CURL_EXIT" -eq 28 ]; then
  echo "⚠️ 전송 시간 초과 (30s). Flow는 응답을 못 줬지만 메시지는 전달됐을 가능성 높음."
  echo "   Teams에서 직접 확인 후 미수신이면 수동 재전송. (자동 재시도 금지 — 중복 위험)"
  SEND_OK=0
elif [ "$CURL_EXIT" -ne 0 ]; then
  echo "⚠️ 전송 실패 (curl exit $CURL_EXIT)"
  SEND_OK=0
elif [ "$HTTP_CODE" -ge 200 ] && [ "$HTTP_CODE" -lt 300 ]; then
  echo "✅ 전송 완료 (HTTP $HTTP_CODE)"
  SEND_OK=1
else
  echo "⚠️ 전송 실패 (HTTP $HTTP_CODE)"
  echo "   응답 본문:"
  cat /tmp/teams_resp.txt | head -c 500
  echo
  SEND_OK=0
fi
```

## 실패 시 1회 재시도 (선택)

`SEND_OK=0` AND `HTTP_CODE >= 500`일 때만 단일 재시도:

```bash
if [ "$SEND_OK" -eq 0 ] && [ "$HTTP_CODE" -ge 500 ]; then
  echo "→ 1회 재시도..."
  HTTP_CODE=$(curl -sS --connect-timeout 5 --max-time 30 \
    -o /tmp/teams_resp.txt -w "%{http_code}" \
    -X POST -H 'Content-Type: application/json' \
    -d @/tmp/teams_msg.json "<TEAMS_FLOW_URL>")
  CURL_EXIT=$?
  if [ "$CURL_EXIT" -eq 0 ] && [ "$HTTP_CODE" -ge 200 ] && [ "$HTTP_CODE" -lt 300 ]; then
    echo "✅ 전송 완료 (재시도, HTTP $HTTP_CODE)"
    SEND_OK=1
  else
    echo "⚠️ 재시도 실패 (exit $CURL_EXIT, HTTP $HTTP_CODE)"
  fi
fi
```

**timeout(CURL_EXIT=28)은 재시도하지 않음** — Power Automate Flow는 응답이 늦어 timeout이 나도 메시지를 이미 전달했을 가능성이 높음. 자동 재시도하면 중복 전송 발생 (RCK처럼 응답이 느린 chat에서 실제로 발생). 사용자가 Teams에서 확인 후 수동 재전송 결정.

4xx(클라이언트 에러)는 재시도해도 같은 결과이므로 재시도하지 않음.

## activity-log 기록 조건

**반드시 `SEND_OK=1`일 때만 기록.** 실패 시 기록 금지(nexus-daily가 오인할 수 있음).

```bash
if [ "$SEND_OK" -eq 1 ]; then
  echo '{"date":"'$(date +%Y-%m-%d)'","skill":"<skill-name>","client":"<CLIENT>"}' \
    >> .claude/activity-log.jsonl
fi
```

## 실패 시 사용자 fallback 안내

`SEND_OK=0`이면 메시지 본문을 다시 출력하며 "복사해서 수동 전송" 안내 제공.

```
전송 실패. 아래 메시지를 복사해서 Teams에 직접 붙여넣어 주세요:

<메시지 본문>
```

## 주의사항

- `--max-time 30`는 Teams Flow 정상 응답 범위 기준 (RCK 등 일부 chat은 15s 이상 걸림). 300초 hang 재발 방지.
- `--connect-timeout 5`로 DNS/TCP 단계 실패를 빠르게 구분.
- HTTP 202(Accepted)도 2xx이므로 성공으로 판정 — Teams Flow는 202 반환이 일반적.
- `curl -w "%{http_code}"`가 응답 body 대신 HTTP code를 stdout으로 출력. body는 `-o` 파일에.
- `/tmp/teams_resp.txt`는 매 호출마다 덮어쓰기. 민감정보 저장 금지.
