---
case: case10
description: --url 명시 → staging guided navigation (read-only) → §3 Flow Map / §4 시나리오 단계에 inspection 결과 반영
client: booktails
project: Booktails
srs: clients/booktails/Booktails/srs.md (mock)
url: https://staging.booktails.example/
expected_buckets:
  pages_inspected: 5+
  no_destructive_clicks: true
  staging_url_recorded: true
notes: PM이 SRS + staging URL 동반 호출. Playwright MCP로 read-only navigation. 결과 frontmatter staging_url + pages_inspected에 기록. 시나리오 §4에 "URL inspect 시 발견된 흐름" 표기. SRS와 충돌 시 SRS 우선.
---

# Input

```
/qa-plan booktails --url https://staging.booktails.example/
```

PM이 SRS와 staging URL을 동반 입력. Playwright로 페이지 5개 정도 read-only navigation 후 plan 작성.
