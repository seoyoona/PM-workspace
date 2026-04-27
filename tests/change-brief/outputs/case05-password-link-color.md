---
status: Draft
client: Connectory
project: Connectory-1
source: free-text
source_ref: "tests/change-brief/fixtures/case05-missing-srs-design.md (test fixture)"
srs_ref: missing
design_md: missing
created: 2026-04-27
---

# Change Brief — 로그인 화면 비밀번호 찾기 링크 색상 가시성 개선

> Reference draft — official spec lives in Nexus / PM Notion.

## 1. 변경 요청 요약
- 누가 / 언제 / 어떤 채널: Connectory 고객사 피드백, 2026-04-27
- 원문 인용:
  > "로그인 화면에서 '비밀번호 찾기' 링크가 안 보인다고 고객이 피드백. 실제 코드 확인하면 링크는 있는데 색상이 배경과 비슷해서 시각적으로 구분이 안 됨. 색상만 조정하면 되는 작은 UI 수정."
- PM 1-line 정규화: 로그인 화면 "비밀번호 찾기" 링크 색상을 배경과 명확히 구분되도록 조정.

## 2. 기존 범위 대비 영향도
- SRS 참조: SRS 미연결 — Nexus Agent / PM 확인 필요
- 영향 분류: 명확화 (UI 가시성 정정)
- Impact: Low

## 3. 화면·UX 영향
- design.md 부재 — UI 영향 상세 판단은 design owner / Nexus Agent 확인 필요
- design.md 갱신 필요 여부: 판단 보류 (color token이 design.md에 정의되어 있는지 확인 필요)
- wireframe 필요 여부: 불필요 [추론 — 색상 값만 조정, 레이아웃·정보 구조 변경 없음.]

## 4. 추가 개발 여부 결정 (4 버킷)

### In-Round
- [ ] 로그인 화면 "비밀번호 찾기" 링크 색상을 배경과 명확히 구분되도록 변경 / 고객 가시성 피드백 + 작은 CSS 조정 / Impact: Low

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
- 티켓 분해가 필요하면, PM 검토 후: `/to-spec --client Connectory --source change-brief tests/change-brief/outputs/case05-password-link-color.md` 별도 실행
- 상태 변경: 이 파일 frontmatter `status:` 직접 수정 (Draft → PM Review → Dev-Handoff)

---

> ⚠️ **In-Round로 분류되었더라도, status가 `Dev-Handoff`로 변경되기 전까지 개발팀 전달 확정안이 아닙니다.**
