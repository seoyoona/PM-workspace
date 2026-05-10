---
case: case08
description: PM Hub today-only dedup. 어제 같은 제목+프로젝트 항목이 PM Hub에 있어도, 오늘 신규 등록은 정상 진행 (Patch B date 조건 정상 작동).
client: dsa
project: Dsa
date: 2026-05-10
gate_choice: "1"
notes: |
  Patch B 회귀: dedup filter에 date 조건 누락이면 어제 항목과 같은 제목이 잘못 skip되었을 것. date 조건 추가로 정상 신규 진행 검증.
---

# Pre-condition (PM Hub state)
- 어제(2026-05-09) 등록된 항목: `[Dsa] 결제 환불 정책 초안` (작성일 2026-05-09)
- 오늘 PM이 같은 제목으로 또 등록 시도
