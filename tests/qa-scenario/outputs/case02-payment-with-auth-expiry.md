---
status: 작성중
client: Connectory
project: Connectory-1
scenario_id: SCN-connectory-1-001
round: R1
priority: P0
created: 2026-04-27
author: PM
srs_ref: REQ-PAY-01, REQ-AUTH-03
brief_ref: none
---

# [SCN-connectory-1-001] 결제 진행 중 로그인 만료 시 재인증 후 결제 복원 검수

> Internal QA scenario draft — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. Source Linkage
- SRS 요구사항 ID: REQ-PAY-01 (포인트 결제 처리), REQ-AUTH-03 (로그인 만료 시 재인증)
- 연결 Change Brief: none
- 연결 Notion 태스크 ID: [확인 필요]
- 연결 화면(Figma URL / 화면명): 포인트 결제 흐름 (충전·결제·결과 페이지)
- 우선순위: P0 (필수 회귀 — 결제 + 인증 동시 검증)

## 2. 사용자 역할
- 주 역할: 일반회원
- 보조 역할: 없음

## 3. 사전 조건 (Preconditions)
- 환경: staging, 세션 만료 시간 5분으로 단축 (테스트용 설정)
- 계정: mock_user_paid01 (포인트 잔액 5000)  ← mock credential
- 외부 의존: 토스 결제 sandbox

## 4. 테스트 목표
사용자가 결제 진행 중 세션이 만료되면 재인증 후 결제 흐름이 정상 복원된다.

## 5. 단계별 행동 + 기대 결과
| # | 행동 | 입력값 | 기대 결과 |
|---|------|--------|-----------|
| 1 | mock_user_paid01 로그인 | - | 로그인 성공 |
| 2 | 포인트 결제 화면 진입 → 1000P 결제 시도 | 1000 | 결제 안내 노출 |
| 3 | 결제 모달에서 6분 대기 (세션 만료 트리거) | - | 세션 만료 감지 |
| 4 | 결제 진행 버튼 클릭 | - | 재인증 모달 노출 (REQ-AUTH-03) |
| 5 | 재인증 비밀번호 입력 | mock_password | 인증 성공 |
| 6 | 결제 흐름 자동 복원 | - | 결제 모달이 직전 상태로 복귀 (REQ-PAY-01) |
| 7 | 결제 완료 | - | 결제 성공 + 포인트 차감 |

> 단계 수: 7 (cap 12 이내)

## 6. 최종 기대 결과 (Final)
- UI: 결제 완료 toast + 포인트 잔액 갱신
- DB / 서버: 결제 row 생성, 포인트 1000 차감, 세션 재발급 로그 1건
- 외부: 토스 결제 sandbox 1건 (KRW 환산)

## 7. 실패 시 기록 체크리스트
- [ ] 발생 URL (full)
- [ ] 사용 역할 / 계정 (mock 식별자만)
- [ ] 브라우저 / 디바이스
- [ ] 스크린샷: 필수
- [ ] 화면 녹화: 필수 (P0)
- [ ] 네트워크 로그(HAR): 필수
- [ ] 콘솔 에러 텍스트
- [ ] 재현률 (1/1, 1/3 등)

## 8. 미디어 요구
- 스크린샷: 모든 단계 (P0 default)
- 영상: 필수

## 9. 실행 로그 (executor가 append)
- 

---

## 다음 단계 (자동 실행 안 함, 안내만)

- 검수 후 발견된 버그: PM 판단 후 `/qa-feedback` 또는 `/issue-ticket` 별도 실행 (본문 첫 줄에 `시나리오 ID: SCN-connectory-1-001` 메타 보존)
- status 변경: 이 파일 frontmatter `status:` 직접 수정 (작성중 → 검토 → 확정)
- `확정` 상태 시나리오만 v3 자동화(`qa-agent-skills` wrapper) 후보 — v1.5에서는 미적용

---

> ⚠️ **이 시나리오는 PM/QA 내부 검수용입니다. 고객·개발팀에 그대로 전달하지 마세요.**
