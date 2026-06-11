#!/usr/bin/env bash
# Blocks push or PR creation for code/config diffs unless a review was acknowledged.

set -uo pipefail

INPUT=$(cat 2>/dev/null || true)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null)

if ! echo "$CMD" | grep -qE '(git push|gh pr create)'; then
  exit 0
fi

if echo "$CMD" | grep -qE '(^|[^A-Z_])CLAUDE_REVIEWED=true'; then
  exit 0
fi
if [ "${CLAUDE_REVIEWED:-}" = "true" ]; then
  exit 0
fi

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [ -z "$REPO_ROOT" ] && [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then
  REPO_ROOT=$(git -C "$CLAUDE_PROJECT_DIR" rev-parse --show-toplevel 2>/dev/null || true)
fi
if [ -z "$REPO_ROOT" ]; then
  exit 0
fi

cd "$REPO_ROOT" 2>/dev/null || exit 0

CHANGED=$(git diff --name-only origin/main..HEAD 2>/dev/null)
if [ -z "$CHANGED" ]; then
  CHANGED=$(git diff --name-only main..HEAD 2>/dev/null)
fi
if [ -z "$CHANGED" ]; then
  exit 0
fi

TECH=$(echo "$CHANGED" | grep -E '(^|/)(src/|app/|components/|lib/|server/|api/|migrations/|supabase/migrations/|scripts/|\.github/workflows/|vercel\.json|netlify\.toml|fly\.toml|render\.ya?ml|package\.json|tsconfig|eslint\.config|next\.config)' || true)

if [ -z "$TECH" ]; then
  exit 0
fi

jq -n --arg paths "$TECH" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: ("Code or deploy-adjacent changes detected. Run review before pushing.\n\nChanged files:\n" + $paths + "\n\nAfter review and fixes, re-attempt with:\n  CLAUDE_REVIEWED=true git push\n\nOr set CLAUDE_REVIEWED=true in the shell before pushing.")
  }
}'
