# PM Workspace

Claude Code 기반 PM 워크플로우 자동화 워크스페이스.

아웃소싱 개발사에서 **한국 클라이언트 ↔ 베트남 개발팀** 사이 PM 반복 업무를 `/커맨드` 한 줄로 자동화합니다.

## 주요 기능

| 상황 | 스킬 | 출력 |
|------|------|------|
| 미팅 끝남 | `/meeting-note` | Notion 미팅노트 + Teams 메시지(EN) + 카톡(KR) |
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
| 아침 브리핑 | `/today-brief` | 오늘 할 일 + 미팅 + blocker 요약 |
| 할 일 추가 | `/todo` | PM Action Hub DB |
| 새 프로젝트 | `/new-project` | 로컬 파일 + Notion 뷰 자동 생성 |

## 구조

```
yoona-workspace/
├── CLAUDE.md                    # 전체 규칙 (자동 로드)
├── clients/{name}/CLAUDE.md     # 고객사별 컨텍스트
├── glossary/{name}.md           # 고객사별 용어집 (KR↔EN)
├── templates/                   # 문서 구조 템플릿
└── .claude/commands/            # 14개 스킬 파일
```

## 시작하기

1. [Claude Code 설치](https://claude.ai/install.sh)
2. 이 저장소 Fork → Clone
3. `cd yoona-workspace && claude`
4. MCP 연결 (Notion, Google Workspace, Linear)

자세한 세팅 가이드는 Notion PM Workspace 내 **PM Claude Code 세팅 가이드** 참고.

## 연동 서비스

- **Notion** — 프로젝트 문서 DB / 커뮤니케이션 DB / 태스크 DB / Daily Scrum Log DB / PM Action Hub DB
- **Linear** — 이슈 티켓
- **Google Workspace** — 스프레드시트, 드라이브, 캘린더

## 설계 원칙

- 한국어 클라이언트 / 영어 개발팀 — 언어 자동 분리
- 모호한 부분은 임의 해석 없이 플래그 처리
- 번역과 추론을 절대 섞지 않음
- 고객사별 용어집 기반 용어 일관성
- 출력물은 복사 → 붙여넣기 가능한 형태
