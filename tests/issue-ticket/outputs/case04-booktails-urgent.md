---
status: Confirmed-1
case: case04
client: booktails
project: Booktails
created: 2026-05-10
gate_choice: "1"
linear_team: BookTails
linear_priority: Urgent
linear_labels: [bug]
linear_issue_id: BT-128
linear_issue_url: https://linear.app/booktails/issue/BT-128
has_original_request: true
---

## 1. Source Summary

- Client: booktails / Project: Booktails
- Priority requested: Urgent (서비스 다운 신호)
- Label: bug

## 2. Translation & Glossary Lookup

- glossary/booktails.md applied

## 3. Confirm Gate

```
[확인 필요]
다음 Linear 이슈를 생성합니다:

- Title: [Payment] Payment module fails entirely — service outage
- Priority: Urgent
- Labels: bug
- Team: BookTails

1. 생성 (추천)
2. 수정
3. 취소
추천: 1
```

## 4. PM Choice

- gate_choice: "1"
- Resulting actions: Linear 이슈 생성 — BT-128 (Urgent)

## 5. Ticket Body

### Title
[Payment] Payment module fails entirely — service outage

### What
Payment attempts fail at the module level — entire payment flow is unavailable. Customer reports complete inability to complete any purchase.

### Why
Payment is the primary revenue path. Full outage is a user-facing service-down condition that requires immediate response.

### Acceptance Criteria
- [ ] Payment attempts succeed for both Kakao and Naver social-login users.
- [ ] Failure is reproducible / non-reproducible reproduction status documented.
- [ ] Postmortem note added to the issue once resolution is found.

### Technical Notes
- Confirm payment provider sandbox status first (provider-side outage vs our-side).
- Check recent deploys / config changes.

### Labels
bug

### Priority
Urgent

## 6. Original Request

(KR, preserved verbatim)

```
결제 모듈이 완전히 안 됩니다. 결제 시도 자체가 실패해요. 긴급 조치 부탁드립니다.
```

## 7. Notes

- linear_priority="Urgent" — priority enum 최상위. 서비스 다운 신호.
- 한국어 원문 §6에 그대로 보존.
