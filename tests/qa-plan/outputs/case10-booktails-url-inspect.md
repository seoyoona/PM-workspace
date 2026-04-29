---
status: Draft
client: booktails
project: Booktails
qa_plan_id: QA-BOOKTAILS-20260429
round: R1
created: 2026-04-29
author: PM
srs_ref: clients/booktails/Booktails/srs.md
brief_refs: []
design_md: missing
staging_url: https://staging.booktails.example/
pages_inspected:
  - /
  - /catalog
  - /catalog/{id}
  - /cart
  - /checkout
scope: all
---

# QA Plan — booktails Booktails R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

> ℹ️ **Staging URL inspected** — host: `staging.booktails.example`, depth 2 / pages 5 / 1 console error logged. Read-only guided navigation only (no form submit / save / delete / payment clicks).

## 1. QA Scope

**Test Targets:**
- SRS requirements: REQ-BOOKTAILS-01 (catalog browse), REQ-BOOKTAILS-02 (cart), REQ-BOOKTAILS-03 (checkout pre-payment)
- Screens (cross-checked via URL inspect): Landing / Catalog / Catalog detail / Cart / Checkout
- Change Brief In-Round items: (none)

**Out of Scope (acknowledged, not tested):**
- Out-of-Scope items: (none)
- Confirm-Needed items: (none)

## 2. Test Roles / Accounts
- Primary roles: regular member (guest browsing OK for catalog)
- Mock account mapping:
  - mock_member_bt01 — role: regular member
- External dependencies: payment provider sandbox (per SRS)

## 3. End-to-End Flow Map
```
Landing (/)
└── Catalog (/catalog)  [URL inspect: list paginated 20 items / day]
    └── Catalog detail (/catalog/{id})  [URL inspect: tabs Description·Reviews·Related]
        └── Add to cart [URL inspect: button found, NOT clicked — read-only]
            └── Cart (/cart)  [URL inspect: line items table, qty input, remove icon]
                └── Checkout (/checkout)  [URL inspect: address form + payment selector — read-only]
```

(URL inspect cross-checked SRS screen list. No discrepancies found in navigation hierarchy.)

## 4. P0 Critical Scenarios (mandatory regression)

### P0-01: Browse catalog and view detail (REQ-BOOKTAILS-01)
- Role: guest
- Preconditions: staging
- Steps (≤9):
  1. Open /
  2. Navigate to /catalog
  3. Verify list shows ≥1 item (URL inspect confirmed: 20 items first page)
  4. Click first item
  5. Verify detail tabs (Description / Reviews / Related — URL inspect confirmed)
- Expected outcome: UI item detail rendered / DB n/a / External n/a

### P0-02: Cart add and quantity update (REQ-BOOKTAILS-02)
- Role: regular member
- Preconditions: mock_member_bt01, ≥1 catalog item
- Steps (≤9):
  1. Log in as mock_member_bt01
  2. Open catalog detail
  3. Click "Add to cart"
  4. Open /cart
  5. Verify line item present
  6. Update quantity → 2
- Expected outcome: UI cart total reflects qty change / DB cart_items qty=2 / External n/a

### P0-03: Checkout pre-payment (REQ-BOOKTAILS-03)
- Role: regular member
- Preconditions: P0-02 completed, mock_member_bt01 with cart ≥1
- Steps (≤9):
  1. Open /cart
  2. Click "Checkout"
  3. Fill address (URL inspect: 5 fields — first/last name, street, city, postal)
  4. Select payment provider (URL inspect: 2 providers shown)
  5. Stop before payment submit (out of QA scope per SRS R1 — payment is R2)
- Expected outcome: UI form valid state / DB n/a (no order created) / External n/a

## 5. P1 Supporting Scenarios

(none in R1)

## 6. Edge / Negative Cases

### EDGE-01: Update quantity to 0 in cart
- Scenario: P0-02 step 6 with qty=0
- Expected outcome: line item removed or qty stays at 1 [TBD — SRS does not specify]

## 7. Regression Checklist (previous → R1)

(no regression items in this round)

## 8. QA Handoff Message

```
Hi team,

Sharing the QA plan for Booktails R1.

Scenarios in scope:
- P0 (mandatory): P0-01, P0-02, P0-03
- EDGE: EDGE-01

Test environment:
- Staging URL: https://staging.booktails.example/
- Mock accounts: mock_member_bt01 (regular member)
- Deadline: [TBD]

When reporting failures, please preserve the following meta on the first line of the report:
QA Plan: QA-BOOKTAILS-20260429
Scenario: P0-NN

Reach out with any questions.
```

## 9. PM Review Items

- URL inspect summary: visited 5/10 pages, 1 screenshot per page saved at `clients/booktails/Booktails/qa/plans/inspect/20260429-*.png`
- 1 console error on /catalog/{id} — `TypeError: Cannot read property 'rating'` ([TBD] — confirm with dev whether this is fix-needed or unrelated)
- EDGE-01 qty=0 behavior not specified in SRS — confirm
- Deadline to be shared

---

## Next Steps (no auto-execution, guidance only)

- §8 QA Handoff Message → use with `/client-chat` or `/qa-request`
- Bugs found during QA → `/qa-feedback` (preserve `QA Plan: QA-BOOKTAILS-20260429` or `Scenario: P0-NN` on the first line of the report body)
- Significant bugs → `/issue-ticket` → Linear
- Status change: edit frontmatter `status:` directly (Draft → Review → Final)

---

> ⚠️ **This QA plan is for PM/QA internal validation.** Do not forward §1–§7 to client or dev team directly. §8 is the only client/QA-facing section.
