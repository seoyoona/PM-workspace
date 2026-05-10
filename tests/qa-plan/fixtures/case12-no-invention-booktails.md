---
case: case12
description: SRS + URL inspect 둘 다 있음 — AI가 staging에서 관찰된 SRS 외 surface(email auth, password reset, 자녀 프로필, /support internal form)를 §4·§5 시나리오로 promote하지 못하게 하는 regression. Confidence=High, deviations 만 §9로 라우팅.
client: booktails
project: Booktails
srs: clients/booktails/Booktails/srs.md (mock SRS scope: Kakao+Naver social login only, no email auth, no password reset, no 자녀 profile feature, complaint = external Google Form link)
url: https://dev.maptails.example/
expected_buckets:
  source_coverage_block: required
  confidence: High
  invented_scenarios_excluded: true
  deviations_routed_to_section_9: true
notes: |
  Inputs replicate the BookTails R1 incident (real-world event 2026-04-29). Staging UI shows email auth + password reset + 자녀 프로필 + /support internal form, but SRS does not specify any of them. Patch must (a) emit Source Coverage block with Confidence=High, (b) NOT promote unsourced UI to P0/P1, (c) route deviations to §9 "SRS-Implementation Deviation" sub-heading only. AI는 SRS 안의 기능에만 P0/P1 시나리오를 작성한다.
---

# Input

```
/qa-plan booktails --srs clients/booktails/Booktails/srs.md --url https://dev.maptails.example/
```

PM이 SRS와 staging URL 둘 다 제공. SRS는 Kakao+Naver social login + worksheet generation + payment + promo code + blacklist + admin manual credit 만 명시. Staging UI는 SRS 외 surface(email/password auth, password reset, 자녀 프로필, /support internal form, /pricing 404 등)도 노출. AI는 SRS 외 surface를 §4·§5에 시나리오로 promote 하면 안 되고, §9 PM Review의 "SRS-Implementation Deviation" sub-heading에만 기록해야 함.
