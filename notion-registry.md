# Notion Touchpoint Registry

> 마이그레이션 완료 상태 (2026-04-09). REST API → MCP 전환 + 5개 DB cigro 이전 완료.

---

## DB Registry (최종)

| DB | DB ID | data_source_id | Workspace | MCP | Used by |
|---|---|---|---|---|---|
| 프로젝트 문서 | `d7f3aae9a894831a96b2013549196181` | `bd33aae9-a894-82a9-b8e2-87387e7fbf47` | cigro | notion-cigro | create-srs, srs-translate, kickoff-prep, new-project |
| 커뮤니케이션 | `3793aae9a894836e8a200120b24454e4` | `47d3aae9-a894-83bf-8db8-071dd9a16fcd` | cigro | notion-cigro | meeting-note, weekly-report, to-spec |
| 태스크 | `b9f3aae9a8948322abee81e151af9831` | `4273aae9-a894-83fd-8d5e-87897d6d0570` | cigro | notion-cigro | to-spec, qa-feedback, new-project |
| Daily Scrum Log | `26b3aae9a89483b79de3810dce151383` | `9e03aae9-a894-8377-bbaf-0717f5d7f2ef` | cigro | notion-cigro | daily-scrum |
| PM Action Hub | `ff43aae9a89482ea8c57815a65ac9f5b` | `a183aae9-a894-8379-8708-87cf507ec8e8` | cigro | notion-cigro | todo, today-brief |
| Projects (cigro) | `98c3ff93-01f1-4b2e-a490-d827ac079ffc` | - | cigro | notion-cigro | qa-feedback |

## Auth 경로 (최종)

| Auth Method | 용도 |
|---|---|
| `notion-cigro` (OAuth MCP) | 모든 DB 접근 — 단일 경로 |
| `notion-yoona` (OAuth MCP) | yoona 개인 워크스페이스 접근 (PM Workspace 허브 페이지 등) |
| `notion` / `notion-v1` (npm MCP) | yoona 워크스페이스 접근 (레거시, 필요 시) |

## 제거 완료

- `NOTION_API_KEY` env — 제거됨
- `notion.sh` — 삭제됨
- `notion-v1-cigro` MCP — 제거됨 (토큰 무효)
- Bash curl Notion API 호출 — 전부 MCP로 전환
- old yoona DB 5개 — 삭제됨
- `.claude/worktrees/cool-heyrovsky/` — 삭제됨

## 텔레그램 봇

- Notion 연동 **비활성** — cigro internal API 토큰 발급 불가
- todo, today_brief의 Notion 접근 불가
- dev_chat, client_chat, sync_note는 Notion 불필요라 작동 가능
