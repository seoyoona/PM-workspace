---
case: case01
description: Bug ticket / High priority / 한국어 원문 요청 보존 / PM gate proceed → Linear 이슈 생성.
client: booktails
project: Booktails
priority: High
label: bug
gate_choice: "1"
has_original_request: true
notes: |
  결제 완료 후 영수증 화면 freeze 버그. PM이 Linear 이슈로 즉시 생성.
---

# Request (KR)

```
결제 완료 후 영수증 화면이 멈춥니다. "확인" 버튼 누르면 빈 화면이 잠깐 뜨고 그 후 진행이 안 됩니다.
```

# PM input

```
/issue-ticket --client booktails --priority high "결제 완료 후 영수증 화면 freeze"
```
