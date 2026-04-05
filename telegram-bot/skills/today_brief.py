"""
/today_brief — 오늘 브리핑 (할 일 + 진행 중 + 미팅)
"""

from datetime import datetime, timezone, timedelta

from services.notion import query_action_hub, extract_todo_info
from services.calendar import get_today_events

KST = timezone(timedelta(hours=9))

WEEKDAYS_KR = ["월", "화", "수", "목", "금", "토", "일"]


def handle(args: str) -> str:
    now = datetime.now(KST)
    date_str = now.strftime("%Y-%m-%d")
    weekday = WEEKDAYS_KR[now.weekday()]

    lines = [f"☀️ {date_str} ({weekday}) — 오늘 브리핑"]

    # Query Notion: "오늘" status
    try:
        today_items = query_action_hub("오늘")
        today_todos = [extract_todo_info(p) for p in today_items]
    except Exception:
        today_todos = []

    # Query Notion: "진행 중" status
    try:
        progress_items = query_action_hub("진행 중")
        progress_todos = [extract_todo_info(p) for p in progress_items]
    except Exception:
        progress_todos = []

    # Query Google Calendar
    events = get_today_events()

    has_content = False

    # 📋 오늘
    if today_todos:
        has_content = True
        lines.append(f"\n📋 오늘 ({len(today_todos)}건)")
        for t in today_todos:
            prefix = f"[{t['project']}] " if t["project"] else ""
            lines.append(f"- {prefix}{t['title']}")

    # 🔄 진행 중
    if progress_todos:
        has_content = True
        lines.append(f"\n🔄 진행 중 ({len(progress_todos)}건)")
        for t in progress_todos:
            lines.append(f"- {t['title']}")

    # 📅 미팅
    if events:
        has_content = True
        lines.append(f"\n📅 오늘 미팅")
        for e in events:
            lines.append(f"- {e['time']} {e['summary']}")

    if not has_content:
        lines.append("\n오늘은 등록된 액션이 없습니다. /todo로 추가하거나 PM Action Hub를 확인하세요.")

    return "\n".join(lines)
