---
status: Draft
client: dsa
project: DSA
qa_plan_id: QA-DSA-20260428
round: R1
created: 2026-04-28
author: PM
srs_ref: clients/dsa/DSA/srs.md
brief_refs: [clients/dsa/DSA/change-briefs/2026-04-25-report-preview-risk-emphasis.md]
design_md: clients/dsa/DSA/design.md
staging_url: not_inspected
pages_inspected: []
scope: all
---

# QA Plan — DSA DSA R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. QA Scope

**Test Targets:**
- SRS requirements: REQ-DSA-01 (report authoring), REQ-DSA-02 (report review), REQ-DSA-03 (vehicle log)
- Screens: Project detail / Tech advisory dashboard / Report compose·preview·edit / Vehicle log compose
- Change Brief In-Round items: Risk-factor emphasis on report preview screen (clients/dsa/DSA/change-briefs/2026-04-25-...md)

**Out of Scope (acknowledged, not tested):**
- Out-of-Scope items: (none)
- Confirm-Needed items: (none)

## 2. Test Roles / Accounts
- Primary roles: Tech Advisor, Org Admin
- Mock account mapping:
  - mock_advisor_dsa01 — role: Tech Advisor, 1 project assigned
  - mock_org_admin_dsa01 — role: Org Admin, review permission
- External dependencies: [TBD — INSEP sync / notification channel source not specified]

## 3. End-to-End Flow Map
```
mock_advisor login
└── Project detail
    └── Tech advisory dashboard
        ├── Report compose form
        │   ├── Risk-factor input
        │   ├── Improvement input
        │   └── Preview → Edit → Submit
        └── Review queue (mock_org_admin)
            └── Report detail → Approve / Reject
```

(design.md cross-check: risk-factor emphasis token uses `--color-danger`)

## 4. P0 Critical Scenarios (mandatory regression)

### P0-01: Tech Advisor authors and submits report (REQ-DSA-01)
- Role: Tech Advisor
- Preconditions: staging, mock_advisor_dsa01, 1 project assigned, 1 mock photo
- Steps (≤9):
  1. Log in as mock_advisor_dsa01 → main entry
  2. Project list → select assigned project
  3. Enter Tech advisory dashboard → click "Compose report"
  4. Upload 1 photo
  5. Enter risk factors
  6. Open preview → verify risk-factor emphasis (Change Brief In-Round verification)
  7. Edit → Submit
- Expected outcome: UI shows "Pending review" label / DB reports.status=`pending_review` / External [TBD]

### P0-02: Org Admin reviews and approves report (REQ-DSA-02)
- Role: Org Admin
- Preconditions: 1 report from P0-01 exists, mock_org_admin_dsa01
- Steps (≤9):
  1. Log in as mock_org_admin_dsa01
  2. Enter Review queue
  3. Select report from P0-01 → open detail
  4. Verify risk factors and improvements
  5. Click Approve
- Expected outcome: UI status changes to `approved` / DB reports.status=`approved`, reviewer recorded / External [TBD]

## 5. P1 Supporting Scenarios

### P1-01: Vehicle log entry (REQ-DSA-03)
- Role: Tech Advisor
- Preconditions: mock_advisor_dsa01, 1 vehicle assigned
- Steps (≤9):
  1. Open Vehicle menu
  2. Compose log → enter origin·destination·distance
  3. Save
- Expected outcome: UI log list updated / DB vehicle_logs row created

## 6. Edge / Negative Cases

### EDGE-01: Submit report without uploading photo
- Scenario: skip step 4 of P0-01
- Expected outcome: submission blocked, error message shown

### EDGE-02: Tech Advisor accesses another advisor's project
- Scenario: mock_advisor_dsa01 directly opens unassigned project URL
- Expected outcome: 403 or redirect to project list

## 7. Regression Checklist (R0 → R1)

### REG-01: Report submit status not reflected (R0 FAIL)
- Original scenario: P0-01 variant — after submit, list refresh did not show `pending_review`
- Round: R0 (previous)
- Re-run criteria: complete P0-01 then refresh list and view from another PM account

## 8. QA Handoff Message

```
Hi team,

Sharing the QA plan for DSA R1.

Scenarios in scope:
- P0 (mandatory): P0-01, P0-02
- P1 (supporting): P1-01
- EDGE: EDGE-01, EDGE-02
- REG: REG-01

Test environment:
- Staging URL: [TBD — DSA staging URL to be shared]
- Mock accounts: mock_advisor_dsa01 (Tech Advisor), mock_org_admin_dsa01 (Org Admin)
- Deadline: [TBD]

When reporting failures, please preserve the following meta on the first line of the report:
QA Plan: QA-DSA-20260428
Scenario: P0-NN

Reach out with any questions.
```

## 9. PM Review Items

- Staging URL needs to be shared (confirm with DSA dev team)
- External effects: notification channel / INSEP sync source missing → confirm with dev team
- Confirm deadline and reflect in §8

---

## Next Steps (no auto-execution, guidance only)

- §8 QA Handoff Message → use with `/client-chat` or `/qa-request`
- Bugs found during QA → `/qa-feedback` (preserve `QA Plan: QA-DSA-20260428` or `Scenario: P0-NN` on the first line of the report body)
- Significant bugs → `/issue-ticket` → Linear
- Status change: edit frontmatter `status:` directly (Draft → Review → Final)

---

> ⚠️ **This QA plan is for PM/QA internal validation.** Do not forward §1–§7 to client or dev team directly. §8 is the only client/QA-facing section.
