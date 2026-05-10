#!/usr/bin/env bash
# /meeting-note offline regression harness (Wave 1-B)
# 외부 write 없음 — tests/meeting-note/outputs/ 에 PM이 손으로 curate한 synthetic snapshot 만 검사.
# Sources scripts/lib/harness-common.sh (Wave 0 shared library).
# Usage: bash scripts/test-meeting-note.sh

set -o pipefail

cd "$(dirname "$0")/.."

# shellcheck source=lib/harness-common.sh
source "$(dirname "$0")/lib/harness-common.sh"

CASES=(case01 case02 case03 case04 case05 case06 case07)
TESTS_DIR="tests/meeting-note"
OUTPUTS_DIR="$TESTS_DIR/outputs"
CHECKS_DIR="$TESTS_DIR/checks"

PASS=0
FAIL=0
declare -a FAIL_DETAILS=()

find_output_for_case() {
  local case_id="$1"
  ls "$OUTPUTS_DIR"/${case_id}-*.md 2>/dev/null | head -1
}

echo "=========================================="
echo "/meeting-note Wave 1-B 자동 검증 하네스"
echo "외부 write 없음. local fixture/output 검사만."
echo "=========================================="
echo ""

printf "%-8s %-8s %-8s %-8s %s\n" "CASE" "STATUS" "PASS" "FAIL" "OUTPUT"
printf -- "----------------------------------------------------------------------\n"

for case_id in "${CASES[@]}"; do
  output_file=$(find_output_for_case "$case_id")

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
