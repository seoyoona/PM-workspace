---
status: Draft only
client: connectory
project: Connectory-2
qa_plan_id: QA-CONNECTORY-20260428
round: R1
created: 2026-04-28
author: PM
srs_ref: missing
brief_refs: []
design_md: clients/Connectory/Connectory-2/design.md
staging_url: not_inspected
pages_inspected: []
auth_used: none
scope: all
---

## Source Coverage
- SRS: missing
- URL inspect: not provided
- design.md: found
- Change Brief: missing
- QA history: missing
- Confidence: Draft only

> ⚠️ Plan body blocked — source insufficient. design.md alone does not pass the minimum source gate (v1.1.1). primary source insufficient — no-invention rule applies. Provide SRS or staging URL and re-invoke.

---

# QA Plan — connectory Connectory-2 R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. QA Scope

**Test Targets:**
- SRS requirements: [TBD — SRS not linked]
- Screens: design.md exists for UI cross-check only. Per no-invention rule, design.md cannot be used as primary source for QA scope or feature flow.
- Change Brief In-Round items: (none)

**Out of Scope (acknowledged, not tested):**
- (blocked — see Source Coverage)

## 2. Test Roles / Accounts
- (blocked — see Source Coverage)

## 3. End-to-End Flow Map
- (blocked — see Source Coverage)

(design.md screen components / tokens may be referenced for UI representation cross-check only, but "how the user flows" is not inferred — primary source insufficient.)

## 4. P0 Critical Scenarios (mandatory regression)

(blocked — see Source Coverage)

## 5. P1 Supporting Scenarios

(blocked — see Source Coverage)

## 6. Edge / Negative Cases

(blocked — see Source Coverage)

## 7. Regression Checklist

(blocked — see Source Coverage)

## 8. QA Handoff Message

(not generated — plan blocked)

## 9. PM Review Items

- **Plan body blocked due to insufficient source.** primary source insufficient — no-invention rule applies. design.md alone cannot be used to invent scenarios.
- **SRS missing** — confirm clients/Connectory/Connectory-2/srs.md or Notion project doc DB
- **Change Brief missing** — clients/Connectory/Connectory-2/change-briefs/ is empty
- **QA history missing** — no prior-round feedback materials
- **design.md found** — UI tokens / components are defined and may be used for §3 screen-name cross-check only. design.md is NOT a primary source for QA scope, feature flow, permissions, or data conditions (no-invention rule).
- To unblock §4–§7, provide one of the following and re-invoke:
  - `--srs <path or Notion URL>` for SRS reference
  - `--url <staging URL>` for read-only guided navigation

---

## Next Steps (no auto-execution, guidance only)

- Provide SRS or staging URL and re-invoke `/qa-plan connectory --project Connectory-2 --srs <...>` or `... --url <...>`
- §8 QA Handoff Message → not generated this round (plan blocked)
- Status change: re-run with sufficient source (status: Draft only → Draft once §4–§7 are populated)

---

> ⚠️ **This QA plan is for PM/QA internal validation.** Do not forward §1–§7 to client or dev team directly. §8 is the only client/QA-facing section.
