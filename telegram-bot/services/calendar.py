"""
Google Calendar API client for today's events.
Uses a service account or OAuth2 refresh token.
"""

import os
import json
from datetime import datetime, timezone, timedelta
from urllib.request import Request, urlopen
from urllib.parse import urlencode

# OAuth2 credentials (reuse existing tokens from google-drive-mcp)
GOOGLE_CLIENT_ID = os.environ.get("GOOGLE_CLIENT_ID", "")
GOOGLE_CLIENT_SECRET = os.environ.get("GOOGLE_CLIENT_SECRET", "")
GOOGLE_REFRESH_TOKEN = os.environ.get("GOOGLE_REFRESH_TOKEN", "")

KST = timezone(timedelta(hours=9))


def _get_access_token() -> str:
    """Get access token using refresh token."""
    data = urlencode({
        "client_id": GOOGLE_CLIENT_ID,
        "client_secret": GOOGLE_CLIENT_SECRET,
        "refresh_token": GOOGLE_REFRESH_TOKEN,
        "grant_type": "refresh_token",
    }).encode()

    req = Request(
        "https://oauth2.googleapis.com/token",
        data=data,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
        method="POST",
    )

    with urlopen(req, timeout=10) as resp:
        result = json.loads(resp.read().decode())
    return result["access_token"]


CALENDAR_IDS = [
    "primary",
    "75cn970oqdaki304qbehm43ehlgcguc0@import.calendar.google.com",
]


def get_today_events() -> list[dict]:
    """Get today's calendar events from all calendars (KST timezone)."""
    try:
        token = _get_access_token()
    except Exception:
        return []

    now_kst = datetime.now(KST)
    time_min = now_kst.replace(hour=0, minute=0, second=0, microsecond=0)
    time_max = time_min + timedelta(days=1)

    base_params = {
        "timeMin": time_min.isoformat(),
        "timeMax": time_max.isoformat(),
        "singleEvents": "true",
        "orderBy": "startTime",
        "timeZone": "Asia/Seoul",
    }

    events = []
    seen = set()

    for cal_id in CALENDAR_IDS:
        params = urlencode(base_params)
        url = f"https://www.googleapis.com/calendar/v3/calendars/{cal_id}/events?{params}"
        req = Request(url, headers={"Authorization": f"Bearer {token}"}, method="GET")

        try:
            with urlopen(req, timeout=10) as resp:
                data = json.loads(resp.read().decode())
        except Exception:
            continue

        for item in data.get("items", []):
            start = item.get("start", {})
            start_time = start.get("dateTime", start.get("date", ""))
            summary = item.get("summary", "(제목 없음)")

            if "T" in start_time:
                dt = datetime.fromisoformat(start_time)
                time_str = dt.strftime("%H:%M")
            else:
                time_str = "종일"

            # Deduplicate by time + summary
            key = f"{time_str}:{summary}"
            if key not in seen:
                seen.add(key)
                events.append({
                    "time": time_str,
                    "summary": summary,
                })

    # Sort by time
    events.sort(key=lambda e: e["time"])
    return events
