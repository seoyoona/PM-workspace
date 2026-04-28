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
brief_ref: clients/Connectory/Connectory-1/change-briefs/2026-04-27-payment-currency-admin-points.md
---

# [SCN-connectory-1-001] 포인트결제 화면 CNY-KRW 통화 안내 노출 검수

> Internal QA scenario draft — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. Source Linkage
- SRS 요구사항 ID: [확인 필요 — Nexus Agent / PM]
- 연결 Change Brief: clients/Connectory/Connectory-1/change-briefs/2026-04-27-payment-currency-admin-points.md (status=Dev-Handoff 가정)
- 연결 Notion 태스크 ID: [확인 필요]
- 연결 화면(Figma URL / 화면명): 포인트 충전 화면 (`/payment/points`)
- 우선순위: P1 (라운드별 회귀)

## 2. 사용자 역할
- 주 역할: 일반회원 (중국 유저)
- 보조 역할: 없음

## 3. 사전 조건 (Preconditions)
- 환경: staging URL, 환율 mock 활성화
- 계정: mock_cn_user_01 (보유 포인트 0)  ← 실제 credential 대신 mock 사용
- 외부 의존: 토스 결제 sandbox

## 4. 테스트 목표
중국 유저가 결제 진행 전 CNY 표시 포인트와 KRW 실 결제 통화 차이를 명확히 인지한다.

## 5. 단계별 행동 + 기대 결과
| # | 행동 | 입력값 | 기대 결과 |
|---|------|--------|-----------|
| 1 | 비로그인 상태로 staging URL 진입 | - | 200, 랜딩 노출 |
| 2 | 로그인 버튼 클릭 → mock 계정 로그인 | mock_cn_user_01 | 메인 페이지 로그인 상태 |
| 3 | 포인트 충전 화면 진입 (`/payment/points`) | - | CNY 기준 포인트 패키지 list 노출 |
| 4 | 충전 패키지 선택 (예: 100 CNY = 1,000 P) | 패키지 클릭 | 결제 안내 영역 표시 |
| 5 | 결제 안내 영역 확인 | - | "실제 결제는 KRW로 진행됩니다 (현재 환율: 1 CNY = 약 X KRW)" 안내 문구 노출 |
| 6 | 결제 진행 버튼 클릭 | - | 토스 결제 모달 KRW 금액 노출 |

> 단계 수: 6 (cap 12 이내)

## 6. 최종 기대 결과 (Final)
- UI: 결제 안내 영역에 CNY-KRW 환산 문구 1줄 추가, 결제 모달은 KRW 표시
- DB / 서버: 결제 시도 row 생성, currency_displayed = CNY, currency_charged = KRW
- 외부: 토스 결제 sandbox에 KRW 금액으로 호출

## 7. 실패 시 기록 체크리스트
- [ ] 발생 URL (full)
- [ ] 사용 역할 / 계정 (mock 식별자만)
- [ ] 브라우저 / 디바이스
- [ ] 스크린샷: 필수
- [ ] 화면 녹화: 선택
- [ ] 네트워크 로그(HAR): 필수
- [ ] 콘솔 에러 텍스트
- [ ] 재현률 (1/1, 1/3 등)

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
