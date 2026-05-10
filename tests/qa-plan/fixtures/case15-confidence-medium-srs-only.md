---
case: case15
description: SRS 있음 + URL 미명시 + Change Brief 없음 + design.md 없음 → Confidence=Medium (SRS alone), plan body written. v1.1.2 Medium 분기 회귀.
client: dsa
project: Dsa
srs: clients/Dsa/Dsa/srs.md (mock SRS scope: org admin + member roles, login, dashboard, member invite, role boundary)
url: not provided
expected_buckets:
  source_coverage_block: required
  confidence: Medium
  body_blocked: false
  url_inspect_status: not_provided
notes: |
  Tests v1.1.2 Confidence rule: SRS found alone (URL inspect not provided AND Change Brief missing) → Medium. Plan body must NOT be blocked. P0 scenarios written from SRS REQ IDs.
---

# Input

```
/qa-plan dsa
```

PM이 SRS만 제공 (auto-discovery). URL 미명시, Brief 없음. 스킬은 Confidence=Medium으로 분류하고 SRS 기반으로 §4·§5 시나리오 작성.
