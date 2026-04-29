---
status: Draft
client: dsa
project: DSA
qa_plan_id: QA-DSA-20260428
round: R1
created: 2026-04-28
author: PM
srs_ref: clients/dsa/DSA/srs.md
brief_refs: []
design_md: clients/dsa/DSA/design.md
staging_url: not_inspected
pages_inspected: []
auth_used: none
scope: all
---

# QA Plan — dsa DSA R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

> ℹ️ **Selected project: DSA** (reason: only one project exists under clients/dsa/ → auto-selected)

## 1. QA Scope

**Test Targets:**
- SRS requirements: REQ-DSA-01, REQ-DSA-02, REQ-DSA-03 (report·review·vehicle log)
- Screens: Project detail / Tech advisory dashboard / Report form / Vehicle log form
- Change Brief In-Round items: (none)

**Out of Scope (acknowledged, not tested):**
- Out-of-Scope items: (none)
- Confirm-Needed items: (none)

## 2. Test Roles / Accounts
- Primary roles: Tech Advisor
- Mock accounts: mock_advisor_dsa01

## 3. End-to-End Flow Map
```
mock_advisor login → Project detail → Tech advisory dashboard → Report compose·preview·edit·submit
```

## 4. P0 Critical Scenarios

### P0-01: Report compose and submit (REQ-DSA-01)
- Role: Tech Advisor
- Preconditions: staging, mock_advisor_dsa01
- Steps (≤9):
  1. Log in → enter project
  2. Tech advisory dashboard → Compose report
  3. Enter photo·risk factors·improvements
  4. Preview → Edit → Submit
- Expected outcome: UI Pending review / DB pending_review / External [TBD]

## 5. P1 Supporting Scenarios

(none)

## 6. Edge / Negative Cases

(none)

## 7. Regression Checklist

(no regression items in this round)

## 8. QA Handoff Message

```
Hi team,

Sharing the QA plan for DSA R1.

Scenarios in scope:
- P0: P0-01

Test environment:
- Staging URL: [TBD]
- Mock accounts: mock_advisor_dsa01

When reporting failures, preserve the meta:
QA Plan: QA-DSA-20260428
Scenario: P0-NN
```

## 9. PM Review Items

- Staging URL to be shared
- External effects source missing

---

## Next Steps (no auto-execution, guidance only)

- §8 → `/client-chat` or `/qa-request`
- Bugs → `/qa-feedback` (preserve meta)
- Status change: edit frontmatter directly

---

> ⚠️ **This QA plan is for PM/QA internal validation.** Do not forward §1–§7 to client or dev team directly. §8 is the only client/QA-facing section.
