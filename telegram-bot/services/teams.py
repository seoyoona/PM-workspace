"""
Teams message sending via Power Automate HTTP trigger.
"""

import os
import json
from urllib.request import Request, urlopen

TEAMS_FLOW_URL = os.environ.get("TEAMS_FLOW_URL", "")


def get_chat_id(client: str):
    """Get Teams chat ID for a client's dev group chat."""
    key = f"TEAMS_CHAT_{client.upper()}_DEV"
    return os.environ.get(key)


def send_teams_message(chat_id: str, message: str) -> bool:
    """Send message to Teams via Power Automate. Returns True on success."""
    if not TEAMS_FLOW_URL:
        return False

    payload = json.dumps({
        "chat_id": chat_id,
        "message": message,
    }).encode()

    req = Request(
        TEAMS_FLOW_URL,
        data=payload,
        headers={"Content-Type": "application/json"},
        method="POST",
    )

    try:
        with urlopen(req, timeout=15) as resp:
            return resp.status == 202
    except Exception:
        return False
