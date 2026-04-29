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
design_md: missing
staging_url: not_inspected
pages_inspected: []
scope: all
---

# QA Plan — dsa DSA R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. QA Scope

**Test Targets:**
- SRS requirements: REQ-DSA-01 (report compose → review → refund end-to-end)
- Screens: Report form / Preview / Edit / Submit / Review / Refund
- Change Brief In-Round items: (none)

**Out of Scope (acknowledged, not tested):** (none)

## 2. Test Roles / Accounts
- Primary roles: Tech Advisor, Org Admin
- Mock accounts: mock_advisor_dsa01, mock_org_admin_dsa01

## 3. End-to-End Flow Map
```
Report compose → Preview → Edit → Submit → Pending review → Approve → Refund request → Refund processed
```

## 4. P0 Critical Scenarios

### P0-01: Report compose·submit·review·refund end-to-end (REQ-DSA-01)
- Role: Tech Advisor + Org Admin
- Preconditions: staging, mock_advisor_dsa01, mock_org_admin_dsa01, refund auto-approval mode
- Steps:
  1. Log in as mock_advisor
  2. Enter project
  3. Tech advisory dashboard → Compose report
  4. Upload photo
  5. Enter risk factors
  6. Enter improvements
  7. Preview → Edit
  8. Submit
  9. Log in as mock_org_admin
  10. Open Review queue
  11. Review report → Approve
  12. Submit refund request (report-based settlement)
  13. Refund auto-approved → balance reflected
- Expected outcome: UI all statuses transition correctly / DB reports + refunds row consistent / External [TBD]

> ⚠️ **Step cap exceeded (currently 13) — split recommended.** No auto-truncation. PM decides manually.

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
- P0: P0-01 (13 steps — split recommended)

Test environment:
- Staging URL: [TBD]
- Mock accounts: mock_advisor_dsa01, mock_org_admin_dsa01

When reporting failures, preserve the meta:
QA Plan: QA-DSA-20260428
Scenario: P0-NN
```

## 9. PM Review Items

- **Step cap exceeded** — P0-01 has 13 steps. Recommended 6–9 / 10–12 consider splitting / 13+ cap exceeded. PM splits manually (e.g., compose·submit / review·approve / refund as 3 separate scenarios)
- Staging URL to be shared
- External effects source missing

---

## Next Steps (no auto-execution, guidance only)

- §8 → `/client-chat` or `/qa-request`
- Bugs → `/qa-feedback` (preserve meta)
- After splitting decision, edit this plan directly

---

> ⚠️ **This QA plan is for PM/QA internal validation.** Do not forward §1–§7 to client or dev team directly. §8 is the only client/QA-facing section.
