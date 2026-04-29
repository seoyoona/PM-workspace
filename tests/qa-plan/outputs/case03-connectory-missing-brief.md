---
status: Draft
client: connectory
project: Connectory-1
qa_plan_id: QA-CONNECTORY-20260428
round: R1
created: 2026-04-28
author: PM
srs_ref: clients/Connectory/Connectory-1/srs.md
brief_refs: []
design_md: clients/Connectory/Connectory-1/design.md
staging_url: not_inspected
pages_inspected: []
scope: all
---

# QA Plan — connectory Connectory-1 R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. QA Scope

**Test Targets:**
- SRS requirements: REQ-CONNECTORY-01 (signup), REQ-CONNECTORY-02 (point top-up), REQ-CONNECTORY-03 (payment), REQ-CONNECTORY-04 (my page), REQ-CONNECTORY-05 (order history)
- Screens: Signup / Point top-up / Payment / My page / Order history
- Change Brief In-Round items: (none)

**Out of Scope (acknowledged, not tested):**
- Out-of-Scope items: (none)
- Confirm-Needed items: (none)

## 2. Test Roles / Accounts
- Primary roles: regular member
- Mock account mapping:
  - mock_member_01 — role: regular member, balance 5000
- External dependencies: Toss payment sandbox

## 3. End-to-End Flow Map
```
mock_member_01 login
├── Signup (REQ-CONNECTORY-01)
├── Point top-up (REQ-CONNECTORY-02)
├── Payment (REQ-CONNECTORY-03)
└── My page → Order history (REQ-CONNECTORY-04, 05)
```

(design.md screen names available for cross-check)

## 4. P0 Critical Scenarios (mandatory regression)

### P0-01: Signup → auto login (REQ-CONNECTORY-01)
- Role: guest
- Preconditions: staging, mock new email
- Steps (≤9):
  1. Open /signup
  2. Fill required fields
  3. Click Sign up
  4. Verify redirect to /home
- Expected outcome: UI signup-complete toast / DB users row created / External [TBD — email send source not specified]

### P0-02: Top-up → payment → balance updated (REQ-CONNECTORY-02, 03)
- Role: regular member
- Preconditions: mock_member_01, Toss sandbox
- Steps (≤9):
  1. Log in as mock_member_01
  2. Open Point top-up screen
  3. Select 10,000 KRW package
  4. Toss sandbox payment
  5. Verify balance refreshed
- Expected outcome: UI balance +10,000 / DB orders + payments row / External 1 Toss call

## 5. P1 Supporting Scenarios

### P1-01: View order history on My page (REQ-CONNECTORY-04, 05)
- Role: regular member
- Preconditions: mock_member_01, ≥1 prior order
- Steps (≤9):
  1. My page → Order history
  2. Verify list rendering
- Expected outcome: only own orders shown (no other users' orders)

## 6. Edge / Negative Cases

### EDGE-01: Direct access to another member's order URL
- Scenario: mock_member_01 opens another member's order id URL directly
- Expected outcome: 403 or redirect to own order list

## 7. Regression Checklist (previous → R1)

(no regression items in this round — Change Brief not linked, no impact area to track)

## 8. QA Handoff Message

```
Hi team,

Sharing the QA plan for Connectory-1 R1.

Scenarios in scope:
- P0 (mandatory): P0-01, P0-02
- P1 (supporting): P1-01
- EDGE: EDGE-01

Test environment:
- Staging URL: [TBD]
- Mock accounts: mock_member_01 (regular member)
- Deadline: [TBD]

When reporting failures, please preserve the following meta on the first line of the report:
QA Plan: QA-CONNECTORY-20260428
Scenario: P0-NN

Reach out with any questions.
```

## 9. PM Review Items

- Change Brief not linked — no change-impact area in this round (regression items 0)
- External effects (email send etc.) source missing → confirm with dev
- Staging URL / deadline to be shared

---

## Next Steps (no auto-execution, guidance only)

- §8 → `/client-chat` or `/qa-request`
- Bugs → `/qa-feedback` (preserve meta)
- Significant bugs → `/issue-ticket`
- Status change: edit frontmatter directly

---

> ⚠️ **This QA plan is for PM/QA internal validation.** Do not forward §1–§7 to client or dev team directly. §8 is the only client/QA-facing section.
