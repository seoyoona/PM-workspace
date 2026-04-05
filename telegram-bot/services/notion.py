"""
Notion API client for PM Action Hub operations.
"""

import os
import json
from urllib.request import Request, urlopen

NOTION_TOKEN = os.environ.get("NOTION_TOKEN", "")
NOTION_API = "https://api.notion.com/v1"
NOTION_VERSION = "2022-06-28"

# PM Action Hub database ID
PM_ACTION_HUB_DB = os.environ.get(
    "NOTION_PM_ACTION_HUB_DB",
    "7ab5868799c1451792da062d4c8fff37",
)


def _headers() -> dict:
    return {
        "Authorization": f"Bearer {NOTION_TOKEN}",
        "Content-Type": "application/json",
        "Notion-Version": NOTION_VERSION,
    }


def _request(method: str, url: str, data=None) -> dict:
    payload = json.dumps(data).encode() if data else None
    req = Request(url, data=payload, headers=_headers(), method=method)
    with urlopen(req, timeout=30) as resp:
        return json.loads(resp.read().decode())


def create_todo(
    title: str,
    project: str = "",
    status: str = "미착수",
    priority: str = "Medium",
    action_type: str = "",
    source: str = "telegram",
) -> dict:
    """Create a page in PM Action Hub DB."""
    properties = {
        "제목": {
            "title": [{"text": {"content": title}}]
        },
        "상태": {
            "select": {"name": status}
        },
        "우선순위": {
            "select": {"name": priority}
        },
        "출처": {
            "select": {"name": source}
        },
    }

    if project:
        properties["프로젝트"] = {
            "select": {"name": project}
        }

    if action_type:
        properties["액션 유형"] = {
            "select": {"name": action_type}
        }

    data = {
        "parent": {"database_id": PM_ACTION_HUB_DB},
        "properties": properties,
    }

    return _request("POST", f"{NOTION_API}/pages", data)


def query_action_hub(status_filter: str):
    """Query PM Action Hub for items with given status."""
    data = {
        "filter": {
            "property": "상태",
            "select": {"equals": status_filter},
        },
        "page_size": 50,
    }

    result = _request("POST", f"{NOTION_API}/databases/{PM_ACTION_HUB_DB}/query", data)
    return result.get("results", [])


def extract_todo_info(page: dict) -> dict:
    """Extract title and project from a Notion page."""
    props = page.get("properties", {})

    # Title
    title_prop = props.get("제목", {}).get("title", [])
    title = title_prop[0]["plain_text"] if title_prop else "(untitled)"

    # Project
    project_prop = props.get("프로젝트", {}).get("select")
    project = project_prop["name"] if project_prop else ""

    return {"title": title, "project": project}
