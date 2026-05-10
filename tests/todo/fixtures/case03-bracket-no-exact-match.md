---
case: case03
description: `[koboom]` 소문자 — Notion exact match 실패 → 자동 확정 ❌, 숫자 선택지 fallback. PM이 2 (전체 목록) 선택 → Koboom 정확 선택.
mode: full_list_select
input_line: "[koboom] 피드백 회신"
expected_buckets:
  created_count: 1
  skipped_duplicate_count: 0
notes: |
  case-insensitive 자동 확정 금지 룰 회귀. exact match 실패 시 즉시 fallback.
---
