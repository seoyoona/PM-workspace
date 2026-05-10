---
status: API-Error
case: case05
created: 2026-05-10
mode: auto
total_hours: 0
nexus_api_status: timeout
detected_projects_count: 3
matched_rows_count: 0
---

## 1. Mode & Source Summary

- Mode: auto
- 감지된 프로젝트 3건 (DSA / Connectory / Booktails)

## 2. Detected Activities

```
DSA: 4건 / Connectory: 2건 / Booktails: 2건
```

## 3. Nexus Row Matching

```
⚠️ Nexus API timeout (CURL_EXIT=28)
  - max-time 30s 초과
  - 매칭 단계 진입 전 안전 중단
  - tasks_list 응답을 받지 못해 row 매칭 불가
```

## 4. Distribution

```
(분배 미실행 — Nexus row 매칭 실패로 진행 불가)
```

## 5. PM Confirm

```
(미실행 — API 오류로 분배 단계에 도달 안 함)
```

## 6. Write Result

- 어떤 Nexus row에도 write 발생 안 함.
- 자동 재시도 금지 (memory feedback rule). PM이 수동으로 재실행 결정.

## 7. Notes

- nexus_api_status=timeout — CURL_EXIT=28 (max-time 초과).
- 안전 중단 — 부분 write 방지. matched_rows_count=0 보장.
- PM 다음 단계: 잠시 후 재시도 또는 수동 모드 (`--manual`)로 우회.
- Memory rule 준수 (`feedback_teams_flow_no_retry_on_timeout` 같은 정신) — 자동 재시도하지 않음.
