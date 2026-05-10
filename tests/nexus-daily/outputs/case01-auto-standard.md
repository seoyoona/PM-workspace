---
status: Confirmed-1
case: case01
created: 2026-05-10
mode: auto
total_hours: 8
nexus_api_status: ok
detected_projects_count: 3
matched_rows_count: 3
---

## 1. Mode & Source Summary

- Mode: auto (인자 없이 invoke)
- Sources: PM Action Hub + 커뮤니케이션 DB + Activity Log
- 활동 수집 범위: 오늘 (KST 기준)

## 2. Detected Activities

```
프로젝트별 활동 건수:
  DSA: 4건 (Action Hub 1 + 커뮤니케이션 2 + Activity Log 1)
  Connectory: 2건 (Action Hub 1 + Activity Log 1)
  Booktails: 2건 (커뮤니케이션 1 + Activity Log 1)
총 8건 / 3 프로젝트
```

## 3. Nexus Row Matching

| 입력 | 매칭 단계 | 매칭된 row | 결과 |
|---|---|---|---|
| DSA | 1순위 alias | DSA-DSA-Apr | 자동 확정 |
| Connectory | 1순위 alias | Connectory-Connectory-1 | 자동 확정 |
| Booktails | 1순위 alias | Booktails-Booktails | 자동 확정 |

## 4. Distribution

가중치 = 활동 건수.

| 프로젝트 | 가중치 | 비율 | 시간 |
|---|---|---|---|
| DSA | 4 | 50% | 4h |
| Connectory | 2 | 25% | 2h |
| Booktails | 2 | 25% | 2h |
| **합계** | 8 | 100% | **8h** |

## 5. PM Confirm

```
다음 항목으로 Nexus 일별 기록을 입력합니다:
- DSA-DSA-Apr: 4h, 메모 "PM Action Hub 1건 + 미팅 노트 2건 + dev-chat 1건"
- Connectory-Connectory-1: 2h, 메모 "스펙 검토 1건 + dev-chat 1건"
- Booktails-Booktails: 2h, 메모 "주간 리포트 1건 + dev-chat 1건"

총 8시간 (100%) — 진행할까요? (y/n)
```

PM 응답: y

## 6. Write Result

- DSA-DSA-Apr: 4h / "PM Action Hub 1건 + 미팅 노트 2건 + dev-chat 1건" — saved
- Connectory-Connectory-1: 2h / "스펙 검토 1건 + dev-chat 1건" — saved
- Booktails-Booktails: 2h / "주간 리포트 1건 + dev-chat 1건" — saved
- Nexus API status: ok / 모든 row 정상 저장.

## 7. Notes

- 자동 모드 — 사용자 입력 없이 Notion 활동에서 자동 수집.
- 모든 매칭이 alias registry 1순위에서 자동 확정 (highest-confidence path).
- 8h 분배 = 활동 건수 비례.
