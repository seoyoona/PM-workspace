---
status: In-Round-only
client: Connectory
project: Connectory-1
created: 2026-04-28
source: free-text
source_ref: "tests/to-spec/fixtures/case02-in-round-proceed.md (test fixture)"
srs_ref: clients/connectory/Connectory-1/srs.md
design_md: missing
spec_pages:
  - "https://www.notion.so/cigroio/mock-spec-page-url-payment-order-number"
---

# Request Triage — 결제 완료 화면 주문번호 형식 통일 (# prefix, 진행)

> Reference draft — official spec lives in Nexus / PM Notion. In-Round 항목은 PM confirm 후 커뮤니케이션 DB / 태스크 DB에 자동 생성됩니다.

## 1. 변경 요청 요약
- 누가 / 언제 / 어떤 채널: Connectory 고객사, 2026-04-28, 직접 피드백
- 원문 인용:
  > "결제 완료 화면 주문번호 표시 형식 통일 요청. 다른 화면은 모두 '#12345' 형식인데 결제 완료만 '12345'로 다름. # 붙여 통일 요망."
- PM 1-line 정규화: 결제 완료 화면 주문번호 표시 형식을 다른 화면과 동일하게 `#` prefix 형식으로 통일.

## 2. 기존 범위 대비 영향도
- SRS 참조: REQ-CON-PAY-03 (결제 완료 표시) 인용
- 영향 분류: 명확화 (UI 텍스트 일관성 정정)
- 전체 Impact: Low

## 3. 화면·UX 영향
- [확인 필요] design.md 부재 — UI 영향 상세 판단은 design owner / Nexus Agent 확인 필요
- design.md 갱신 필요 여부: 판단 보류
- wireframe 필요 여부: 불필요

## 4. 4-Bucket Triage

### In-Round
- [ ] 결제 완료 화면 주문번호 형식 `#12345`로 통일 / 다른 화면들이 이미 `#` 형식, 명확화 변경 / Impact: Low

### Next-Round
(현재 항목 없음)

### Out-of-Scope
(현재 항목 없음)

### Confirm-Needed
(현재 항목 없음)

## 5. 고객 확인 / 거절 안내
(현재 확인 필요·거절 안내 항목 없음)

## 6. 개발팀 전달 문구
- English summary: Standardize order number display format on payment completion screen to use `#` prefix matching other screens.
- 영향 SRS section: REQ-CON-PAY-03
- AC 후보:
  - When user completes payment, then order number is displayed as `#<number>`
- Impact: Low (구체 공수 산정은 dev 확인)

## 7. PM Confirm Gate

```
[확인 필요]
다음 In-Round 항목을 Notion 스펙 페이지 + 태스크 1개로 생성합니다:

스펙 페이지:
- Title: Standardize order number format on payment completion screen
- Scope summary: Display format only
- AC: When payment complete, order number is `#<number>`
- Tasks: 1개 (Update payment-completion screen)

1. 진행 (Notion 페이지 + 태스크 생성)
2. 수정 (4-bucket 분류 다시 검토)
3. 취소

추천: 1
```

PM 선택: **1 (진행)** — Notion 스펙 페이지 + 태스크 생성됨.

## 8. Notion 스펙 + 태스크
- 스펙 페이지: https://www.notion.so/cigroio/mock-spec-page-url-payment-order-number
- 태스크 1개:
  - [ ] Update payment-completion screen order number format (Priority: Medium / AC: When payment complete, order number is `#<number>` / link: mock)
- linked view 수동 설정 안내: 스펙 페이지 하단 /linked view → 태스크 DB 추가 → 필터: 스펙 출처 = "Standardize order number format on payment completion screen"

## 9. PM 다음 단계
- In-Round (Notion 생성됨): /dev-chat에 §6 사용 + linked view 수동 설정
- Confirm-Needed: (없음)
- Out-of-Scope: (없음)
- Next-Round: (없음)

---

## 다음 단계 (자동 실행 안 함, 안내만)

- In-Round 페이지: /dev-chat에 §6 사용 + linked view 수동 설정
- Confirm-Needed: /client-chat에 §5 사용
- Out-of-Scope: /client-chat에 거절 안내 사용
- Next-Round: 다음 라운드 진입 시 본 triage 파일 재검토
- 상태 변경: triage 파일 frontmatter status 직접 수정 (Triaged → Dev-Handoff)

---

> ⚠️ **In-Round로 분류·생성된 Notion 스펙은 PM이 §7 confirm gate에서 명시 진행한 항목만 포함합니다. PM 미확인 In-Round 항목은 Notion으로 가지 않았습니다.**
