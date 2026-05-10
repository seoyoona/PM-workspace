---
status: Confirmed-1
case: case04
client: edGroup
project: edGroup-LMS
created: 2026-05-10
source_type: text
source_ref: text inline (LMS 1줄 메모)
project_doc_db: collection://bd33aae9-a894-82a9-b8e2-87387e7fbf47
preview_gate_choice: "1"
save_gate_choice: "1"
new_page_url: https://notion.so/cigroio/edgroup-lms-srs-draft
req_total: 7
confirm_needed_count: 1
out_of_scope_count: 1
output_mode: full
custom_domain_codes: [LMS]
---

## 1. Source Summary

- Source: text inline (LMS 1줄 메모)
- Coverage: 강의 등록·수강·진도·수료증

## 2. REQ Extraction Summary

| 그룹 | 도메인 코드 | REQ 개수 |
|---|---|---|
| LMS (강의·진도) | LMS (custom) | 5 |
| 인증·회원 | AUTH | 2 |
| **합계** | | **7건** |

- 커스텀 도메인 코드: `LMS` (PM 미리보기 승인됨 — CONTENT 코드로 분류가 어색)
- 제외사항: 결제 (외부 SaaS 위임)

## 3. Step 3 Preview

```
## SRS 초안 미리보기
기능 그룹: 2개, REQ 7건
커스텀 도메인 코드: LMS — 사용 승인 필요?
  근거: CONTENT 코드는 CMS 성격. 본 프로젝트는 강의 / 진도 / 수료증으로
        교육 도메인 특화 → LMS 도입 권고.

진행 / 수정 / 취소?
```

## 4. Preview Gate Choice

- preview_gate_choice: "1" (진행) — 커스텀 코드 LMS 사용 승인 포함

## 5. SRS Draft

### 5. 기능명세 요약 (인덱스)
| REQ ID | 요구사항 |
|---|---|
| REQ-LMS-01 | 강의 등록 |
| REQ-LMS-02 | 강의 수강 |
| REQ-LMS-03 | 진도 추적 |
| REQ-LMS-04 | 수료증 발급 |
| REQ-LMS-05 | 수강 이력 조회 |
| REQ-AUTH-01 | 회원 가입·로그인 |
| REQ-AUTH-02 | 강사·수강생 권한 분리 [추론] |

**제외:** 결제 (외부 SaaS 위임)

### 7. 확인 필요 사항
| 분류 | 질문 |
|---|---|
| 정책 확인 | 수료 기준 (출석률·평가 등) 미정 (REQ-LMS-04) |

## 6. Step 6 Save Gate

```
Notion 프로젝트 문서 DB에 저장할까요?
1. 저장 (추천)
2. 수정 후 저장
3. 저장 안 함
```

## 7. Save Gate Choice

- save_gate_choice: "1" (저장)
- Resulting actions: Notion 프로젝트 문서 DB에 SRS 초안 저장 — https://notion.so/cigroio/edgroup-lms-srs-draft

## 8. Notes

- 커스텀 도메인 코드 `LMS` 도입 — 기본 9개 코드로 분류가 어색한 교육 도메인 특화. §3 preview에서 PM이 명시 승인 후 사용.
- 비창작 원칙 — 결제는 명시 제외 → 본문에 결제 REQ 추가하지 않고 인라인 `**제외:**`로 처리.
- 다음 라운드: REQ-LMS-04 수료 기준 정책 결정 후 본문 보완.
