---
status: 작성중
client: Connectory
project: Connectory-5
scenario_id: SCN-connectory-5-001
round: R1
priority: P1
created: 2026-04-27
author: PM
srs_ref: missing
brief_ref: none
step_count: 10
---

# [SCN-connectory-5-001] 결제 → 환불 → 재결제 흐름 검수

> Internal QA scenario draft — for PM/QA validation only. Not a client-facing spec or dev ticket.

> ℹ️ **현재 시나리오는 10단계입니다.** PM/QA 실행성을 위해 작성/제출/검수 등으로 분리할지 검토하세요. 자동 분리는 하지 않습니다.

## 1. Source Linkage
- SRS 요구사항 ID: [확인 필요 — Nexus Agent / PM]
- 연결 Change Brief: none
- 연결 Notion 태스크 ID: [확인 필요]
- 연결 화면(Figma URL / 화면명): 결제 / 환불 / 재결제 흐름 전체
- 우선순위: P1 (라운드별 회귀)

## 2. 사용자 역할
- 주 역할: 일반회원

## 3. 사전 조건 (Preconditions)
- 환경: staging URL, 결제 sandbox + 환불 자동 승인 모드
- 계정: mock_member_paid (잔액 보유)  ← mock credential
- 외부 의존: 토스 결제 sandbox

## 4. 테스트 목표
사용자가 결제 후 환불 처리하고 다시 재결제하는 흐름이 단일 세션에서 정상 동작한다.

## 5. 단계별 행동 + 기대 결과
| # | 행동 | 입력값 | 기대 결과 |
|---|------|--------|-----------|
| 1 | mock_member_paid 로그인 | - | 로그인 성공 |
| 2 | 상품 결제 진행 | 1만원 | 결제 완료 |
| 3 | 마이페이지 → 주문 내역 | - | 결제 1건 노출 |
| 4 | 환불 요청 | 사유: 단순 변심 | 환불 접수 |
| 5 | 환불 자동 승인 처리 | - | 환불 완료 toast |
| 6 | 잔액 반영 확인 | - | +1만원 잔액 |
| 7 | 동일 상품 재결제 | 1만원 | 결제 완료 |
| 8 | 주문 내역 갱신 확인 | - | 주문 2건 노출 |
| 9 | 영수증 메뉴 진입 | - | 결제·환불 row 정렬 |
| 10 | 영수증 PDF 다운로드 | - | PDF 다운로드 시작 |

> 단계 수: 10 (권장 6~9 범위 밖, 10~12 분리 검토 권장 tier — 위 안내 참조)

## 6. 최종 기대 결과 (Final)
- UI: 주문 2건 + 환불 1건 + 영수증 PDF
- DB / 서버: orders 2 row + refunds 1 row + payment_logs 일관성
- 외부: 토스 sandbox 3건 호출 (2 결제 + 1 환불)

## 7. 실패 시 기록 체크리스트
- [ ] 발생 URL
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

- 검수 후 발견된 버그: PM 판단 후 `/qa-feedback` 또는 `/issue-ticket` 별도 실행 (본문 첫 줄에 `시나리오 ID: SCN-connectory-5-001` 메타 보존)
- status 변경: 이 파일 frontmatter `status:` 직접 수정 (작성중 → 검토 → 확정)
- 분리 검토 권장: 결제 / 환불 / 재결제 / 영수증 4개 시나리오로 나눌지 PM 판단

---

> ⚠️ **이 시나리오는 PM/QA 내부 검수용입니다. 고객·개발팀에 그대로 전달하지 마세요.**
