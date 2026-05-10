---
case: case04
description: 같은 제목이 오늘 이미 PM Action Hub에 있음 → C1 skip + 기존 링크 알림.
mode: exact_bracket
input_line: "[Koboom] 피드백 업데이트 전달"
existing_match: https://notion.so/cigroio/koboom-feedback-update-existing
expected_buckets:
  created_count: 0
  skipped_duplicate_count: 1
---
