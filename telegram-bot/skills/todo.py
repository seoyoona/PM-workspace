"""
/todo — PM 액션 빠르게 추가 → PM Action Hub DB 저장
"""

import json
from services.claude import call_claude
from services.notion import create_todo

PARSE_PROMPT = """You are a parser for a PM todo system.
Given raw Korean input, extract structured todo items.

## Detection Rules
- Project: text in [brackets], or known project name (Koboom, RCK, BaraeCNP, DSA, 21gram, Booktails, W81, Freshmart)
- Priority: "급함", "긴급", "urgent", "오늘" → "High"; default "Medium"
- Status: "오늘" detected → "오늘"; default "미착수"
- Action type:
  - "회신", "전달", "공유", "카톡", "메시지" → "고객 커뮤니케이션"
  - "sync", "확인", "체크", "follow-up" → "내부 follow-up"
  - "등록", "업데이트", "정리", "작성" → "운영 체크"
  - otherwise → ""
- Title: always "[ProjectName] short description" format

## Output
Return ONLY a JSON array. Each item:
{"title": "[Project] description", "project": "Project", "status": "미착수", "priority": "Medium", "action_type": ""}

Multiple lines = multiple items. If no project detected, use "" for project and omit brackets in title.
Return raw JSON only, no markdown fences."""


def handle(args: str) -> str:
    if not args.strip():
        return "Usage: /todo [프로젝트] 할 일"

    # Use Claude to parse the input
    parsed = call_claude(PARSE_PROMPT, args, max_tokens=1024)

    try:
        items = json.loads(parsed)
    except json.JSONDecodeError:
        # Try to extract JSON from response
        start = parsed.find("[")
        end = parsed.rfind("]") + 1
        if start >= 0 and end > start:
            items = json.loads(parsed[start:end])
        else:
            return f"파싱 실패. 다시 시도해주세요."

    if not isinstance(items, list):
        items = [items]

    results = []
    for item in items:
        title = item.get("title", "")
        project = item.get("project", "")
        status = item.get("status", "미착수")
        priority = item.get("priority", "Medium")
        action_type = item.get("action_type", "")

        if not title:
            continue

        try:
            create_todo(
                title=title,
                project=project,
                status=status,
                priority=priority,
                action_type=action_type,
            )
            results.append(f"✅ {title}\n   상태: {status} | 우선순위: {priority}")
        except Exception as e:
            results.append(f"❌ {title} — Error: {str(e)}")

    if not results:
        return "추가할 항목이 없습니다."

    return "\n\n".join(results)
