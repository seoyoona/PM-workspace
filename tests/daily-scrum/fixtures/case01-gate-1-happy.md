---
case: case01
description: gate=1 happy path. Notion DSL 저장 + PM Hub 자동 등록 + Teams 전송 모두 성공. PM Hub fetched 3건 (skip) + 신규 2건 (등록 성공) + Team today 1건 (PM Hub 제외).
client: dsa
project: Dsa
date: 2026-05-10
gate_choice: "1"
notes: |
  Standard happy path. 모든 외부 write 성공, partial failure 없음.
---

# Input
사용자 추가 입력: 메모로 "오후에 dev sync 30분 예상". 외에 PM Action Hub fetched 3건 + 신규 PM 추가 2건.
