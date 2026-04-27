---
status: 작성중
client: {client}
project: {project_or_unknown}
scenario_id: SCN-{project-slug}-{NNN}
round: R{N or unknown}
priority: P{0|1|2}
created: {YYYY-MM-DD}
author: {PM}
srs_ref: {REQ ID list or "missing"}
brief_ref: {change-brief path or "none"}
---

# [SCN-{project-slug}-{NNN}] {시나리오 한 줄 제목}

> Internal QA scenario draft — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. Source Linkage
- SRS 요구사항 ID: {REQ-X-NN list 또는 "[확인 필요 — Nexus Agent / PM]"}
- 연결 Change Brief: {clients/<c>/<p>/change-briefs/...md 또는 "none"}
- 연결 Notion 태스크 ID: {TASK-#### 또는 "[확인 필요]"}
- 연결 화면(Figma URL / 화면명): {링크 또는 "[확인 필요]"}
- 우선순위: P0 (필수 회귀) / P1 (라운드별) / P2 (선택)

## 2. 사용자 역할
- 주 역할: {예: 일반회원 / 관리자 / 비로그인}
- 보조 역할: {필요 시}

## 3. 사전 조건 (Preconditions)
- 환경: {staging URL / DB seed / 시간대}
- 계정: {ID, 역할, 보유 데이터}  ← 실제 credential 대신 mock·redact 권고
- 외부 의존: {결제 mock / 이메일 mock / 푸시 토큰}

## 4. 테스트 목표 (한 문장)
{"사용자가 ~ 할 수 있다" / "~가 정확히 동작한다"}

## 5. 단계별 행동 + 기대 결과
| # | 행동 | 입력값 | 기대 결과 |
|---|------|--------|-----------|
| 1 | URL 진입 | - | 200, 랜딩 노출 |
| 2 | 버튼 클릭 | form 데이터 | toast + 다음 화면 이동 |

> 단계 수 가이드: **권장 6~9** / 10~12 분리 검토 권장 (출력 하단 안내) / 13+ cap 초과 경고. 자동 자르기·자동 분리 X.

## 6. 최종 기대 결과 (Final)
- UI: {최종 상태}
- DB / 서버: {레코드 생성 / 상태 변화}
- 외부: {알림 발송 / 외부 API 호출 / 또는 "[확인 필요]"}

## 7. 실패 시 기록 체크리스트
- [ ] 발생 URL (full)
- [ ] 사용 역할 / 계정 (mock 식별자만 기록)
- [ ] 브라우저 / 디바이스 (Chrome 124 / iOS 17.4 등)
- [ ] 스크린샷: 필수
- [ ] 화면 녹화: {필수 | 선택}
- [ ] 네트워크 로그(HAR): {필수 | 선택}
- [ ] 콘솔 에러 텍스트
- [ ] 재현률 (1/1, 1/3 등)

## 8. 미디어 요구
- 스크린샷: {모든 단계 | 실패 시만 | 불필요}
- 영상: {필수 | 선택}

## 9. 실행 로그 (executor가 append)
- R{N} / YYYY-MM-DD / {executor} / 결과: PASS|FAIL|BLOCKED / 비고

---

## 다음 단계 (자동 실행 안 함, 안내만)

- 검수 후 발견된 버그: PM 판단 후 `/qa-feedback` 또는 `/issue-ticket` 별도 실행 (본문 첫 줄에 `시나리오 ID: SCN-...` 메타 보존)
- status 변경: 이 파일 frontmatter `status:` 직접 수정 (작성중 → 검토 → 확정)
- `확정` 상태 시나리오만 v3 자동화(`qa-agent-skills` wrapper) 후보 — v1.5에서는 미적용

---

> ⚠️ **이 시나리오는 PM/QA 내부 검수용입니다. 고객·개발팀에 그대로 전달하지 마세요.**
