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
design_md: missing
scope: 전체
---

# QA Plan — dsa DSA R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. QA 범위
**검수 대상:**
- SRS 요구사항: REQ-DSA-01 (보고서 작성 → 검수 → 환불까지 종합)
- 화면 list: 보고서 폼 / 미리보기 / 편집 / 제출 / 검수 / 환불
- Change Brief In-Round 항목: (현재 항목 없음)

**검수 제외:** (현재 항목 없음)

## 2. 테스트 역할 / 계정
- 주 역할: 기술지도위원, 조직관리자
- mock 계정: mock_advisor_dsa01, mock_org_admin_dsa01

## 3. 전체 플로우 맵
```
보고서 작성 → 미리보기 → 편집 → 제출 → 검수 대기 → 승인 → 환불 신청 → 환불 처리
```

## 4. P0 핵심 시나리오

### P0-01: 보고서 작성·제출·검수·환불 종합 흐름 (REQ-DSA-01)
- 역할: 기술지도위원 + 조직관리자
- 사전 조건: staging, mock_advisor_dsa01, mock_org_admin_dsa01, 환불 자동 승인 모드
- 단계:
  1. mock_advisor 로그인
  2. 프로젝트 진입
  3. 기술지도 현황 → 보고서 작성
  4. 사진 업로드
  5. 위험요인 입력
  6. 개선사항 입력
  7. 미리보기 → 편집
  8. 제출
  9. mock_org_admin 로그인
  10. 검수 대기 list 진입
  11. 보고서 검토 → 승인
  12. 환불 신청 (보고서 기반 정산)
  13. 환불 자동 승인 → 잔액 반영
- 기대 결과: UI 모든 status 정상 전환 / DB reports + refunds row 일관성 / 외부 [확인 필요]

> ⚠️ **단계 cap 초과 (현재 13) — 시나리오 분리 권장.** 자동 자르기 X. PM 수동 결정.

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
- P0: P0-01 (13단계 — 분리 검토 권장)

테스트 환경:
- staging URL: [확인 필요]
- mock 계정: mock_advisor_dsa01, mock_org_admin_dsa01

실패 보고 시 메타 보존:
QA Plan: QA-DSA-20260428
Scenario: P0-NN
```

## 9. PM 확인 필요

- **단계 cap 초과** — P0-01이 13단계. 권장 6~9 / 10~12 분리 검토 / 13+ cap 초과. PM 수동 분리 결정 (예: 작성·제출 / 검수·승인 / 환불 3개로 분리)
- staging URL 공유 필요
- 외부 효과 source 부재

---

## 다음 단계 (자동 실행 안 함, 안내만)

- §8 → `/client-chat` 또는 `/qa-request`
- 버그 → `/qa-feedback` (메타 보존)
- 시나리오 분리 결정 후 본 plan 직접 편집

---

> ⚠️ **이 QA plan은 PM/QA 내부 검수용입니다.** §1~§7을 고객·개발팀에 그대로 전달하지 마세요. §8만 전달용.
