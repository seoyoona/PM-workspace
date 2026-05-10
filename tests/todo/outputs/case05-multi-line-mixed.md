---
status: Mixed
case: case05
created: 2026-05-10
mode: multi_line
pm_action_hub_db: collection://a183aae9-a894-8379-8708-87cf507ec8e8
input_lines_count: 3
created_count: 2
skipped_duplicate_count: 1
---

## 1. Input Summary

- Input: 3 lines
  1. `[Koboom] admin figma update`
  2. `[RCK] timeline 정리`
  3. `[BaraeCNP] 문의내용 회신`

## 2. Project Detection

| Line | Bracket | Project | Action Type |
|---|---|---|---|
| 1 | [Koboom] | Koboom (exact) | 운영 체크 (update) |
| 2 | [RCK] | RCK (exact) | 운영 체크 (정리) |
| 3 | [BaraeCNP] | BaraeCNP (exact) | 고객 커뮤니케이션 (회신) |

## 3. C1 Duplicate Check

라인별 개별 체크:

| Line | Title | C1 결과 |
|---|---|---|
| 1 | [Koboom] admin figma update | 0건 → 신규 |
| 2 | [RCK] timeline 정리 | **1건 발견** → skip (기존: https://notion.so/cigroio/rck-timeline-existing) |
| 3 | [BaraeCNP] 문의내용 회신 | 0건 → 신규 |

한 줄 중복이어도 나머지는 정상 생성됨 (skill rule).

## 4. Notion Write Result

생성:
- [Koboom] admin figma update → https://notion.so/cigroio/koboom-figma-2026-05-10
- [BaraeCNP] 문의내용 회신 → https://notion.so/cigroio/baraecnp-reply-2026-05-10

Skip:
```
⏭️ Skip: [RCK] timeline 정리 (오늘 이미 등록됨 — https://notion.so/cigroio/rck-timeline-existing)
```

생성 2건 / Skip 1건.

## 5. Notes

- multi_line mode — 라인별 개별 중복 체크.
- 1줄 skip이 다른 라인 생성을 막지 않음 (independence rule).
- mixed status 사용 — 일부 신규 일부 skip.
