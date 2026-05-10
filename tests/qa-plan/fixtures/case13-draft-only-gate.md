---
case: case13
description: minimum source gate — SRS missing AND URL not provided. design.md / CLAUDE.md / glossary 만 있을 때 §4–§7 작성이 차단되고 Confidence=Draft only로 출력되는지 검증
client: connectory
project: connectory
srs: missing
url: not provided
design_md: clients/connectory/connectory/design.md (mock — UI sketch only)
client_context: clients/connectory/CLAUDE.md, glossary/connectory.md
expected_buckets:
  source_coverage_block: required
  confidence: Draft only
  status_field: Draft only
  plan_body_blocked: true
  no_p0_p1_edge_reg_headings: true
notes: |
  Inputs intentionally insufficient — no SRS, no URL inspect, only design.md + client context. Patch must (a) emit Source Coverage with Confidence=Draft only, (b) set frontmatter status: "Draft only", (c) §4·§5·§6·§7 contain only "(blocked — see Source Coverage)" line, (d) §9 has source request, (e) NO P0-NN / P1-NN / EDGE-NN / REG-NN scenario headings anywhere in the file.
---

# Input

```
/qa-plan connectory
```

PM이 SRS 미연결 상태로 호출. URL inspect도 없음. 로컬에는 design.md + client CLAUDE.md + glossary 만 존재. AI는 §4·§5·§6·§7 본문 작성을 중단하고 source 보강 요청만 출력해야 함. CLAUDE.md/glossary 에 적힌 도메인 컨텍스트로 시나리오 발명 X.
