---
status: Triaged    # In-Round-only / Confirm-Needed-only / Mixed / Out-of-Scope-only / Empty
client: {client}
project: {project}
created: {YYYY-MM-DD}
source: {free-text | meeting-note | change-brief}
source_ref: {URL or quote or change-brief path}
srs_ref: {URL or path or "missing"}
design_md: {path or "missing"}
spec_pages: []   # In-Round confirm 통과 후 Notion 스펙 페이지 URL list (PM cancel / In-Round 0건이면 빈 list)
---

# Request Triage — {한 줄 요약}

> Reference draft — official spec lives in Nexus / PM Notion. In-Round 항목은 PM confirm 후 커뮤니케이션 DB / 태스크 DB에 자동 생성됩니다.

## 1. 변경 요청 요약
- 누가 / 언제 / 어떤 채널: {client}, {date}, {channel}
- 원문 인용: "{1-3 lines, 원본 그대로}"
- PM 1-line 정규화: {one-line PM rephrase}

## 2. 기존 범위 대비 영향도
- SRS 참조: {section ID 또는 "[확인 필요] SRS 미연결 — Nexus Agent / PM 확인 필요"}
- 영향 분류: {신규 기능 | 기존 변경 | 명확화 | 비범위}
- 전체 Impact: {Low | Medium | High | Unknown}

## 3. 화면·UX 영향
- {design.md 있으면: 충돌·확장하는 token / component / pattern 인용}
- {design.md 없으면: "[확인 필요] design.md 부재 — UI 영향 상세 판단은 design owner / Nexus Agent 확인 필요"}
- design.md 갱신 필요 여부: {불필요 | 필요 | 판단 보류}
- wireframe 필요 여부: {불필요 | 필요 | 판단 보류}

## 4. 4-Bucket Triage

### In-Round
- [ ] {항목} / {근거} / Impact: {Low | Medium | High | Unknown}

(현재 항목 없음 시: "(현재 항목 없음)")

### Next-Round
- [ ] {항목} / {근거} / 보류 사유: {reason}

### Out-of-Scope
- [ ] {항목} / {근거} / 거절 사유: {reason}

### Confirm-Needed
- [ ] {항목} / 어떤 정보가 더 필요한가: {missing info}

## 5. 고객 확인 / 거절 안내 (Confirm-Needed + Out-of-Scope)
한국어, 합니다체. 추측성 UI 위치 제안 ❌, 중립 질문으로.

- {Confirm-Needed 질문 1}
- {Out-of-Scope 거절·견적 안내 1}

(둘 다 비어 있으면: "(현재 확인 필요·거절 안내 항목 없음)")

## 6. 개발팀 전달 문구 (In-Round, Notion 생성 후 채움)
- English summary: {summary}
- 영향 SRS section: {section ID or "no SRS impact"}
- AC 후보:
  - When {condition}, then {expected behavior}
- Impact: {Low | Medium | High | Unknown} (구체 공수 산정은 dev 확인)

(In-Round 비어 있으면: "(In-Round 항목 없음 — 개발팀 전달 없음)")

## 7. PM Confirm Gate (In-Round 항목 있을 때만)

```
[확인 필요]
다음 In-Round 항목을 Notion 스펙 페이지 + 태스크 N개로 생성합니다:

스펙 페이지:
- Title: {한 줄 요약}
- Scope summary: {table preview}
- AC: {preview}
- Tasks: N개 ({task1}, {task2}, ...)

1. 진행 (Notion 페이지 + 태스크 생성)
2. 수정 (4-bucket 분류 다시 검토)
3. 취소 (Notion 생성 안 함, 로컬 triage markdown만)

추천: 1
```

(In-Round 0건이면 이 섹션 자체 skip 또는 "(In-Round 항목 없음 — confirm gate skip)")

## 8. Notion 스펙 + 태스크 (PM confirm 후 자동 채움)

- 스펙 페이지: {URL or "(생성 안 됨 — PM cancel 또는 In-Round 0건)"}
- 태스크 N개:
  - [ ] {task1} (Priority / AC / link)
  - [ ] {task2} (Priority / AC / link)
- linked view 수동 설정 안내: "스펙 페이지 하단 /linked view → 태스크 DB 추가 → 필터: 스펙 출처 = {스펙 제목}"

## 9. PM 다음 단계
- In-Round (Notion 생성됨): /dev-chat에 §6 사용 + linked view 수동 설정
- Confirm-Needed: /client-chat에 §5 사용
- Out-of-Scope: /client-chat에 거절 안내 사용
- Next-Round: 다음 라운드 진입 시 본 triage 파일 재검토
- 상태 변경: 본 파일 frontmatter `status:` 직접 수정 (Triaged → Dev-Handoff)

---

> ⚠️ **In-Round로 분류·생성된 Notion 스펙은 PM이 §7 confirm gate에서 명시 진행한 항목만 포함합니다. PM 미확인 In-Round 항목은 Notion으로 가지 않았습니다.**
