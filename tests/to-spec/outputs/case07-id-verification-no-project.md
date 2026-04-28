---
status: Confirm-Needed-only
client: Connectory
project: unknown
created: 2026-04-28
source: free-text
source_ref: "tests/to-spec/fixtures/case07-project-missing-fallback.md (test fixture)"
srs_ref: missing
design_md: missing
spec_pages: []
---

# Request Triage — 본인 인증 이메일 추가 (project 미식별)

> Reference draft — official spec lives in Nexus / PM Notion. In-Round 항목은 PM confirm 후 커뮤니케이션 DB / 태스크 DB에 자동 생성됩니다.

## 1. 변경 요청 요약
- 누가 / 언제 / 어떤 채널: Connectory 고객사, 2026-04-28, 직접 피드백
- 원문 인용:
  > "회원 본인 인증 방법을 휴대폰뿐 아니라 이메일로도 가능하게 해주세요. 어떤 화면에서 어떻게 동작할지는 추후 협의입니다."
- PM 1-line 정규화: 본인 인증 채널을 휴대폰에 더해 이메일까지 확장 요청 — 화면·플로우 미정.

## 2. 기존 범위 대비 영향도
- SRS 참조: [확인 필요] SRS 미연결 — Nexus Agent / PM 확인 필요
- 영향 분류: 신규 기능 (Confirm-Needed)
- 전체 Impact: Unknown

## 3. 화면·UX 영향
- [확인 필요] design.md 부재 — UI 영향 상세 판단은 design owner / Nexus Agent 확인 필요
- design.md 갱신 필요 여부: 판단 보류
- wireframe 필요 여부: 판단 보류

## 4. 4-Bucket Triage

### In-Round
(현재 항목 없음)

### Next-Round
(현재 항목 없음)

### Out-of-Scope
(현재 항목 없음)

### Confirm-Needed
- [ ] 이메일 본인 인증 / 어떤 정보가 더 필요한가: (1) 가입 / 로그인 / 비밀번호 재설정 중 어느 화면에 적용 / (2) 휴대폰 인증과 OR / AND / (3) 인증 코드 발송 채널 / (4) 만료·재발송 정책

## 5. 고객 확인 / 거절 안내
- 이메일 본인 인증 추가에 앞서 다음 항목 확정이 먼저 필요합니다.
  1. 어떤 화면(가입 / 로그인 / 비밀번호 재설정 등)에 적용할지 확인 부탁드립니다.
  2. 휴대폰 인증과 OR / AND 관계를 어떻게 가져갈지 확인 부탁드립니다.
  3. 인증 코드 발송 채널과 만료·재발송 정책을 확인 부탁드립니다.

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
- [확인 필요 — project 미식별] clients/Connectory/ 하위 project 디렉토리가 발견되지 않아 frontmatter project: unknown으로 저장되었습니다. 본 항목이 어느 project인지 PM 확인 부탁드립니다.

---

## 다음 단계 (자동 실행 안 함, 안내만)

- In-Round 페이지: (없음)
- Confirm-Needed: /client-chat에 §5 사용
- Out-of-Scope: (없음)
- Next-Round: 다음 라운드 진입 시 본 triage 파일 재검토
- 상태 변경: triage 파일 frontmatter status 직접 수정

---

> ⚠️ **In-Round로 분류·생성된 Notion 스펙은 PM이 §7 confirm gate에서 명시 진행한 항목만 포함합니다. PM 미확인 In-Round 항목은 Notion으로 가지 않았습니다.**
