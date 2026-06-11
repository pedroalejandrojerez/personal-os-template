#!/usr/bin/env bash
# Run prettier/eslint after Claude saves a file. Best effort, never blocks.

set -uo pipefail

[ "${SKIP_FORMAT:-}" = "true" ] && exit 0

INPUT=$(cat 2>/dev/null || true)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""' 2>/dev/null)

[ -n "$FILE_PATH" ] && [ "$FILE_PATH" != "null" ] || exit 0

case "$FILE_PATH" in
  *.ts|*.tsx|*.js|*.jsx|*.json|*.css|*.md) ;;
  *) exit 0 ;;
esac

case "$FILE_PATH" in
  */node_modules/*|*/.next/*|*/dist/*|*/build/*|*/.git/*)
    exit 0
    ;;
esac

[ -f "$FILE_PATH" ] || exit 0

PROJECT_ROOT=""
DIR=$(dirname "$FILE_PATH")
while [ "$DIR" != "/" ] && [ -n "$DIR" ]; do
  if [ -f "$DIR/package.json" ]; then
    PROJECT_ROOT="$DIR"
    break
  fi
  DIR=$(dirname "$DIR")
done

[ -n "$PROJECT_ROOT" ] || exit 0

run_with_timeout() {
  local secs="$1"
  shift
  if command -v gtimeout >/dev/null 2>&1; then
    gtimeout "$secs" "$@"
  elif command -v timeout >/dev/null 2>&1; then
    timeout "$secs" "$@"
  else
    perl -e 'alarm shift; exec @ARGV' "$secs" "$@"
  fi
}

PRETTIER="$PROJECT_ROOT/node_modules/.bin/prettier"
if [ -x "$PRETTIER" ]; then
  run_with_timeout 10 "$PRETTIER" --write --log-level warn "$FILE_PATH" >/dev/null 2>&1 || true
fi

case "$FILE_PATH" in
  *.ts|*.tsx|*.js|*.jsx)
    ESLINT="$PROJECT_ROOT/node_modules/.bin/eslint"
    if [ -x "$ESLINT" ]; then
      run_with_timeout 10 "$ESLINT" --fix "$FILE_PATH" >/dev/null 2>&1 || true
    fi
    ;;
esac

exit 0
