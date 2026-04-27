---
status: Draft
client: Connectory
project: Connectory-1
source: free-text
source_ref: "tests/change-brief/fixtures/case08-notion-fetch-fail.md (Notion URL fetch 실패 → free-text fallback)"
srs_ref: missing
design_md: missing
created: 2026-04-27
---

# Change Brief — 통화 환산율 표시 정책 (실시간 vs 5분 캐시)

> Reference draft — official spec lives in Nexus / PM Notion.

> ⚠️ Notion 페이지를 읽지 못했습니다. meeting-note 내용을 직접 붙여넣어 주세요. → free-text 모드로 전환 진행.

## 1. 변경 요청 요약
- 누가 / 언제 / 어떤 채널: Connectory 고객사 미팅, 2026-04-27, free-text fallback (Notion URL fetch 실패)
- 원문 인용:
  > "미팅에서 통화 환산율 표시 정확도에 대해 논의했음. 고객은 환율이 실시간으로 반영되어야 한다고 강력 주장하지만, 개발팀은 API 호출 비용/안정성 이슈로 5분 캐시를 제안. 이 정책 차이를 어느 쪽으로 갈지 PM이 결정해야 함."
- PM 1-line 정규화: 통화 환산율 갱신 주기 정책 — 고객은 실시간, 개발팀은 5분 캐시. PM 의사결정 필요.

## 2. 기존 범위 대비 영향도
- SRS 참조: SRS 미연결 — Nexus Agent / PM 확인 필요
- 영향 분류: 명확화 필요 (정책 결정 미확정)
- Impact: Medium [추론 — 정책에 따라 환율 API 호출 비용·안정성·UX(stale 표시 여부)가 모두 달라짐.]

## 3. 화면·UX 영향
- design.md 부재 — UI 영향 상세 판단은 design owner / Nexus Agent 확인 필요
- design.md 갱신 필요 여부: 판단 보류
- wireframe 필요 여부: 불필요 [추론 — 정책 변경이지 화면 구조 변경이 아님. 단, "마지막 갱신 시각" 표시 추가 시 별도 검토.]

## 4. 추가 개발 여부 결정 (4 버킷)

### In-Round
(현재 항목 없음)

### Next-Round
(현재 항목 없음)

### Out-of-Scope
(현재 항목 없음)

### Confirm-Needed
- [ ] 통화 환산율 갱신 주기 정책 / 고객 요구(실시간) vs 개발팀 제안(5분 캐시) 간 차이. API 호출 비용 한도, stale 환율 표시 시 사용자 안내 정책, 결제 시점 환율 확정 시점 등 미확정.

## 5. 고객 확인 질문
한국어, 합니다체.

- 통화 환산율 갱신 주기에 대해 개발팀에서는 외부 API 호출 비용·안정성 이슈로 5분 캐시를 제안드리고 있습니다. 실시간 갱신이 비즈니스적으로 꼭 필요하신지, 또는 일정 캐시 허용이 가능하신지 확인 부탁드립니다.
- 결제 시점에 환율을 확정해 표시할지, 화면 노출 시점 환율 그대로 결제로 진행할지에 대한 정책도 함께 확인이 필요합니다.

## 6. 개발팀 전달 문구 (status=Dev-Handoff에서만 채움)
status가 `Draft` 또는 `PM Review`면 이 섹션은 비어 있어야 함.

(현재 status=Draft — 정책 미확정 상태라 Dev-Handoff 승급 안 함.)

---

## 다음 단계 (자동 실행 안 함, 안내만)

- 고객 확인이 필요하면: `/client-chat`에 위 Section 5 사용
- 개발팀 전달이 필요하면: `/dev-chat`에 위 Section 6 사용 (status=Dev-Handoff 이후)
- 티켓 분해가 필요하면, PM 검토 후: `/to-spec --client Connectory --source change-brief tests/change-brief/outputs/case08-currency-rate-policy.md` 별도 실행
- 상태 변경: 이 파일 frontmatter `status:` 직접 수정 (Draft → PM Review → Dev-Handoff)

---

> ⚠️ **In-Round로 분류되었더라도, status가 `Dev-Handoff`로 변경되기 전까지 개발팀 전달 확정안이 아닙니다.**
