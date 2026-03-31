# PM Workspace

> Claude Code 기반 PM 워크플로우 자동화 — 아웃소싱 개발사에서 **한국 클라이언트 ↔ 베트남 개발팀** 사이 PM 반복 업무를 `/커맨드` 한 줄로 처리합니다.

## 이 워크스페이스가 해결하는 문제

| Before (수동) | After (자동화) |
|---|---|
| 미팅 후 노션 정리 30분 + Teams 메시지 15분 + 카톡 10분 | `/meeting-note` 한 번이면 3개 동시 생성 |
| 고객 요청을 매번 영어로 번역하고 구조화 | `/dev-chat` 또는 `/to-spec`으로 자동 변환 |
| 개발팀 영어 메시지를 고객 카톡으로 매번 다시 작성 | `/client-chat`이 톤/용어 맞춰서 자동 변환 |
| 매일 "오늘 뭐하지?" 머리로 조합 | `/today-brief`로 아침 브리핑 |
| 할 일이 여러 곳에 흩어져 누락 | PM Action Hub + `/todo`로 통합 관리 |

## 사용 예시

```
# 고객 미팅 끝나면 — 러프한 메모만 넣으면 됨
/meeting-note --client rck
대표님이 질문지 삭제 안 된다고 하셨음
외부 QA 금요일 종료
질문지 안정화 최우선

→ Notion 미팅노트 자동 저장
→ Teams 영어 메시지 생성 (복붙용)
→ 카톡 한국어 메시지 생성 (복붙용)
```

## 14개 스킬

| 상황 | 스킬 | 출력 |
|------|------|------|
| 미팅 끝남 | `/meeting-note` | Notion 미팅노트 + Teams(EN) + 카톡(KR) |
| 개발팀에 전달 | `/dev-chat` | 영어 Teams 메시지 |
| 고객에게 전달 | `/client-chat` | 한국어 카톡 메시지 |
| 큰 요청 | `/to-spec` | Notion 스펙 + 태스크 DB |
| 검수 요청 | `/qa-request` | 카톡 검수 요청 메시지 |
| 주간 보고 | `/weekly-report` | Notion 주간 리포트 |
| SRS 번역 | `/srs-translate` | 영어 구조화 번역 (Notion) |
| 킥오프 준비 | `/kickoff-prep` | 고객 안건(KR) + 내부 노트(EN) |
| 이슈 티켓 | `/issue-ticket` | Linear 티켓 |
| 데일리 스크럼 | `/daily-scrum` | Notion Daily Scrum Log |
| 내부 싱크 | `/sync-note` | 영어 Teams 메시지 |
| 아침 브리핑 | `/today-brief` | 오늘 할 일 + blocker 요약 |
| 할 일 추가 | `/todo` | PM Action Hub DB |
| 새 프로젝트 | `/new-project` | 로컬 파일 + Notion 뷰 자동 생성 |

## 구조

```
yoona-workspace/
├── CLAUDE.md                    # 전체 규칙 (자동 로드)
├── clients/{name}/CLAUDE.md     # 고객사별 컨텍스트 (톤, 도메인, 담당자)
├── glossary/{name}.md           # 고객사별 용어집 (KR↔EN)
├── templates/                   # 문서 구조 템플릿
└── .claude/commands/            # 14개 스킬 파일
```

## 시작하기

### 1. Claude Code 설치

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

### 2. 저장소 Fork & Clone

1. 이 저장소 우측 상단 **Fork** 클릭
2. 본인 계정에서 Clone:

```bash
cd ~/Documents
git clone https://github.com/본인계정/yoona-workspace.git
cd yoona-workspace
```

### 3. Claude Code 실행

```bash
claude
```

### 4. MCP 연결

```bash
# Notion
claude mcp add --transport http notion https://mcp.notion.com/mcp

# Linear (선택)
claude mcp add --transport http linear https://mcp.linear.app/sse
```

### 5. 고객사 세팅

Fork 직후에는 고객사 파일이 없습니다 (보안상 제외). 담당 고객사를 등록하세요:

```
/new-project --client 고객사명 --project 프로젝트명
```

### 6. 테스트

```
/dev-chat --client 고객사명 테스트 메시지입니다
```

영어 Teams 메시지가 출력되면 세팅 완료.

## 연동 서비스

| 서비스 | 용도 | MCP |
|---|---|---|
| **Notion** | 문서, 미팅노트, 리포트, PM Action Hub, Daily Scrum | notion |
| **Linear** | 이슈 티켓 | linear |
| **Google Workspace** | 스프레드시트, 드라이브 | google-workspace |

## 설계 원칙

- **언어 자동 분리** — 고객: 한국어 / 개발팀: 영어
- **모호함 플래그** — 임의 해석 없이 "Ambiguities" 섹션에 표시
- **번역 ≠ 추론** — 원문 번역과 Claude 추론을 절대 섞지 않음
- **용어 일관성** — 고객사별 glossary 기반, 동의어 금지
- **복붙 가능** — 출력물을 그대로 Teams/카톡에 붙여넣기

## 커스텀하기

이 워크스페이스를 본인 팀에 맞게 조정하려면:

1. **CLAUDE.md** — 팀 역할, 번역 규칙, Notion DB ID 수정
2. **clients/{name}/CLAUDE.md** — 고객사 컨텍스트 (톤, 도메인, 담당자 성향)
3. **glossary/{name}.md** — 도메인 용어 매핑 (KR↔EN)
4. **.claude/commands/*.md** — 스킬 수정/추가
5. **templates/*.md** — 출력 구조 변경

## 기술 스택

- [Claude Code](https://claude.ai/code) — CLI/Desktop 앱
- [Notion MCP](https://mcp.notion.com) — 문서 읽기/쓰기
- [Linear MCP](https://mcp.linear.app) — 이슈 관리
- Notion-flavored Markdown — 페이지 생성/수정

## License

MIT
