#!/usr/bin/env bash
# /qa-plan v1 자동 검증 하네스
# 외부 write 없음 (tests/qa-plan/outputs/ 로컬 파일만 검사)
# Usage: bash scripts/test-qa-plan.sh

set -o pipefail

cd "$(dirname "$0")/.."

CASES=(case01 case02 case03 case04 case05 case06 case07 case09 case10 case11 case08)
TESTS_DIR="tests/qa-plan"
OUTPUTS_DIR="$TESTS_DIR/outputs"
CHECKS_DIR="$TESTS_DIR/checks"

PASS=0
FAIL=0
declare -a FAIL_DETAILS=()

# Find output file matching case ID prefix (case07 expected to return empty)
find_output_for_case() {
  local case_id="$1"
  ls "$OUTPUTS_DIR"/${case_id}-*.md 2>/dev/null | head -1
}

# Section extraction: matches "## <name>" or "### <name>", reads until next "##"/"###" header.
# section_name is literal text (no regex escapes); script tries h2 first then h3.
extract_section() {
  local file="$1"
  local section_name="$2"
  awk -v sec_h2="## $section_name" -v sec_h3="### $section_name" '
    $0 == sec_h2 { in_section=1; next }
    $0 == sec_h3 { in_section=1; next }
    in_section && /^(##|###)/ { exit }
    in_section { print }
  ' "$file"
}

# grep with ERE only (single-line). multiline patterns are handled via must_match_in_section.
# Use -e to avoid pattern being parsed as option flag.
grep_pattern() {
  local pattern="$1"
  local content="$2"
  printf '%s' "$content" | grep -qE -e "$pattern"
}

run_global_check() {
  local check_type="$1"
  local pattern="$2"
  local description="$3"
  local file="$4"
  local case_id="$5"

  local content
  content="$(cat "$file")"

  case "$check_type" in
    must_match)
      if grep_pattern "$pattern" "$content"; then
        return 0
      fi
      FAIL_DETAILS+=("$case_id [global]: must_match FAIL — $description (pattern: $pattern)")
      return 1
      ;;
    must_not_match)
      if grep_pattern "$pattern" "$content"; then
        FAIL_DETAILS+=("$case_id [global]: must_not_match FAIL — $description (matched: $pattern)")
        return 1
      fi
      return 0
      ;;
    *)
      FAIL_DETAILS+=("$case_id [global]: unknown check type '$check_type'")
      return 1
      ;;
  esac
}

run_case_check() {
  local f1="$1"  # check_type
  local f2="$2"  # pattern (or section_name for must_match_in_section)
  local f3="$3"  # description (or section_pattern for must_match_in_section)
  local f4="${4:-}"  # description (only for must_match_in_section)
  local file="$5"
  local case_id="$6"

  local content
  if [ -n "$file" ] && [ "$file" != "/dev/null" ] && [ -f "$file" ]; then
    content="$(cat "$file")"
  else
    content=""
  fi

  case "$f1" in
    must_match)
      if grep_pattern "$f2" "$content"; then
        return 0
      fi
      FAIL_DETAILS+=("$case_id: must_match FAIL — $f3 (pattern: $f2)")
      return 1
      ;;
    must_not_match)
      if grep_pattern "$f2" "$content"; then
        FAIL_DETAILS+=("$case_id: must_not_match FAIL — $f3 (matched: $f2)")
        return 1
      fi
      return 0
      ;;
    must_match_in_section)
      local section_name="$f2"
      local section_pattern="$f3"
      local desc="$f4"
      local section_content
      section_content="$(extract_section "$file" "$section_name")"
      if grep_pattern "$section_pattern" "$section_content"; then
        return 0
      fi
      FAIL_DETAILS+=("$case_id: must_match_in_section FAIL — $desc (section: $section_name, pattern: $section_pattern)")
      return 1
      ;;
    file_must_not_exist)
      local matches
      matches=$(ls $f2 2>/dev/null | wc -l | tr -d ' ')
      if [ "$matches" -eq 0 ]; then
        return 0
      fi
      FAIL_DETAILS+=("$case_id: file_must_not_exist FAIL — $f3 (found: $matches files matching $f2)")
      return 1
      ;;
    must_match_filepath)
      if [ -f "$f2" ]; then
        return 0
      fi
      FAIL_DETAILS+=("$case_id: must_match_filepath FAIL — $f3 (missing: $f2)")
      return 1
      ;;
    note)
      return 0
      ;;
    *)
      FAIL_DETAILS+=("$case_id: unknown check type '$f1'")
      return 1
      ;;
  esac
}

run_checks_file() {
  local checks_file="$1"
  local file="$2"
  local case_id="$3"
  local mode="$4"  # "global" or "case"
  local local_pass=0
  local local_fail=0

  while IFS=$'\t' read -r f1 f2 f3 f4 || [ -n "$f1" ]; do
    [ -z "$f1" ] && continue
    [[ "$f1" =~ ^# ]] && continue

    if [ "$mode" = "global" ]; then
      if run_global_check "$f1" "$f2" "$f3" "$file" "$case_id"; then
        local_pass=$((local_pass+1))
      else
        local_fail=$((local_fail+1))
      fi
    else
      if run_case_check "$f1" "$f2" "$f3" "$f4" "$file" "$case_id"; then
        local_pass=$((local_pass+1))
      else
        local_fail=$((local_fail+1))
      fi
    fi
  done < "$checks_file"

  printf '%d %d' "$local_pass" "$local_fail"
}

echo "=========================================="
echo "/qa-plan v1 자동 검증 하네스"
echo "외부 write 없음. local fixture/output 검사만."
echo "=========================================="
echo ""

printf "%-8s %-8s %-8s %-8s %s\n" "CASE" "STATUS" "PASS" "FAIL" "OUTPUT"
printf -- "----------------------------------------------------------------------\n"

for case_id in "${CASES[@]}"; do
  output_file=$(find_output_for_case "$case_id")

  # case08: expects no output file (client missing → no-save 3순위 fallback)
  if [ "$case_id" = "case08" ]; then
    if [ -n "$output_file" ]; then
      printf "%-8s %-8s %-8s %-8s %s\n" "$case_id" "FAIL" "0" "1" "(unexpected file: $output_file)"
      FAIL=$((FAIL+1))
      FAIL_DETAILS+=("$case_id: client 누락 시 outputs/에 파일 생성되어 있음 — 3순위 fallback 위반")
      continue
    fi
    read case_specific_pass case_specific_fail < <(run_checks_file "$CHECKS_DIR/${case_id}.txt" "" "$case_id" "case")
    if [ "$case_specific_fail" -eq 0 ]; then
      printf "%-8s %-8s %-8s %-8s %s\n" "$case_id" "PASS" "$case_specific_pass" "0" "(no output file as expected)"
      PASS=$((PASS+1))
    else
      printf "%-8s %-8s %-8s %-8s %s\n" "$case_id" "FAIL" "$case_specific_pass" "$case_specific_fail" "(no output file as expected)"
      FAIL=$((FAIL+1))
    fi
    continue
  fi

  if [ -z "$output_file" ]; then
    printf "%-8s %-8s %-8s %-8s %s\n" "$case_id" "FAIL" "0" "1" "(missing output file)"
    FAIL=$((FAIL+1))
    FAIL_DETAILS+=("$case_id: outputs/ 디렉토리에 ${case_id}-*.md 없음")
    continue
  fi

  read global_pass global_fail < <(run_checks_file "$CHECKS_DIR/global.txt" "$output_file" "$case_id" "global")
  read specific_pass specific_fail < <(run_checks_file "$CHECKS_DIR/${case_id}.txt" "$output_file" "$case_id" "case")

  total_pass=$((global_pass + specific_pass))
  total_fail=$((global_fail + specific_fail))

  if [ "$total_fail" -eq 0 ]; then
    printf "%-8s %-8s %-8s %-8s %s\n" "$case_id" "PASS" "$total_pass" "0" "$(basename "$output_file")"
    PASS=$((PASS+1))
  else
    printf "%-8s %-8s %-8s %-8s %s\n" "$case_id" "FAIL" "$total_pass" "$total_fail" "$(basename "$output_file")"
    FAIL=$((FAIL+1))
  fi
done

echo ""
echo "=========================================="
echo "Summary: PASS=$PASS / FAIL=$FAIL (out of ${#CASES[@]} cases)"
echo "=========================================="

if [ "$FAIL" -gt 0 ]; then
  echo ""
  echo "Failure details:"
  for detail in "${FAIL_DETAILS[@]}"; do
    echo "  - $detail"
  done
  exit 1
fi

exit 0
