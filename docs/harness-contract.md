# Workspace Harness Contract — Wave 0 Standard

This document defines the standard contract for skill harnesses in PM-workspace. New harnesses must follow this contract. Existing harnesses (`test-change-brief.sh` / `test-to-spec.sh` / `test-qa-plan.sh`) keep their current inline implementations; migration to the shared library is deferred to Wave 1+.

## Table of Contents

1. Purpose & Scope
2. Directory Layout
3. Naming Conventions
4. Check File Format
5. Global Checks (mandatory for write-risk skills)
6. PM Confirm Gate Verification Standard
7. Source Priority Standard Form
8. Write-risk Classification
9. Output Sample Fixturing Workflow
10. Rollout Rule

---

## 1. Purpose & Scope

The harness model is **offline static assertion**:
- The harness does NOT invoke the skill CLI.
- The harness reads pre-curated `tests/<skill>/outputs/<id>-*.md` markdown files.
- The harness runs regex / section-grep assertions defined in `tests/<skill>/checks/`.
- LLM nondeterminism is accepted; sample outputs are human-curated baselines.

This trade-off makes the harness fast, deterministic, and CI-friendly, at the cost of not catching live-skill regressions. Live regressions are caught manually by PM during sample re-curation (§9).

## 2. Directory Layout

```
scripts/
  test-<skill>.sh                    # one harness per skill (entry point)
  lib/
    harness-common.sh                # shared handlers (Wave 0)
tests/
  <skill>/
    fixtures/<id>-<short-desc>.md    # input scenario (frontmatter + body)
    checks/global.txt                # global assertions for this skill
    checks/<id>.txt                  # per-case assertions
    outputs/<id>-<resolved-name>.md  # sample output (human-curated)
docs/
  harness-contract.md                # this document
```

`scripts/lib/harness-common.sh` is sourceable by any skill harness. It defines the standard handlers and assumes the caller declares a global `FAIL_DETAILS` array.

## 3. Naming Conventions

| Item | Format | Example |
|---|---|---|
| Case ID | `caseNN` (zero-pad, 2 digits) | `case14` |
| Fixture filename | `caseNN-<kebab-short-desc>.md` | `case14-prod-url-block.md` |
| Output filename | `caseNN-<resolved-context>.md` | `case14-booktails-prod-url-rejected.md` |
| Check filename | `caseNN.txt` | `case14.txt` |

Output files MUST match the glob `caseNN-*.md` so the harness's `find_output_for_case` helper can resolve them. The `<resolved-context>` portion typically encodes the client / variant chosen by the fixture (e.g., `dsa-r1`, `connectory-design-only`).

## 4. Check File Format

TAB-separated, one assertion per line. Comments start with `#`. Empty lines ignored.

| Handler | Signature (TAB-separated fields) | Semantics |
|---|---|---|
| `must_match` | `<pattern>\t<description>` | Pattern must match somewhere in file (ERE) |
| `must_not_match` | `<pattern>\t<description>` | Pattern must NOT match anywhere in file |
| `must_match_in_section` | `<section_name>\t<pattern>\t<description>` | Pattern must match inside the body of `## <section_name>` |
| `must_not_match_in_section` | `<section_name>\t<pattern>\t<description>` | Pattern must NOT match inside the body of `## <section_name>` |
| `must_match_filepath` | `<path>\t<description>` | File must exist at the exact path |
| `file_must_not_exist` | `<glob>\t<description>` | No file matches the glob |
| `note` | `<text>` | Comment / no-op |

**Section extraction caveat:** `extract_section` stops at the next `##` or `###` header. Sub-headings inside a section terminate extraction. To put a sub-section inside `## N. Section`, render it with bold (`**Sub-heading:**`) — never `### Sub-heading`. This is enforced by convention; a `### X` inside `## N. Y` will not be visible to `*_in_section` handlers.

## 5. Global Checks (mandatory for write-risk skills)

Every `tests/<skill>/checks/global.txt` for a Critical / High write-risk skill (§8) MUST include:

```
# Frontmatter / output structure
must_match    ^---$                              frontmatter delimiter
must_match    ^status: (...)                     status enum allowed by the skill
must_match    <skill-specific ID format>         e.g., qa_plan_id: QA-<CLIENT>-YYYYMMDD

# Required sections (skill-specific section list)
must_match    ## 1\. ...
must_match    ## 2\. ...
...

# Internal-use banner (audience-locked)
must_match    Internal <skill> — for PM/QA validation only

# No auto-write guards
must_not_match    notion-create-pages            # unless Notion-write skill, then exclude
must_not_match    mcp__nexus-os__                # never auto-call Nexus
must_not_match    → 자동 실행                    # auto-chain language forbidden
must_not_match    Running /(to-spec|dev-chat|client-chat|qa-feedback|issue-ticket|qa-plan)

# No Mermaid (v1 baseline)
must_not_match    ```mermaid
must_not_match    flowchart [TLBR]D
must_not_match    graph [TLBR]D

# No AI-invented effort estimates
must_not_match    [0-9]+ ?MD\b
must_not_match    [0-9]+ ?(시간|hours?|hrs?)\b
```

Notion-write skills (e.g., `/qa-feedback`, `/srs-translate`, `/weekly-report`, `/create-srs`, `/meeting-note`, `/kickoff-prep`, `/daily-scrum`, `/to-spec`) are exempt from the `notion-create-pages` negative match for their own write paths, but MUST still negative-match unrelated MCP calls (e.g., `mcp__nexus-os__`).

## 6. PM Confirm Gate Verification Standard

Critical / High write-risk skills MUST have at least 3 base case templates:

| Case template | PM input | Expected harness assertion |
|---|---|---|
| `case-proceed` | "1" (proceed) | external write ID populated in frontmatter (Notion URL / Linear ID / Teams send log) |
| `case-defer` | "2" (defer / modify) | external write ID empty, local draft preserved |
| `case-cancel` | "3" (cancel) | `file_must_not_exist <skill>-<output-pattern>` OR explicit cancel marker in §9 |

Each new harness case MUST classify itself as one of the above and assert accordingly. A "proceed-only" harness is not sufficient — defer and cancel paths are equally important regression surface.

Skills without a confirm gate at all (currently `/kickoff-prep`) are flagged for Wave 1 gate introduction.

## 7. Source Priority Standard Form

Skills that read multiple primary sources MUST define source priority in the skill body using the following form:

```
[skill-specific] 의 primary source는 다음 순서:
1. <highest-priority>
2. <second>
3. <third>
4. <fourth>
5. <auxiliary / lowest>
```

**Required:**
- Conflict rule MUST be explicit (e.g., "SRS와 충돌 시 SRS 우선").
- Auxiliary sources (e.g., `design.md`, client `CLAUDE.md`, `glossary/<c>.md`) MUST be marked "primary로 사용 ❌" and their role limited to UI cross-check or terminology lookup.
- Partial-skip rule for missing sources MUST be explicit ("hard-fail 금지 — 해당 영역만 `[TBD]` 또는 `(none)`").

**Reference implementation:** `/qa-plan` v1.1.2 §"Source 우선순위 (중요)" + `/to-spec` v2 §"Source 우선순위" both follow this form. Use them as templates.

## 8. Write-risk Classification

| 등급 | 정의 | 해당 스킬 (2026-05-10 기준) |
|---|---|---|
| **Critical** | 외부 시스템(Notion / Linear / Nexus / Teams)에 page / ticket / row 자동 생성 가능 + 다수 stakeholder 가시성 | to-spec, qa-feedback, srs-translate, create-srs, weekly-report, meeting-note, kickoff-prep, issue-ticket, daily-scrum, nexus-daily |
| **High** | 외부 시스템에 단일 row / 메모 추가 또는 schema option 변경. blast radius 작음 | todo, new-project, setup-workspace |
| **Medium** | 로컬 markdown write만 (외부 시스템 X) | qa-plan, change-brief (deprecated) |
| **Low** | terminal 출력 + 사용자 명시 confirm 후 송신 | dev-chat, sync-note |
| **Read-only** | terminal 출력만 | client-chat, qa-request, today-brief |

Wave 1+ harness rollout follows this priority order: Critical → High → Medium → Low → Read-only.

## 9. Output Sample Fixturing Workflow

Since the harness does NOT call the skill, sample outputs are human-curated:

1. PM defines fixture: `tests/<skill>/fixtures/caseNN-<desc>.md` with frontmatter (case metadata) + body (scenario description and skill input).
2. PM runs `/<skill> <fixture args>` once in a real Claude Code session.
3. PM verifies output against skill rules (no-invention, gate, partial-skip, source priority).
4. PM commits the verified output to `tests/<skill>/outputs/<id>-*.md`.

**When skill body changes break a baseline:**
- The PR that changes the skill MUST update the affected output samples.
- All other cases MUST still pass against the new output samples.
- This is enforced by `bash scripts/test-<skill>.sh` exiting 0.

**When in doubt:** prefer fewer cases over invented cases. A baseline that has not been hand-verified by PM is worse than no case at all (it bakes in a hallucination as a regression target).

## 10. Rollout Rule

- **Wave 0 (this PR):** Contract definition only. No existing harness refactored. No new skill harness scripts. Library defined but not yet sourced by any caller.
- **Wave 1+:** Existing 3 harnesses migrate to source `scripts/lib/harness-common.sh`. New skill harnesses created top-down by write-risk (Critical first).

**Migration constraint:** Existing harness migration to the shared library MUST happen in a separate PR from any skill body change. This isolates "contract change" from "behavior change" and keeps regression bisecting clean.

**No silent contract changes:** Any update to this document or `harness-common.sh` is a contract change. It MUST be reviewed by PM before merging, even if no individual skill harness is affected.
