---
status: 작성중
client: Connectory
project: Connectory-1
scenario_id: SCN-connectory-1-001
round: R1
priority: P2
created: 2026-04-27
author: PM
srs_ref: missing
brief_ref: none
---

# [SCN-connectory-1-001] 로그인 화면 비밀번호 찾기 링크 가시성 검수

> Internal QA scenario draft — for PM/QA validation only. Not a client-facing spec or dev ticket.

## 1. Source Linkage
- SRS 요구사항 ID: [확인 필요 — Nexus Agent / PM]
- 연결 Change Brief: none
- 연결 Notion 태스크 ID: [확인 필요]
- 연결 화면(Figma URL / 화면명): 로그인 화면 (`/login`)
- 우선순위: P2 (선택, UI 가시성)

## 2. 사용자 역할
- 주 역할: 비로그인 사용자
- 보조 역할: 없음

## 3. 사전 조건 (Preconditions)
- 환경: staging URL, 표준 light theme
- 계정: 로그인하지 않음
- 외부 의존: 없음 [확인 필요]

## 4. 테스트 목표
비로그인 사용자가 로그인 화면에서 "비밀번호 찾기" 링크를 시각적으로 명확히 식별할 수 있다.

## 5. 단계별 행동 + 기대 결과
| # | 행동 | 입력값 | 기대 결과 |
|---|------|--------|-----------|
| 1 | staging URL `/login` 진입 | - | 로그인 화면 노출 |
| 2 | "비밀번호 찾기" 링크 위치 확인 | - | 배경과 명확히 구분되는 색상으로 노출 |
| 3 | 링크 호버 | - | 호버 상태 시각 피드백 (underline 또는 색상 변화) [확인 필요 — design.md 부재로 패턴 미정] |
| 4 | 링크 클릭 | - | 비밀번호 찾기 화면 진입 |

> 단계 수: 4 (cap 12 이내)

## 6. 최종 기대 결과 (Final)
- UI: 비밀번호 찾기 링크가 배경 대비 충분한 명도 차이로 노출
- DB / 서버: [확인 필요 — UI-only 변경이라면 DB 영향 없음]
- 외부: [확인 필요]

## 7. 실패 시 기록 체크리스트
- [ ] 발생 URL (full)
- [ ] 사용 역할 / 계정
- [ ] 브라우저 / 디바이스
- [ ] 스크린샷: 필수
- [ ] 화면 녹화: 선택
- [ ] 네트워크 로그(HAR): 선택
- [ ] 콘솔 에러 텍스트
- [ ] 재현률

## 8. 미디어 요구
- 스크린샷: 실패 시만 (P2 default — 단, P2여도 시각 가시성 시나리오라 스크린샷 권장)
- 영상: 불필요

## 9. 실행 로그 (executor가 append)
- 

---

## 다음 단계 (자동 실행 안 함, 안내만)

- 검수 후 발견된 버그: PM 판단 후 `/qa-feedback` 또는 `/issue-ticket` 별도 실행 (본문 첫 줄에 `시나리오 ID: SCN-connectory-1-001` 메타 보존)
- status 변경: 이 파일 frontmatter `status:` 직접 수정 (작성중 → 검토 → 확정)
- `확정` 상태 시나리오만 v3 자동화(`qa-agent-skills` wrapper) 후보 — v1.5에서는 미적용

---

> ⚠️ **이 시나리오는 PM/QA 내부 검수용입니다. 고객·개발팀에 그대로 전달하지 마세요.**
