#!/usr/bin/env bash
# Repo verification gate for personal-os workflow controls.

set -euo pipefail

failures=0

run_check() {
  local label="$1"
  shift

  echo "==> $label"
  if "$@"; then
    echo "ok: $label"
  else
    echo "fail: $label" >&2
    failures=$((failures + 1))
  fi
  echo
}

if [ -f .claude/settings.json ]; then
  if command -v jq >/dev/null 2>&1; then
    run_check "Claude settings JSON" jq empty .claude/settings.json
  else
    echo "skip: jq not installed, cannot validate .claude/settings.json"
  fi
fi

for file in .claude/hooks/*.sh scripts/*.sh scripts/detect-change-risk scripts/verify-before-ship; do
  [ -f "$file" ] || continue
  run_check "shell syntax: $file" bash -n "$file"
done

if [ -f scripts/slice-board.py ]; then
  run_check "python syntax: scripts/slice-board.py" python3 -m py_compile scripts/slice-board.py
fi

package_has_script() {
  local package_json="$1"
  local script_name="$2"

  node -e "const p=require('./$package_json'); process.exit(p.scripts && p.scripts['$script_name'] ? 0 : 1)" 2>/dev/null
}

run_package_script_if_available() {
  local package_dir="$1"
  local script_name="$2"
  local package_json="$package_dir/package.json"

  if ! command -v node >/dev/null 2>&1; then
    echo "skip: node not installed, cannot inspect $package_json"
    return 0
  fi

  if ! package_has_script "$package_json" "$script_name"; then
    echo "skip: $package_dir npm run $script_name, script not defined"
    return 0
  fi

  if [ ! -d "$package_dir/node_modules" ]; then
    echo "skip: $package_dir npm run $script_name, node_modules not installed"
    return 0
  fi

  run_check "$package_dir npm run $script_name" npm --prefix "$package_dir" run "$script_name"
}

for package_json in $(find . \( -path './.git' -o -path '*/node_modules' -o -path '*/.next' -o -path './.context' \) -prune -o -name package.json -print | sort); do
  package_dir=$(dirname "$package_json")
  run_package_script_if_available "$package_dir" typecheck
  run_package_script_if_available "$package_dir" lint
  run_package_script_if_available "$package_dir" test
done

if [ "$failures" -ne 0 ]; then
  echo "verify failed: $failures check(s) failed" >&2
  exit 1
fi

echo "verify passed"
