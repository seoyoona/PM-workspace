---
status: Confirmed-1
case: case03
client: dsa
project: Dsa
created: 2026-05-10
gate_choice: "1"
linear_team: Dsa
linear_priority: Medium
linear_labels: [feature]
linear_issue_id: DSA-318
linear_issue_url: https://linear.app/dsa/issue/DSA-318
has_original_request: false
---

## 1. Source Summary

- Client: dsa / Project: Dsa
- Priority requested: Medium
- Label proposed: feature
- Source language: English (no Korean original to preserve)

## 2. Translation & Glossary Lookup

- glossary/dsa.md applied
- Source already in English. No translation step needed.

## 3. Confirm Gate

```
[확인 필요]
다음 Linear 이슈를 생성합니다:

- Title: [Member] Export member list to CSV
- Priority: Medium
- Labels: feature
- Team: Dsa

1. 생성 (추천)
2. 수정
3. 취소
추천: 1
```

## 4. PM Choice

- gate_choice: "1"
- Resulting actions: Linear 이슈 생성 — DSA-318

## 5. Ticket Body

### Title
[Member] Export member list to CSV

### What
Add a CSV export option to the admin member list. Export should include the same columns as the on-screen list (name, email, role, signup date, last login).

### Why
Customer support and finance teams currently have to manually copy member data row by row. CSV export will reduce manual workload and reduce copy errors.

### Acceptance Criteria
- [ ] Admin member list has a "Export CSV" button.
- [ ] Exported CSV file contains: name, email, role, signup date, last login.
- [ ] CSV header row is present.
- [ ] File downloads with timestamp in filename (e.g., `members-2026-05-10.csv`).
- [ ] No regression on existing list rendering or pagination.

### Technical Notes
- Server-side CSV generation preferred (handle 10k+ rows without browser memory issues).
- Consider streaming response for large org datasets.

### Labels
feature

### Priority
Medium

## 7. Notes

- has_original_request=false — input was already in English. §6 Original Request 섹션 생략.
- Title format: `[Member] Export member list to CSV` — `[Page]` prefix convention.
