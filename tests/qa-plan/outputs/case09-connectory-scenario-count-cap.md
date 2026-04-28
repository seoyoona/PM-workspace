---
status: 작성중
client: connectory
project: Connectory-1
qa_plan_id: QA-CONNECTORY-20260428
round: R1
created: 2026-04-28
author: PM
srs_ref: clients/Connectory/Connectory-1/srs.md
brief_refs: [clients/Connectory/Connectory-1/change-briefs/cb-01.md, cb-02.md, cb-03.md, cb-04.md, cb-05.md]
design_md: clients/Connectory/Connectory-1/design.md
scope: 전체
---

# QA Plan — connectory Connectory-1 R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. QA 범위
**검수 대상:**
- SRS 요구사항: REQ-CONNECTORY-01~20 (20개)
- 화면 list: 10개
- Change Brief In-Round 항목: 5건

**검수 제외:** (현재 항목 없음)

## 2. 테스트 역할 / 계정
- 주 역할: 일반회원, 관리자
- mock 계정: mock_member_01, mock_admin_01

## 3. 전체 플로우 맵
(생략 — 10화면 전체 텍스트 트리)

## 4. P0 핵심 시나리오 (10개)

### P0-01: 회원가입
### P0-02: 로그인
### P0-03: 포인트 충전
### P0-04: 결제
### P0-05: 환불
### P0-06: 주문 내역 조회
### P0-07: 마이페이지 정보 수정
### P0-08: 프로필 사진 변경
### P0-09: 비밀번호 변경
### P0-10: 회원 탈퇴

(상세 단계 생략 — 각 ≤9 단계)

## 5. P1 보조 시나리오 (8개)

### P1-01 ~ P1-08
(상세 생략)

## 6. Edge / Negative Case (3개)

### EDGE-01 ~ EDGE-03
(상세 생략)

## 7. Regression Checklist

### REG-01 ~ REG-02
(상세 생략)

> 시나리오 수: P0=10, P1=8, EDGE=3, REG=2 → 합계 23개. 화면 수 10 × 1.5 = 15 cap 초과.

## 8. QA 전달 메시지

```
안녕하세요, Connectory-1 R1 QA 플랜 공유드립니다.

검수 시나리오:
- P0: P0-01 ~ P0-10 (10개)
- P1: P1-01 ~ P1-08 (8개)
- EDGE: EDGE-01 ~ EDGE-03 (3개)
- REG: REG-01 ~ REG-02 (2개)
총 23개 — 분량 큰 라운드.

테스트 환경:
- staging URL: [확인 필요]
- mock 계정: mock_member_01, mock_admin_01

실패 보고 시 메타 보존:
QA Plan: QA-CONNECTORY-20260428
Scenario: P0-NN

문의 회신 부탁드립니다.
```

## 9. PM 확인 필요

- **시나리오 수 cap 초과** — 합계 23개. 화면 수 10 × 1.5 = 15 cap 초과. **분리·통합 검토 권장:**
  - 옵션 A: 라운드 분할 (R1 절반 + R2 절반)
  - 옵션 B: P1 일부를 다음 라운드로 미루기
  - 옵션 C: 그대로 진행 (QA 분량 큰 라운드)
- staging URL 공유 필요

---

## 다음 단계 (자동 실행 안 함, 안내만)

- §9 시나리오 수 cap 초과 결정 후 §8 메시지 조정
- §8 → `/client-chat` 또는 `/qa-request`
- 버그 → `/qa-feedback` (메타 보존)
- status 변경: frontmatter 직접 수정

---

> ⚠️ **이 QA plan은 PM/QA 내부 검수용입니다.** §1~§7을 고객·개발팀에 그대로 전달하지 마세요. §8만 전달용.
