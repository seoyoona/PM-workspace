---
status: 작성중
client: connectory
project: Connectory-2
qa_plan_id: QA-CONNECTORY-20260428
round: R1
created: 2026-04-28
author: PM
srs_ref: missing
brief_refs: []
design_md: clients/Connectory/Connectory-2/design.md
scope: 전체
---

# QA Plan — connectory Connectory-2 R1

> Internal QA plan — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. QA 범위
**검수 대상:**
- SRS 요구사항: [확인 필요 — SRS 미연결]
- 화면 list: [확인 필요 — primary source 부족]
- Change Brief In-Round 항목: (현재 항목 없음)

**검수 제외 (인지만):**
- Out-of-Scope 항목: [확인 필요 — Change Brief 부재로 미식별]
- Confirm-Needed 항목: [확인 필요]

## 2. 테스트 역할 / 계정
- 주 역할: [확인 필요 — SRS·Change Brief·QA history 부재로 역할 미식별]
- mock 계정 매핑: [확인 필요]
- 외부 의존: [확인 필요]

## 3. 전체 플로우 맵
[확인 필요 — 사용자 흐름의 primary source(SRS / Change Brief / QA history) 부재. design.md만으로 시나리오 흐름 발명 ❌]

(design.md에서 정의된 화면 컴포넌트 / 토큰 인용은 가능하나, "사용자가 어떻게 흐르는가"는 추론하지 않음)

## 4. P0 핵심 시나리오 (필수 회귀)

(현재 항목 없음 — primary source 부족으로 P0 시나리오 작성 불가)

## 5. P1 보조 시나리오

(현재 항목 없음)

## 6. Edge / Negative Case

(현재 항목 없음 — Edge case는 source 명시 흐름이 있어야 작성 가능)

## 7. Regression Checklist (이전 → R1)

(현재 회귀 대상 없음)

## 8. QA 전달 메시지

```
[확인 필요 — primary source 부족으로 QA 플랜 본문 작성 불가. 아래 sources 확보 후 재실행 권장:
- SRS / 기능명세
- Change Brief
- 이전 QA history
design.md만으로는 시나리오 발명 X (no-invention 룰)]
```

## 9. PM 확인 필요

- **SRS 미연결** — clients/Connectory/Connectory-2/srs.md 또는 Notion 프로젝트 문서 DB 확인 필요
- **Change Brief 부재** — clients/Connectory/Connectory-2/change-briefs/ 비어 있음
- **QA history 부재** — 이전 라운드 피드백 자료 없음
- **design.md만 있음** — UI 토큰·컴포넌트는 정의되어 있으나, design.md를 QA 범위·기능 흐름 primary source로 사용하지 않음 (no-invention 룰)
- → primary source 확보 후 `/qa-plan` 재실행 권장

---

## 다음 단계 (자동 실행 안 함, 안내만)

- 본 QA plan은 source 부족으로 검수에 사용 불가
- PM이 SRS / Change Brief / QA history 중 1개 이상 확보 후 `/qa-plan connectory --project Connectory-2` 재실행
- design.md만으로는 시나리오 발명 X (룰 위반)

---

> ⚠️ **이 QA plan은 PM/QA 내부 검수용입니다.** §1~§7을 고객·개발팀에 그대로 전달하지 마세요. §8만 전달용 — 단, 본 case는 §8도 [확인 필요] 상태이므로 전달 X.
