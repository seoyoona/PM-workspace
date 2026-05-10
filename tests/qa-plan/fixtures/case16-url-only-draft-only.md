---
case: case16
description: SRS 미연결 + URL 명시 → Draft only (URL 단독은 Medium 으로 승급 ❌). §3 화면 관찰 요약은 작성 가능, §4·§5·§6·§7 차단, §9 SRS-Implementation Deviation list + SRS 제공 후 재호출 안내. v1.1.2 핵심 회귀 — BookTails 사고 재발 방지.
client: booktails
project: Booktails
srs: missing
url: https://dev.maptails.example/
design_md: missing
client_context: clients/booktails/CLAUDE.md, glossary/booktails.md
expected_buckets:
  source_coverage_block: required
  confidence: Draft only
  status_field: Draft only
  url_inspect_status: done
  staging_url_recorded: true
  pages_inspected_populated: true
  section_3_observation_allowed: true
  section_4_to_7_blocked: true
  section_9_deviation_routing: true
notes: |
  Tests v1.1.2 minimum source gate: SRS missing + URL inspect done → Draft only. URL 단독은 baseline truth가 아니므로 P0/P1/EDGE/REG 발명 금지. URL에서 관찰된 surface는 §3 fact summary + §9 SRS-Implementation Deviation list 로만. AI가 staging UI 화면을 P0/P1 시나리오로 promote하면 회귀 실패.
---

# Input

```
/qa-plan booktails --url https://dev.maptails.example/
```

PM이 SRS 미연결 상태로 staging URL만 전달. URL은 staging 도메인이므로 inspect는 진행되지만, SRS 부재로 §4~§7 작성은 차단. §3에는 관찰된 페이지 / 노출 텍스트 / 링크 구조만 사실 기술. §9에는 SRS에 없는 surface 목록과 SRS 제공 후 재호출 안내.
