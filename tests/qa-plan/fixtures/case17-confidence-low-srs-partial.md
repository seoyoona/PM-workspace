---
case: case17
description: SRS는 파일/Notion fetch는 됐지만 본문이 placeholder 수준 (REQ ID 나열만, 행위·기대결과·권한 정의 부재) + Change Brief 없음 + URL 미명시 → Confidence=Low. plan body는 작성하지만 §9에 "SRS 본문 보강 권고" 강조. v1.1.2 Low tier 회귀.
client: connectory
project: Connectory-1
srs: clients/Connectory/Connectory-1/srs.md (mock — REQ-CONNECTORY-01..05 IDs nominally listed but each REQ body is "TBD" / "details to follow" / "[추후]")
url: not provided
expected_buckets:
  source_coverage_block: required
  confidence: Low
  body_blocked: false
  srs_partial_warning_in_section_9: true
notes: |
  Tests v1.1.2 Confidence=Low rule: SRS body is placeholder-only. Plan body can be written from REQ IDs but expected outcomes, role boundaries, and step details are necessarily skeletal. AI must (a) emit Confidence=Low, (b) write skeletal P0 from REQ IDs, (c) flag "SRS body insufficient" prominently in §9, (d) recommend SRS body completion before next round.
---

# Input

```
/qa-plan connectory --project Connectory-1
```

PM이 SRS는 연결돼 있지만 내용이 placeholder 수준인 상태에서 호출. 스킬은 SRS=found로 인식하지만 본문이 placeholder임을 자체 판단해 Confidence=Low로 분류. 시나리오는 REQ ID + 헤딩 수준으로만 작성하고 §9에 SRS 본문 보강 요청.
