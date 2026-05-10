---
status: Confirmed-1
case: case03
created: 2026-05-10
mode: manual
total_hours: 8
nexus_api_status: ok
detected_projects_count: 0
matched_rows_count: 2
---

## 1. Mode & Source Summary

- Mode: manual (`--manual` 옵션 사용)
- PM 직접 input: `DSA 4 디자인 검토, RCK 4 마이그레이션 정리`
- Notion 활동 자동 수집 단계 skip — PM이 명시한 항목만 사용.

## 2. Detected Activities

```
(자동 수집 skip — manual 모드)
```

## 3. Nexus Row Matching

| 입력 | 매칭 단계 | 매칭된 row | 결과 |
|---|---|---|---|
| DSA | 1순위 alias | DSA-DSA-Apr | 자동 확정 |
| RCK | 1순위 alias | RCK-RCK-1 | 자동 확정 |

## 4. Distribution

수동 입력 그대로:

| 프로젝트 | 시간 | 메모 |
|---|---|---|
| DSA-DSA-Apr | 4h | 디자인 검토 |
| RCK-RCK-1 | 4h | 마이그레이션 정리 |
| **합계** | **8h** | |

## 5. PM Confirm

```
다음 항목으로 입력합니다:
- DSA-DSA-Apr: 4h, 메모 "디자인 검토"
- RCK-RCK-1: 4h, 메모 "마이그레이션 정리"

총 8시간 — 진행할까요? (y/n)
```

PM: y

## 6. Write Result

- DSA-DSA-Apr: 4h / "디자인 검토" — saved
- RCK-RCK-1: 4h / "마이그레이션 정리" — saved

## 7. Notes

- manual 모드 — Notion 자동 수집 skip, PM 입력 그대로.
- alias 매칭 양쪽 모두 1순위 자동 확정.
