---
status: Confirm-Needed-only
client: Connectory
project: Connectory-1
created: 2026-04-28
source: free-text
source_ref: "tests/to-spec/fixtures/case06-missing-srs-design.md (test fixture)"
srs_ref: missing
design_md: missing
spec_pages: []
---

# Request Triage — 비밀번호 재설정 링크 색상 변경 (디자인 가이드 미정)

> Reference draft — official spec lives in Nexus / PM Notion. In-Round 항목은 PM confirm 후 커뮤니케이션 DB / 태스크 DB에 자동 생성됩니다.

## 1. 변경 요청 요약
- 누가 / 언제 / 어떤 채널: Connectory 고객사, 2026-04-28, 직접 피드백
- 원문 인용:
  > "비밀번호 재설정 링크 색깔을 좀 더 눈에 띄게 바꿔주세요. 현재 회색이라 눈에 잘 안 들어옵니다."
- PM 1-line 정규화: 비밀번호 재설정 링크 색상을 더 강조되는 색으로 변경 — 구체 색상·다른 화면 정합성은 디자인 가이드 확인 필요.

## 2. 기존 범위 대비 영향도
- SRS 참조: [확인 필요] SRS 미연결 — Nexus Agent / PM 확인 필요
- 영향 분류: 명확화 (UI 톤 정정)
- 전체 Impact: Unknown

## 3. 화면·UX 영향
- [확인 필요] design.md 부재 — UI 영향 상세 판단은 design owner / Nexus Agent 확인 필요
- design.md 갱신 필요 여부: 필요 [추론 — 링크 색상 토큰 정의가 design system 차원 변경일 가능성]
- wireframe 필요 여부: 불필요

## 4. 4-Bucket Triage

### In-Round
(현재 항목 없음)

### Next-Round
(현재 항목 없음)

### Out-of-Scope
(현재 항목 없음)

### Confirm-Needed
- [ ] 비밀번호 재설정 링크 색상 변경 / 어떤 정보가 더 필요한가: (1) 디자인 가이드 / 토큰 정의 / (2) 다른 화면 링크 색상 정합성 / (3) 변경 적용 범위 (비밀번호 재설정 링크만? 모든 링크?)

## 5. 고객 확인 / 거절 안내
- 비밀번호 재설정 링크 색상 변경에 앞서 다음 항목 확정이 먼저 필요합니다.
  1. 디자인 가이드에 정의된 링크 색상 토큰을 확인 부탁드립니다.
  2. 다른 화면들의 링크 색상과의 정합성을 어떻게 가져갈지 확인 부탁드립니다.
  3. 본 변경을 비밀번호 재설정 링크에만 적용할지, 모든 링크에 적용할지 확인 부탁드립니다.

## 6. 개발팀 전달 문구
(In-Round 항목 없음 — 개발팀 전달 없음)

## 7. PM Confirm Gate
(In-Round 항목 없음 — confirm gate skip)

## 8. Notion 스펙 + 태스크
- 스펙 페이지: (생성 안 됨 — In-Round 항목 없음)
- 태스크: (생성 안 됨)

## 9. PM 다음 단계
- In-Round: (없음)
- Confirm-Needed: /client-chat에 §5 사용 → 답변 받아 다시 /to-spec 호출
- Out-of-Scope: (없음)
- Next-Round: (없음)

---

## 다음 단계 (자동 실행 안 함, 안내만)

- In-Round 페이지: (없음)
- Confirm-Needed: /client-chat에 §5 사용
- Out-of-Scope: (없음)
- Next-Round: 다음 라운드 진입 시 본 triage 파일 재검토
- 상태 변경: triage 파일 frontmatter status 직접 수정

---

> ⚠️ **In-Round로 분류·생성된 Notion 스펙은 PM이 §7 confirm gate에서 명시 진행한 항목만 포함합니다. PM 미확인 In-Round 항목은 Notion으로 가지 않았습니다.**
