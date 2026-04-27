---
status: 작성중
client: Connectory
project: Connectory-1
scenario_id: SCN-connectory-1-001
round: R1
priority: P1
created: 2026-04-27
author: PM
srs_ref: missing
brief_ref: none
---

# [SCN-connectory-1-001] 회원가입 폼 제출 후 가입 완료 화면 진입 검수

> Internal QA scenario draft — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. Source Linkage
- SRS 요구사항 ID: [확인 필요 — Nexus Agent / PM]
- 연결 Change Brief: none
- 연결 Notion 태스크 ID: [확인 필요]
- 연결 화면(Figma URL / 화면명): 회원가입 폼 (`/signup`) → 가입 완료 (`/home`)
- 우선순위: P1 (라운드별 회귀)

## 2. 사용자 역할
- 주 역할: 비회원 (가입 진행 사용자)
- 보조 역할: 없음

## 3. 사전 조건 (Preconditions)
- 환경: staging URL
- 계정: 가입 전 (mock 신규 이메일 사용)
- 외부 의존: [확인 필요]

## 4. 테스트 목표
유효한 가입 폼 제출 시 가입 완료 toast가 노출되고 `/home`으로 이동하며 users 테이블에 row가 생성된다.

## 5. 단계별 행동 + 기대 결과
| # | 행동 | 입력값 | 기대 결과 |
|---|------|--------|-----------|
| 1 | `/signup` 진입 | - | 회원가입 폼 노출 |
| 2 | 필수 필드 입력 (이메일, 비밀번호, 약관 동의) | mock_signup_user@example.com / mock_password | 입력 완료 |
| 3 | 가입하기 버튼 클릭 | - | 가입 완료 toast 노출 |
| 4 | redirect 확인 | - | `/home`으로 이동 |

> 단계 수: 4 (cap 12 이내)

## 6. 최종 기대 결과 (Final)
- UI: 가입 완료 toast + `/home` 이동
- DB / 서버: users 테이블에 row 1개 생성 (이메일, 가입일, 약관 동의 timestamp)
- 외부: [확인 필요 — source(SRS / Change Brief / PM 메모)에 외부 효과(이메일·푸시·외부 API 호출) 명시 없음. design owner 또는 dev 확인 필요]

## 7. 실패 시 기록 체크리스트
- [ ] 발생 URL (full)
- [ ] 사용 역할 / 계정 (mock 식별자만)
- [ ] 브라우저 / 디바이스
- [ ] 스크린샷: 필수
- [ ] 화면 녹화: 선택
- [ ] 네트워크 로그(HAR): 필수
- [ ] 콘솔 에러 텍스트
- [ ] 재현률

## 8. 미디어 요구
- 스크린샷: 실패 시만 (P1 default)
- 영상: 선택

## 9. 실행 로그 (executor가 append)
- 

---

## 다음 단계 (자동 실행 안 함, 안내만)

- 검수 후 발견된 버그: PM 판단 후 `/qa-feedback` 또는 `/issue-ticket` 별도 실행 (본문 첫 줄에 `시나리오 ID: SCN-connectory-1-001` 메타 보존)
- status 변경: 이 파일 frontmatter `status:` 직접 수정 (작성중 → 검토 → 확정)
- `확정` 상태 시나리오만 v3 자동화(`qa-agent-skills` wrapper) 후보 — v1.5에서는 미적용

---

> ⚠️ **이 시나리오는 PM/QA 내부 검수용입니다. 고객·개발팀에 그대로 전달하지 마세요.**
