---
case: case04
description: 기본 9개 도메인 코드로 분류가 어색한 도메인 (예: 학습 콘텐츠 / LMS) → PM이 미리보기에서 커스텀 코드 `LMS` 승인 후 사용.
client: edGroup
project: edGroup-LMS
preview_gate_choice: "1"
save_gate_choice: "1"
custom_domain_codes_proposed: [LMS]
expected_buckets:
  req_total: 7
  confirm_needed_count: 1
  output_mode: full
notes: |
  학습 콘텐츠 / 강의 영상 / 진도 추적은 CONTENT 코드로도 어색 → LMS 커스텀 도입. PM이 §3 preview에서 명시 승인.
---

# Source memo (KR)
LMS — 강의 등록·수강·진도 추적·수료증 발급. 기본 결제는 외부 SaaS에 위임.
