# shellcheck shell=bash
# scripts/lib/harness-common.sh — Wave 0 shared handlers for PM-workspace skill harnesses.
#
# This library defines section extraction, grep, and check handlers used by
# tests/<skill>/checks/<id>.txt assertion files (TAB-separated, ERE patterns).
#
# Sourcing example:
#   source "$(dirname "$0")/lib/harness-common.sh"
#
# Caller contract:
#   - Caller declares a global array `FAIL_DETAILS` (declare -a FAIL_DETAILS=()).
#   - All run_*_check functions append failure messages via FAIL_DETAILS+=("...")
#     and return 0 on PASS, 1 on FAIL.
#   - Caller passes file paths and case IDs as positional arguments.
#
# Wave 0 status: NEW. Existing test-change-brief.sh / test-to-spec.sh / test-qa-plan.sh
# keep their current inline copies — migration to this library is deferred to Wave 1+.
#
# Known limitation (inherited from existing harness convention):
#   `run_checks_file` is typically called from a subshell via `< <(run_checks_file ...)`,
#   so FAIL_DETAILS appended inside that subshell does not propagate to the caller.
#   The contract still requires FAIL_DETAILS+= for documentation; subshell scoping
#   is a known gap that future Wave can address by changing the call pattern.
#
# ERE notes:
#   - grep_pattern uses `grep -qE -e "<pattern>"`; `-e` prevents the pattern being
#     parsed as a flag if it starts with `-`.
#   - Patterns are single-line. Multi-line constraints must be expressed via
#     must_match_in_section / must_not_match_in_section.

# extract_section: print the body of a markdown section (## or ### with the given name).
# Stops at the next ## or ### header. Sub-headings inside the section terminate
# extraction — render sub-sections with bold (**Sub-heading:**) instead of ###.
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

# grep_pattern: ERE single-line match. Returns 0 if pattern is found, 1 otherwise.
grep_pattern() {
  local pattern="$1"
  local content="$2"
  printf '%s' "$content" | grep -qE -e "$pattern"
}

# run_global_check: assertions in tests/<skill>/checks/global.txt.
# Args: check_type pattern description file case_id
# Supports: must_match, must_not_match
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

# run_case_check: assertions in tests/<skill>/checks/<id>.txt.
# Args: f1 f2 f3 f4 file case_id
#   - f1 = check_type
#   - f2 = pattern (or section_name for *_in_section)
#   - f3 = description (or section_pattern for *_in_section)
#   - f4 = description (only for *_in_section variants; "" otherwise)
# Supports: must_match, must_not_match, must_match_in_section, must_not_match_in_section,
#           file_must_not_exist, must_match_filepath, note
run_case_check() {
  local f1="$1"
  local f2="$2"
  local f3="$3"
  local f4="${4:-}"
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
    must_not_match_in_section)
      local section_name="$f2"
      local section_pattern="$f3"
      local desc="$f4"
      local section_content
      section_content="$(extract_section "$file" "$section_name")"
      if grep_pattern "$section_pattern" "$section_content"; then
        FAIL_DETAILS+=("$case_id: must_not_match_in_section FAIL — $desc (section: $section_name, matched: $section_pattern)")
        return 1
      fi
      return 0
      ;;
    file_must_not_exist)
      local matches
      # shellcheck disable=SC2086
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

# run_checks_file: iterate over a TAB-separated check file.
# Args: checks_file file case_id mode
#   - mode: "global" (uses run_global_check) or "case" (uses run_case_check)
# Prints to stdout: "<pass_count> <fail_count>" (space-separated, no newline).
# Caller typically reads via:  read pass fail < <(run_checks_file ...)
run_checks_file() {
  local checks_file="$1"
  local file="$2"
  local case_id="$3"
  local mode="$4"
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
