---
status: Draft
client: connectory
project: Connectory-1
qa_plan_id: QA-CONNECTORY-20260428
round: R1
created: 2026-04-28
author: PM
srs_ref: missing
brief_refs: [clients/Connectory/Connectory-1/change-briefs/2026-04-27-payment-currency-admin-points.md]
design_md: missing
scope: all
---

# QA Plan — connectory Connectory-1 R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. QA Scope

**Test Targets:**
- SRS requirements: [TBD — SRS not linked]
- Screens: Point top-up screen (extracted from Change Brief)
- Change Brief In-Round items: Add CNY-KRW currency notice on payment screen

**Out of Scope (acknowledged, not tested):**
- Out-of-Scope items: (none)
- Confirm-Needed items: Admin manual point adjustment — confirm whether MVP estimate includes this

## 2. Test Roles / Accounts
- Primary roles: regular member (Chinese user)
- Mock account mapping:
  - mock_cn_user_01 — role: regular member, points balance 0
- External dependencies: Toss payment sandbox

## 3. End-to-End Flow Map
```
mock_cn_user_01 login
└── Point top-up screen (`/payment/points`)
    ├── Package selection (CNY display)
    ├── Payment notice area (KRW conversion shown — Change Brief verification)
    └── Pay (Toss sandbox)
```

(design.md missing — detailed UI cross-check not available)

## 4. P0 Critical Scenarios (mandatory regression)

### P0-01: Chinese user sees CNY-KRW currency notice during payment (Change Brief In-Round)
- Role: regular member (Chinese user)
- Preconditions: staging, mock_cn_user_01, FX mock enabled, Toss sandbox
- Steps (≤9):
  1. Log in as mock_cn_user_01
  2. Open Point top-up screen
  3. Select 100 CNY package
  4. Verify payment notice area shows CNY-KRW conversion line
  5. Proceed to pay → Toss modal displays KRW amount
- Expected outcome: UI shows extra conversion line / DB payment row currency_displayed=CNY, charged=KRW / External Toss sandbox KRW call

## 5. P1 Supporting Scenarios

(none)

## 6. Edge / Negative Cases

### EDGE-01: FX mock failure
- Scenario: FX API returns failure response
- Expected outcome: payment notice area shows fallback line [TBD — fallback policy source not specified]

## 7. Regression Checklist (previous → R1)

(no regression items in this round — prior-round info not linked)

## 8. QA Handoff Message

```
Hi team,

Sharing the QA plan for Connectory-1 R1.

Scenarios in scope:
- P0 (mandatory): P0-01
- EDGE: EDGE-01

Test environment:
- Staging URL: [TBD]
- Mock accounts: mock_cn_user_01 (regular member, Chinese user)
- Deadline: [TBD]

When reporting failures, please preserve the following meta on the first line of the report:
QA Plan: QA-CONNECTORY-20260428
Scenario: P0-NN

Reach out with any questions.
```

## 9. PM Review Items

- SRS not linked — confirm with Nexus Agent / dev team
- design.md missing — detailed UI cross-check requires design owner
- Staging URL / deadline to be shared
- Fallback policy on FX API failure not specified → confirm with dev

---

## Next Steps (no auto-execution, guidance only)

- §8 QA Handoff Message → use with `/client-chat` or `/qa-request`
- Bugs found during QA → `/qa-feedback` (preserve meta on the first line of the report body)
- Significant bugs → `/issue-ticket` → Linear
- Status change: edit frontmatter `status:` directly

---

> ⚠️ **This QA plan is for PM/QA internal validation.** Do not forward §1–§7 to client or dev team directly. §8 is the only client/QA-facing section.
