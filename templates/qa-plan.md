---
status: 작성중
client: {client}
project: {project_or_unknown}
qa_plan_id: QA-{CLIENT}-YYYYMMDD
round: R{N}
created: {YYYY-MM-DD}
author: {PM}
srs_ref: {path or "missing"}
brief_refs: []
design_md: {path or "missing"}
scope: {free-text or "전체"}
---

# QA Plan — {client} {project} R{N}

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. QA 범위
**검수 대상:**
- SRS 요구사항: {REQ-X-NN list 또는 "[확인 필요 — SRS 미연결]"}
- 화면 list: {화면명·URL 또는 "[확인 필요]"}
- Change Brief In-Round 항목: {brief 인용 또는 `(현재 항목 없음)`}

**검수 제외 (인지만):**
- Out-of-Scope 항목: {brief Out-of-Scope 인용 또는 `(현재 항목 없음)`}
- Confirm-Needed 항목: {brief Confirm-Needed 인용 또는 `(현재 항목 없음)`}

## 2. 테스트 역할 / 계정
- 주 역할: {예: 일반회원 / 조직관리자 / 외부사용자}
- mock 계정 매핑:
  - mock_<role>_01 — role: <role>, 보유 데이터: <설명>
  - (실제 credential 대신 mock 식별자만)
- 외부 의존: {결제 mock / 이메일 mock / 푸시 토큰 / 또는 "[확인 필요]"}

## 3. 전체 플로우 맵
텍스트 트리 또는 표 (Mermaid X — v1)

```
진입
├── <화면 1>
│   ├── 행동 → <화면 2>
│   └── 행동 → <화면 3>
└── <대안 진입>
    └── ...
```

화면명은 design.md 있을 때 보조 인용 (UI 표현 검증용).

## 4. P0 핵심 시나리오 (필수 회귀)

### P0-01: {한 줄 제목}
- 역할: {주 역할}
- 사전 조건: {환경·계정·외부 의존 1줄}
- 단계 (≤9 권장):
  1. {행동} → {기대 즉시 결과}
  2. ...
- 기대 결과: UI {최종 상태} / DB {레코드 변화} / 외부 {API 호출 또는 "[확인 필요]"}

### P0-02: {...}
...

(P0 시나리오 0개 시: `(현재 항목 없음)`)

## 5. P1 보조 시나리오 (라운드별)

### P1-01: {...}
- 역할: ...
- 사전 조건: ...
- 단계 (≤9 권장):
- 기대 결과: ...

(P1 시나리오 0개 시: `(현재 항목 없음)`)

## 6. Edge / Negative Case
**source 근거 있는 것만 작성. 추측 ❌**

### EDGE-01: {입력 검증 실패}
- 시나리오: ...
- 기대 결과: ...

### EDGE-02: {권한 boundary}
- ...

(EDGE case 0개 시: `(현재 항목 없음)`)

## 7. Regression Checklist (라운드 N → N-1)

### REG-01: {이전 라운드 FAIL 시나리오 재실행}
- 원래 시나리오: <SCN-... 또는 P0-NN>
- 라운드: R{N-1}
- 재실행 요건: ...

### REG-02: {Change Brief In-Round 변경 영향 영역}
- ...

(REG 항목 0개 시: `(현재 회귀 대상 없음)`)

## 8. QA 전달 메시지

PM이 그대로 복사해 QA / 고객사에 전달:

```
{인사 한 줄}.

{client/{project} R{N} QA 플랜을 공유드립니다.

검수 시나리오:
- P0 (필수): P0-01, P0-02, ...
- P1 (보조): P1-01, ...
- EDGE: EDGE-01, ...
- REG: REG-01, ...

테스트 환경:
- staging URL: {URL or "[확인 필요]"}
- mock 계정: {계정 list}
- 마감 일자: {date or "[확인 필요]"}

실패 보고 시 본문 첫 줄에 다음 메타를 보존해 주세요:
QA Plan: QA-{CLIENT}-YYYYMMDD
Scenario: P0-NN

문의 사항은 회신 부탁드립니다.}
```

## 9. PM 확인 필요

- {SRS 미연결 / Change Brief 미연결 / design.md 부재 등 [확인 필요] 항목}
- {musing 톤 항목 — Decision 승급 X}
- {외부 효과(이메일·푸시 등) source 부재 항목}
- {시나리오 수 cap (화면 × 1.5) 초과 시 분리·통합 검토 권장}
- {project resolution 0개일 때 입력 요청}

(현재 확인 필요 항목 없음 시: `(현재 확인 필요 항목 없음)`)

---

## 다음 단계 (자동 실행 안 함, 안내만)

- §8 QA 전달 메시지 → `/client-chat` 또는 `/qa-request`에 사용
- 검수 후 발견된 버그 → `/qa-feedback` (본문 첫 줄에 `QA Plan: QA-<CLIENT>-YYYYMMDD` 또는 `Scenario: P0-NN` 메타 보존)
- 큰 버그 → `/issue-ticket` → Linear
- status 변경: 이 파일 frontmatter `status:` 직접 수정 (작성중 → 검토 → 확정)

---

> ⚠️ **이 QA plan은 PM/QA 내부 검수용입니다.** §1~§7을 고객·개발팀에 그대로 전달하지 마세요. §8만 전달용.
