#!/usr/bin/env bash
# Stop hook that reminds the agent to do a simplicity pass on meaningful code diffs.

set -uo pipefail

cat >/dev/null 2>&1 || true
[ "${SKIP_SIMPLIFY:-}" = "true" ] && exit 0

REPO_ROOT="${CLAUDE_PROJECT_DIR:-}"
if [ -z "$REPO_ROOT" ] || { [ ! -d "$REPO_ROOT/.git" ] && [ ! -f "$REPO_ROOT/.git" ]; }; then
  REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || true)
fi
[ -n "$REPO_ROOT" ] || exit 0
cd "$REPO_ROOT" 2>/dev/null || exit 0

DIFF_STATS=$(git diff HEAD --numstat 2>/dev/null || true)
[ -n "$DIFF_STATS" ] || exit 0

TOTAL_LINES=0
HAS_CODE_FILE=false

while IFS=$'\t' read -r ADDS DELS PATHNAME; do
  [ -n "${PATHNAME:-}" ] || continue
  [ "$ADDS" != "-" ] && [ "$DELS" != "-" ] || continue
  case "$PATHNAME" in
    *.ts|*.tsx|*.js|*.jsx|*.py|*.go|*.rb|*.rs) ;;
    *) continue ;;
  esac
  case "$PATHNAME" in
    *.test.*|*.spec.*|*.stories.*|*/node_modules/*|*/.next/*|*/dist/*|*/build/*)
      continue
      ;;
  esac
  HAS_CODE_FILE=true
  TOTAL_LINES=$((TOTAL_LINES + ADDS + DELS))
done <<< "$DIFF_STATS"

[ "$HAS_CODE_FILE" = true ] && [ "$TOTAL_LINES" -ge 10 ] || exit 0

REASON="Code changes detected (${TOTAL_LINES} changed lines). Before stopping, do a simplicity pass on the diff. Look for speculative features, abstractions used once, impossible-case error handling, orphaned imports, and files that can be smaller. Fix clear issues or list them for the user."

jq -cn --arg reason "$REASON" '{decision: "block", reason: $reason}'
