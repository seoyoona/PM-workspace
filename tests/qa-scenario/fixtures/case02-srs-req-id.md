---
case: case02
description: SRS REQ ID(REQ-PAY-01)가 frontmatter srs_ref와 Source Linkage에 보존되는지
client: Connectory
project: Connectory-1
srs: clients/Connectory/Connectory-1/srs.md (mock 가정, REQ-PAY-01 / REQ-AUTH-03 포함)
brief: none
expected_scenario_id: SCN-connectory-1-001
expected_srs_ref: "REQ-PAY-01, REQ-AUTH-03"
notes: SRS는 read-only. PM이 REQ ID list를 인자 또는 본문으로 전달.
---

# Input intent

REQ-PAY-01 (포인트 결제 처리) + REQ-AUTH-03 (로그인 만료 시 재인증) 두 요구사항을 함께 검증하는 시나리오.

# Expected behavior

- frontmatter srs_ref: "REQ-PAY-01, REQ-AUTH-03"
- Section 1 Source Linkage에 두 REQ ID 모두 인용
- brief_ref: none
- SRS 본문 편집 0건 (read-only)
