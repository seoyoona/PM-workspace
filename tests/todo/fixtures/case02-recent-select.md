---
case: case02
description: 대괄호 없음 → 숫자 선택지 → PM이 1 (최근) 선택 → 최근 프로젝트 3개 중 1개 선택.
mode: recent_project_select
input_line: "오늘 디자인 검토 끝까지 정리하기"
expected_buckets:
  created_count: 1
  skipped_duplicate_count: 0
---
