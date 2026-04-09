#!/bin/bash
# PM Workspace Migration Script
# fork 후 본인 값으로 교체하는 대화형 스크립트
#
# 사용법: cd yoona-workspace && bash scripts/migrate-pm.sh

set -e

WORKSPACE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$WORKSPACE_DIR"

echo "============================================"
echo "  PM Workspace Migration"
echo "  fork 후 본인 값으로 교체합니다"
echo "============================================"
echo ""
echo "워크스페이스: $WORKSPACE_DIR"
echo ""

# --- Helper ---
replace_all() {
  local old="$1"
  local new="$2"
  local label="$3"

  if [ "$old" = "$new" ]; then
    echo "  ⏭️  $label — 동일값, 건너뜀"
    return
  fi

  local count
  count=$(grep -rl "$old" CLAUDE.md .claude/commands/ .claude/nexus-alias.md .claude/nexus-daily.md 2>/dev/null | wc -l | tr -d ' ')

  if [ "$count" = "0" ]; then
    echo "  ⚠️  $label — 기존 값 찾을 수 없음 (이미 교체되었거나 없음)"
    return
  fi

  grep -rl "$old" CLAUDE.md .claude/commands/ .claude/nexus-alias.md 2>/dev/null | while read -r file; do
    sed -i '' "s|$old|$new|g" "$file"
  done

  echo "  ✅ $label — ${count}개 파일 교체 완료"
}

# ============================================
# Phase 1: PM 기본 정보
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Phase 1: PM 기본 정보"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "PM 이름 (영문, 예: Yoona): " PM_NAME
echo ""

# ============================================
# Phase 2: Notion DB ID 교체
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Phase 2: Notion DB ID 교체"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "cigro 워크스페이스에서 본인용 DB ID를 확인 후 입력하세요."
echo "Notion 페이지 URL 끝의 32자리 = DB ID"
echo "data_source_id는 MCP fetch 후 collection:// 태그에서 추출"
echo ""
echo "빈 칸으로 엔터 = 건너뛰기 (기존 값 유지)"
echo ""

# PM Hub Page
read -p "PM Hub 페이지 ID (기존: 339823375b0c8001ab28d33783105b8b): " NEW_PM_HUB
[ -n "$NEW_PM_HUB" ] && replace_all "339823375b0c8001ab28d33783105b8b" "$NEW_PM_HUB" "PM Hub"

echo ""
echo "--- 프로젝트 문서 DB ---"
read -p "DB ID (기존: d7f3aae9a894831a96b2013549196181): " NEW_ID
[ -n "$NEW_ID" ] && replace_all "d7f3aae9a894831a96b2013549196181" "$NEW_ID" "프로젝트문서 DB"
read -p "data_source_id (기존: bd33aae9-a894-82a9-b8e2-87387e7fbf47): " NEW_DS
[ -n "$NEW_DS" ] && replace_all "bd33aae9-a894-82a9-b8e2-87387e7fbf47" "$NEW_DS" "프로젝트문서 DS"

echo ""
echo "--- 커뮤니케이션 DB ---"
read -p "DB ID (기존: 3793aae9a894836e8a200120b24454e4): " NEW_ID
[ -n "$NEW_ID" ] && replace_all "3793aae9a894836e8a200120b24454e4" "$NEW_ID" "커뮤니케이션 DB"
read -p "data_source_id (기존: 47d3aae9-a894-83bf-8db8-071dd9a16fcd): " NEW_DS
[ -n "$NEW_DS" ] && replace_all "47d3aae9-a894-83bf-8db8-071dd9a16fcd" "$NEW_DS" "커뮤니케이션 DS"

echo ""
echo "--- 태스크 DB ---"
read -p "DB ID (기존: b9f3aae9a8948322abee81e151af9831): " NEW_ID
[ -n "$NEW_ID" ] && replace_all "b9f3aae9a8948322abee81e151af9831" "$NEW_ID" "태스크 DB"
read -p "data_source_id (기존: 4273aae9-a894-83fd-8d5e-87897d6d0570): " NEW_DS
[ -n "$NEW_DS" ] && replace_all "4273aae9-a894-83fd-8d5e-87897d6d0570" "$NEW_DS" "태스크 DS"

echo ""
echo "--- Daily Scrum Log DB ---"
read -p "DB ID (기존: 26b3aae9a89483b79de3810dce151383): " NEW_ID
[ -n "$NEW_ID" ] && replace_all "26b3aae9a89483b79de3810dce151383" "$NEW_ID" "DailyScrum DB"
read -p "data_source_id (기존: 9e03aae9-a894-8377-bbaf-0717f5d7f2ef): " NEW_DS
[ -n "$NEW_DS" ] && replace_all "9e03aae9-a894-8377-bbaf-0717f5d7f2ef" "$NEW_DS" "DailyScrum DS"

echo ""
echo "--- PM Action Hub DB ---"
read -p "DB ID (기존: ff43aae9a89482ea8c57815a65ac9f5b): " NEW_ID
[ -n "$NEW_ID" ] && replace_all "ff43aae9a89482ea8c57815a65ac9f5b" "$NEW_ID" "ActionHub DB"
read -p "data_source_id (기존: a183aae9-a894-8379-8708-87cf507ec8e8): " NEW_DS
[ -n "$NEW_DS" ] && replace_all "a183aae9-a894-8379-8708-87cf507ec8e8" "$NEW_DS" "ActionHub DS"

# ============================================
# Phase 3: Nexus OS
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Phase 3: Nexus OS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Nexus 관리자에게 API key 발급받고,"
echo "workforces_list로 본인 workforce ID를 확인하세요."
echo ""

read -p "Nexus Workforce ID (기존: q57f6mhcy8zg5fgzqq30t36azd83cvsr): " NEW_WID
[ -n "$NEW_WID" ] && replace_all "q57f6mhcy8zg5fgzqq30t36azd83cvsr" "$NEW_WID" "Workforce ID"

read -p "Nexus API Token (기존: nxs_3d3173c4a8a2b14510a9ae73c6260adc): " NEW_TOKEN
[ -n "$NEW_TOKEN" ] && replace_all "nxs_3d3173c4a8a2b14510a9ae73c6260adc" "$NEW_TOKEN" "Nexus Token"

# ============================================
# Phase 4: Nexus Alias 초기화
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Phase 4: Nexus Alias"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo ".claude/nexus-alias.md를 본인 프로젝트로 교체해야 합니다."
echo "지금은 건너뛰고 나중에 수동 편집해도 됩니다."
echo ""
read -p "nexus-alias.md를 빈 템플릿으로 초기화? (y/N): " RESET_ALIAS

if [ "$RESET_ALIAS" = "y" ] || [ "$RESET_ALIAS" = "Y" ]; then
  cat > .claude/nexus-alias.md << 'ALIAS_EOF'
# Nexus Project Alias Registry
# 사용자 약칭 → Nexus projectName (tasks_list 응답의 projectName 필드)
# 한 약칭 = 하나의 projectName (1:1 매핑)
#
# 확인 방법:
# 1. /nexus-daily 인자 없이 실행 → 활성 태스크 목록 출력
# 2. 각 태스크의 projectName 확인
# 3. 약칭 | projectName 형태로 등록
#
# 예시:
# DSA           | DSA-DSA-Apr
# Koboom        | Koboom-Koboom-2

# --- 여기에 본인 프로젝트 등록 ---

ALIAS_EOF
  echo "  ✅ nexus-alias.md 빈 템플릿으로 초기화 완료"
else
  echo "  ⏭️  건너뜀 — 나중에 .claude/nexus-alias.md 수동 편집하세요"
fi

# ============================================
# Phase 5: 검증
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Phase 5: 검증"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 기존 Yoona 값이 남아있는지 체크
echo "기존 값 잔존 체크..."
REMAINING=0

for old_id in \
  "339823375b0c8001ab28d33783105b8b" \
  "q57f6mhcy8zg5fgzqq30t36azd83cvsr" \
  "nxs_3d3173c4a8a2b14510a9ae73c6260adc"; do
  found=$(grep -rl "$old_id" CLAUDE.md .claude/commands/ 2>/dev/null | wc -l | tr -d ' ')
  if [ "$found" != "0" ]; then
    echo "  ⚠️  기존 값 남아있음: $old_id (${found}개 파일)"
    REMAINING=$((REMAINING + found))
  fi
done

if [ "$REMAINING" = "0" ]; then
  echo "  ✅ 기존 PM 전용 값 모두 교체 완료"
else
  echo ""
  echo "  일부 값이 교체되지 않았습니다. 수동 확인이 필요합니다."
fi

# ============================================
# 완료
# ============================================
echo ""
echo "============================================"
echo "  마이그레이션 완료!"
echo "============================================"
echo ""
echo "남은 작업:"
echo "  1. MCP 서버 등록:"
echo "     claude mcp add notion-cigro --transport http \"https://mcp.notion.com/mcp\" --header \"Authorization: Bearer {토큰}\""
echo "     claude mcp add nexus-os --transport http \"https://nexus-os-iota.vercel.app/api/mcp\" --header \"Authorization: Bearer {토큰}\""
echo ""
echo "  2. .env.teams 수정 (Teams 사용 시)"
echo ""
echo "  3. .claude/nexus-alias.md 본인 프로젝트 등록"
echo ""
echo "  4. 검증:"
echo "     /today-brief"
echo "     /todo [TestProject] 테스트"
echo "     /nexus-daily"
echo ""
