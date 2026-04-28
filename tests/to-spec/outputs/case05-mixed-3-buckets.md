---
status: Mixed
client: Connectory
project: Connectory-1
created: 2026-04-28
source: meeting-note
source_ref: "tests/to-spec/fixtures/case05-mixed-buckets.md (test fixture)"
srs_ref: clients/connectory/Connectory-1/srs.md
design_md: missing
spec_pages:
  - "https://www.notion.so/cigroio/mock-spec-page-url-payment-order-number"
---

# Request Triage — 미팅 3건 동시 (결제 텍스트 / 등급별 차등 / 푸시)

> Reference draft — official spec lives in Nexus / PM Notion. In-Round 항목은 PM confirm 후 커뮤니케이션 DB / 태스크 DB에 자동 생성됩니다.

## 1. 변경 요청 요약
- 누가 / 언제 / 어떤 채널: Connectory 고객사, 2026-04-28, 미팅
- 원문 인용:
  > "(1) 결제 완료 화면 주문번호 형식 통일 (#12345로) — 단순 텍스트 변경  (2) 다음 라운드에 회원 등급별 적립금 적립률 차등화를 검토하고 싶음 (3) 회원에게 푸시 알림을 보내고 싶다 — 어떤 시점에 어떤 내용을 보낼지는 미정"
- PM 1-line 정규화: 미팅에서 3건 동시 발생 — 텍스트 통일(즉시) / 등급 차등(다음 라운드) / 푸시 알림(미정).

## 2. 기존 범위 대비 영향도
- SRS 참조: REQ-CON-PAY-03 (결제 완료 표시) / REQ-CON-MEMBER-04 (회원 등급)
- 영향 분류: 명확화 + 신규 기능 + Confirm-Needed 혼합
- 전체 Impact: Medium

## 3. 화면·UX 영향
- [확인 필요] design.md 부재 — UI 영향 상세 판단은 design owner / Nexus Agent 확인 필요
- design.md 갱신 필요 여부: 판단 보류
- wireframe 필요 여부: 판단 보류

## 4. 4-Bucket Triage

### In-Round
- [ ] 결제 완료 화면 주문번호 `#12345` 형식 통일 / 다른 화면 일관성 정정, 명확 근거 / Impact: Low

### Next-Round
- [ ] 회원 등급별 적립금 적립률 차등화 / 클라가 명시적으로 "다음 라운드" 언급 / 보류 사유: 일정·공수 영향, 본 라운드 외 명시

### Out-of-Scope
(현재 항목 없음)

### Confirm-Needed
- [ ] 회원 푸시 알림 / 어떤 정보가 더 필요한가: (1) 발송 시점 / (2) 발송 내용 / (3) 옵트인 정책 / (4) 채널 (FCM / APNs)

## 5. 고객 확인 / 거절 안내
- 푸시 알림 기능 검토에 앞서 다음 항목 확정이 먼저 필요합니다.
  1. 어떤 시점에 푸시를 발송하실 계획인지 확인 부탁드립니다.
  2. 어떤 내용을 푸시로 발송하실 계획인지 확인 부탁드립니다.
  3. 옵트인 정책은 어떻게 가져갈지 확인 부탁드립니다.
- 회원 등급별 적립률 차등화는 다음 라운드 검토 항목으로 기록해 두겠습니다.

## 6. 개발팀 전달 문구
- English summary: Standardize order number display format on payment completion screen to use `#` prefix.
- 영향 SRS section: REQ-CON-PAY-03
- AC 후보:
  - When user completes payment, then order number is displayed as `#<number>` matching other screens
- Impact: Low (구체 공수 산정은 dev 확인)

## 7. PM Confirm Gate

```
[확인 필요]
다음 In-Round 항목을 Notion 스펙 페이지 + 태스크 1개로 생성합니다:

스펙 페이지:
- Title: Standardize order number format on payment completion screen
- Tasks: 1개

1. 진행
2. 수정
3. 취소

추천: 1
```

PM 선택: **1 (진행)**.

## 8. Notion 스펙 + 태스크
- 스펙 페이지: https://www.notion.so/cigroio/mock-spec-page-url-payment-order-number
- 태스크 1개: Update payment-completion screen order number format
- linked view 수동 설정 안내: 스펙 페이지 하단 /linked view → 태스크 DB 추가 → 필터: 스펙 출처 = "Standardize order number format on payment completion screen"

## 9. PM 다음 단계
- In-Round (Notion 생성됨): /dev-chat에 §6 사용 + linked view 수동 설정
- Confirm-Needed (푸시): /client-chat에 §5 사용
- Out-of-Scope: (없음)
- Next-Round (등급별 차등): 다음 라운드 진입 시 본 항목 재검토

---

## 다음 단계 (자동 실행 안 함, 안내만)

- In-Round 페이지: /dev-chat에 §6 사용 + linked view 수동 설정
- Confirm-Needed: /client-chat에 §5 사용
- Out-of-Scope: (없음)
- Next-Round: 다음 라운드 진입 시 본 triage 파일 재검토
- 상태 변경: triage 파일 frontmatter status 직접 수정

---

> ⚠️ **In-Round로 분류·생성된 Notion 스펙은 PM이 §7 confirm gate에서 명시 진행한 항목만 포함합니다. PM 미확인 In-Round 항목은 Notion으로 가지 않았습니다.**
