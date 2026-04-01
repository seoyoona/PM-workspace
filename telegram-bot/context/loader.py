"""
Load client context (CLAUDE.md) and glossary for a given client name.
Context files are bundled in the Lambda deployment package under context/data/.
"""

import os

DATA_DIR = os.path.join(os.path.dirname(__file__), "data")

# Known client directory names
KNOWN_CLIENTS = {
    "21gram", "baraecnp", "booktails", "dsa",
    "freshmart", "koboom", "rck", "w81",
}

# Aliases: common shorthand → directory name
CLIENT_ALIASES = {
    "gram": "21gram",
    "barae": "baraecnp",
    "cnp": "baraecnp",
    "book": "booktails",
    "fresh": "freshmart",
}


def resolve_client(name: str):
    """Resolve a client name (case-insensitive, alias-aware)."""
    name_lower = name.lower().strip()
    if name_lower in KNOWN_CLIENTS:
        return name_lower
    if name_lower in CLIENT_ALIASES:
        return CLIENT_ALIASES[name_lower]
    # Partial match
    for client in KNOWN_CLIENTS:
        if client.startswith(name_lower):
            return client
    return None


def load_client_context(client: str) -> str:
    """Load client CLAUDE.md content."""
    path = os.path.join(DATA_DIR, "clients", client, "CLAUDE.md")
    if os.path.exists(path):
        with open(path) as f:
            return f.read()
    return ""


def load_glossary(client: str) -> str:
    """Load client glossary."""
    path = os.path.join(DATA_DIR, "glossary", f"{client}.md")
    if os.path.exists(path):
        with open(path) as f:
            return f.read()
    return ""


def load_client_defaults() -> str:
    """Load default client communication rules."""
    path = os.path.join(DATA_DIR, "clients", "CLAUDE.md")
    if os.path.exists(path):
        with open(path) as f:
            return f.read()
    return ""


def get_full_context(client: str) -> str:
    """Build full context string for a client."""
    parts = []

    defaults = load_client_defaults()
    if defaults:
        parts.append(f"## Client Communication Defaults\n{defaults}")

    ctx = load_client_context(client)
    if ctx:
        parts.append(f"## Client Context ({client})\n{ctx}")

    glossary = load_glossary(client)
    if glossary:
        parts.append(f"## Glossary ({client})\n{glossary}")

    return "\n\n---\n\n".join(parts)


def parse_client_and_args(text: str):
    """Parse client name and remaining arguments from input.
    Supports: '--client name rest' or 'name rest' (first word = client).
    Returns (resolved_client, remaining_args).
    """
    text = text.strip()
    if not text:
        return None, ""

    # --client flag
    if text.startswith("--client "):
        rest = text[9:].strip()
        parts = rest.split(None, 1)
        if parts:
            client = resolve_client(parts[0])
            args = parts[1] if len(parts) > 1 else ""
            return client, args
        return None, ""

    # First word as client name
    parts = text.split(None, 1)
    candidate = resolve_client(parts[0])
    if candidate:
        args = parts[1] if len(parts) > 1 else ""
        return candidate, args

    # No client detected
    return None, text
