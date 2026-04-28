---
status: 작성중
client: connectory
project: Connectory-1
qa_plan_id: QA-CONNECTORY-20260428
round: R1
created: 2026-04-28
author: PM
srs_ref: clients/Connectory/Connectory-1/srs.md
brief_refs: []
design_md: clients/Connectory/Connectory-1/design.md
scope: 전체
---

# QA Plan — connectory Connectory-1 R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. QA 범위
**검수 대상:**
- SRS 요구사항: REQ-CONNECTORY-01 (회원가입), REQ-CONNECTORY-02 (포인트 충전), REQ-CONNECTORY-03 (결제), REQ-CONNECTORY-04 (마이페이지), REQ-CONNECTORY-05 (주문 내역)
- 화면 list: 회원가입 / 포인트 충전 / 결제 / 마이페이지 / 주문 내역
- Change Brief In-Round 항목: (현재 항목 없음)

**검수 제외 (인지만):**
- Out-of-Scope 항목: (현재 항목 없음)
- Confirm-Needed 항목: (현재 항목 없음)

## 2. 테스트 역할 / 계정
- 주 역할: 일반회원
- mock 계정 매핑:
  - mock_member_01 — role: 일반회원, 잔액 5000
- 외부 의존: 토스 결제 sandbox

## 3. 전체 플로우 맵
```
mock_member_01 로그인
├── 회원가입 (REQ-CONNECTORY-01)
├── 포인트 충전 (REQ-CONNECTORY-02)
├── 결제 (REQ-CONNECTORY-03)
└── 마이페이지 → 주문 내역 (REQ-CONNECTORY-04, 05)
```

(design.md 화면명 보조 인용 가능)

## 4. P0 핵심 시나리오 (필수 회귀)

### P0-01: 회원가입 → 자동 로그인 (REQ-CONNECTORY-01)
- 역할: 비회원
- 사전 조건: staging, mock 신규 이메일
- 단계 (≤9):
  1. /signup 진입
  2. 필수 필드 입력
  3. 가입하기 클릭
  4. /home redirect 확인
- 기대 결과: UI 가입 완료 toast / DB users row 1개 / 외부 [확인 필요 — 이메일 발송 source 미명시]

### P0-02: 포인트 충전 → 결제 → 잔액 반영 (REQ-CONNECTORY-02, 03)
- 역할: 일반회원
- 사전 조건: mock_member_01, 토스 sandbox
- 단계 (≤9):
  1. mock_member_01 로그인
  2. 포인트 충전 화면 진입
  3. 1만원 패키지 선택
  4. 토스 sandbox 결제
  5. 잔액 갱신 확인
- 기대 결과: UI 잔액 +1만원 / DB orders + payments row / 외부 토스 1건

## 5. P1 보조 시나리오

### P1-01: 마이페이지 주문 내역 조회 (REQ-CONNECTORY-04, 05)
- 역할: 일반회원
- 사전 조건: mock_member_01, 이전 주문 1건+
- 단계 (≤9):
  1. 마이페이지 → 주문 내역 진입
  2. list 노출 확인
- 기대 결과: 본인 주문만 노출 (다른 user 주문 X)

## 6. Edge / Negative Case

### EDGE-01: 다른 회원 주문 URL 직접 접근
- 시나리오: mock_member_01이 다른 회원의 order id URL 직접 진입
- 기대 결과: 403 또는 본인 주문 list로 redirect

## 7. Regression Checklist (이전 → R1)

(현재 회귀 대상 없음 — Change Brief 미연결로 변경 영향 영역 없음)

## 8. QA 전달 메시지

```
안녕하세요, Connectory-1 R1 QA 플랜을 공유드립니다.

검수 시나리오:
- P0 (필수): P0-01, P0-02
- P1 (보조): P1-01
- EDGE: EDGE-01

테스트 환경:
- staging URL: [확인 필요]
- mock 계정: mock_member_01 (일반회원)
- 마감 일자: [확인 필요]

실패 보고 시 본문 첫 줄에 메타 보존:
QA Plan: QA-CONNECTORY-20260428
Scenario: P0-NN

문의 회신 부탁드립니다.
```

## 9. PM 확인 필요

- Change Brief 미연결 — 이번 라운드 변경 영향 영역 없음 (회귀 대상 0)
- 외부 효과 (이메일 발송 등) source 부재 → dev 확인 필요
- staging URL / 마감 일자 공유 필요

---

## 다음 단계 (자동 실행 안 함, 안내만)

- §8 → `/client-chat` 또는 `/qa-request`
- 버그 → `/qa-feedback` (메타 보존)
- 큰 버그 → `/issue-ticket`
- status 변경: frontmatter 직접 수정

---

> ⚠️ **이 QA plan은 PM/QA 내부 검수용입니다.** §1~§7을 고객·개발팀에 그대로 전달하지 마세요. §8만 전달용.
