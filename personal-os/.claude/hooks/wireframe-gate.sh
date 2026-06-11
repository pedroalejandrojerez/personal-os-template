#!/usr/bin/env bash
# Source-of-truth build gate for user-facing TSX edits.
#
# Blocks user-facing .tsx edits unless .gstack/build-lock.md exists, contains
# "Confirmed by user: YES", and was modified in the last 24 hours.
#
# Bypass: WIREFRAME_GATE_BYPASS=true or CLAUDE_REVIEWED=true.

set -uo pipefail

INPUT=$(cat 2>/dev/null || true)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""' 2>/dev/null)

[ -n "$FILE_PATH" ] || exit 0

case "$FILE_PATH" in
  *.tsx) ;;
  *) exit 0 ;;
esac

if echo "$FILE_PATH" | grep -q '/api/'; then exit 0; fi
if echo "$FILE_PATH" | grep -qE '\.(test|spec|stories)\.tsx$'; then exit 0; fi
if echo "$FILE_PATH" | grep -qE '\.d\.ts$'; then exit 0; fi

if ! echo "$FILE_PATH" | grep -qE '(^|/)(app|components|src/app|src/components)/'; then
  exit 0
fi

if [ "${CLAUDE_REVIEWED:-}" = "true" ] || [ "${WIREFRAME_GATE_BYPASS:-}" = "true" ]; then
  exit 0
fi

LOCK_PATH=""
for candidate in \
  "${CLAUDE_PROJECT_DIR:-}/.gstack/build-lock.md" \
  "$(pwd)/.gstack/build-lock.md"; do
  [ -n "$candidate" ] && [ "$candidate" != "/.gstack/build-lock.md" ] || continue
  if [ -f "$candidate" ]; then
    LOCK_PATH="$candidate"
    break
  fi
done

EXPECTED_LOCK="${CLAUDE_PROJECT_DIR:-$(pwd)}/.gstack/build-lock.md"
LOCK_VALID=false
LOCK_FAILURE_REASON=""

if [ -z "$LOCK_PATH" ]; then
  LOCK_FAILURE_REASON="No build-lock.md found"
elif ! grep -q 'Confirmed by user: YES' "$LOCK_PATH" 2>/dev/null; then
  LOCK_FAILURE_REASON="Lock is missing the literal line 'Confirmed by user: YES'"
elif [ -z "$(find "$LOCK_PATH" -mtime -1 2>/dev/null)" ]; then
  LOCK_FAILURE_REASON="Lock is older than 24 hours"
else
  LOCK_VALID=true
fi

if [ "$LOCK_VALID" = "true" ]; then
  exit 0
fi

jq -n \
  --arg file "$FILE_PATH" \
  --arg expected "$EXPECTED_LOCK" \
  --arg why "$LOCK_FAILURE_REASON" \
  '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: (
        "Source-of-truth build gate blocked this edit.\n\n" +
        "Target file: " + $file + "\n" +
        "Lock check failed: " + $why + "\n\n" +
        "Expected lock path:\n  " + $expected + "\n\n" +
        "Required lock format:\n" +
        "  # Build Lock - [feature name]\n" +
        "  Date: YYYY-MM-DD\n" +
        "  Surface: [settings | onboarding | dashboard | ...]\n" +
        "  Wireframe source: [file path, preview URL, screenshot, or spec]\n" +
        "  Confirmed by user: YES, YYYY-MM-DD HH:MM\n\n" +
        "Ask the user to confirm the source of truth, write the lock, then retry. For tiny non-visual edits, set WIREFRAME_GATE_BYPASS=true."
      )
    }
  }'
