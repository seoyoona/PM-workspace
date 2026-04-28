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

> ℹ️ **선택된 project: Connectory-1** (근거: 최근 mtime 2일 전, clients/Connectory/CLAUDE.md `프로젝트명`과 일치)
>
> 참고: clients/connectory/ 하위 project 후보 3개 — Connectory-1 (선택), Connectory-2, Connectory-3. PM이 1번 선택 후 진행.

## 1. QA 범위
**검수 대상:**
- SRS 요구사항: REQ-CONNECTORY-01~05
- 화면 list: 회원가입 / 결제 / 마이페이지
- Change Brief In-Round 항목: (현재 항목 없음)

**검수 제외 (인지만):**
- Out-of-Scope 항목: (현재 항목 없음)
- Confirm-Needed 항목: (현재 항목 없음)

## 2. 테스트 역할 / 계정
- 주 역할: 일반회원
- mock 계정: mock_member_01

## 3. 전체 플로우 맵
```
mock_member_01 로그인 → 결제 → 마이페이지
```

## 4. P0 핵심 시나리오

### P0-01: 결제 흐름 (REQ-CONNECTORY-03)
- 역할: 일반회원
- 사전 조건: mock_member_01, 토스 sandbox
- 단계 (≤9):
  1. 로그인
  2. 상품 선택 → 결제
  3. 잔액 갱신 확인
- 기대 결과: UI 결제 완료 / DB orders row / 외부 토스 1건

## 5. P1 보조 시나리오

(현재 항목 없음)

## 6. Edge / Negative Case

(현재 항목 없음)

## 7. Regression Checklist

(현재 회귀 대상 없음)

## 8. QA 전달 메시지

```
안녕하세요, Connectory-1 R1 QA 플랜 공유드립니다.

검수 시나리오:
- P0: P0-01

테스트 환경:
- staging URL: [확인 필요]
- mock 계정: mock_member_01

실패 보고 시 메타 보존:
QA Plan: QA-CONNECTORY-20260428
Scenario: P0-NN
```

## 9. PM 확인 필요

- staging URL 공유 필요

---

## 다음 단계 (자동 실행 안 함, 안내만)

- §8 → `/client-chat` 또는 `/qa-request`
- 버그 → `/qa-feedback` (메타 보존)
- status 변경: frontmatter 직접 수정

---

> ⚠️ **이 QA plan은 PM/QA 내부 검수용입니다.** §1~§7을 고객·개발팀에 그대로 전달하지 마세요. §8만 전달용.
