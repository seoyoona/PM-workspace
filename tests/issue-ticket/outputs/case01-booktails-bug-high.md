---
status: Confirmed-1
case: case01
client: booktails
project: Booktails
created: 2026-05-10
gate_choice: "1"
linear_team: BookTails
linear_priority: High
linear_labels: [bug]
linear_issue_id: BT-127
linear_issue_url: https://linear.app/booktails/issue/BT-127
has_original_request: true
---

## 1. Source Summary

- Client: booktails / Project: Booktails
- Priority requested: High
- Label proposed: bug

## 2. Translation & Glossary Lookup

- glossary/booktails.md found — 5 terms loaded
- Korean → English mapping:
  - "영수증 화면" → Receipt screen
  - "확인" → Confirm
  - "freeze" → Freeze (UI hang)

## 3. Confirm Gate

```
[확인 필요]
다음 Linear 이슈를 생성합니다:

- Title: [Payment] Receipt screen freezes after "확인" tap
- Priority: High
- Labels: bug
- Team: BookTails

1. 생성 (추천)
2. 수정
3. 취소
추천: 1
```

## 4. PM Choice

- gate_choice: "1"
- Resulting actions: Linear 이슈 생성 — BT-127

## 5. Ticket Body

### Title
[Payment] Receipt screen freezes after "확인" tap

### What
After completing payment, the receipt screen freezes when the user taps "확인" (Confirm). The screen briefly shows a blank state and then becomes unresponsive.

### Why
Payment completion is a critical user-facing flow. A frozen receipt screen blocks downstream actions (confirmation, navigation back, repeat purchase) and may also block backend reconciliation if the user never reaches the post-confirm state.

### Acceptance Criteria
- [ ] Tapping "확인" on the receipt screen never produces a frozen / blank state.
- [ ] Receipt screen remains visible until user dismisses it explicitly.
- [ ] No regression on the rest of the post-payment flow (back navigation, history view).

### Technical Notes
- Reproduction: complete a payment → tap Confirm → observe blank flash → screen unresponsive.
- Likely related to async state transition in receipt component.
- Verify with both Kakao and Naver social-login users.

### Labels
bug

### Priority
High

## 6. Original Request

(KR, preserved verbatim)

```
결제 완료 후 영수증 화면이 멈춥니다. "확인" 버튼 누르면 빈 화면이 잠깐 뜨고 그 후 진행이 안 됩니다.
```

## 7. Notes

- 한국어 원문 보존됨 (§6).
- glossary 적용 — UI 요소명 한국어 + 영문 괄호 (`"확인" (Confirm)`).
- linear_priority="High", linear_labels=[bug] — input과 일치.
