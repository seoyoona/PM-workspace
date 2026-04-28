---
status: 작성중
client: connectory
project: Connectory-1
qa_plan_id: QA-CONNECTORY-20260428
round: R1
created: 2026-04-28
author: PM
srs_ref: missing
brief_refs: [clients/Connectory/Connectory-1/change-briefs/2026-04-27-payment-currency-admin-points.md]
design_md: missing
scope: 전체
---

# QA Plan — connectory Connectory-1 R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. QA 범위
**검수 대상:**
- SRS 요구사항: [확인 필요 — SRS 미연결]
- 화면 list: 포인트 충전 화면 (Change Brief에서 추출)
- Change Brief In-Round 항목: 결제 화면 CNY-KRW 통화 안내 문구 추가

**검수 제외 (인지만):**
- Out-of-Scope 항목: (현재 항목 없음)
- Confirm-Needed 항목: 어드민 포인트 수동 조정 기능 — MVP 견적 포함 여부 확인 필요

## 2. 테스트 역할 / 계정
- 주 역할: 일반회원 (중국 유저)
- mock 계정 매핑:
  - mock_cn_user_01 — role: 일반회원, 보유 포인트 0
- 외부 의존: 토스 결제 sandbox

## 3. 전체 플로우 맵
```
mock_cn_user_01 로그인
└── 포인트 충전 화면 (`/payment/points`)
    ├── 패키지 선택 (CNY 표시)
    ├── 결제 안내 영역 (KRW 환산 표시 — Change Brief 검증)
    └── 결제 진행 (토스 sandbox)
```

(design.md 부재 — UI 표현 상세 보조 불가)

## 4. P0 핵심 시나리오 (필수 회귀)

### P0-01: 중국 유저 결제 시 CNY-KRW 통화 안내 노출 (Change Brief In-Round)
- 역할: 일반회원 (중국 유저)
- 사전 조건: staging, mock_cn_user_01, 환율 mock 활성화, 토스 sandbox
- 단계 (≤9):
  1. mock_cn_user_01 로그인
  2. 포인트 충전 화면 진입
  3. 100 CNY 패키지 선택
  4. 결제 안내 영역 확인 → CNY-KRW 환산 문구 노출
  5. 결제 진행 → 토스 모달 KRW 금액 노출
- 기대 결과: UI 환산 안내 1줄 추가 / DB 결제 row currency_displayed=CNY, charged=KRW / 외부 토스 sandbox KRW 호출

## 5. P1 보조 시나리오

(현재 항목 없음)

## 6. Edge / Negative Case

### EDGE-01: 환율 mock 실패 시
- 시나리오: 환율 API 실패 응답
- 기대 결과: 결제 안내 영역에 fallback 문구 [확인 필요 — fallback 정책 source 미명시]

## 7. Regression Checklist (이전 → R1)

(현재 회귀 대상 없음 — 이전 라운드 정보 미연결)

## 8. QA 전달 메시지

```
안녕하세요, Connectory-1 R1 QA 플랜을 공유드립니다.

검수 시나리오:
- P0 (필수): P0-01
- EDGE: EDGE-01

테스트 환경:
- staging URL: [확인 필요]
- mock 계정: mock_cn_user_01 (일반회원, 중국 유저)
- 마감 일자: [확인 필요]

실패 보고 시 본문 첫 줄에 다음 메타를 보존해 주세요:
QA Plan: QA-CONNECTORY-20260428
Scenario: P0-NN

문의 사항은 회신 부탁드립니다.
```

## 9. PM 확인 필요

- SRS 미연결 — Nexus Agent / dev팀 확인 필요
- design.md 부재 — UI 표현 상세 검증은 별도 design owner 확인 필요
- staging URL / 마감 일자 공유 필요
- 환율 API 실패 시 fallback 정책 source 미명시 → dev 확인

---

## 다음 단계 (자동 실행 안 함, 안내만)

- §8 QA 전달 메시지 → `/client-chat` 또는 `/qa-request`에 사용
- 검수 후 발견된 버그 → `/qa-feedback` (본문 첫 줄에 메타 보존)
- 큰 버그 → `/issue-ticket` → Linear
- status 변경: 이 파일 frontmatter `status:` 직접 수정

---

> ⚠️ **이 QA plan은 PM/QA 내부 검수용입니다.** §1~§7을 고객·개발팀에 그대로 전달하지 마세요. §8만 전달용.
