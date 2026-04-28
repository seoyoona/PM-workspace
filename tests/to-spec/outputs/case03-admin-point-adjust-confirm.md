---
status: Confirm-Needed-only
client: Connectory
project: Connectory-1
created: 2026-04-28
source: free-text
source_ref: "tests/to-spec/fixtures/case03-confirm-needed-default.md (test fixture)"
srs_ref: missing
design_md: missing
spec_pages: []
---

# Request Triage — 어드민 회원 점수 조정 기능 (대상·한도·이력 미정)

> Reference draft — official spec lives in Nexus / PM Notion. In-Round 항목은 PM confirm 후 커뮤니케이션 DB / 태스크 DB에 자동 생성됩니다.

## 1. 변경 요청 요약
- 누가 / 언제 / 어떤 채널: Connectory 고객사, 2026-04-28, 미팅 발언
- 원문 인용:
  > "어드민에서 회원 점수를 직접 조정할 수 있는 기능이 필요하다고 들었습니다. 어떤 회원 grade에서 가능한지, 한도가 있는지, 이력 추적이 필요한지 등은 아직 정해지지 않았습니다."
- PM 1-line 정규화: 어드민이 회원 점수를 임의 조정하는 기능 — 적용 대상/한도/이력 정책 미정.

## 2. 기존 범위 대비 영향도
- SRS 참조: [확인 필요] SRS 미연결 — Nexus Agent / PM 확인 필요
- 영향 분류: 신규 기능 (Confirm-Needed)
- 전체 Impact: Unknown

## 3. 화면·UX 영향
- [확인 필요] design.md 부재 — UI 영향 상세 판단은 design owner / Nexus Agent 확인 필요
- design.md 갱신 필요 여부: 판단 보류
- wireframe 필요 여부: 판단 보류 [추론 — 어드민 화면 신규 추가 가능성, 그러나 권한·이력 모델 미정으로 와이어프레임 작성 시기 X]

## 4. 4-Bucket Triage

### In-Round
(현재 항목 없음)

### Next-Round
(현재 항목 없음)

### Out-of-Scope
(현재 항목 없음)

### Confirm-Needed
- [ ] 어드민 회원 점수 조정 기능 / 어떤 정보가 더 필요한가: (1) 적용 대상 회원 grade (2) 일회 / 일별 / 월별 조정 한도 (3) 이력 추적 + 사유 입력 의무 (4) 권한 분리 (super-admin only?) (5) MVP 견적 포함 여부

## 5. 고객 확인 / 거절 안내
- 어드민이 회원 점수를 조정하는 기능을 검토 중이신데, 다음 항목 확정이 먼저 필요합니다.
  1. 어떤 회원 grade에서 조정이 가능해야 하는지 확인 부탁드립니다.
  2. 일회·일별·월별 조정 한도가 있는지 확인 부탁드립니다.
  3. 이력 추적과 조정 사유 입력 의무 여부를 확인 부탁드립니다.
  4. super-admin만 가능한지, 일반 admin도 가능한지 권한 분리에 대한 정책을 확인 부탁드립니다.
  5. 본 기능이 현재 라운드 MVP 견적에 포함되는지 확인 부탁드립니다.

## 6. 개발팀 전달 문구
(In-Round 항목 없음 — 개발팀 전달 없음)

## 7. PM Confirm Gate
(In-Round 항목 없음 — confirm gate skip)

## 8. Notion 스펙 + 태스크
- 스펙 페이지: (생성 안 됨 — In-Round 항목 없음)
- 태스크: (생성 안 됨)

## 9. PM 다음 단계
- In-Round: (없음)
- Confirm-Needed: /client-chat에 §5 사용 → 5개 질문 발송 후 답변 받아 다시 /to-spec 호출
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
