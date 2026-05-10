---
status: Draft only
client: connectory
project: connectory
qa_plan_id: QA-CONNECTORY-20260510
round: R1
created: 2026-05-10
author: PM
srs_ref: missing
brief_refs: []
design_md: clients/connectory/connectory/design.md
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

> ⚠️ Plan body blocked — source insufficient. Provide SRS or staging URL and re-invoke. design.md and CLAUDE.md alone do not pass the minimum source gate (v1.1.1).

---

# QA Plan — connectory connectory R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. QA Scope

**Test Targets:**
- SRS requirements: [TBD — SRS not linked]
- Screens: design.md screen names available for cross-check only (not used as primary source)
- Change Brief In-Round items: (none)

**Out of Scope (acknowledged, not tested):**
- Out-of-Scope items: (none)
- Confirm-Needed items: (none)

## 2. Test Roles / Accounts
- (blocked — see Source Coverage)

## 3. End-to-End Flow Map
- (blocked — see Source Coverage)

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

- **Plan body blocked due to insufficient source.** SRS 또는 staging URL 제공 후 재호출 필요.
- design.md alone is insufficient — design.md is a UI representation aid only, not a primary source for QA scope / functional flow / permissions / data conditions
- CLAUDE.md and glossary alone are insufficient — client context is not a baseline requirement source
- To unblock §4–§7, provide one of the following and re-invoke:
  - `--srs <path or Notion URL>` for SRS reference
  - `--url <staging URL>` for read-only guided navigation (URL inspect role = implementation evidence, used to cross-check SRS-defined features)
  - Both together yield Confidence: High

---

## Next Steps (no auto-execution, guidance only)

- Provide SRS or staging URL and re-invoke `/qa-plan connectory --srs <...>` or `/qa-plan connectory --url <...>`
- §8 QA Handoff Message → not generated this round (plan blocked)
- Status change: re-run with sufficient source (status: Draft only → Draft once §4–§7 are populated)

---

> ⚠️ **This QA plan is for PM/QA internal validation.** Do not forward §1–§7 to client or dev team directly. §8 is the only client/QA-facing section.
