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
staging_url: https://dev.maptails.example/
pages_inspected:
  - /
  - /browse
  - /login/
  - /signup/
  - /support
auth_used: none
scope: all
---

## Source Coverage
- SRS: found
- URL inspect: done
- design.md: missing
- Change Brief: missing
- QA history: missing
- Confidence: High

> SRS + URL inspect both present. URL inspect role = implementation evidence only. SRS-only features are scoped into P0/P1. Staging-only surfaces routed to §9 SRS-Implementation Deviation.

---

# QA Plan — booktails Booktails R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

> ℹ️ **Staging URL inspected** — host: `dev.maptails.example`, depth 2 / pages 5 / 0 destructive clicks. Read-only guided navigation only.

## 1. QA Scope

**Test Targets:**
- SRS requirements: REQ-AUTH-01 (Kakao + Naver social login), REQ-AUTH-02 (signup → free credit), REQ-AI-01..05 (worksheet generation pipeline), REQ-DATA-01..04 (worksheet save/list/detail/complaint), REQ-PAY-01..02 (payment webhook + credit recharge), REQ-REWARD-01 (promo code 2 credits, no dup per user), Admin scope (chips / banners / users / payments / promotions / logs / blacklist)
- Screens (cross-checked via URL inspect): / Home, /browse 콜렉션, /login/, /signup/ (existence only — see §9 for SRS-Implementation Deviation on email/password)
- Change Brief In-Round items: (none — no Change Brief linked)

**Out of Scope (acknowledged, not tested):**
- Out-of-Scope items: discount logic (per SRS §4.A), refund execution inside Admin (per SRS §3.1)
- Confirm-Needed items: (none)

## 2. Test Roles / Accounts
- Primary roles: regular_user (parent), admin (operator)
- Mock account mapping:
  - mock_regular_user_kakao — role: regular_user via Kakao
  - mock_regular_user_naver — role: regular_user via Naver
  - mock_admin_bt01 — role: admin
- External dependencies: OpenAI API (mock or live — confirm with BE), PG sandbox (PortOne / Toss), Kakao + Naver developer test accounts

## 3. End-to-End Flow Map
```
User Service (https://dev.maptails.example/)
├── / Home — generation form, recommended chips, banner, free worksheet cards
├── /browse 콜렉션 — 7 categories × 4 cards (FE-hardcoded)
└── /login/ — Kakao + Naver social entry [SRS REQ-AUTH-01]

Admin (separate host — not inspected this round)
├── /users — manual credit grant/deduct
├── /payments — PG mapping
├── /promotions — code lifecycle
└── /blacklist — keyword block
```

(URL inspect cross-checked SRS screen list. Screen names matched. Additional staging-only surfaces routed to §9.)

## 4. P0 Critical Scenarios (mandatory regression)

### P0-01: Kakao social login + free credit grant (REQ-AUTH-01, REQ-AUTH-02)
- Role: mock_regular_user_kakao (brand-new account)
- Preconditions: Kakao test account ready, BE Auth API connected
- Steps (≤9):
  1. Open `/login/` → click "Kakao로 계속하기"
  2. Approve consent on Kakao OAuth
  3. Verify JWT issued and stored client-side
  4. In admin /users, search by Kakao email → row shows 가입 경로 = `카카오`
  5. Verify 크레딧 = configured free-credit (exact amount per BE confirmation)
  6. Sign out, sign in again with same Kakao account → no duplicate signup
- Expected outcome: UI logged-in / DB 1 user row + 1 free-credit ledger entry / External Kakao token validated

### P0-02: Naver social login + free credit grant (REQ-AUTH-01, REQ-AUTH-02)
- Role: mock_regular_user_naver
- Preconditions: Naver test account ready
- Steps (≤9):
  1. Open `/login/` → click "Naver로 계속하기"
  2. Approve consent on Naver OAuth
  3. Verify JWT issued
  4. In admin /users, verify 가입 경로 reflects Naver
  5. Verify free-credit grant applied
- Expected outcome: UI logged-in / DB 1 user row + free-credit / External Naver token validated

### P0-03: Worksheet generation E2E (REQ-AI-01..05, REQ-DATA-01)
- Role: regular_user (logged in, ≥1 credit)
- Preconditions: OpenAI reachable, blacklist seeded
- Steps (≤9):
  1. Open Home generation form
  2. Enter safe keyword + 대상 연령 + 대상 언어 + 테마 → submit
  3. Verify Gatekeeper → Classifier → Generator pipeline runs
  4. Verify worksheet renders in viewer
  5. In admin /users, verify 크레딧 −1
  6. In admin /logs, verify new row with matching User ID + 키워드
- Expected outcome: UI worksheet rendered / DB Credit_Ledger debit + Worksheet row + Operational Log row

### P0-04: Credit rollback on AI pipeline failure (REQ-AI-04)
- Role: regular_user (≥1 credit)
- Preconditions: BE configured to surface forced AI failure
- Steps (≤9):
  1. Note balance B
  2. Submit generation that fails mid-pipeline
  3. Verify error UX surfaces
  4. Verify admin /users balance = B (rollback succeeded)
  5. Verify no Worksheet row created
  6. Retry with valid input → balance becomes B − 1
- Expected outcome: UI failure surfaced / DB no net debit on failed attempt / External 0 saved Worksheet rows

### P0-05: Payment webhook reaches 결제 상태 = 완료 (REQ-PAY-01, REQ-PAY-02)
- Role: regular_user (0 credits)
- Preconditions: PG sandbox configured
- Steps (≤9):
  1. Initiate paid credit purchase from user side
  2. Complete PG sandbox payment
  3. Wait for PG webhook → BE verifies → Credit_Ledger insert
  4. Open admin /payments → row shows PG 거래 ID, 결제 상태 = `완료`
  5. Open admin /users → balance reflects credit recharge
- Expected outcome: UI balance updates / DB Credit_Ledger row + /payments status 완료 / External webhook signature verified

### P0-06: Promotion code grants credits + duplicate-claim block (REQ-REWARD-01)
- Role: regular_user (fresh account)
- Preconditions: Active promo code in admin /promotions
- Steps (≤9):
  1. Sign in, note balance B
  2. Redeem active promo code
  3. Verify balance = B + (code's 지급 크레딧)
  4. Re-redeem same code with same account → expect rejection
  5. Sign in as different user → redeem same code → expect success
- Expected outcome: UI duplicate-claim error / DB enforces (user_id, promo_code) uniqueness

### P0-07: Blacklist filter blocks generation (REQ-AI-05)
- Role: regular_user (≥1 credit)
- Preconditions: Blacklist seeded
- Steps (≤9):
  1. Note balance B
  2. Submit generation with blacklisted keyword
  3. Verify generation blocked before AI call
  4. Verify admin /users balance = B (no debit)
  5. Submit valid keyword → succeeds, balance = B − 1
- Expected outcome: UI block message / DB no debit, no Worksheet row / External 0 OpenAI calls

### P0-08: Admin login + manual credit 지급/차감 (CS)
- Role: admin (admin@gmail.com / 123123123)
- Preconditions: ≥1 regular_user exists
- Steps (≤9):
  1. Sign in to admin
  2. Navigate to /users → search target user
  3. Note 크레딧 = B
  4. Click 지급 → enter +N → save
  5. Verify 크레딧 = B + N
  6. Click 차감 → enter −M → save → verify 크레딧 = B + N − M
- Expected outcome: UI admin user row reflects new balance / DB 2 ledger rows

## 5. P1 Supporting Scenarios

### P1-01: Recommended chips + banners + theme dropdown (REQ-API-01..04)
- Role: regular_user (logged in or guest)
- Preconditions: Admin has seeded chips + banners
- Steps (≤9):
  1. Open Home
  2. Verify recommended-keyword chips render (admin / seed)
  3. Verify banner blocks render with target links from admin /banners
  4. Open theme dropdown → verify options populate (REQ-API-04)
  5. Tap a banner → external link opens
- Expected outcome: UI all blocks render / DB read-only / External banner link opens

### P1-02: Collection click triggers AI pipeline (REQ-API-03 updated)
- Role: regular_user (logged in, ≥1 credit)
- Preconditions: Logged in
- Steps (≤9):
  1. Open /browse, tap a collection card
  2. Verify modal opens with location + theme
  3. Submit generation
  4. Verify pipeline runs and worksheet appears
  5. Resubmit same collection → new worksheet (per REQ-API-03 updated wording in SRS)
- Expected outcome: UI worksheets generated / DB 2 Worksheet rows + 2 ledger debits

### P1-03: My worksheets pagination + cross-user privacy (REQ-DATA-02..03)
- Role: regular_user (≥3 saved worksheets)
- Preconditions: Generation prerequisites
- Steps (≤9):
  1. Sign in, open My Page → My Worksheets
  2. Verify first page loads
  3. Paginate to next page without duplicates
  4. Sign in as different user → does NOT see other user's worksheets
- Expected outcome: UI paginated list / DB query scoped by user_id

### P1-04: PDF A4 conversion (REQ-DATA-01 PDF)
- Role: regular_user with one generated worksheet
- Preconditions: PDF endpoint live
- Steps (≤9):
  1. Open generated worksheet
  2. Trigger PDF download
  3. Verify A4 size, no clipped text, no missing images
- Expected outcome: A4 PDF generated correctly

### P1-05: Account deletion (REQ-AUTH-03)
- Role: regular_user (disposable)
- Preconditions: Account with ≥1 worksheet and ≥1 ledger entry
- Steps (≤9):
  1. Sign in
  2. Open account settings → delete
  3. Confirm deletion
  4. Verify session invalidated
- Expected outcome: UI logged out / DB user record handled per policy

### P1-06: Admin chips / banners / promo / blacklist CRUD (Admin scope)
- Role: admin
- Preconditions: Admin signed in
- Steps (≤9):
  1. Add chip in admin / → verify on user Home
  2. Edit banner slot → verify on user Home
  3. Create promo code → as user, redeem → success
  4. Add blacklist keyword → as user, attempt generation → blocked
- Expected outcome: Admin CRUD reflects on user-side guards/displays

## 6. Edge / Negative Cases

### EDGE-01: Insufficient credit blocks generation (REQ-AI-02)
- Scenario: regular_user with 0 credits submits generation
- Expected outcome: Pre-pipeline rejection, no AI call, no Worksheet row, no ledger movement

### EDGE-02: Promo code already claimed by same user (REQ-REWARD-01)
- Scenario: regular_user redeems same promo code twice with same account
- Expected outcome: Second attempt rejected, /promotions 사용 횟수 not double-incremented

### EDGE-03: Expired promo code (REQ-REWARD-01)
- Scenario: regular_user redeems code in 만료됨 state
- Expected outcome: Rejected with expiry error, no credit grant

### EDGE-04: Invalid social login token (REQ-AUTH-01)
- Scenario: BE receives malformed or expired Kakao/Naver token
- Expected outcome: Auth API rejects, no JWT issued, no user row created

### EDGE-05: Payment webhook duplicate delivery (REQ-PAY-01..02)
- Scenario: PG re-delivers same webhook payload (same PG 거래 ID)
- Expected outcome: Idempotent — Credit_Ledger credits once, /payments shows only 1 row

### EDGE-06: Cross-user worksheet access (REQ-DATA-02..03)
- Scenario: User A passes User B's worksheet_id to detail API
- Expected outcome: Access denied or not-found

## 7. Regression Checklist (R0 → R1)

(no regression items in this round — R1 is the baseline)

## 8. QA Handoff Message

```
Hi team,

Sharing the QA plan for Booktails R1.

Scenarios in scope:
- P0 (mandatory): P0-01..P0-08 (Kakao login, Naver login, generation E2E, credit rollback, payment webhook, promo code, blacklist, admin manual credit)
- P1 (supporting): P1-01..P1-06 (home data, collection click, my-worksheets pagination, PDF A4, account deletion, admin CRUD)
- EDGE: EDGE-01..EDGE-06
- REG: (none)

Test environment:
- User staging URL: https://dev.maptails.example/
- Admin account: please request from PM
- Mock accounts: prepare disposable Kakao + Naver test accounts

When reporting failures, please preserve the following meta on the first line of the report:
QA Plan: QA-BOOKTAILS-20260510
Scenario: P0-NN

Reach out with any questions.
```

## 9. PM Review Items

**SRS-Implementation Deviation (URL inspect found surfaces NOT in SRS):**
- **Email/password authentication** (`/login/` form, `/signup/` form) — SRS REQ-AUTH-01 specifies Kakao + Naver social only. Email/password observed in staging but NOT in SRS. PM must decide: update SRS to include email/password, or remove from staging
- **Password reset** ("비밀번호를 잊으셨나요?" on `/login/`) — not in SRS. PM decision needed
- **자녀 (child profile)** column in admin /users + /logs — not in SRS REQ-AUTH-02 (signup) or related sections. PM decision needed on whether to expand SRS scope
- **/support internal 1:1 문의 form** (6 inquiry types, attachment, email collection) — SRS REQ-DATA-04 says "External link only (Google Form, etc.)". Internal form is a deviation
- **/pricing route returns React Router 404** — broken state observed. Confirm with FE whether the route is intentional and broken, or unimplemented

**Source-grounded items needing PM clarification:**
- Free-credit grant amount on signup (REQ-AUTH-02) is not numerically specified in SRS — confirm with BE
- Account deletion data-retention policy (P1-05) is [TBD] — confirm hard vs soft delete
- OpenAI API call mode for QA (live vs mock) is [TBD]
- PG sandbox configuration (P0-05) is [TBD]

**URL inspect summary:**
- visited 5/10 pages
- 1 console error (favicon 404 — ignorable)
- screenshots saved at `clients/booktails/Booktails/qa/plans/inspect/20260510-*.png`

---

## Next Steps (no auto-execution, guidance only)

- §8 QA Handoff Message → use with `/client-chat` or `/qa-request`
- Bugs found during QA → `/qa-feedback` (preserve `QA Plan: QA-BOOKTAILS-20260510` or `Scenario: P0-NN` on the first line of the report body)
- Significant bugs → `/issue-ticket` → Linear
- Status change: edit frontmatter `status:` directly (Draft → Review → Final)

---

> ⚠️ **This QA plan is for PM/QA internal validation.** Do not forward §1–§7 to client or dev team directly. §8 is the only client/QA-facing section.
