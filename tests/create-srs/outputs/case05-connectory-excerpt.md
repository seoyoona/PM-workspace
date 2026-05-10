---
status: Confirmed-1
case: case05
client: Connectory
project: Connectory-2
created: 2026-05-10
source_type: text
source_ref: text inline (대형 SRS 메모)
project_doc_db: collection://bd33aae9-a894-82a9-b8e2-87387e7fbf47
preview_gate_choice: "1"
save_gate_choice: "1"
new_page_url: https://notion.so/cigroio/connectory-2-srs-draft
req_total: 18
confirm_needed_count: 4
out_of_scope_count: 0
output_mode: excerpt
custom_domain_codes: []
---

## 1. Source Summary

- Source: text inline (대형 SRS 메모)
- Coverage: 회원·MFA / 결제·구독 / admin 통계·CSV / API 키 / system health

## 2. REQ Extraction Summary

| 그룹 | 도메인 코드 | REQ 개수 |
|---|---|---|
| 인증·회원 | AUTH | 5 |
| 결제·크레딧 | PAY | 4 |
| 관리자 | ADMIN | 4 |
| API | API | 3 |
| 시스템 | SYS | 2 |
| **합계** | | **18건** |

- REQ 16건 이상 → 발췌 모드 출력
- 확인 필요: 4건
- 커스텀 도메인 코드: 없음

## 3. Step 3 Preview

```
## SRS 초안 미리보기
기능 그룹: 5개, REQ 18건 (대형)
출력 모드: 발췌 — 전문 필요시 별도 요청

진행 / 수정 / 취소?
```

## 4. Preview Gate Choice

- preview_gate_choice: "1" (진행)

## 5. SRS Draft

(excerpt mode — 16건 이상이라 핵심 발췌. 전문이 필요하면 PM이 명시 요청.)

### 1. 프로젝트 개요
- 프로젝트명: Connectory-2
- 형태: B2B SaaS + admin + API
- 핵심 1줄: MFA·구독 결제·통계·API 키 발급까지 통합 SaaS 플랫폼.

### 3. 개발 범위 (Scope)
- In-scope: 위 18건 REQ
- Out-of-scope: (none)

### 5. 기능명세 요약 (인덱스 — 발췌)
| REQ ID | 요구사항 |
|---|---|
| REQ-AUTH-01 | 회원 가입 |
| REQ-AUTH-02 | 로그인 |
| REQ-AUTH-03 | MFA |
| REQ-AUTH-04 | 소셜 로그인 |
| REQ-AUTH-05 | 프로필 편집 |
| REQ-PAY-01 | 크레딧 충전 |
| REQ-PAY-02 | 환불 |
| REQ-PAY-03 | 구독 결제 |
| REQ-PAY-04 | 영수증 발급 |
| REQ-ADMIN-01 | 회원 관리 |
| REQ-ADMIN-02 | 결제 관리 |
| REQ-ADMIN-03 | 통계 대시보드 |
| REQ-ADMIN-04 | CSV 내보내기 |
| REQ-API-01 | API 키 발급 |
| REQ-API-02 | API 키 회수 |
| REQ-API-03 | rate-limit 정책 [확인 필요] |
| REQ-SYS-01 | health check |
| REQ-SYS-02 | 로그 보존 정책 [확인 필요] |

### 7. 확인 필요 사항
| 분류 | 질문 |
|---|---|
| 정책 확인 | MFA 강제 vs 선택? (REQ-AUTH-03) |
| 정책 확인 | 구독 결제 결제 사이클 (월/연) 미정 (REQ-PAY-03) |
| 기술 전제 | API rate-limit 임계값 미정 (REQ-API-03) |
| 운영 확인 | 로그 보존 기간 미정 (REQ-SYS-02) |

> 전문(섹션 2 배경, 섹션 4 IA, 섹션 6 상세 기능명세)이 필요하면 PM이 별도 요청.

## 6. Step 6 Save Gate

```
Notion 프로젝트 문서 DB에 저장할까요?
1. 저장 (추천)
2. 수정 후 저장
3. 저장 안 함
```

## 7. Save Gate Choice

- save_gate_choice: "1" (저장)
- Resulting actions: Notion 프로젝트 문서 DB에 SRS 초안 저장 — https://notion.so/cigroio/connectory-2-srs-draft

## 8. Notes

- output_mode="excerpt" — REQ 18건이 16건 임계 초과. 발췌 모드로 §1 / §3 / §5 / §7만 출력.
- §2 배경 / §4 IA / §6 상세 기능명세는 본 출력에서 생략. 전문이 필요하면 PM이 별도 명시.
- 비창작 원칙 준수 — 모든 18건 REQ는 소스 메모에 직접 명시된 항목.
