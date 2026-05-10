---
status: Confirmed-1
case: case05
client: dsa
project: Dsa
created: 2026-05-10
gate_choice: "1"
linear_team: Dsa
linear_priority: Low
linear_labels: [improvement]
linear_issue_id: DSA-319
linear_issue_url: https://linear.app/dsa/issue/DSA-319
has_original_request: true
---

## 1. Source Summary

- Client: dsa / Project: Dsa
- Priority requested: Low
- Label: improvement

## 2. Translation & Glossary Lookup

- glossary/dsa.md found — terms loaded
- Mappings applied:
  - 조직 관리자 → Organization admin (org_admin)
  - 회원 → Member
  - 초대 → Invite
  - 사인업 → Signup

## 3. Confirm Gate

```
[확인 필요]
다음 Linear 이슈를 생성합니다:

- Title: [Invite] Show signup deadline in invite email
- Priority: Low
- Labels: improvement
- Team: Dsa

1. 생성 (추천)
2. 수정
3. 취소
추천: 1
```

## 4. PM Choice

- gate_choice: "1"
- Resulting actions: Linear 이슈 생성 — DSA-319

## 5. Ticket Body

### Title
[Invite] Show signup deadline in invite email

### What
Add a signup deadline field to the Member invite email. Org admins can set the deadline; if not set, the email omits the line.

### Why
Better signup conversion — recipients can prioritize the invite. Reduces follow-up emails from admins to remind invitees.

### Acceptance Criteria
- [ ] Invite email template has an optional signup deadline line.
- [ ] org_admin can set the deadline when sending an invite.
- [ ] If no deadline is set, the line is omitted from the email entirely (no empty placeholder).
- [ ] Deadline displays in the recipient's timezone.

### Technical Notes
- Use existing email template variables.
- No DB migration if we add the field as nullable on the existing invite record.

### Labels
improvement

### Priority
Low

## 6. Original Request

(KR, preserved verbatim)

```
조직 관리자(org admin)가 회원을 초대할 때 invite 메일에 사인업 마감 기한을 표시했으면 좋겠어요.
```

## 7. Notes

- glossary 적용 — `Organization admin (org_admin)`, `Member`, `Invite`, `Signup`.
- linear_labels=[improvement] — 신규 기능보다는 기존 기능 보강.
- linear_priority="Low" — 핵심 흐름 비차단.
