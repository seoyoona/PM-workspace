---
status: Confirmed-1
case: case06
client: Connectory
project: Connectory-1
created: 2026-05-10
source_type: text
source_ref: text inline (의도적 좁은 입력)
project_doc_db: collection://bd33aae9-a894-82a9-b8e2-87387e7fbf47
preview_gate_choice: "1"
save_gate_choice: "1"
new_page_url: https://notion.so/cigroio/connectory-srs-narrow
req_total: 4
confirm_needed_count: 3
out_of_scope_count: 0
output_mode: full
custom_domain_codes: []
---

## 1. Source Summary

- Source: text inline (의도적 좁은 입력 — 회원가입·로그인만 명시)
- Coverage: 매우 좁음. 본 메모만으로 SRS 작성.

## 2. REQ Extraction Summary

| 그룹 | 도메인 코드 | REQ 개수 |
|---|---|---|
| 인증 | AUTH | 4 |
| **합계** | | **4건** |

- 확인 필요: 3건 (소스 미언급 항목)

## 3. Step 3 Preview

```
## SRS 초안 미리보기
기능 그룹: 1개, REQ 4건. 입력이 매우 좁음 — 발췌 모드 X (전문 출력).

진행 / 수정 / 취소?
```

## 4. Preview Gate Choice

- preview_gate_choice: "1" (진행)

## 5. SRS Draft

### 5. 기능명세 요약 (인덱스)
| REQ ID | 요구사항 |
|---|---|
| REQ-AUTH-01 | 이메일 회원 가입 |
| REQ-AUTH-02 | 비밀번호 회원 가입 (이메일과 동일 폼) |
| REQ-AUTH-03 | 로그인 (이메일 + 비밀번호) |
| REQ-AUTH-04 | 세션 처리 [추론] |

> 본문에는 위 4건만 포함. "비밀번호 찾기" / "이메일 인증" / "회원 탈퇴" 등 일반적 부속 기능은 소스 미언급 → §7로 이동.

### 7. 확인 필요 사항
| 분류 | 질문 |
|---|---|
| 범위 확인 | 비밀번호 찾기 미언급 — 포함 여부? |
| 범위 확인 | 이메일 인증 미언급 — 포함 여부? |
| 범위 확인 | 회원 탈퇴 미언급 — 포함 여부? |

## 6. Step 6 Save Gate

```
Notion 프로젝트 문서 DB에 저장할까요?
1. 저장 (추천)
2. 수정 후 저장
3. 저장 안 함
```

## 7. Save Gate Choice

- save_gate_choice: "1" (저장)
- Resulting actions: Notion 프로젝트 문서 DB에 SRS 초안 저장 — https://notion.so/cigroio/connectory-srs-narrow

## 8. Notes

- 비창작 원칙 핵심 적용:
  - 소스에 명시된 4건 (가입·로그인·세션[추론])만 본문에.
  - "비밀번호 찾기" — 일반 서비스에서 흔한 기능이지만 소스 미언급 → §7만.
  - "이메일 인증" — 소스 미언급 → §7만.
  - "회원 탈퇴" — 소스 미언급 → §7만.
- `[추론]` 1건만 사용 — REQ-AUTH-04 세션 처리 (로그인 명시 → 세션은 직접 맥락상 필연).
- 일반 부속 기능 추론(흔히 동반되는 fallback / verification / withdrawal 류)은 §8 메타 주석 외 본문에 절대 사용 X.
