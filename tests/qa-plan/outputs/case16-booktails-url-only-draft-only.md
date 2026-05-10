---
status: Draft only
client: booktails
project: Booktails
qa_plan_id: QA-BOOKTAILS-20260510
round: R1
created: 2026-05-10
author: PM
srs_ref: missing
brief_refs: []
design_md: missing
staging_url: https://dev.maptails.example/
pages_inspected:
  - /
  - /browse
  - /login
  - /signup
  - /support
auth_used: none
scope: all
---

## Source Coverage
- SRS: missing
- URL inspect: done
- design.md: missing
- Change Brief: missing
- QA history: missing
- Confidence: Draft only

> ⚠️ Plan body blocked — source insufficient. URL inspect alone does not promote to Medium (v1.1.2). URL is implementation evidence, not a baseline source for QA scenario invention. Provide SRS and re-invoke. URL inspect results are recorded in §3 (observed facts only) and §9 (SRS-Implementation Deviation list).

---

# QA Plan — booktails Booktails R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

> ℹ️ **Staging URL inspected** — host: `dev.maptails.example`, depth 2 / pages 5 / 0 console errors. Read-only guided navigation only (no form submit / save / delete / payment clicks). Plan body §4–§7 blocked because SRS is missing — URL alone is implementation evidence, not baseline truth.

## 1. QA Scope

**Test Targets:**
- SRS requirements: [TBD — SRS not linked]
- Screens (URL inspect observed only): /, /browse, /login, /signup, /support
- Change Brief In-Round items: (none)

**Out of Scope (acknowledged, not tested):**
- Out-of-Scope items: (none)
- Confirm-Needed items: (none)

## 2. Test Roles / Accounts
- [TBD] — roles cannot be defined without SRS. URL inspect observed login + signup pages but the role taxonomy (member / admin / parent / child / etc.) is not derivable from staging UI alone.
- External dependencies: [TBD]

## 3. End-to-End Flow Map

Observed page structure from URL inspect (read-only, depth 2 / pages 5):

```
/ (Landing)
├── /browse  [Observed: collection list, "Generate" buttons visible]
├── /login   [Observed: email + password fields, "Kakao로 시작" + "Naver로 시작" + "Sign up" links]
├── /signup  [Observed: email + password + nickname fields]
└── /support [Observed: 1:1 inquiry form, name + email + message fields]
```

**Important:** the above is observed staging UI fact only. Whether each surface is part of the intended product scope, an MVP placeholder, or a regression cannot be determined without SRS. See §9 SRS-Implementation Deviation.

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

- **Plan body blocked due to insufficient source.** SRS missing. URL inspect alone is implementation evidence and cannot be promoted to baseline truth (v1.1.2 no-invention rule). SRS 제공 후 재호출 필요.

**SRS-Implementation Deviation (URL inspect found surfaces — SRS not linked, intent unconfirmed):**

URL inspect observed the following surfaces in staging. Confirm with PM whether each is in the intended product scope (SRS update) or an out-of-scope implementation artifact (revert). Do NOT promote any of these to P0/P1/EDGE/REG until SRS confirms scope:

- `/login` — email + password authentication form. SRS not linked, intent unconfirmed.
- `/login` — "Kakao로 시작" / "Naver로 시작" social login buttons. Provider scope unconfirmed.
- `/signup` — direct email signup form. Self-signup intent unconfirmed.
- `/support` — internal `/support` form. Public support flow vs internal-only access unconfirmed.
- `/browse` — Generate buttons visible without auth. Anonymous access scope unconfirmed.

**Source request:**

- To unblock §4–§7, provide SRS via `--srs <path or Notion URL>` and re-invoke `/qa-plan booktails --srs <...> --url https://dev.maptails.example/`
- Per Source Coverage gate (v1.1.2), `SRS = missing` triggers Draft only regardless of URL inspect status. URL alone cannot raise Confidence to Medium.

---

## Next Steps (no auto-execution, guidance only)

- Provide SRS and re-invoke `/qa-plan booktails --srs <...> --url https://dev.maptails.example/`
- §8 QA Handoff Message → not generated this round (plan blocked)
- Status change: re-run with sufficient source (status: Draft only → Draft once §4–§7 are populated)

---

> ⚠️ **This QA plan is for PM/QA internal validation.** Do not forward §1–§7 to client or dev team directly. §8 is the only client/QA-facing section.
