#!/usr/bin/env bash
# Optional Stop hook for background QA.
#
# It is silent unless AUTO_QA_COMMAND is set. Example:
#   export AUTO_QA_COMMAND='claude --print "/qa http://localhost:3000"'

set -uo pipefail

cat >/dev/null 2>&1 || true
[ "${SKIP_QA:-}" = "true" ] && exit 0
[ -n "${AUTO_QA_COMMAND:-}" ] || exit 0

REPO_ROOT="${CLAUDE_PROJECT_DIR:-}"
if [ -z "$REPO_ROOT" ] || { [ ! -d "$REPO_ROOT/.git" ] && [ ! -f "$REPO_ROOT/.git" ]; }; then
  REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || true)
fi
[ -n "$REPO_ROOT" ] || exit 0
cd "$REPO_ROOT" 2>/dev/null || exit 0

CHANGED=$(git status --porcelain 2>/dev/null | awk '{line = substr($0, 4); if (index(line, " -> ") > 0) sub(/^.* -> /, "", line); print line}')
USER_FACING=$(echo "$CHANGED" | grep -E '(^|/)(app|components|src/app|src/components)/.*\.(tsx|jsx|css)$' || true)
[ -n "$USER_FACING" ] || exit 0

mkdir -p .gstack
LOCK_FILE=".gstack/qa-running.lock"
RESULT_FILE=".gstack/last-qa-result.md"

if [ -f "$LOCK_FILE" ]; then
  EXISTING_PID=$(jq -r '.pid // empty' "$LOCK_FILE" 2>/dev/null || true)
  if [ -n "$EXISTING_PID" ] && kill -0 "$EXISTING_PID" 2>/dev/null; then
    exit 0
  fi
  rm -f "$LOCK_FILE"
fi

STARTED_AT=$(date -u +%Y-%m-%dT%H:%M:%SZ)
nohup bash -c "
  printf '{\"pid\": %s, \"started\": \"%s\", \"result_file\": \"%s\"}\n' \"\$\$\" \"$STARTED_AT\" \"$RESULT_FILE\" > \"$LOCK_FILE\"
  $AUTO_QA_COMMAND > \"$RESULT_FILE\" 2>&1
  rm -f \"$LOCK_FILE\"
" </dev/null >/dev/null 2>&1 &
disown

cat <<EOF
Auto-QA started in background.

Command:
  $AUTO_QA_COMMAND

Files:
  - Lock: .gstack/qa-running.lock
  - Result: .gstack/last-qa-result.md
EOF
