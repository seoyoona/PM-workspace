---
status: Confirmed-1
case: case03
created: 2026-05-10
mode: full_list_select
pm_action_hub_db: collection://a183aae9-a894-8379-8708-87cf507ec8e8
input_lines_count: 1
created_count: 1
skipped_duplicate_count: 0
---

## 1. Input Summary

- Input: `[koboom] 피드백 회신` (대괄호는 있지만 소문자)
- Lines: 1

## 2. Project Detection

- 대괄호 추출: `koboom` (소문자)
- Notion 프로젝트 select 옵션과 exact-match 비교 (대소문자 완전 일치): ❌ (Koboom과 다름)
- substring / 유사도 / case-insensitive 매칭 자동 확정 ❌ (skill rule).
- 숫자 선택지 fallback:

```
프로젝트를 지정해주세요:
1. 최근 사용 프로젝트
2. 전체 목록 보기
3. 취소
추천: 1
```

PM 입력: `2` → 전체 목록:
```
1. DSA
2. Booktails
3. Connectory
4. Koboom
5. RCK
6. BaraeCNP
7. Mountain
```

PM 입력: `4` → Koboom 정확 선택.

- 액션 유형 감지: "회신" 키워드 → 고객 커뮤니케이션

## 3. C1 Duplicate Check

- Unique key: 제목 `[Koboom] 피드백 회신` + 프로젝트 Koboom + 작성일 2026-05-10
- 0건 → 신규 생성

## 4. Notion Write Result

- 생성 1건:
  - 제목: `[Koboom] 피드백 회신` (대문자 Koboom — Notion 옵션 정확 일치)
  - 프로젝트: Koboom
  - 상태: 미착수
  - 액션 유형: 고객 커뮤니케이션
- URL: https://notion.so/cigroio/koboom-feedback-reply

## 5. Notes

- 소문자 [koboom]은 Notion select 옵션 "Koboom"과 exact match 실패. case-insensitive 자동 확정은 skill rule로 금지.
- fallback에서 PM이 명시 선택 → 정확한 옵션값 "Koboom"으로 저장 (Notion 옵션 무결성 유지).
