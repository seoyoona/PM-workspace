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

> ℹ️ **Selected project: Connectory-1** (reason: recent mtime 2 days ago, matches `프로젝트명` in clients/Connectory/CLAUDE.md)
>
> Note: 3 project candidates under clients/connectory/ — Connectory-1 (selected), Connectory-2, Connectory-3. PM picked option 1.

## 1. QA Scope

**Test Targets:**
- SRS requirements: REQ-CONNECTORY-01~05
- Screens: Signup / Payment / My page
- Change Brief In-Round items: (none)

**Out of Scope (acknowledged, not tested):**
- Out-of-Scope items: (none)
- Confirm-Needed items: (none)

## 2. Test Roles / Accounts
- Primary roles: regular member
- Mock accounts: mock_member_01

## 3. End-to-End Flow Map
```
mock_member_01 login → Payment → My page
```

## 4. P0 Critical Scenarios

### P0-01: Payment flow (REQ-CONNECTORY-03)
- Role: regular member
- Preconditions: mock_member_01, Toss sandbox
- Steps (≤9):
  1. Log in
  2. Select item → pay
  3. Verify balance updated
- Expected outcome: UI payment-complete / DB orders row / External 1 Toss call

## 5. P1 Supporting Scenarios

(none)

## 6. Edge / Negative Cases

(none)

## 7. Regression Checklist

(no regression items in this round)

## 8. QA Handoff Message

```
Hi team,

Sharing the QA plan for Connectory-1 R1.

Scenarios in scope:
- P0: P0-01

Test environment:
- Staging URL: [TBD]
- Mock accounts: mock_member_01

When reporting failures, preserve the meta:
QA Plan: QA-CONNECTORY-20260428
Scenario: P0-NN
```

## 9. PM Review Items

- Staging URL to be shared

---

## Next Steps (no auto-execution, guidance only)

- §8 → `/client-chat` or `/qa-request`
- Bugs → `/qa-feedback` (preserve meta)
- Status change: edit frontmatter directly

---

> ⚠️ **This QA plan is for PM/QA internal validation.** Do not forward §1–§7 to client or dev team directly. §8 is the only client/QA-facing section.
