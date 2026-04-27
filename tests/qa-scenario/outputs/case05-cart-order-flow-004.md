---
status: 작성중
client: Connectory
project: Connectory-2
scenario_id: SCN-connectory-2-004
round: R1
priority: P1
created: 2026-04-27
author: PM
srs_ref: missing
brief_ref: none
---

# [SCN-connectory-2-004] 장바구니에서 주문 완료까지 흐름 검수

> Internal QA scenario draft — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. Source Linkage
- SRS 요구사항 ID: [확인 필요 — Nexus Agent / PM]
- 연결 Change Brief: none
- 연결 Notion 태스크 ID: [확인 필요]
- 연결 화면(Figma URL / 화면명): 장바구니 (`/cart`) → 주문서 (`/checkout`) → 주문 완료 (`/orders/<id>`)
- 우선순위: P1 (라운드별)

## 2. 사용자 역할
- 주 역할: 일반회원

## 3. 사전 조건 (Preconditions)
- 환경: staging URL
- 계정: mock_member_01 (장바구니 비어 있음)
- 외부 의존: 토스 결제 sandbox

## 4. 테스트 목표
사용자가 상품을 장바구니에 추가하고 주문 완료까지 정상 진행할 수 있다.

## 5. 단계별 행동 + 기대 결과
| # | 행동 | 입력값 | 기대 결과 |
|---|------|--------|-----------|
| 1 | 상품 상세 페이지 진입 | - | 상품 정보 노출 |
| 2 | 장바구니 추가 버튼 클릭 | 수량 1 | 장바구니 +1 toast |
| 3 | `/cart` 진입 | - | 추가한 상품 1건 표시 |
| 4 | 주문하기 버튼 클릭 | - | `/checkout` 이동 |
| 5 | 배송지 + 결제 수단 선택 | 기본값 | 검증 통과 |
| 6 | 결제 진행 | - | 주문 완료 화면 이동 |

> 단계 수: 6 (cap 12 이내)

## 6. 최종 기대 결과 (Final)
- UI: 주문 완료 화면 노출, 주문번호 표시
- DB / 서버: orders 테이블 row 1개, order_items 테이블 row 1개
- 외부: 토스 결제 sandbox 1건

## 7. 실패 시 기록 체크리스트
- [ ] 발생 URL (full)
- [ ] 사용 역할 / 계정 (mock)
- [ ] 브라우저 / 디바이스
- [ ] 스크린샷: 필수
- [ ] 화면 녹화: 선택
- [ ] 네트워크 로그(HAR): 필수
- [ ] 콘솔 에러 텍스트
- [ ] 재현률

## 8. 미디어 요구
- 스크린샷: 실패 시만 (P1)
- 영상: 선택

## 9. 실행 로그 (executor가 append)
- 

---

## 다음 단계 (자동 실행 안 함, 안내만)

- 검수 후 발견된 버그: PM 판단 후 `/qa-feedback` 또는 `/issue-ticket` 별도 실행 (본문 첫 줄에 `시나리오 ID: SCN-connectory-2-004` 메타 보존)
- status 변경: 이 파일 frontmatter `status:` 직접 수정 (작성중 → 검토 → 확정)
- `확정` 상태 시나리오만 v3 자동화(`qa-agent-skills` wrapper) 후보 — v1.5에서는 미적용

---

> ⚠️ **이 시나리오는 PM/QA 내부 검수용입니다. 고객·개발팀에 그대로 전달하지 마세요.**

<!-- 충돌 방지 룰 검증: pre-existing SCN-connectory-2-001/002/003 → 이 시나리오는 max+1=004로 자동 부여됨. 기존 파일은 손대지 않음. -->
