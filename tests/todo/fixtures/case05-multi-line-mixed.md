---
case: case05
description: 3줄 입력 — 1번째 신규 / 2번째 중복 skip / 3번째 신규. 각 라인 개별 중복 체크.
mode: multi_line
input_lines:
  - "[Koboom] admin figma update"
  - "[RCK] timeline 정리"
  - "[BaraeCNP] 문의내용 회신"
existing_matches:
  - "[RCK] timeline 정리": https://notion.so/cigroio/rck-timeline-existing
expected_buckets:
  created_count: 2
  skipped_duplicate_count: 1
---
