---
status: Draft
client: Connectory
project: Connectory-1
source: free-text
source_ref: "tests/change-brief/fixtures/case02-admin-feature-confirm.md (test fixture)"
srs_ref: missing
design_md: missing
created: 2026-04-27
---

# Change Brief — 어드민 포인트 수동 조정 기능 검토

> Reference draft — official spec lives in Nexus / PM Notion.

## 1. 변경 요청 요약
- 누가 / 언제 / 어떤 채널: Connectory 운영팀 요청, 2026-04-27
- 원문 인용:
  > "어드민 페이지에서 사용자별 포인트를 수동으로 조정할 수 있는 기능을 추가해달라는 요청. 운영팀이 환불/보상 처리할 때 포인트를 직접 차감/증가시킬 수 있어야 한다고 함. 이 기능이 기존 MVP 견적/SRS에 포함되어 있는지 확인이 필요하다."
- PM 1-line 정규화: 어드민에서 사용자 포인트 차감·증가 기능 추가 — 기존 MVP 견적 범위 내인지 확인 필요.

## 2. 기존 범위 대비 영향도
- SRS 참조: SRS 미연결 — Nexus Agent / PM 확인 필요
- 영향 분류: 비범위 후보 (신규 기능, 견적 미확정)
- Impact: Unknown

## 3. 화면·UX 영향
- design.md 부재 — UI 영향 상세 판단은 design owner / Nexus Agent 확인 필요
- design.md 갱신 필요 여부: 판단 보류
- wireframe 필요 여부: 필요 [추론 — 어드민 신규 화면 또는 기존 화면 기능 추가. 정보 구조 영향 가능성 있어 design owner 확인 필요.]

## 4. 추가 개발 여부 결정 (4 버킷)

### In-Round
(현재 항목 없음)

### Next-Round
(현재 항목 없음)

### Out-of-Scope
(현재 항목 없음)

### Confirm-Needed
- [ ] 어드민 포인트 수동 조정 기능 / 기존 MVP 견적·SRS 범위에 포함되어 있는지 확인 필요. 견적 외라면 별도 견적/일정 분리 필요. 어떤 어드민 권한이 이 기능에 접근 가능한지, 변경 이력 로깅 요구사항이 있는지도 미확정.

## 5. 고객 확인 질문
한국어, 합니다체.

- 어드민에서 사용자 포인트를 수동 조정하는 기능이 기존 MVP 견적·SRS 범위에 포함되어 있는지 확인 부탁드립니다. 포함되어 있다면 우선순위를 알려주시고, 포함되어 있지 않다면 별도 견적·일정으로 분리해 진행하면 될지 회신 부탁드립니다.
- 이 기능 사용 권한은 어떤 어드민 등급에 한정해야 할지, 그리고 변경 이력(누가 언제 얼마만큼 조정했는지) 로그가 필요한지 확인이 필요합니다.

## 6. 개발팀 전달 문구 (status=Dev-Handoff에서만 채움)
status가 `Draft` 또는 `PM Review`면 이 섹션은 비어 있어야 함.

(현재 status=Draft — Confirm-Needed 항목으로 고객 회신 받기 전까지 Dev-Handoff 승급 안 함.)

---

## 다음 단계 (자동 실행 안 함, 안내만)

- 고객 확인이 필요하면: `/client-chat`에 위 Section 5 사용
- 개발팀 전달이 필요하면: `/dev-chat`에 위 Section 6 사용 (status=Dev-Handoff 이후)
- 티켓 분해가 필요하면, PM 검토 후: `/to-spec --client Connectory --source change-brief tests/change-brief/outputs/case02-admin-point-adjust.md` 별도 실행
- 상태 변경: 이 파일 frontmatter `status:` 직접 수정 (Draft → PM Review → Dev-Handoff)

---

> ⚠️ **In-Round로 분류되었더라도, status가 `Dev-Handoff`로 변경되기 전까지 개발팀 전달 확정안이 아닙니다.**
