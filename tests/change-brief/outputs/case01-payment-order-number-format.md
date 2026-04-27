---
status: Draft
client: Connectory
project: Connectory-1
source: free-text
source_ref: "tests/change-brief/fixtures/case01-small-copy-change.md (test fixture)"
srs_ref: missing
design_md: missing
created: 2026-04-27
---

# Change Brief — 결제 완료 화면 주문번호 형식 통일 (# prefix)

> Reference draft — official spec lives in Nexus / PM Notion.

## 1. 변경 요청 요약
- 누가 / 언제 / 어떤 채널: Connectory 고객사, 2026-04-27, 직접 피드백
- 원문 인용:
  > "고객이 결제 완료 화면에서 주문번호 표시 형식이 헷갈린다고 피드백. '주문번호: 12345'가 아니라 '주문번호 #12345'처럼 # 기호를 앞에 붙여서 일관성 있게 보여달라고 요청함. 다른 화면들은 이미 # 형식으로 표시되고 있어서 결제 완료 화면만 다른 상태."
- PM 1-line 정규화: 결제 완료 화면 주문번호 표시 형식을 다른 화면과 동일하게 `#` prefix 형식으로 통일.

## 2. 기존 범위 대비 영향도
- SRS 참조: SRS 미연결 — Nexus Agent / PM 확인 필요
- 영향 분류: 명확화 (UI 텍스트 일관성 정정)
- Impact: Low

## 3. 화면·UX 영향
- design.md 부재 — UI 영향 상세 판단은 design owner / Nexus Agent 확인 필요
- design.md 갱신 필요 여부: 판단 보류
- wireframe 필요 여부: 불필요 [추론 — 기존 화면 텍스트 형식 변경, 정보 구조나 레이아웃 변경 없음.]

## 4. 추가 개발 여부 결정 (4 버킷)

### In-Round
- [ ] 결제 완료 화면 주문번호 형식 `#12345`로 통일 / 다른 화면들이 이미 `#` 형식이라 일관성 정정에 해당, 고객 명확 근거 / Impact: Low

### Next-Round
(현재 항목 없음)

### Out-of-Scope
(현재 항목 없음)

### Confirm-Needed
(현재 항목 없음)

## 5. 고객 확인 질문
(현재 확인 필요 항목 없음)

## 6. 개발팀 전달 문구 (status=Dev-Handoff에서만 채움)
status가 `Draft` 또는 `PM Review`면 이 섹션은 비어 있어야 함.

(현재 status=Draft — Dev-Handoff로 승급 시 자동 생성 예정.)

---

## 다음 단계 (자동 실행 안 함, 안내만)

- 고객 확인이 필요하면: `/client-chat`에 위 Section 5 사용
- 개발팀 전달이 필요하면: `/dev-chat`에 위 Section 6 사용 (status=Dev-Handoff 이후)
- 티켓 분해가 필요하면, PM 검토 후: `/to-spec --client Connectory --source change-brief tests/change-brief/outputs/case01-payment-order-number-format.md` 별도 실행
- 상태 변경: 이 파일 frontmatter `status:` 직접 수정 (Draft → PM Review → Dev-Handoff)

---

> ⚠️ **In-Round로 분류되었더라도, status가 `Dev-Handoff`로 변경되기 전까지 개발팀 전달 확정안이 아닙니다.**
