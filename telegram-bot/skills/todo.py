"""
/todo — PM 액션 빠르게 추가 → PM Action Hub DB 저장
"""

import json
from services.claude import call_claude
from services.notion import create_todo

PARSE_PROMPT = """You are a parser for a PM todo system.
Given raw Korean input, extract todo titles.

## Rules
- Each line or comma-separated item = one todo
- Keep the title as-is (no reformatting)
- Multiple items → multiple entries

## Output
Return ONLY a JSON array of title strings.
Example: ["정솔푸드 대표님 전화", "RCK 디자인 확인"]
Return raw JSON only, no markdown fences."""


def handle(args: str) -> str:
    if not args.strip():
        return "Usage: /todo [할 일]"

    parsed = call_claude(PARSE_PROMPT, args, max_tokens=512)

    try:
        items = json.loads(parsed)
    except json.JSONDecodeError:
        start = parsed.find("[")
        end = parsed.rfind("]") + 1
        if start >= 0 and end > start:
            items = json.loads(parsed[start:end])
        else:
            return "파싱 실패. 다시 시도해주세요."

    if not isinstance(items, list):
        items = [items]

    results = []
    for title in items:
        if not isinstance(title, str) or not title.strip():
            continue
        try:
            create_todo(title=title.strip())
            results.append(f"✅ {title.strip()}")
        except Exception as e:
            results.append(f"❌ {title.strip()} — Error: {str(e)}")

    if not results:
        return "추가할 항목이 없습니다."

    return "\n".join(results)
