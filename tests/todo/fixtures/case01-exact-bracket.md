---
case: case01
description: `[Koboom]` 대괄호 + Notion 프로젝트 select 옵션 exact match → 자동 확정 + 1줄 인식 메시지.
mode: exact_bracket
input_line: "[Koboom] 피드백 업데이트 전달"
notion_project_options: [Koboom, RCK, BaraeCNP, DSA, Connectory, Booktails, Mountain]
expected_buckets:
  created_count: 1
  skipped_duplicate_count: 0
---
