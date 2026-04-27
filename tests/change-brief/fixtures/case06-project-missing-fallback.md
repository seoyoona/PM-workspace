---
case: case06
description: --project 미입력 → clients/<client>/change-briefs/ 2순위 경로로 fallback
client: Connectory
project: none
srs: none
design: none
expected_buckets:
  in_round: 0
  next_round: 0
  out_of_scope: 0
  confirm_needed: 1
notes: project 누락 상태에서도 저장 자체는 성공해야 함. frontmatter에 project=unknown, 저장 경로는 clients/Connectory/change-briefs/.
expected_save_path: clients/Connectory/change-briefs/
---

# Input

고객이 회원가입 시 본인인증 절차를 추가할 수 있는지 문의.
현재 SRS에 본인인증 요구사항이 명시되어 있는지 PM이 확인 못한 상태.
구체적인 인증 방식(SMS/카카오/PASS 등)이나 시점(가입 시점/결제 시점)도 미정.
