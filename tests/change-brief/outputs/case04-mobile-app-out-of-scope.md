---
status: Draft
client: Connectory
project: Connectory-1
source: free-text
source_ref: "tests/change-brief/fixtures/case04-clear-out-of-scope.md (test fixture)"
srs_ref: missing
design_md: missing
created: 2026-04-27
---

# Change Brief — 모바일 앱(iOS/Android) 추가 문의 검토

> Reference draft — official spec lives in Nexus / PM Notion.

## 1. 변경 요청 요약
- 누가 / 언제 / 어떤 채널: Connectory 고객사 문의, 2026-04-27
- 원문 인용:
  > "iOS/Android 모바일 앱 버전도 같이 만들 수 있는지 문의. 현재 프로젝트는 웹 전용으로 계약되어 있고 ... 계약서에도 WEB-only로 명시되어 있어서 이번 라운드에 들어갈 수 없음."
- PM 1-line 정규화: 모바일 앱 추가 개발 문의 — 계약(WEB-only) 범위 외, 별도 견적/일정으로 분리 필요.

## 2. 기존 범위 대비 영향도
- SRS 참조: SRS 미연결 — Nexus Agent / PM 확인 필요
- 영향 분류: 비범위 (계약 type=WEB와 명확히 다름)
- Impact: High [추론 — 모바일 앱은 별도 플랫폼 개발 공수가 들어가는 신규 프로젝트 수준 작업.]

## 3. 화면·UX 영향
- design.md 부재 — UI 영향 상세 판단은 design owner / Nexus Agent 확인 필요
- design.md 갱신 필요 여부: 판단 보류 (별도 프로젝트로 진행 시 모바일 전용 design.md 필요)
- wireframe 필요 여부: 필요 [추론 — 모바일 앱은 웹과 별도 UX 설계 필요. 단, 본 라운드에서 처리 안 함.]

## 4. 추가 개발 여부 결정 (4 버킷)

### In-Round
(현재 항목 없음)

### Next-Round
(현재 항목 없음)

### Out-of-Scope
- [ ] iOS/Android 모바일 앱 추가 개발 / 계약서에 WEB-only 명시되어 본 프로젝트 범위 밖. 별도 견적·일정으로 분리해 신규 계약 수준에서 진행해야 함.

### Confirm-Needed
(현재 항목 없음)

## 5. 고객 확인 질문
(현재 확인 필요 항목 없음)

## 6. 개발팀 전달 문구 (status=Dev-Handoff에서만 채움)
status가 `Draft` 또는 `PM Review`면 이 섹션은 비어 있어야 함.

(현재 status=Draft — Out-of-Scope이므로 본 라운드 Dev-Handoff 대상 아님. 별도 프로젝트로 분리 시 새 라운드에서 처리.)

---

## 다음 단계 (자동 실행 안 함, 안내만)

- 고객 확인이 필요하면: `/client-chat`에 위 Section 5 사용
- 개발팀 전달이 필요하면: `/dev-chat`에 위 Section 6 사용 (status=Dev-Handoff 이후)
- 티켓 분해가 필요하면, PM 검토 후: `/to-spec --client Connectory --source change-brief tests/change-brief/outputs/case04-mobile-app-out-of-scope.md` 별도 실행
- 상태 변경: 이 파일 frontmatter `status:` 직접 수정 (Draft → PM Review → Dev-Handoff)

---

> ⚠️ **In-Round로 분류되었더라도, status가 `Dev-Handoff`로 변경되기 전까지 개발팀 전달 확정안이 아닙니다.**
