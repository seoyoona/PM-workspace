---
case: case01
description: 표준 SRS 초안 — 11 REQ (15건 이하, full mode), 기본 도메인 코드만, 양쪽 게이트 모두 PM 승인.
client: Connectory
project: Connectory-1
source_type: text
source_ref: text inline (기획 회의 메모)
preview_gate_choice: "1"
save_gate_choice: "1"
expected_buckets:
  req_total: 11
  confirm_needed_count: 3
  output_mode: full
notes: |
  Standard happy path. 회원 / 결제 / 관리자 / 데이터 / 화면 5개 도메인 그룹.
---

# Source memo (KR)
회원가입(이메일+비밀번호), 로그인, 프로필 편집. 크레딧 충전(카카오페이) + 환불 정책. admin 페이지에서 회원 검색·정지 가능. 메인 화면 / 마이페이지 / admin 페이지 분기.
