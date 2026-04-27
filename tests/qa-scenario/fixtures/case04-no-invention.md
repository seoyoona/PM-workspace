---
case: case04
description: source에 외부 효과(이메일·푸시·외부 API)가 명시되지 않으면 Section 6의 "외부" 항목을 임의로 채우지 않고 [확인 필요]
client: Connectory
project: Connectory-1
srs: none
brief: none
expected_scenario_id: SCN-connectory-1-001
notes: no-invention 룰 검증. AI가 "이메일 발송될 것" 같은 추측을 임의로 작성하면 FAIL.
---

# Input intent

PM 메모: "회원가입 폼 제출 후 가입 완료 화면 진입 검수. UI / DB만 source에서 명시됨."
- UI: 가입 완료 toast + redirect to /home
- DB: users 테이블에 row 생성
- 외부 효과: source에 명시 없음

# Expected behavior

- Section 6 UI: "가입 완료 toast + /home 이동" 정상 작성
- Section 6 DB: "users 테이블 row 생성" 정상 작성
- Section 6 외부: "[확인 필요]" 명시 (이메일·푸시 같은 추측 금지)
- 시나리오 본문 어디에도 source 없는 사용자 흐름·기대결과·권한·데이터 조건 임의 추가 0건
