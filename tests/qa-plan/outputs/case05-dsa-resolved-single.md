---
status: 작성중
client: dsa
project: DSA
qa_plan_id: QA-DSA-20260428
round: R1
created: 2026-04-28
author: PM
srs_ref: clients/dsa/DSA/srs.md
brief_refs: []
design_md: clients/dsa/DSA/design.md
scope: 전체
---

# QA Plan — dsa DSA R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

> ℹ️ **선택된 project: DSA** (근거: clients/dsa/ 하위 project 1개만 존재 → 자동 선택)

## 1. QA 범위
**검수 대상:**
- SRS 요구사항: REQ-DSA-01, REQ-DSA-02, REQ-DSA-03 (보고서·검수·운행일지)
- 화면 list: 프로젝트 상세 / 기술지도 현황 / 보고서 폼 / 운행일지 폼
- Change Brief In-Round 항목: (현재 항목 없음)

**검수 제외 (인지만):**
- Out-of-Scope 항목: (현재 항목 없음)
- Confirm-Needed 항목: (현재 항목 없음)

## 2. 테스트 역할 / 계정
- 주 역할: 기술지도위원
- mock 계정: mock_advisor_dsa01

## 3. 전체 플로우 맵
```
mock_advisor 로그인 → 프로젝트 상세 → 기술지도 현황 → 보고서 작성·미리보기·편집·제출
```

## 4. P0 핵심 시나리오

### P0-01: 보고서 작성·제출 (REQ-DSA-01)
- 역할: 기술지도위원
- 사전 조건: staging, mock_advisor_dsa01
- 단계 (≤9):
  1. 로그인 → 프로젝트 진입
  2. 기술지도 현황 → 보고서 작성
  3. 사진·위험요인·개선사항 입력
  4. 미리보기 → 편집 → 제출
- 기대 결과: UI 검수 대기 / DB pending_review / 외부 [확인 필요]

## 5. P1 보조 시나리오

(현재 항목 없음)

## 6. Edge / Negative Case

(현재 항목 없음)

## 7. Regression Checklist

(현재 회귀 대상 없음)

## 8. QA 전달 메시지

```
안녕하세요, DSA R1 QA 플랜 공유드립니다.

검수 시나리오:
- P0: P0-01

테스트 환경:
- staging URL: [확인 필요]
- mock 계정: mock_advisor_dsa01

실패 보고 시 메타 보존:
QA Plan: QA-DSA-20260428
Scenario: P0-NN
```

## 9. PM 확인 필요

- staging URL 공유 필요
- 외부 효과 source 부재

---

## 다음 단계 (자동 실행 안 함, 안내만)

- §8 → `/client-chat` 또는 `/qa-request`
- 버그 → `/qa-feedback` (메타 보존)
- status 변경: frontmatter 직접 수정

---

> ⚠️ **이 QA plan은 PM/QA 내부 검수용입니다.** §1~§7을 고객·개발팀에 그대로 전달하지 마세요. §8만 전달용.
