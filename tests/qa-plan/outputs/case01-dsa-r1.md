---
status: 작성중
client: dsa
project: DSA
qa_plan_id: QA-DSA-20260428
round: R1
created: 2026-04-28
author: PM
srs_ref: clients/dsa/DSA/srs.md
brief_refs: [clients/dsa/DSA/change-briefs/2026-04-25-report-preview-risk-emphasis.md]
design_md: clients/dsa/DSA/design.md
scope: 전체
---

# QA Plan — DSA DSA R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. QA 범위
**검수 대상:**
- SRS 요구사항: REQ-DSA-01 (보고서 작성), REQ-DSA-02 (보고서 검수), REQ-DSA-03 (운행일지)
- 화면 list: 프로젝트 상세 / 기술지도 현황 / 보고서 작성·미리보기·편집 / 운행일지 작성
- Change Brief In-Round 항목: 보고서 미리보기 화면에 위험요인 강조 표시 추가 (clients/dsa/DSA/change-briefs/2026-04-25-...md)

**검수 제외 (인지만):**
- Out-of-Scope 항목: (현재 항목 없음)
- Confirm-Needed 항목: (현재 항목 없음)

## 2. 테스트 역할 / 계정
- 주 역할: 기술지도위원, 조직관리자
- mock 계정 매핑:
  - mock_advisor_dsa01 — role: 기술지도위원, 보유 프로젝트 1건 할당
  - mock_org_admin_dsa01 — role: 조직관리자, 검수 권한
- 외부 의존: [확인 필요 — 인세프 동기화 / 알림 채널 source 미명시]

## 3. 전체 플로우 맵
```
mock_advisor 로그인
└── 프로젝트 상세
    └── 기술지도 현황
        ├── 보고서 작성 폼
        │   ├── 위험요인 입력
        │   ├── 개선사항 입력
        │   └── 미리보기 → 편집 → 제출
        └── 검수 대기 list (mock_org_admin)
            └── 보고서 상세 → 승인 / 반려
```

(design.md 화면명 보조 인용: 미리보기 영역의 위험요인 강조 token은 `--color-danger` 사용)

## 4. P0 핵심 시나리오 (필수 회귀)

### P0-01: 기술지도위원 보고서 작성·제출 (REQ-DSA-01)
- 역할: 기술지도위원
- 사전 조건: staging, mock_advisor_dsa01, 담당 프로젝트 1건 할당, 사진 mock 1장
- 단계 (≤9):
  1. mock_advisor_dsa01 로그인 → 메인 진입
  2. 프로젝트 list → 담당 프로젝트 선택
  3. 기술지도 현황 진입 → "보고서 작성" 클릭
  4. 사진 1장 업로드
  5. 위험요인 입력
  6. 미리보기 → 위험요인 강조 표시 확인 (Change Brief In-Round 검증)
  7. 편집 → 제출
- 기대 결과: UI "검수 대기" 라벨 / DB reports.status=`pending_review` / 외부 [확인 필요]

### P0-02: 조직관리자 보고서 검수 승인 (REQ-DSA-02)
- 역할: 조직관리자
- 사전 조건: P0-01 완료된 보고서 1건 존재, mock_org_admin_dsa01
- 단계 (≤9):
  1. mock_org_admin_dsa01 로그인
  2. 검수 대기 list 진입
  3. P0-01 보고서 선택 → 상세 진입
  4. 위험요인·개선사항 확인
  5. 승인 클릭
- 기대 결과: UI 보고서 status `approved` / DB reports.status=`approved`, 검수자 기록 / 외부 [확인 필요]

## 5. P1 보조 시나리오

### P1-01: 운행일지 작성 (REQ-DSA-03)
- 역할: 기술지도위원
- 사전 조건: mock_advisor_dsa01, 차량 1대 할당
- 단계 (≤9):
  1. 차량 메뉴 진입
  2. 운행일지 작성 → 출발지·도착지·거리 입력
  3. 저장
- 기대 결과: UI 일지 list에 추가 / DB vehicle_logs row 생성

## 6. Edge / Negative Case

### EDGE-01: 사진 미업로드로 보고서 제출 시도
- 시나리오: P0-01 단계 4 skip
- 기대 결과: 제출 차단, 에러 메시지 노출

### EDGE-02: 다른 기술지도위원의 프로젝트 접근 시도
- 시나리오: mock_advisor_dsa01이 본인 미할당 프로젝트 URL 직접 접근
- 기대 결과: 403 또는 프로젝트 list로 redirect

## 7. Regression Checklist (R0 → R1)

### REG-01: 보고서 제출 시 status 미반영 (R0 FAIL)
- 원래 시나리오: P0-01 변형 — 제출 후 list 새로고침 시 `pending_review` 미표시
- 라운드: R0 (이전)
- 재실행 요건: P0-01 완료 후 list 새로고침 + 다른 PM 계정으로 list 조회

## 8. QA 전달 메시지

```
안녕하세요, DSA R1 QA 플랜을 공유드립니다.

검수 시나리오:
- P0 (필수): P0-01, P0-02
- P1 (보조): P1-01
- EDGE: EDGE-01, EDGE-02
- REG: REG-01

테스트 환경:
- staging URL: [확인 필요 — DSA staging URL 공유 필요]
- mock 계정: mock_advisor_dsa01 (기술지도위원), mock_org_admin_dsa01 (조직관리자)
- 마감 일자: [확인 필요]

실패 보고 시 본문 첫 줄에 다음 메타를 보존해 주세요:
QA Plan: QA-DSA-20260428
Scenario: P0-NN

문의 사항은 회신 부탁드립니다.
```

## 9. PM 확인 필요

- staging URL 공유 필요 (DSA dev팀 확인)
- 외부 효과: 알림 채널·인세프 동기화 source 부재 → dev팀 확인 필요
- 마감 일자 확인 후 §8에 반영

---

## 다음 단계 (자동 실행 안 함, 안내만)

- §8 QA 전달 메시지 → `/client-chat` 또는 `/qa-request`에 사용
- 검수 후 발견된 버그 → `/qa-feedback` (본문 첫 줄에 `QA Plan: QA-DSA-20260428` 또는 `Scenario: P0-NN` 메타 보존)
- 큰 버그 → `/issue-ticket` → Linear
- status 변경: 이 파일 frontmatter `status:` 직접 수정 (작성중 → 검토 → 확정)

---

> ⚠️ **이 QA plan은 PM/QA 내부 검수용입니다.** §1~§7을 고객·개발팀에 그대로 전달하지 마세요. §8만 전달용.
