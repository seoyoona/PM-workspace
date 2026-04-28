---
status: Draft
client: {client}
project: {project_or_unknown}
qa_plan_id: QA-{CLIENT}-YYYYMMDD
round: R{N}
created: {YYYY-MM-DD}
author: {PM}
srs_ref: {path or "missing"}
brief_refs: []
design_md: {path or "missing"}
scope: {free-text or "all"}
---

# QA Plan — {client} {project} R{N}

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. QA Scope

**Test Targets:**
- SRS requirements: {REQ-X-NN list or "[TBD — SRS not linked]"}
- Screens: {screen names / URLs or "[TBD]"}
- Change Brief In-Round items: {brief quote or `(none)`}

**Out of Scope (acknowledged, not tested):**
- Out-of-Scope items: {brief Out-of-Scope quote or `(none)`}
- Confirm-Needed items: {brief Confirm-Needed quote or `(none)`}

## 2. Test Roles / Accounts
- Primary roles: {e.g., regular member / org admin / external user}
- Mock account mapping:
  - mock_<role>_01 — role: <role>, data: <description>
  - (Use mock identifiers, not real credentials)
- External dependencies: {payment mock / email mock / push token / or "[TBD]"}

## 3. End-to-End Flow Map
Text tree or table (no Mermaid in v1).

```
Entry
├── <Screen 1>
│   ├── Action → <Screen 2>
│   └── Action → <Screen 3>
└── <Alternate entry>
    └── ...
```

Reference design.md screen names if available (UI-representation cross-check only).

## 4. P0 Critical Scenarios (mandatory regression)

### P0-01: {one-line title}
- Role: {primary role}
- Preconditions: {environment / account / external dependencies, one line}
- Steps (≤9 recommended):
  1. {action} → {expected immediate result}
  2. ...
- Expected outcome: UI {final state} / DB {record changes} / External {API call or "[TBD]"}

### P0-02: {...}
...

(If no P0 scenarios: `(none)`)

## 5. P1 Supporting Scenarios (per-round)

### P1-01: {...}
- Role: ...
- Preconditions: ...
- Steps (≤9 recommended):
- Expected outcome: ...

(If no P1 scenarios: `(none)`)

## 6. Edge / Negative Cases
**Source-grounded only. No speculation.**

### EDGE-01: {input validation failure}
- Scenario: ...
- Expected outcome: ...

### EDGE-02: {permission boundary}
- ...

(If no EDGE cases: `(none)`)

## 7. Regression Checklist (round N → N-1)

### REG-01: {prior-round FAIL re-run}
- Original scenario: <SCN-... or P0-NN>
- Round: R{N-1}
- Re-run criteria: ...

### REG-02: {Change Brief In-Round impact area}
- ...

(If no REG items: `(no regression items in this round)`)

## 8. QA Handoff Message

Copy/paste this block to send to QA / client:

```
Hi team,

Sharing the QA plan for {client} / {project} R{N}.

Scenarios in scope:
- P0 (mandatory): P0-01, P0-02, ...
- P1 (supporting): P1-01, ...
- EDGE: EDGE-01, ...
- REG: REG-01, ...

Test environment:
- Staging URL: {URL or "[TBD]"}
- Mock accounts: {account list}
- Deadline: {date or "[TBD]"}

When reporting failures, please preserve the following meta on the first line of the report:
QA Plan: QA-{CLIENT}-YYYYMMDD
Scenario: P0-NN

Reach out with any questions.
```

## 9. PM Review Items

- {SRS not linked / Change Brief not linked / design.md missing — [TBD] items}
- {musing-tone items — not promoted to Decision}
- {external effects (email / push) without source}
- {scenario count cap (screens × 1.5) exceeded — split / consolidate review}
- {project resolution = 0 — input required from PM}

(If no review items: `(none)`)

---

## Next Steps (no auto-execution, guidance only)

- §8 QA Handoff Message → use with `/client-chat` or `/qa-request`
- Bugs found during QA → `/qa-feedback` (preserve `QA Plan: QA-<CLIENT>-YYYYMMDD` or `Scenario: P0-NN` on the first line of the report body)
- Significant bugs → `/issue-ticket` → Linear
- Status change: edit frontmatter `status:` directly (Draft → Review → Final)

---

> ⚠️ **This QA plan is for PM/QA internal validation.** Do not forward §1–§7 directly to the client or dev team. §8 is the only client/QA-facing section.
