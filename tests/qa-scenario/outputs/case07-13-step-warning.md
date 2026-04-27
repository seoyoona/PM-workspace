---
status: 작성중
client: Connectory
project: Connectory-4
scenario_id: SCN-connectory-4-001
round: R1
priority: P0
created: 2026-04-27
author: PM
srs_ref: missing
brief_ref: none
step_count: 13
---

# [SCN-connectory-4-001] 복합 결제 → 환불 → 재결제 → 영수증 다운로드 검수

> Internal QA scenario draft — for PM/QA validation only. Not a client-facing spec or dev ticket.

> ⚠️ **단계 수가 12를 초과했습니다 (현재 13). 시나리오 분리를 권장합니다.** 자동 자르지 않고 그대로 보존. PM이 분리·통합 결정.

## 1. Source Linkage
- SRS 요구사항 ID: [확인 필요 — Nexus Agent / PM]
- 연결 Change Brief: none
- 연결 Notion 태스크 ID: [확인 필요]
- 연결 화면(Figma URL / 화면명): 결제·환불·재결제·영수증 흐름 전체
- 우선순위: P0 (필수 회귀)

## 2. 사용자 역할
- 주 역할: 일반회원

## 3. 사전 조건 (Preconditions)
- 환경: staging, 결제 sandbox + 환불 자동 승인 모드
- 계정: mock_member_paid (결제 가능 잔액 보유)
- 외부 의존: 토스 결제 sandbox

## 4. 테스트 목표
복합 결제→환불→재결제→영수증 다운로드까지 전체 흐름이 단일 세션에서 정상 동작한다.

## 5. 단계별 행동 + 기대 결과
| # | 행동 | 입력값 | 기대 결과 |
|---|------|--------|-----------|
| 1 | mock_member_paid 로그인 | - | 로그인 성공 |
| 2 | 상품 A 결제 | 1만원 | 결제 완료 |
| 3 | 상품 B 결제 | 2만원 | 결제 완료 |
| 4 | 마이페이지 → 주문 내역 진입 | - | 주문 2건 노출 |
| 5 | 상품 A 환불 요청 | 환불 사유: 단순 변심 | 환불 접수 |
| 6 | 환불 자동 승인 | - | 환불 완료 toast |
| 7 | 환불 금액 잔액 반영 확인 | - | 잔액 +1만원 |
| 8 | 상품 A 재결제 | 1만원 | 결제 완료 |
| 9 | 재결제 후 주문 내역 갱신 | - | 주문 3건 노출 |
| 10 | 영수증 메뉴 진입 | - | 영수증 list 3건 |
| 11 | 영수증 PDF 다운로드 | - | PDF 다운로드 시작 |
| 12 | PDF 내용 확인 | - | 결제 정보 정확 |
| 13 | 환불 영수증 별도 표시 확인 | - | 환불 row가 별도 라벨로 표시 |

> 단계 수: 13 (cap 12 초과 — 위 경고 참조)

## 6. 최종 기대 결과 (Final)
- UI: 주문 3건 + 환불 1건 + 영수증 3개 PDF
- DB / 서버: orders 3 row + refunds 1 row + payment_logs 일관성
- 외부: 토스 sandbox 4건 호출 (3 결제 + 1 환불)

## 7. 실패 시 기록 체크리스트
- [ ] 발생 URL
- [ ] 사용 역할 / 계정 (mock)
- [ ] 브라우저 / 디바이스
- [ ] 스크린샷: 필수
- [ ] 화면 녹화: 필수 (P0)
- [ ] 네트워크 로그(HAR): 필수
- [ ] 콘솔 에러 텍스트
- [ ] 재현률

## 8. 미디어 요구
- 스크린샷: 모든 단계 (P0)
- 영상: 필수

## 9. 실행 로그 (executor가 append)
- 

---

## 다음 단계 (자동 실행 안 함, 안내만)

- 검수 후 발견된 버그: PM 판단 후 `/qa-feedback` 또는 `/issue-ticket` 별도 실행 (본문 첫 줄에 `시나리오 ID: SCN-connectory-4-001` 메타 보존)
- status 변경: 이 파일 frontmatter `status:` 직접 수정 (작성중 → 검토 → 확정)
- 권장: 13단계는 분리 (예: 결제+환불 / 재결제+영수증 두 개로) — PM 판단

---

> ⚠️ **이 시나리오는 PM/QA 내부 검수용입니다. 고객·개발팀에 그대로 전달하지 마세요.**
