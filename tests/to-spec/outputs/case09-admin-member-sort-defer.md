---
status: In-Round-only
client: Connectory
project: Connectory-1
created: 2026-05-10
source: free-text
source_ref: "tests/to-spec/fixtures/case09-in-round-defer.md (test fixture)"
srs_ref: clients/Connectory/Connectory-1/srs.md
design_md: missing
spec_pages: []
---

# Request Triage — 어드민 회원 정렬 옵션 + 통계 표시 (수정 보류)

> Reference draft — official spec lives in Nexus / PM Notion. In-Round 항목은 PM confirm 후 커뮤니케이션 DB / 태스크 DB에 자동 생성됩니다.

## 1. 변경 요청 요약
- 누가 / 언제 / 어떤 채널: Connectory 고객사, 2026-05-10, 직접 피드백
- 원문 인용:
  > "어드민 회원 관리 화면에 정렬 옵션을 추가해주세요. 가입일 / 마지막 로그인 / 이름 가나다순 정도면 충분합니다. 그리고 같이 보면, 회원 통계도 한 번에 보고 싶은데 어디까지 가능할지 좀 봐주세요."
- PM 1-line 정규화: 어드민 회원 관리 화면에 정렬 옵션 (가입일·마지막 로그인·이름) 추가 + 통계 표시 (범위 미명확).

## 2. 기존 범위 대비 영향도
- SRS 참조: REQ-CON-ADM-04 (회원 관리 화면) 인용
- 영향 분류: 정렬 = 명확화 / 통계 = 신규 기능 후보 (범위 미명확)
- 전체 Impact: Low (정렬) + Unknown (통계)

## 3. 화면·UX 영향
- [확인 필요] design.md 부재 — UI 영향 상세 판단은 design owner / Nexus Agent 확인 필요
- 정렬: 회원 관리 list 헤더 영역
- 통계: 별도 영역 추가 가능성 (위치·항목 미명확)

## 4. 4-Bucket Triage

### In-Round
- 회원 관리 화면 정렬 옵션 추가 (가입일 / 마지막 로그인 / 이름 가나다순)

### Next-Round
(none — 통계는 범위 미명확하므로 Confirm-Needed로)

### Out-of-Scope
(none)

### Confirm-Needed
- 회원 통계 표시 — "어디까지 가능할지 봐주세요"는 범위·필수 항목 미명확. PM이 고객에게 (a) 어떤 통계 항목 (총 회원 수 / 활성 회원 / 가입 추이 등) (b) 표시 위치 (별도 화면 vs 같은 화면 상단) 확인 필요.

## 5. 고객 확인 / 거절 안내

> 정렬 옵션 추가는 이번 라운드 진행해도 될 것 같습니다. 다만 회원 통계는 어떤 항목을 보시고 싶으신지 (예: 총 회원 수, 가입 추이, 활성 회원 수) 그리고 별도 화면 / 동일 화면 상단 / 사이드 패널 중 어디가 좋으실지 한 번 더 확인 부탁드립니다.

## 6. 개발팀 전달 문구
(보류 — PM 확인 후 §7 게이트 통과 시 생성)

## 7. PM Confirm Gate

```
[확인 필요]
다음 In-Round 항목을 Notion 스펙 페이지 + 태스크 1개로 생성합니다:

스펙 페이지:
- Title: Add sort options to admin member management screen
- Scope summary: Sort by signup date / last login / name (Korean alphabetical)
- AC: When admin opens member list, then sort dropdown is available with the 3 options
- Tasks: 1개 (Add sort dropdown to admin member list)

1. 진행 (Notion 페이지 + 태스크 생성)
2. 수정 (4-bucket 분류 다시 검토)
3. 취소

추천: 1
```

PM 선택: **2 (수정)** — 통계 항목이 Confirm-Needed로 분류됐지만, PM이 정렬 옵션도 같이 고객 확인 후 한 번에 진행할지 재검토하기로 결정. 4-bucket 분류 재검토 필요.

## 8. Notion 스펙 + 태스크

(보류 — PM 선택=2. Notion 생성 미실행. spec_pages: [] 유지. PM이 §5 고객 확인 후 다시 invoke 또는 4-bucket 재분류 후 Step 5로 회귀.)

## 9. PM 다음 단계

다음 단계 (자동 실행 안 함, 안내만):

- §5 고객 확인 → /client-chat에 사용 (정렬 + 통계 확인 한 번에)
- 고객 회신 후 4-bucket 재분류:
  - 정렬 옵션 → In-Round 유지
  - 통계 → 회신 결과에 따라 In-Round / Next-Round / Confirm-Needed 재배치
- 재분류 후 `/to-spec`을 다시 invoke해서 §7 게이트 진행
- 본 라운드 spec_pages 비어 있음 (PM 선택=2로 Notion 생성 보류)

## Notes

- gate_choice="2" 처리 결과: spec_pages 비어 있음, Notion 생성 미실행, §6/§8/§9가 "보류·재검토" 모드.
- §7 PM 선택: 2 (수정)이 본문에 명시 기록됨.
- 본 snapshot은 "PM이 In-Round 항목을 일단 미확정 상태로 유지" 흐름을 검증한다.
