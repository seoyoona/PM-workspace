---
status: Draft
client: booktails
project: Booktails
qa_plan_id: QA-BOOKTAILS-20260510
round: R1
created: 2026-05-10
author: PM
srs_ref: clients/booktails/Booktails/srs.md
brief_refs: []
design_md: missing
staging_url: rejected (production pattern)
pages_inspected: []
auth_used: none
scope: all
---

## Source Coverage
- SRS: found
- URL inspect: not available
- design.md: missing
- Change Brief: missing
- QA history: missing
- Confidence: Medium

> ℹ️ URL inspect refused — production URL pattern detected. Plan body written from SRS alone. Provide a staging URL and re-invoke if implementation cross-check is needed.

---

# QA Plan — booktails Booktails R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. QA Scope

**Test Targets:**
- SRS requirements: REQ-BOOKTAILS-01 (Kakao+Naver social login), REQ-BOOKTAILS-02 (worksheet generation pipeline), REQ-BOOKTAILS-03 (credit-based payment), REQ-BOOKTAILS-04 (admin manual credit grant)
- Screens: Login / Worksheet generator / Cart / Checkout / Admin credit panel (per SRS, no URL cross-check this round)
- Change Brief In-Round items: (none)

**Out of Scope (acknowledged, not tested):**
- Out-of-Scope items: (none)
- Confirm-Needed items: (none)

## 2. Test Roles / Accounts
- Primary roles: regular member (parent), admin
- Mock account mapping:
  - mock_member_bt01 — role: regular member, default credits 0
  - mock_admin_bt01 — role: admin, manual credit grant capability
- External dependencies: payment provider sandbox, Kakao OAuth mock, Naver OAuth mock

## 3. End-to-End Flow Map
```
Entry
├── Login (Kakao / Naver)
│   └── Member home
│       ├── Browse collections
│       │   └── Worksheet detail → Generate (1 credit)
│       │       └── PDF download
│       └── Cart → Checkout (PG sandbox) → Credit balance update
└── Admin login
    └── Admin credit panel → Grant credits to member
```

(Flow derived from SRS only this round — staging URL not inspected.)

## 4. P0 Critical Scenarios (mandatory regression)

### P0-01: Kakao login → first-time member onboarding
- Role: regular member
- Preconditions: fresh Kakao account, no prior session
- Steps (≤9 recommended):
  1. Tap "Kakao로 시작" → Kakao OAuth consent screen
  2. Approve scopes (email, profile) → redirect to /onboarding
  3. Onboarding form: nickname → submit
  4. Confirm member home loads with default credits 0
- Expected outcome: UI shows member home / DB users row created with kakao provider / External Kakao ID stored

### P0-02: Naver login (existing member)
- Role: regular member
- Preconditions: Naver-linked member exists in DB
- Steps (≤9 recommended):
  1. Tap "Naver로 시작" → Naver OAuth consent
  2. Approve → redirect home
- Expected outcome: UI member home / DB last_login_at updated / no duplicate user row

### P0-03: Worksheet generation costs 1 credit
- Role: regular member
- Preconditions: member with 1+ credits
- Steps (≤9 recommended):
  1. Navigate to a Collection → select keyword
  2. Tap Generate → AI pipeline run
  3. Confirm PDF preview loads
  4. Check credit balance decreased by 1
- Expected outcome: UI PDF preview / DB credits_log entry / External AI pipeline call logged

## 5. P1 Supporting Scenarios

### P1-01: Admin manual credit grant
- Role: admin
- Preconditions: admin authenticated, target member exists
- Steps (≤9 recommended):
  1. Admin login
  2. Navigate to credit panel
  3. Search target member by ID
  4. Enter grant amount → submit
- Expected outcome: UI grant confirmation / DB credits_log admin_grant entry / Member balance updated

## 6. Edge / Negative Cases

### EDGE-01: Insufficient credits at generation
- Scenario: member with 0 credits attempts to generate
- Expected outcome: UI shows "credits needed" prompt / no AI pipeline call / no credit deduction

### EDGE-02: OAuth consent denied
- Scenario: user denies Kakao/Naver consent
- Expected outcome: UI returns to login screen with error / no user row created

## 7. Regression Checklist

(no regression items in this round)

## 8. QA Handoff Message

Copy/paste this block to send to QA / client:

```
Hi team,

Sharing the QA plan for booktails / Booktails R1.

Scenarios in scope:
- P0 (mandatory): P0-01, P0-02, P0-03
- P1 (supporting): P1-01
- EDGE: EDGE-01, EDGE-02
- REG: (none)

Test environment:
- Staging URL: [TBD — production URL was rejected this round, please provide staging URL]
- Mock accounts: mock_member_bt01 / mock_admin_bt01
- Deadline: [TBD]

When reporting failures, please preserve the following meta on the first line of the report:
QA Plan: QA-BOOKTAILS-20260510
Scenario: P0-NN

Reach out with any questions.
```

## 9. PM Review Items

- **Production URL rejected by Pre-flight check.** Input: `https://www.booktails.com/` matched production pattern (`www.` prefix + no staging/test/dev keyword). browser_navigate refused. Re-invoke with staging URL when implementation cross-check is needed.
- **Staging URL not yet provided** — provide a staging/dev/test domain to enable §3 Flow Map cross-check and §9 SRS-Implementation Deviation routing.
- design.md missing — UI cross-check unavailable this round
- Change Brief missing — `clients/booktails/Booktails/change-briefs/` empty for this round
- QA history empty — no prior-round feedback materials

---

## Next Steps (no auto-execution, guidance only)

- Re-invoke with staging URL: `/qa-plan booktails --srs clients/booktails/Booktails/srs.md --url https://staging.booktails.example/` (or any non-production host)
- §8 QA Handoff Message → use with `/client-chat` or `/qa-request` once staging URL is confirmed
- Bugs found during QA → `/qa-feedback` (preserve `QA Plan: QA-BOOKTAILS-20260510` or `Scenario: P0-NN` on the first line of the report body)
- Significant bugs → `/issue-ticket` → Linear

---

> ⚠️ **This QA plan is for PM/QA internal validation.** Do not forward §1–§7 to client or dev team directly. §8 is the only client/QA-facing section.
