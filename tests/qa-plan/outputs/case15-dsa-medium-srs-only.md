---
status: Draft
client: dsa
project: Dsa
qa_plan_id: QA-DSA-20260510
round: R1
created: 2026-05-10
author: PM
srs_ref: clients/Dsa/Dsa/srs.md
brief_refs: []
design_md: missing
staging_url: not_inspected
pages_inspected: []
auth_used: none
scope: all
---

## Source Coverage
- SRS: found
- URL inspect: not provided
- design.md: missing
- Change Brief: missing
- QA history: missing
- Confidence: Medium

> ℹ️ Confidence Medium — SRS alone. Plan body written from SRS. Provide staging URL or Change Brief next round to raise Confidence.

---

# QA Plan — dsa Dsa R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. QA Scope

**Test Targets:**
- SRS requirements: REQ-DSA-01 (org admin + member roles), REQ-DSA-02 (login flow), REQ-DSA-03 (dashboard), REQ-DSA-04 (member invite), REQ-DSA-05 (role boundary enforcement)
- Screens: Login / Dashboard / Member list / Invite modal (per SRS, no URL cross-check this round)
- Change Brief In-Round items: (none)

**Out of Scope (acknowledged, not tested):**
- Out-of-Scope items: (none)
- Confirm-Needed items: (none)

## 2. Test Roles / Accounts
- Primary roles: org admin, member
- Mock account mapping:
  - mock_admin_dsa01 — role: org admin, can invite + manage members
  - mock_member_dsa01 — role: member, dashboard read-only
- External dependencies: email mock for invite delivery

## 3. End-to-End Flow Map
```
Entry
├── Login
│   ├── Org admin login → Dashboard (admin view)
│   │   └── Member list → Invite modal → Send invite
│   └── Member login → Dashboard (member view, read-only)
└── Logout
```

(Flow derived from SRS only this round — staging URL not inspected.)

## 4. P0 Critical Scenarios (mandatory regression)

### P0-01: Org admin login → dashboard loads (REQ-DSA-01, REQ-DSA-02)
- Role: org admin
- Preconditions: mock_admin_dsa01 active in mock org
- Steps (≤9 recommended):
  1. Open login page
  2. Enter mock_admin_dsa01 credentials → submit
  3. Confirm dashboard loads with admin nav (Member list, Invite)
- Expected outcome: UI dashboard admin view / DB session created / No error in console

### P0-02: Member invite flow (REQ-DSA-04)
- Role: org admin
- Preconditions: admin authenticated, no pending invite for target email
- Steps (≤9 recommended):
  1. Navigate to Member list
  2. Open Invite modal
  3. Enter target email + role=member → submit
  4. Confirm invite row appears with status=pending
- Expected outcome: UI invite confirmation / DB invites row pending / External email mock received

### P0-03: Role boundary — member cannot access admin endpoints (REQ-DSA-05)
- Role: member
- Preconditions: mock_member_dsa01 authenticated
- Steps (≤9 recommended):
  1. Member login
  2. Attempt direct navigate to /admin/members
  3. Confirm redirect to dashboard or 403
- Expected outcome: UI access denied / DB no admin action logged / No data leak

## 5. P1 Supporting Scenarios

### P1-01: Logout flow
- Role: any authenticated
- Preconditions: active session
- Steps (≤9 recommended):
  1. Click logout
  2. Confirm redirect to login
- Expected outcome: UI login screen / DB session invalidated / Cookie cleared

## 6. Edge / Negative Cases

### EDGE-01: Invalid login credentials
- Scenario: member enters wrong password
- Expected outcome: UI error message / DB no session / No lockout this round

### EDGE-02: Duplicate invite to same email
- Scenario: admin sends invite to email with pending invite
- Expected outcome: UI duplicate notice / DB no second invite row / per SRS REQ-DSA-04

## 7. Regression Checklist

(no regression items in this round)

## 8. QA Handoff Message

Copy/paste this block to send to QA / client:

```
Hi team,

Sharing the QA plan for dsa / Dsa R1.

Scenarios in scope:
- P0 (mandatory): P0-01, P0-02, P0-03
- P1 (supporting): P1-01
- EDGE: EDGE-01, EDGE-02
- REG: (none)

Test environment:
- Staging URL: [TBD — not inspected this round]
- Mock accounts: mock_admin_dsa01 / mock_member_dsa01
- Deadline: [TBD]

When reporting failures, please preserve the following meta on the first line of the report:
QA Plan: QA-DSA-20260510
Scenario: P0-NN

Reach out with any questions.
```

## 9. PM Review Items

- **URL inspect not performed** — Confidence stays Medium. Provide `--url <staging>` next round for §3 Flow Map cross-check and SRS-Implementation Deviation surfacing.
- **Change Brief missing** — `clients/Dsa/Dsa/change-briefs/` empty for this round.
- **design.md missing** — UI representation cross-check unavailable.
- **QA history empty** — no prior-round feedback materials.

---

## Next Steps (no auto-execution, guidance only)

- §8 QA Handoff Message → use with `/client-chat` or `/qa-request`
- Bugs found during QA → `/qa-feedback` (preserve `QA Plan: QA-DSA-20260510` or `Scenario: P0-NN` on the first line of the report body)
- Significant bugs → `/issue-ticket` → Linear
- Status change: edit frontmatter `status:` directly (Draft → Review → Final)

---

> ⚠️ **This QA plan is for PM/QA internal validation.** Do not forward §1–§7 to client or dev team directly. §8 is the only client/QA-facing section.
