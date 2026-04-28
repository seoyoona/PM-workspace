---
status: Draft
client: {client}
project: {project}
source: {meeting-note | free-text}
source_ref: {URL or quote}
srs_ref: {URL or path or "missing"}
design_md: {path or "missing"}
created: {YYYY-MM-DD}
deprecated: true
---

# Change Brief — {한 줄 요약}

> ⚠️ **DEPRECATED — 이 템플릿은 `/to-spec`(`templates/request-to-spec.md`)으로 흡수되었습니다.** 신규 작성은 `/to-spec` 사용.
>
> Reference draft — official spec lives in Nexus / PM Notion.

## 1. 변경 요청 요약
- 누가 / 언제 / 어떤 채널: {client}, {date}, {channel}
- 원문 인용: "{1-3 lines}"
- PM 1-line 정규화: {one-line PM rephrase}

## 2. 기존 범위 대비 영향도
- SRS 참조: {section ID 또는 "SRS 미연결 — Nexus Agent / PM 확인 필요"}
- 영향 분류: {신규 기능 | 기존 변경 | 명확화 | 비범위}
- Impact: {Low | Medium | High | Unknown}

## 3. 화면·UX 영향
- {design.md 있으면: 충돌·확장하는 token / component / pattern 인용}
- {design.md 없으면: "design.md 부재 — UI 영향 상세 판단은 design owner / Nexus Agent 확인 필요"}
- design.md 갱신 필요 여부: {불필요 | 필요 | 판단 보류}
- wireframe 필요 여부: {불필요 | 필요 | 판단 보류}

## 4. 추가 개발 여부 결정 (4 버킷)

### In-Round
- [ ] {항목} / {근거} / Impact: {Low | Medium | High | Unknown}

(현재 항목 없음 시: "(현재 항목 없음)")

### Next-Round
- [ ] {항목} / {근거} / 보류 사유: {reason}

### Out-of-Scope
- [ ] {항목} / {근거} / 거절 사유: {reason}

### Confirm-Needed
- [ ] {항목} / 어떤 정보가 더 필요한가: {missing info}

## 5. 고객 확인 질문 (Confirm-Needed에서 자동 생성)
한국어, 합니다체.

- {질문 1}
- {질문 2}

(Confirm-Needed가 비어 있으면: "(현재 확인 필요 항목 없음)")

## 6. 개발팀 전달 문구 (status=Dev-Handoff에서만 채움)
status가 `Draft` 또는 `PM Review`면 이 섹션은 비어 있어야 함.

- English summary: {summary}
- 영향 SRS section: {section ID or "no SRS impact"}
- AC 후보:
  - When {condition}, then {expected behavior}
- Impact: {Low | Medium | High | Unknown} (구체 공수 산정은 dev 확인)

---

## 다음 단계 (자동 실행 안 함, 안내만)

- 고객 확인이 필요하면: `/client-chat`에 위 Section 5 사용
- 개발팀 전달이 필요하면: `/dev-chat`에 위 Section 6 사용
- 티켓 분해가 필요하면, PM 검토 후: `/to-spec --client {client} --source change-brief {path}` 별도 실행
- 상태 변경: 이 파일 frontmatter `status:` 직접 수정 (Draft → PM Review → Dev-Handoff)

---

> ⚠️ **In-Round로 분류되었더라도, status가 `Dev-Handoff`로 변경되기 전까지 개발팀 전달 확정안이 아닙니다.**
