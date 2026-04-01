"""
AWS Lambda handler for Telegram PM Bot.
Receives webhook from Telegram, routes commands to skills.
"""

import json
import os
import logging
import traceback
from urllib.request import Request, urlopen

logger = logging.getLogger()
logger.setLevel(logging.INFO)

TELEGRAM_TOKEN = os.environ.get("TELEGRAM_TOKEN", "")
TELEGRAM_API = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}"

# Allowed Telegram user IDs (comma-separated in env)
ALLOWED_USERS = set()
raw = os.environ.get("ALLOWED_USER_IDS", "")
if raw:
    ALLOWED_USERS = {int(uid.strip()) for uid in raw.split(",") if uid.strip()}

# Commands that support Teams sending
TEAMS_COMMANDS = {"/dev_chat", "/sync_note"}

# In-memory cache for last message per chat (for Teams callback)
# In Lambda, this only lives within the same warm instance
_last_messages = {}


def send_telegram(chat_id, text, parse_mode="Markdown", reply_markup=None):
    """Send a message back to Telegram."""
    payload = {
        "chat_id": chat_id,
        "text": text,
        "parse_mode": parse_mode,
    }
    if reply_markup:
        payload["reply_markup"] = reply_markup

    data = json.dumps(payload).encode()
    req = Request(
        f"{TELEGRAM_API}/sendMessage",
        data=data,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        urlopen(req, timeout=10)
    except Exception:
        # Fallback: retry without parse_mode
        payload = {"chat_id": chat_id, "text": text}
        if reply_markup:
            payload["reply_markup"] = reply_markup
        data = json.dumps(payload).encode()
        req = Request(
            f"{TELEGRAM_API}/sendMessage",
            data=data,
            headers={"Content-Type": "application/json"},
            method="POST",
        )
        urlopen(req, timeout=10)


def answer_callback(callback_query_id, text=""):
    """Answer a callback query (dismiss the loading indicator)."""
    payload = json.dumps({
        "callback_query_id": callback_query_id,
        "text": text,
    }).encode()
    req = Request(
        f"{TELEGRAM_API}/answerCallbackQuery",
        data=payload,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        urlopen(req, timeout=5)
    except Exception:
        pass


def edit_message_reply_markup(chat_id, message_id, reply_markup=None):
    """Remove or update inline keyboard on a message."""
    payload = json.dumps({
        "chat_id": chat_id,
        "message_id": message_id,
        "reply_markup": reply_markup or {"inline_keyboard": []},
    }).encode()
    req = Request(
        f"{TELEGRAM_API}/editMessageReplyMarkup",
        data=payload,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        urlopen(req, timeout=5)
    except Exception:
        pass


def send_typing(chat_id):
    """Send typing indicator."""
    payload = json.dumps({"chat_id": chat_id, "action": "typing"}).encode()
    req = Request(
        f"{TELEGRAM_API}/sendChatAction",
        data=payload,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        urlopen(req, timeout=5)
    except Exception:
        pass


# Command registry — lazy imports to keep cold start fast
COMMANDS = {
    "/dev_chat": "skills.dev_chat",
    "/client_chat": "skills.client_chat",
    "/sync_note": "skills.sync_note",
    "/todo": "skills.todo",
    "/today_brief": "skills.today_brief",
    "/start": None,
    "/help": None,
}

HELP_TEXT = """PM Bot Commands:

/dev\\_chat <client> <내용>
→ 개발팀 Teams 메시지 생성 (EN)

/client\\_chat <client> <내용>
→ 클라이언트 카톡 메시지 생성 (KR)

/sync\\_note <client> <내용>
→ Sync 미팅 → 개발팀 메시지 (EN)

/todo <내용>
→ PM Action Hub에 할 일 추가

/today\\_brief
→ 오늘 브리핑 (할 일 + 미팅)

커맨드 없이 자연어로도 사용 가능!
예: "koboom한테 로그인 버그 수정됐다고 전달해줘"
예: "오늘 뭐해야돼?"
예: "rck 미팅 내용 정리해서 개발팀에 전달해줘\""""


ROUTER_PROMPT = """You are a router for a PM bot. Given a natural language message in Korean,
determine which skill to run and extract the arguments.

Available skills:
- dev_chat: Send message to dev team (English). Triggers: 개발팀에 전달, 개발팀한테, dev한테, teams에, 팀즈에
- client_chat: Send message to client (Korean). Triggers: 고객한테, 클라이언트한테, 카톡으로, 고객에게 전달
- sync_note: Internal sync meeting follow-up. Triggers: 싱크, sync, 내부 미팅
- todo: Add PM action item. Triggers: 할 일, todo, 투두, 해야할, 추가해, 등록
- today_brief: Morning briefing. Triggers: 오늘 뭐해, 브리핑, 오늘 할 일, 뭐해야돼

Rules:
- If the message clearly matches one skill, return that skill
- If ambiguous, pick the most likely one
- Extract the client name if mentioned (koboom, rck, 21gram, booktails, baraecnp, dsa, w81, freshmart, everytalk)
- Return ONLY a JSON object: {"skill": "dev_chat", "client": "koboom", "content": "the rest"}
- If it's today_brief, client and content can be empty: {"skill": "today_brief", "client": "", "content": ""}
- If you truly cannot determine the skill, return: {"skill": "unknown", "client": "", "content": ""}
- Return raw JSON only, no markdown fences."""


def route_command(text):
    """Parse command and arguments from message text."""
    if not text or not text.startswith("/"):
        return None, None
    parts = text.split(None, 1)
    cmd = parts[0].lower().split("@")[0]
    args = parts[1] if len(parts) > 1 else ""
    return cmd, args


def route_natural_language(text):
    """Use Claude to route natural language to a skill.
    Returns (command, args) or (None, None).
    """
    from services.claude import call_claude
    try:
        result = call_claude(ROUTER_PROMPT, text, max_tokens=256)
        # Parse JSON
        start = result.find("{")
        end = result.rfind("}") + 1
        if start >= 0 and end > start:
            parsed = json.loads(result[start:end])
        else:
            return None, None

        skill = parsed.get("skill", "unknown")
        if skill == "unknown":
            return None, None

        cmd = f"/{skill}"
        client = parsed.get("client", "")
        content = parsed.get("content", "")

        if client and content:
            args = f"{client} {content}"
        elif client:
            args = client
        else:
            args = content

        return cmd, args
    except Exception:
        return None, None


def handle_callback(body):
    """Handle inline keyboard button presses."""
    callback = body["callback_query"]
    callback_id = callback["id"]
    chat_id = callback["message"]["chat"]["id"]
    message_id = callback["message"]["message_id"]
    data = callback.get("data", "")

    if data.startswith("teams_send:"):
        client = data.split(":", 1)[1]
        # Get cached message
        cache_key = f"{chat_id}:{client}"
        message_text = _last_messages.get(cache_key)

        if not message_text:
            answer_callback(callback_id, "메시지가 만료되었습니다. 다시 생성해주세요.")
            return

        # Send to Teams
        from services.teams import get_chat_id, send_teams_message
        teams_chat_id = get_chat_id(client)

        if not teams_chat_id:
            answer_callback(callback_id, f"{client} Teams 채팅 ID가 없습니다.")
            return

        success = send_teams_message(teams_chat_id, message_text)
        if success:
            answer_callback(callback_id, "Teams 전송 완료!")
            # Remove the button
            edit_message_reply_markup(chat_id, message_id)
            send_telegram(chat_id, "✅ Teams 전송 완료")
        else:
            answer_callback(callback_id, "Teams 전송 실패")
            send_telegram(chat_id, "❌ Teams 전송 실패. 복사해서 수동 전송해주세요.")

    elif data == "teams_skip":
        answer_callback(callback_id)
        edit_message_reply_markup(chat_id, message_id)


def lambda_handler(event, context):
    """AWS Lambda entry point."""
    try:
        body = json.loads(event.get("body", "{}"))
    except (json.JSONDecodeError, TypeError):
        return {"statusCode": 400, "body": "Bad request"}

    # Handle callback queries (button presses)
    if "callback_query" in body:
        try:
            handle_callback(body)
        except Exception as e:
            logger.error(f"Callback error: {traceback.format_exc()}")
        return {"statusCode": 200, "body": "OK"}

    message = body.get("message")
    if not message:
        return {"statusCode": 200, "body": "OK"}

    chat_id = message["chat"]["id"]
    user_id = message.get("from", {}).get("id")
    text = message.get("text", "").strip()

    # Auth check
    if ALLOWED_USERS and user_id not in ALLOWED_USERS:
        send_telegram(chat_id, "Unauthorized.")
        return {"statusCode": 200, "body": "OK"}

    cmd, args = route_command(text)

    if cmd is None:
        # Try natural language routing
        send_typing(chat_id)
        cmd, args = route_natural_language(text)
        if cmd is None:
            send_telegram(chat_id, "무슨 스킬을 실행할지 모르겠어요. 다시 말해주시거나 /help를 확인해주세요.")
            return {"statusCode": 200, "body": "OK"}

    if cmd in ("/start", "/help"):
        send_telegram(chat_id, HELP_TEXT)
        return {"statusCode": 200, "body": "OK"}

    if cmd not in COMMANDS:
        send_telegram(chat_id, f"Unknown command: {cmd}\n\n{HELP_TEXT}")
        return {"statusCode": 200, "body": "OK"}

    if not args and cmd != "/today_brief":
        send_telegram(chat_id, f"Usage: {cmd} <client> <내용>")
        return {"statusCode": 200, "body": "OK"}

    send_typing(chat_id)

    try:
        module_path = COMMANDS[cmd]
        mod = __import__(module_path, fromlist=["handle"])
        result = mod.handle(args)

        # For Teams-capable commands, add send button
        if cmd in TEAMS_COMMANDS:
            from context.loader import parse_client_and_args
            client, _ = parse_client_and_args(args)
            from services.teams import get_chat_id
            teams_chat_id = get_chat_id(client) if client else None

            if client and teams_chat_id:
                # Cache message for callback
                _last_messages[f"{chat_id}:{client}"] = result

                reply_markup = {
                    "inline_keyboard": [[
                        {"text": "📤 Teams 전송", "callback_data": f"teams_send:{client}"},
                        {"text": "✖ 복사만", "callback_data": "teams_skip"},
                    ]]
                }
                send_telegram(chat_id, result, reply_markup=reply_markup)
            else:
                send_telegram(chat_id, result)
        else:
            send_telegram(chat_id, result)

    except Exception as e:
        logger.error(f"Error in {cmd}: {traceback.format_exc()}")
        send_telegram(chat_id, f"Error: {str(e)}")

    return {"statusCode": 200, "body": "OK"}
