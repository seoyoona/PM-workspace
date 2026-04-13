# Template: SRS Translation (KR → EN)

This is the highest-volume, highest-impact template.
Errors here propagate to kickoff, planning, design, and development.

## Non-Invention Rule
**Translate the source. Do not add to it.**
- Do NOT add requirements, interpretations, or analysis not present in the source
- Do NOT add "inferred requirements" — if it's not in the SRS, it's not in the output
- Do NOT force-find ambiguities — only flag what is genuinely unclear in the source text
- Claude's editorial judgment stays out of the translation output

Exception: if the PM explicitly instructs to incorporate additional content (e.g., "이 링크 내용도 반영해줘"), follow those specific instructions only.

## Input
Korean SRS document (from Notion or pasted text)

## Process
1. Read the full SRS before translating — understand structure and scope first
2. Check `glossary/{client-name}.md` for established term mappings
3. Translate faithfully — do NOT add, remove, or reinterpret requirements
4. Mirror the source structure — do not reorganize sections unless the Korean structure is genuinely unreadable
5. If a term or phrase is ambiguous in the Korean source, flag it — do not silently pick an interpretation

## Output Format
```
# [Project Name] — SRS (English Translation)

> Source: [Notion link or reference]
> Translated: [Date]
> Client: [Client name]
> Status: Draft — pending PM review

---

## 1. Overview
[Translated project overview / background]

## 2. Scope
[What is included and excluded]

## 3. Functional Requirements
### 3.1 [Feature Area]
- FR-001: [Requirement]
- FR-002: [Requirement]
(Maintain original numbering if the SRS has it)

### 3.2 [Feature Area]
- FR-003: [Requirement]

## 4. Non-Functional Requirements
- [Performance, security, compatibility, etc.]

## 5. Ambiguities & Open Questions
⚠️ Include only if actual ambiguities exist in the source:
- [ ] [Section X]: "[Korean original]" — could mean [A] or [B]. Which is intended?
- [ ] [Section Y]: No detail on [topic] in the source. Developers will need [specific info].

(Omit this section entirely if there are no genuine ambiguities.)

## 6. New Terms (for glossary review)
Include on first translation for a new client, or when new domain terms appear:
| Korean | English (used in this doc) | Confidence | Notes |
|--------|---------------------------|------------|-------|
| [term] | [translation] | High/Medium/Low | [why low confidence, if applicable] |
```

## Key Rules
- Translate what the source says. Nothing more.
- Section 5 (Ambiguities): only if genuinely unclear in the source — zero ambiguities is fine.
- Section 6 (New Terms): include on first client translation or when new terms appear.
- No "Inferred Requirements" section — Claude does not speculate about implied requirements.
- Mark the whole document as "Draft — pending PM review".
