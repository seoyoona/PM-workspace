---
case: case01
description: Change Brief In-Round 항목을 source로 받아 시나리오 1개 생성
client: Connectory
project: Connectory-1
srs: none
brief: clients/Connectory/Connectory-1/change-briefs/2026-04-27-payment-currency-admin-points.md (status=Dev-Handoff 가정)
expected_scenario_id: SCN-connectory-1-001
expected_priority: P1
notes: Change Brief In-Round = "포인트결제 화면에 CNY-KRW 통화 안내 문구 추가". 시나리오는 그 In-Round 항목을 검수.
---

# Input intent

PM이 결제 통화 안내 추가 항목에 대한 사용자 시나리오 작성:
- 비로그인 → 로그인 → 포인트 충전 화면 진입 → 충전 금액 선택 → 결제 안내 문구 확인 → 결제 진행
- 화면: 포인트 충전 화면 (`/payment/points`)
- Brief에서 In-Round 확정된 항목이라 `Dev-Handoff` 상태로 가정

# Expected behavior

- Source Linkage에 brief_ref 정상 기록
- srs_ref: missing (SRS 미연결, partial-skip)
- 단계 수 ≤ 12
- "Internal QA scenario draft" 배너 포함
