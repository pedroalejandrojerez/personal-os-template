#!/usr/bin/env bash
# Hard-block production deploy and production DB mutation commands unless
# the exact approval phrase is present in the command text.

set -uo pipefail

INPUT=$(cat 2>/dev/null || true)

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""' 2>/dev/null)

deny() {
  local reason="$1"
  jq -n --arg reason "$reason" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }
  }'
  exit 0
}

warn() {
  local message="$1"
  printf '%s\n' "$message"
}

PROD_DEPLOY_RE='(^|[[:space:]])(vercel([[:space:]]+deploy)?([[:space:]].*)?(--prod|--target[[:space:]]+production|--target=production)|netlify[[:space:]]+deploy([[:space:]].*)?--prod|fly[[:space:]]+deploy|gstack-land-and-deploy|/gstack-land-and-deploy)([[:space:]]|$)'
PROD_DB_RE='(supabase[[:space:]]+db[[:space:]]+push|supabase[[:space:]]+migration[[:space:]]+up|psql[[:space:]].*(-h|--host)[[:space:]]|prisma[[:space:]]+migrate[[:space:]]+deploy)'
RISK_RE='(billing|payment|stripe|supabase/migrations|migrations/|auth|intake|onboarding|settings|voice|audio|vercel\.json|deploy|production)'

if [ "$TOOL_NAME" = "Bash" ] || [ -n "$CMD" ]; then
  if echo "$CMD" | grep -Eiq "$PROD_DEPLOY_RE"; then
    if ! echo "$CMD" | grep -Fq "approved to deploy production"; then
      deny "Production deploy command blocked. The user must first use the exact phrase: approved to deploy production. Then restate branch, files changed, tests run, deploy target, rollback plan, and exact next action."
    fi
  fi

  if echo "$CMD" | grep -Eiq "$PROD_DB_RE"; then
    if ! echo "$CMD" | grep -Fq "approved for production DB mutation"; then
      deny "Production DB mutation command blocked. The user must first use the exact phrase: approved for production DB mutation. Then restate target database, command, expected rows/schema change, verification, and rollback plan."
    fi
  fi

  if echo "$CMD" | grep -Eiq "$RISK_RE"; then
    warn "Workflow guard notice: risky command surface detected. Confirm scope, stop condition, verification, and deploy permission before proceeding."
  fi
fi

if [ -n "$FILE_PATH" ] && echo "$FILE_PATH" | grep -Eiq "$RISK_RE"; then
  warn "Workflow guard notice: risky file path detected: $FILE_PATH. Name files in scope, files out of scope, success symptom, stop symptom, and whether deploy is allowed."
fi

exit 0
