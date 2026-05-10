---
status: Confirmed-1
case: case01
client: Connectory
project: Connectory-1
created: 2026-05-10
source_type: text
source_ref: text inline (기획 회의 메모)
project_doc_db: collection://bd33aae9-a894-82a9-b8e2-87387e7fbf47
preview_gate_choice: "1"
save_gate_choice: "1"
new_page_url: https://notion.so/cigroio/connectory-srs-draft
req_total: 11
confirm_needed_count: 3
out_of_scope_count: 1
output_mode: full
custom_domain_codes: []
---

## 1. Source Summary

- Source: text inline (기획 회의 메모, KR)
- Coverage: 회원·로그인·프로필 / 크레딧 충전·환불 / admin 회원 관리 / IA (3개 분기)

## 2. REQ Extraction Summary

| 그룹 | 도메인 코드 | REQ 개수 |
|---|---|---|
| 인증·회원 | AUTH | 3 (REQ-AUTH-01~03) |
| 결제·크레딧 | PAY | 3 (REQ-PAY-01~03) |
| 관리자 | ADMIN | 2 (REQ-ADMIN-01~02) |
| 데이터 | DATA | 1 (REQ-DATA-01) |
| 화면·UX | UI | 2 (REQ-UI-01~02) |
| **합계** | | **11건** |

- 확인 필요: 3건
- 제외사항: 1건 (모바일 앱은 out-of-scope)
- 커스텀 도메인 코드: 없음

## 3. Step 3 Preview

```
## SRS 초안 미리보기
프로젝트: Connectory-1 / 클라이언트: Connectory

기능 그룹: 5개, REQ 11건
확인 필요: 3건 / 제외사항: 1건 / 커스텀 도메인 코드: 없음

진행 / 수정 / 취소?
```

## 4. Preview Gate Choice

- preview_gate_choice: "1" (진행)
- Resulting actions: Step 4 SRS draft 생성 진행

## 5. SRS Draft

(full mode — 11 REQ는 15건 이하 임계 이하라 전문 출력)

### 1. 프로젝트 개요
- 프로젝트명: Connectory-1
- 형태: 웹 백오피스 + user 화면
- 핵심 1줄: 회원이 크레딧을 충전하고 admin이 회원을 관리할 수 있는 SaaS.

### 5. 기능명세 요약 (인덱스)
| REQ ID | 요구사항 |
|---|---|
| REQ-AUTH-01 | 이메일/비밀번호 회원가입 |
| REQ-AUTH-02 | 로그인 |
| REQ-AUTH-03 | 프로필 편집 |
| REQ-PAY-01 | 크레딧 충전 (카카오페이) |
| REQ-PAY-02 | 결제 검증 [추론] |
| REQ-PAY-03 | 환불 정책 |
| REQ-ADMIN-01 | 회원 검색 |
| REQ-ADMIN-02 | 회원 정지 |
| REQ-DATA-01 | 회원 데이터 저장·조회 |
| REQ-UI-01 | 메인 화면 / 마이페이지 / admin 분기 |
| REQ-UI-02 | 화면 전환 일관성 |

### 7. 확인 필요 사항
| 분류 | 질문 |
|---|---|
| 범위 확인 | 비밀번호 찾기 미언급 — 포함 여부? (REQ-AUTH-01 관련) |
| 정책 확인 | 환불 정책 세부 룰 미정 (REQ-PAY-03) |
| 운영 확인 | 회원 정지 후 데이터 보존 기간 미언급 (REQ-ADMIN-02) |

## 6. Step 6 Save Gate

```
Notion 프로젝트 문서 DB에 저장할까요?
1. 저장 (추천)
2. 수정 후 저장
3. 저장 안 함
```

## 7. Save Gate Choice

- save_gate_choice: "1" (저장)
- Resulting actions: Notion 프로젝트 문서 DB에 SRS 초안 저장 — https://notion.so/cigroio/connectory-srs-draft

## 8. Notes

- 비창작 원칙 적용: 소스에 명시된 기능만 본문에. "비밀번호 찾기"는 소스 미언급 → §7 확인 필요로만 처리, 본문 제외.
- `[추론]` 1건 (REQ-PAY-02 결제 검증) — 결제 기능 명시 → 검증 로직은 직접 맥락상 필연.
- 발췌 모드 미적용 (REQ 11건, 15건 이하).
- 커스텀 도메인 코드 미사용.
