---
case: case07
description: --client 미입력 → 저장 안 하고 화면 출력만 (3순위 fallback)
client: none
project: none
srs: none
design: none
expected_buckets:
  in_round: 0
  next_round: 0
  out_of_scope: 0
  confirm_needed: 1
notes: client 불명확 시 저장 금지. 화면 출력만 + "client/project를 지정해 주세요" 안내. outputs/ 디렉토리에 파일이 생기면 안 됨.
expected_save_path: SCREEN_ONLY
---

# Input

고객이 회원 등급제 도입에 대해 검토 중이라고 함.
구체적인 요구는 아직 없고 일반적인 의견 정도.
어느 클라이언트인지도 메시지에 명시되지 않은 상태.
