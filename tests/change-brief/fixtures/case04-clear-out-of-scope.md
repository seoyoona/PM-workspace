---
case: case04
description: 명백한 계약 범위 밖 신규 기능 → Out-of-Scope
client: Connectory
project: Connectory-1
srs: none
design: none
expected_buckets:
  in_round: 0
  next_round: 0
  out_of_scope: 1
  confirm_needed: 0
notes: 모바일 앱은 contract type=WEB 프로젝트와 명백히 다른 범위. PM이 source에서 "별도 견적 필요" 명시 → Out-of-Scope.
---

# Input

고객이 iOS/Android 모바일 앱 버전도 같이 만들 수 있는지 문의.
현재 프로젝트는 웹 전용으로 계약되어 있고, 모바일 앱은 별도 견적/일정으로 분리해야 한다고 PM이 판단.
계약서에도 WEB-only로 명시되어 있어서 이번 라운드에 들어갈 수 없음.
