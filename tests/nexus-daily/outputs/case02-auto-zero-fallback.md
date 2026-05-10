---
status: Confirmed-1
case: case02
created: 2026-05-10
mode: auto
total_hours: 8
nexus_api_status: ok
detected_projects_count: 0
matched_rows_count: 2
---

## 1. Mode & Source Summary

- Mode: auto (인자 없이 invoke)
- 오늘 Notion 활동 기록 0건 — fallback 흐름

## 2. Detected Activities

```
📋 오늘 Notion 활동 기록 없음
```

## 3. Nexus Row Matching

활성 태스크 row를 PM에게 제시:

```
1. DSA-DSA-Apr (DSA-4월 구독)
2. Connectory-Connectory-1 (Connectory - PM)
3. Muchang-Muchang-1 (Muchang - PM)
4. Booktails-Booktails (Booktails - PM)

번호로 선택 (쉼표로 여러 개) / --manual로 직접 입력 / c=취소
```

PM 입력: `1, 2`

매칭된 rows:
- DSA-DSA-Apr (선택)
- Connectory-Connectory-1 (선택)

## 4. Distribution

수동 선택 → 균등 분배.

| 프로젝트 | 시간 |
|---|---|
| DSA-DSA-Apr | 4h |
| Connectory-Connectory-1 | 4h |
| **합계** | **8h** |

## 5. PM Confirm

```
다음 항목으로 입력합니다:
- DSA-DSA-Apr: 4h, 메모 "프로젝트 관리"
- Connectory-Connectory-1: 4h, 메모 "프로젝트 관리"

총 8시간 — 진행할까요? (y/n)
```

PM: y

## 6. Write Result

- DSA-DSA-Apr: 4h / "프로젝트 관리" — saved
- Connectory-Connectory-1: 4h / "프로젝트 관리" — saved

## 7. Notes

- detected_projects_count=0 fallback 경로 — 자동 감지 실패 시 활성 row에서 PM이 직접 선택.
- 시간은 균등 분배, 메모는 "프로젝트 관리" 기본값.
- 본 실행은 status=Confirmed-1 (PM이 fallback에서 선택해 진행). detected_projects_count는 0이지만 final write는 정상.
