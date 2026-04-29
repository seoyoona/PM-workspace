---
status: Draft
client: dsa
project: DSA
qa_plan_id: QA-DSA-20260429
round: R1
created: 2026-04-29
author: PM
srs_ref: clients/dsa/DSA/srs.md
brief_refs: []
design_md: clients/dsa/DSA/design.md
staging_url: https://staging.dsa.example/
pages_inspected:
  - /admin/login
  - /admin/dashboard
  - /admin/projects
  - /admin/projects/{id}
  - /admin/reports/queue
  - /admin/reports/{id}
auth_used: mock_org_admin_dsa01
scope: admin review flow
---

# QA Plan — dsa DSA R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

> ℹ️ **Staging URL inspected (with login)** — host: `staging.dsa.example`, depth 2 / pages 6 / auth: mock_org_admin_dsa01 (1 login attempt, success). Read-only guided navigation only after login (no form submit / save / delete clicks).

## 1. QA Scope

**Test Targets:**
- SRS requirements: REQ-DSA-02 (report review), REQ-DSA-04 (admin dashboard)
- Screens (cross-checked via authenticated URL inspect): Admin login / Admin dashboard / Project list / Project detail / Review queue / Report detail
- Change Brief In-Round items: (none)

**Out of Scope (acknowledged, not tested):**
- Out-of-Scope items: (none)
- Confirm-Needed items: (none)

## 2. Test Roles / Accounts
- Primary roles: Org Admin
- Mock account mapping:
  - mock_org_admin_dsa01 — role: Org Admin (used for inspection login)
- External dependencies: notification channel mock (per SRS)

## 3. End-to-End Flow Map
```
mock_org_admin_dsa01 login (/admin/login)
└── Admin dashboard (/admin/dashboard)  [URL inspect: KPI cards, nav menu confirmed]
    ├── Project list (/admin/projects)  [URL inspect: 12 projects, filter by status]
    │   └── Project detail (/admin/projects/{id})  [URL inspect: tabs Overview·Reports·Members]
    └── Review queue (/admin/reports/queue)  [URL inspect: 5 pending reports]
        └── Report detail (/admin/reports/{id})  [URL inspect: Approve/Reject buttons present, NOT clicked — read-only]
```

(URL inspect cross-checked SRS admin flow. Approve/Reject buttons confirmed present but not clicked per read-only rule.)

## 4. P0 Critical Scenarios (mandatory regression)

### P0-01: Org Admin login and dashboard access (REQ-DSA-04)
- Role: Org Admin
- Preconditions: staging, mock_org_admin_dsa01
- Steps (≤9):
  1. Open /admin/login
  2. Enter mock_org_admin_dsa01 credentials
  3. Submit
  4. Verify redirect to /admin/dashboard
  5. Verify KPI cards rendered
- Expected outcome: UI dashboard with KPI cards / DB sessions row / External n/a

### P0-02: Org Admin reviews pending report (REQ-DSA-02)
- Role: Org Admin
- Preconditions: P0-01 completed, ≥1 pending report
- Steps (≤9):
  1. Open /admin/reports/queue
  2. Verify pending list (URL inspect confirmed: 5 pending)
  3. Click first report → /admin/reports/{id}
  4. Verify risk-factor and improvement sections rendered
  5. Click Approve
- Expected outcome: UI status changes to `approved` / DB reports.status=`approved`, reviewer recorded / External notification sent [TBD]

## 5. P1 Supporting Scenarios

### P1-01: Project filter on admin list (REQ-DSA-04)
- Role: Org Admin
- Preconditions: P0-01 completed
- Steps (≤9):
  1. Open /admin/projects
  2. Apply status filter (URL inspect: filter dropdown found)
  3. Verify list updates
- Expected outcome: UI filtered list / DB n/a / External n/a

## 6. Edge / Negative Cases

### EDGE-01: Org Admin opens another tenant's project URL directly
- Scenario: Direct URL access to a project not under this admin's tenant
- Expected outcome: 403 or redirect to /admin/projects [TBD — SRS does not specify exact behavior]

## 7. Regression Checklist (previous → R1)

(no regression items in this round)

## 8. QA Handoff Message

```
Hi team,

Sharing the QA plan for DSA R1 (admin review flow).

Scenarios in scope:
- P0 (mandatory): P0-01, P0-02
- P1 (supporting): P1-01
- EDGE: EDGE-01

Test environment:
- Staging URL: https://staging.dsa.example/
- Mock accounts: mock_org_admin_dsa01 (Org Admin) — credentials from PM
- Deadline: [TBD]

When reporting failures, please preserve the following meta on the first line of the report:
QA Plan: QA-DSA-20260429
Scenario: P0-NN

Reach out with any questions.
```

## 9. PM Review Items

- URL inspect summary: visited 6/10 pages after login, 1 screenshot per page saved at `clients/dsa/DSA/qa/plans/inspect/20260429-*.png`
- auth: mock_org_admin_dsa01 — success / 1 login attempt / post-login pages: 5
- Approve/Reject button click NOT executed during inspect (read-only enforced) — actual Approve flow tested in P0-02 by QA team
- EDGE-01 cross-tenant access behavior not specified in SRS — confirm with dev
- Deadline to be shared

---

## Next Steps (no auto-execution, guidance only)

- §8 QA Handoff Message → use with `/client-chat` or `/qa-request`
- Bugs found during QA → `/qa-feedback` (preserve `QA Plan: QA-DSA-20260429` or `Scenario: P0-NN` on the first line of the report body)
- Significant bugs → `/issue-ticket` → Linear
- Status change: edit frontmatter `status:` directly (Draft → Review → Final)

---

> ⚠️ **This QA plan is for PM/QA internal validation.** Do not forward §1–§7 to client or dev team directly. §8 is the only client/QA-facing section.
