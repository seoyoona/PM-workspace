---
status: Draft
client: Connectory
project: unknown
source: free-text
source_ref: "tests/change-brief/fixtures/case06-project-missing-fallback.md (test fixture)"
srs_ref: missing
design_md: missing
created: 2026-04-27
---

# Change Brief — 회원가입 본인인증 추가 문의 (방식·시점 미정)

> Reference draft — official spec lives in Nexus / PM Notion.

## 1. 변경 요청 요약
- 누가 / 언제 / 어떤 채널: Connectory 고객사 문의, 2026-04-27
- 원문 인용:
  > "고객이 회원가입 시 본인인증 절차를 추가할 수 있는지 문의. 현재 SRS에 본인인증 요구사항이 명시되어 있는지 PM이 확인 못한 상태. 구체적인 인증 방식(SMS/카카오/PASS 등)이나 시점(가입 시점/결제 시점)도 미정."
- PM 1-line 정규화: 회원가입 본인인증 추가 — 인증 방식과 시점 모두 미정, SRS 명시 여부도 미확인.

## 2. 기존 범위 대비 영향도
- SRS 참조: SRS 미연결 — Nexus Agent / PM 확인 필요
- 영향 분류: 명확화 필요 (방식·시점·범위 미정)
- Impact: Unknown

## 3. 화면·UX 영향
- design.md 부재 — UI 영향 상세 판단은 design owner / Nexus Agent 확인 필요
- design.md 갱신 필요 여부: 판단 보류
- wireframe 필요 여부: 판단 보류 [추론 — 인증 방식·시점에 따라 화면 흐름이 달라지므로 요구사항 확정 후 판단.]

## 4. 추가 개발 여부 결정 (4 버킷)

### In-Round
(현재 항목 없음)

### Next-Round
(현재 항목 없음)

### Out-of-Scope
(현재 항목 없음)

### Confirm-Needed
- [ ] 회원가입 본인인증 추가 / 인증 방식(SMS / 카카오 / PASS / 통신사 본인확인 등), 적용 시점(가입 시점 / 결제 시점 / 특정 액션 시점), 외부 API 연동 비용·계약, SRS 명시 여부 모두 미확정.

## 5. 고객 확인 질문
한국어, 합니다체.

- 회원가입 본인인증을 어떤 방식으로 진행할지(예: SMS 인증·카카오·PASS 등) 선호하시는 방식이 있으신지 확인 부탁드립니다.
- 본인인증을 어느 시점에 적용할지(가입 시점 / 결제 시점 / 특정 액션 시점) 확인이 필요합니다.
- 외부 본인인증 API는 별도 사용료·계약이 발생할 수 있어, 어느 서비스를 사용할지 함께 결정이 필요한 점 안내드립니다.

## 6. 개발팀 전달 문구 (status=Dev-Handoff에서만 채움)
status가 `Draft` 또는 `PM Review`면 이 섹션은 비어 있어야 함.

(현재 status=Draft — 인증 방식·시점 미확정 상태라 Dev-Handoff 승급 안 함.)

---

## 다음 단계 (자동 실행 안 함, 안내만)

- 고객 확인이 필요하면: `/client-chat`에 위 Section 5 사용
- 개발팀 전달이 필요하면: `/dev-chat`에 위 Section 6 사용 (status=Dev-Handoff 이후)
- 티켓 분해가 필요하면, PM 검토 후: `/to-spec --client Connectory --source change-brief tests/change-brief/outputs/case06-id-verification-no-project.md` 별도 실행
- 상태 변경: 이 파일 frontmatter `status:` 직접 수정 (Draft → PM Review → Dev-Handoff)

---

> ⚠️ **In-Round로 분류되었더라도, status가 `Dev-Handoff`로 변경되기 전까지 개발팀 전달 확정안이 아닙니다.**
