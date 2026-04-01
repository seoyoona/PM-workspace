"""
Claude API client — builds system prompt from skill template + client context,
sends to Claude API, returns response text.
"""

import os
import json
import logging
from urllib.request import Request, urlopen
from urllib.error import HTTPError

logger = logging.getLogger()

ANTHROPIC_API_KEY = os.environ.get("ANTHROPIC_API_KEY", "")
MODEL = os.environ.get("CLAUDE_MODEL", "claude-sonnet-4-20250514")
MAX_TOKENS = 4096


def call_claude(system_prompt: str, user_message: str, max_tokens: int = MAX_TOKENS) -> str:
    """Call Claude API and return the text response."""
    payload = json.dumps({
        "model": MODEL,
        "max_tokens": max_tokens,
        "system": system_prompt,
        "messages": [
            {"role": "user", "content": user_message}
        ],
    }).encode()

    req = Request(
        "https://api.anthropic.com/v1/messages",
        data=payload,
        headers={
            "Content-Type": "application/json",
            "x-api-key": ANTHROPIC_API_KEY,
            "anthropic-version": "2023-06-01",
        },
        method="POST",
    )

    try:
        with urlopen(req, timeout=60) as resp:
            data = json.loads(resp.read().decode())
    except HTTPError as e:
        error_body = e.read().decode()
        logger.error(f"Claude API {e.code}: {error_body}")
        raise RuntimeError(f"Claude API {e.code}: {error_body}")

    # Extract text from response
    for block in data.get("content", []):
        if block.get("type") == "text":
            return block["text"]

    return ""
