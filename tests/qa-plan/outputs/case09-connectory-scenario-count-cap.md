---
status: Draft
client: connectory
project: Connectory-1
qa_plan_id: QA-CONNECTORY-20260428
round: R1
created: 2026-04-28
author: PM
srs_ref: clients/Connectory/Connectory-1/srs.md
brief_refs: [clients/Connectory/Connectory-1/change-briefs/cb-01.md, cb-02.md, cb-03.md, cb-04.md, cb-05.md]
design_md: clients/Connectory/Connectory-1/design.md
staging_url: not_inspected
pages_inspected: []
auth_used: none
scope: all
---

# QA Plan — connectory Connectory-1 R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. QA Scope

**Test Targets:**
- SRS requirements: REQ-CONNECTORY-01~20 (20 items)
- Screens: 10
- Change Brief In-Round items: 5

**Out of Scope (acknowledged, not tested):** (none)

## 2. Test Roles / Accounts
- Primary roles: regular member, admin
- Mock accounts: mock_member_01, mock_admin_01

## 3. End-to-End Flow Map
(omitted — full 10-screen text tree)

## 4. P0 Critical Scenarios (10)

### P0-01: Signup
### P0-02: Login
### P0-03: Point top-up
### P0-04: Payment
### P0-05: Refund
### P0-06: Order history view
### P0-07: My page profile edit
### P0-08: Profile photo change
### P0-09: Password change
### P0-10: Account deletion

(detailed steps omitted — each ≤9 steps)

## 5. P1 Supporting Scenarios (8)

### P1-01 ~ P1-08
(details omitted)

## 6. Edge / Negative Cases (3)

### EDGE-01 ~ EDGE-03
(details omitted)

## 7. Regression Checklist

### REG-01 ~ REG-02
(details omitted)

> Scenario count: P0=10, P1=8, EDGE=3, REG=2 → total 23. Screens 10 × 1.5 = 15 cap exceeded.

## 8. QA Handoff Message

```
Hi team,

Sharing the QA plan for Connectory-1 R1.

Scenarios in scope:
- P0: P0-01 ~ P0-10 (10)
- P1: P1-01 ~ P1-08 (8)
- EDGE: EDGE-01 ~ EDGE-03 (3)
- REG: REG-01 ~ REG-02 (2)
Total 23 scenarios — large round.

Test environment:
- Staging URL: [TBD]
- Mock accounts: mock_member_01, mock_admin_01

When reporting failures, preserve the meta:
QA Plan: QA-CONNECTORY-20260428
Scenario: P0-NN

Reach out with any questions.
```

## 9. PM Review Items

- **Scenario count cap exceeded** — total 23. Screens 10 × 1.5 = 15 cap exceeded. **Split / consolidate review recommended:**
  - Option A: split round (half R1 + half R2)
  - Option B: defer some P1 to the next round
  - Option C: proceed as-is (large QA round)
- Staging URL to be shared

---

## Next Steps (no auto-execution, guidance only)

- After deciding on scenario count cap, adjust §8 accordingly
- §8 → `/client-chat` or `/qa-request`
- Bugs → `/qa-feedback` (preserve meta)
- Status change: edit frontmatter directly

---

> ⚠️ **This QA plan is for PM/QA internal validation.** Do not forward §1–§7 to client or dev team directly. §8 is the only client/QA-facing section.
