---
case: case09
description: PM 선택=2 (수정) — In-Round 항목이 있지만 PM이 분류를 다시 검토하기로 결정. spec_pages 비어 있음, §8 Notion 생성 보류 표기, §9에 수정해야 할 분류/항목 명시.
client: Connectory
project: Connectory-1
source: free-text
srs_ref: clients/Connectory/Connectory-1/srs.md
design_md: missing
gate_choice: "2"
expected_buckets:
  in_round_count: 1
  next_round_count: 0
  out_of_scope_count: 0
  confirm_needed_count: 1
notes: |
  Test PM 선택=2 path: In-Round 항목이 1건 있지만 또 다른 1건이 Confirm-Needed에 가까워 보여 PM이 분류 재검토 결정. Notion write 발생 X. spec_pages: [] 유지.
---

# Request

```
/to-spec --client Connectory --project Connectory-1
```

요청 본문:
> "어드민 회원 관리 화면에 정렬 옵션을 추가해주세요. 가입일 / 마지막 로그인 / 이름 가나다순 정도면 충분합니다. 그리고 같이 보면, 회원 통계도 한 번에 보고 싶은데 어디까지 가능할지 좀 봐주세요."

PM 1-line: "어드민 회원 관리 화면에 정렬 옵션 추가 + 회원 통계 표시 요청 (범위 명확치 않음)."
