---
case: case02
description: 같은 날짜+클라이언트+유형="미팅 노트" 매치 1건 → "1 덮어쓰기 (기존 archive + 새 생성)" 선택. archive_target 채워지고 새 page URL 기록.
client: dsa
project: Dsa
meeting_date: 2026-05-08
existing_match_count: 1
existing_match_url: https://notion.so/cigroio/dsa-meeting-2026-05-08-old
gate_choice: "1"
expected_buckets:
  action_items_count: 2
  out_of_scope_count: 0
  memo_only_count: 0
  to_spec_recommendation: no
notes: |
  PM이 같은 날짜에 미팅 노트를 다시 만들 때 archive flow 검증. 기존 1건 archive → 새 page 생성. 같은 미팅의 갱신 케이스.
---

# Meeting transcript (raw)

```
[Yoona]
오늘 R2 디자인 검토 미팅이고, 어제 보낸 와이어프레임 다시 봅니다.

[Kim (Client)]
admin 사이드바 정렬은 어제 안 그대로 진행하는 걸로 합니다.

[Tuan (Dev)]
admin 검색 정렬 우선순위는 제가 따로 정리해서 내일까지 공유드릴게요.

[Yoona]
저는 오늘 미팅 노트 정리해서 내일까지 공유드릴게요.
```

# PM input
```
/meeting-note --client dsa --date 2026-05-08
```

같은 날짜 매치 1건 발견 → PM이 "1 덮어쓰기 (기존 archive + 새 생성)" 선택.
