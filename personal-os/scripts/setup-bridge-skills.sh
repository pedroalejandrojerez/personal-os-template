#!/usr/bin/env bash

set -euo pipefail

skills=(
  "grill-me"
  "build-prd"
  "prd-to-slices"
)

for skill in "${skills[@]}"; do
  source="memory/skills/$skill/skill.md"
  target=".agents/skills/$skill/SKILL.md"

  if [ ! -f "$source" ]; then
    echo "Missing bridge skill source: $source" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$target")"
  cp "$source" "$target"
done

rm -rf .agents/skills/to-prd .agents/skills/to-issues

echo "Workflow bridge skills installed from memory/skills."
