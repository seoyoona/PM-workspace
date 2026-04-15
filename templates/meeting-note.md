# Template: Meeting Note

## Design Principle
Part 1 = source of truth. Part 2/3은 Part 1의 Action Items 테이블 + 결정/합의 섹션에서 쿼리.
각 항목은 하나의 섹션에만 존재. 중복 없음.

**핵심 철학**: 목적은 "더 많은 액션을 만드는 것"이 아니라 "실제 액션이 더 선명하게 보이게 하는 것". 모호한 항목은 `논의 메모`로.

## Part 1: 미팅 노트 (Notion 저장)

```
## 미팅 정보
- 일시: [날짜/시간]
- 참석자: [이름들]
- 장소: [장소]
- 기준 문서: [있을 때만]

## 핵심 요약
- [가장 중요한 결정/방향]
- [블로커/일정 영향]
- [이번 라운드 vs 후순위 구분]
- [고객 영향/타임라인]
(3-4줄. Action Items 🔴 + 결정/합의 항목에서만 도출. 새 내용 창작 금지.)

## 결정 / 합의 사항
- [명시 합의된 방향/사양]
- [설계 결정]
(액션 없어도 기록. "…진행 중" 같은 진행 상태 bullet 금지 — 그건 논의 메모로.)

## Action Items

### 🔴 미팅 직후 긴급
| # | Owner | Action | Due | Context |
|---|-------|--------|-----|---------|
| A1 | [Dev/Client/PM/복합] | [실행 단위 평서문] | [명시 시에만] | [왜 필요한지] |

### 🟡 실행
| # | Owner | Action | Due | Context |
|---|-------|--------|-----|---------|
| A2 | ... | ... | ... | ... |

### 🔵 확인 필요
| # | Owner | Action | Due | Context |
|---|-------|--------|-----|---------|
| A3 | ... | ... | ... | ... |

(표 컬럼은 위 5개만. confidence/status/source_quote는 내부 보관, 표 미노출.
 근거 없는 하위 그룹은 통째로 생략.
 [추론]은 Action 텍스트 끝에 인라인 태그로만.)

## 스코프 경계 — 이번 라운드 아님
- [신규 기능 후보 — 고객사 티켓 예정]
(고객사가 별도 티켓으로 정리할 항목. "지금 착수 아님" 선언.)

## 후순위 / 유지보수
- [미룬 실행 항목]
(명시적으로 나중에 하기로 한 것만.)

## 논의 메모 / 진행 상태
- [BE와 의논 중 / 방식 검토 중 등 in-flight]
- [owner/action/요청 주체가 불명확하여 Action Item 승격 안 된 항목]
- [[추론] 태그 항목]
("아직 결정 안 된 것" 파악용. 다음 미팅 이월 후보.)

## 배경 / 신뢰 관리 컨텍스트 [PM 참고용]
- [전략 맥락, 고객사 감정, 관계 이슈]
(Part2/3에 노출하지 않음. 해당 없으면 섹션 생략.)
```

### 섹션 배치 규칙
- 개발팀 반영 + owner 명확 → `Action Items` (🔴 또는 🟡).
- 명시적 확인/정리/응답/승인 요청 → `Action Items` 🔵.
- 합의만 됐고 누가 실행할지 아직 없음 → `결정 / 합의 사항`.
- 실행 동사 있지만 owner/요청 주체 불명확 → `논의 메모 / 진행 상태`.
- "어떨까 / 고민 / 의논 중" → `논의 메모 / 진행 상태`.
- 신규 기능 + 스코프 미확정 → `스코프 경계`.
- 명시적으로 미룸 → `후순위 / 유지보수`.
- 과거/현재 사실 서술 → `배경` 또는 `핵심 요약`.

### 핵심 요약 vs 나머지
- 핵심 요약 = 미팅의 결론 (방향, 영향, 큰 그림).
- 나머지는 구체 항목 리스트.
- 요약에 나온 내용을 아래 섹션에서 한 줄씩 다시 쓰지 않음.

### 내부 스키마 (표 미노출, Phase B 내부 보관)
각 Action Item은 표 컬럼 외에 아래를 내부적으로 갖는다:

- `confidence`: high(명시합의) / medium(맥락추론) / low(불확실)
- `status`: 대기 / 진행중 / 완료 — 녹취에 명시 시에만
- `source_quote`: 녹취 원문 인용 (최대 2줄, 필수)

표에는 노출하지 않지만 내부 검증에 사용.

## Part 1 → Part 2 매핑 (dev-chat)

**쿼리 기반. 표 복제 금지. Teams 톤 서술 bullet으로 풀어쓴다.**

```
📌 [{project}] Meeting follow-up — {date}

Critical context:
- ← Action Items 🔴 WHERE owner IN (Dev, Dev+*). 상황 + 왜 긴급한지. 2~3줄 bullet.

This round:
- ← Action Items 🟡 WHERE owner IN (Dev, Dev+*) + 결정/합의 dev 대상. 3~5 bullet, 각 1줄.
- due 있으면 inline "— by Apr 23" 형태.
- 직접 서술 ("Change X to Y"), 모델 추측 ("This likely means...") 금지.

Discussion/open: (있을 때만)
- ← 논의 메모 WHERE dev 대상. 개발팀이 "아직 결정 아님"을 알게. 1~2줄.

Maintenance later: (있을 때만)
- ← 후순위/유지보수 WHERE owner=Dev.

Please review and let me know if anything needs more effort than expected.
```

제외: owner=Client만, owner=PM만, 배경/신뢰 관리 컨텍스트, 🔵 확인 필요 중 Client 전용.

## Part 1 → Part 3 매핑 (client-chat)

**쿼리 기반. 합니다체 서술문으로 풀어쓴다. 표·체크박스 금지.**

```
안녕하세요, 오늘 미팅 감사드립니다!
말씀 나눈 내용 정리해서 공유드립니다.

** 오늘 논의된 핵심 내용
- ← 핵심 요약에서 고객 가시 문장만. 2~3줄.

** 확정된 사항
- ← 결정/합의 사항 중 고객 가시. 결과 중심 한 줄 서술. 기술 디테일 금지.

** 진행 예정 사항
- ← Action Items WHERE owner IN (Dev, PM) + 고객 가시. "무엇을 할지"만, 일정은 전달 가능 시.
- 스코프 경계 항목이 있으면 마지막 줄: "4차 신규 건은 별도 티켓으로 정리 부탁드립니다"

** 추가 확인 부탁드리는 사항
1. ← Action Items 🔵 WHERE owner=Client. 2개 이상이면 번호 목록.
2. PM 내부 항목 제외.

감사합니다!
```

제외: [추론] 태그, PM 내부 액션, 기술 디테일, 일정 지연 사유, 팀 리소스, 신뢰 관리 컨텍스트.

## Example (우오봉 2026-04-15 미팅 적용 — 축약)

**Part 1:**
```
## 미팅 정보
- 일시: 2026-04-15
- 참석자: Simon, Client(임수영), PM(Yoona)

## 핵심 요약
- 미팅 중 긴급 이슈 3건(고려산 Romeo 타깃 미획득 / Android APK 재전달 / iOS 운동기록 에러) 병행 발생 — 미팅 직후 최우선
- GPS 수집/필터링 구조 개선 다음 주 목(2026-04-23)까지 반영 목표
- 4차 신규 후보(자동 휴식시간)는 고객사가 티켓 정리 예정

## 결정 / 합의 사항
- GPS 처리: 프론트 raw GPS 누적 → raw GPX 생성 → 백엔드 검증 구조로 전환
- Trail log 개선과 GPS 간격 개선을 함께 처리
- 자동 휴식시간 계산 포뮬러는 Litmers가 제안 → 고객사 승인 후 스펙화

## Action Items

### 🔴 미팅 직후 긴급
| # | Owner | Action | Due | Context |
|---|-------|--------|-----|---------|
| A1 | Dev (Simon→개발자) | 고려산 Romeo 유저 타깃 미획득 로그 조사 + 폴백 검토 | 미팅 직후 | 산 정상 대기, 어드민 변경 미소급 추정 |
| A2 | Dev | Android APK 재빌드 고객사 재전달 | 미팅 종료 직후 | 미팅 중 검증 완료 |
| A3 | Dev | iOS 운동기록 버튼 에러 원인 조사 | — | TestFlight 재현 확인 |

### 🟡 실행
| # | Owner | Action | Due | Context |
|---|-------|--------|-----|---------|
| A4 | Dev (FE) | GPS 필터링 2회 중복 제거 (raw GPX → BE 검증 구조 구현) | 2026-04-23 | 프론트·저장 2회 필터링으로 기록 손실 |
| A5 | Dev (BE) | 어드민 타깃 위치 변경 진행 중 퀘스트 소급 적용 구현 | 2026-04-23 | A1 이슈와 묶어 처리 |

### 🔵 확인 필요
| # | Owner | Action | Due | Context |
|---|-------|--------|-----|---------|
| A6 | Client/임수영 | Garmin/Ramblr/Mountain 3종 병행 측정 데이터 공유 | 다음 산행 | 거리 정확도 재검증 |
| A7 | Client/임수영 | 4차 신규 3건 티켓 정리 전달 | — | 휴식시간 계산 등 스코프 확정 |
| A8 | Litmers (Dev) | 자동 휴식시간 계산 포뮬러 제안서 작성 → 고객사 승인 요청 | — | 4차 스펙화 전제 |

## 스코프 경계 — 이번 라운드 아님
- 자동 휴식시간 계산 (4차 신규 후보)
- "내 트래커" 버튼 클릭 시 타깃 달성 반경 일시 확장 (4차 신규 후보)
- 타깃 달성 시 실제 GPS 좌표 DB 저장 (4차 신규 후보)

## 후순위 / 유지보수
- 고도 계산 (개선 반영됨, 모니터링만)

## 논의 메모 / 진행 상태
- 거리 계산 정확도 추가 검증 — Client 측정 데이터 수신 후 재논의 예정

## 배경 / 신뢰 관리 컨텍스트 [PM 참고용]
- 고객사 강한 불만: 2개월 개발 → 150건 이슈. "이런 식이면 다른 방법 생각해봐야" 언급
- 대응: PM 투입 완료, 한국 QA 고정, 에이전트 QA 도입 검토, 풀스택 추가 투입 검토
- 4차부터 품질 공약
```

**Part 2 (Teams 톤, 표 복제 X):**
```
📌 [Mountain] Meeting follow-up — 2026-04-15

Critical context:
- Romeo user can't acquire target on Koryeo-san (user stuck at summit). Admin position change didn't propagate — investigate logs + fallback right after this meeting.
- iOS workout record button lands on error page. Reproducible on TestFlight — need root-cause.

This round:
- Rebuild & resend Android APK (verified in meeting) — right after this meeting.
- Rework GPS pipeline: accumulate raw GPS on frontend → generate raw GPX → backend validates. Remove double filtering — by Apr 23.
- Implement retroactive target-position update for in-progress quests — by Apr 23. Bundle with Romeo issue (A1).

Discussion/open:
- Distance accuracy vs Ramblr — pending client's side-by-side measurement data.

Please review and let me know if anything needs more effort than expected.
```

**Part 3 (합니다체, 표 X, 체크박스 X):**
```
안녕하세요, 오늘 미팅 감사드립니다!
말씀 나눈 내용 정리해서 공유드립니다.

** 오늘 논의된 핵심 내용
- 미팅 중 긴급 이슈 3건(고려산 Romeo 타깃, Android APK 재전달, iOS 운동기록 에러)은 미팅 직후 최우선으로 처리합니다
- GPS 수집 구조 개선은 다음 주 목요일(4/23)까지 반영 목표로 진행합니다

** 확정된 사항
- GPS 처리 구조를 raw GPX → 백엔드 검증 방식으로 전환합니다
- 어드민 타깃 위치 변경 시 진행 중 퀘스트에 자연스럽게 반영되도록 개선합니다

** 진행 예정 사항
- GPS/트레일 로그 구조 개선을 다음 주 목요일까지 반영할 예정입니다
- 자동 휴식시간 계산 포뮬러 제안서를 준비해 전달드리겠습니다
- 4차 신규 건(휴식시간/트래커 반경/좌표 저장)은 별도 티켓으로 정리 부탁드립니다

** 추가 확인 부탁드리는 사항
1. 다음 산행 시 Garmin/Ramblr/저희 앱 3종 병행 측정 데이터를 공유 부탁드립니다
2. 4차 신규 건 3가지를 하나의 티켓으로 정리해 전달 부탁드립니다

감사합니다!
```
