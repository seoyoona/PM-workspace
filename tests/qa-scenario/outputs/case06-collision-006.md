---
status: 작성중
client: Connectory
project: Connectory-3
scenario_id: SCN-connectory-3-006
round: R1
priority: P1
created: 2026-04-27
author: PM
srs_ref: missing
brief_ref: none
collision_note: PM이 --scenario-id SCN-connectory-3-005 명시했으나 이미 존재. 자동 덮어쓰지 않고 다음 가용 번호 006으로 자동 증가됨. 기존 SCN-connectory-3-005.md는 손대지 않음.
---

# [SCN-connectory-3-006] 마이페이지 주문 내역 조회 검수

> Internal QA scenario draft — for PM/QA validation only. Not a client-facing spec or dev ticket.

> ℹ️ **충돌로 자동 증가된 번호:** PM이 `--scenario-id SCN-connectory-3-005`로 명시했으나 동일 ID 파일이 이미 존재. 자동 덮어쓰기 절대 금지 룰에 따라 다음 가용 번호인 `SCN-connectory-3-006`으로 자동 부여. 기존 005 파일은 손대지 않음.

## 1. Source Linkage
- SRS 요구사항 ID: [확인 필요 — Nexus Agent / PM]
- 연결 Change Brief: none
- 연결 Notion 태스크 ID: [확인 필요]
- 연결 화면(Figma URL / 화면명): 마이페이지 (`/mypage`) → 주문 내역 (`/mypage/orders`)
- 우선순위: P1

## 2. 사용자 역할
- 주 역할: 일반회원 (이전 주문 보유)

## 3. 사전 조건 (Preconditions)
- 환경: staging URL
- 계정: mock_member_with_orders (주문 5건 보유)
- 외부 의존: 없음

## 4. 테스트 목표
사용자가 마이페이지에서 본인 주문 내역을 정확히 조회할 수 있다.

## 5. 단계별 행동 + 기대 결과
| # | 행동 | 입력값 | 기대 결과 |
|---|------|--------|-----------|
| 1 | mock_member_with_orders 로그인 | - | 로그인 성공 |
| 2 | 마이페이지 진입 | - | 주문 내역 메뉴 노출 |
| 3 | 주문 내역 클릭 | - | 5건 list 노출, 최신순 정렬 |
| 4 | 첫 번째 주문 클릭 | - | 주문 상세 페이지 이동 |

> 단계 수: 4 (cap 12 이내)

## 6. 최종 기대 결과 (Final)
- UI: 주문 list 5건 노출, 주문 상세 페이지 정상 진입
- DB / 서버: orders.user_id = 로그인 user 만 조회 (다른 user 주문 X)
- 외부: 없음

## 7. 실패 시 기록 체크리스트
- [ ] 발생 URL
- [ ] 사용 역할 / 계정 (mock)
- [ ] 브라우저 / 디바이스
- [ ] 스크린샷: 필수
- [ ] 화면 녹화: 선택
- [ ] 네트워크 로그(HAR): 필수
- [ ] 콘솔 에러 텍스트
- [ ] 재현률

## 8. 미디어 요구
- 스크린샷: 실패 시만
- 영상: 선택

## 9. 실행 로그 (executor가 append)
- 

---

## 다음 단계 (자동 실행 안 함, 안내만)

- 검수 후 발견된 버그: PM 판단 후 `/qa-feedback` 또는 `/issue-ticket` 별도 실행 (본문 첫 줄에 `시나리오 ID: SCN-connectory-3-006` 메타 보존)
- status 변경: 이 파일 frontmatter `status:` 직접 수정 (작성중 → 검토 → 확정)

---

> ⚠️ **이 시나리오는 PM/QA 내부 검수용입니다. 고객·개발팀에 그대로 전달하지 마세요.**
