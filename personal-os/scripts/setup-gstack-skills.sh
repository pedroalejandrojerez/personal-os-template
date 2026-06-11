#!/usr/bin/env bash

set -euo pipefail

source_root="${GSTACK_SKILLS_SOURCE:-$HOME/.claude/skills/gstack/.agents/skills}"
target_root=".agents/skills"

if [ ! -d "$source_root" ]; then
  echo "Missing G-Stack skills source: $source_root" >&2
  exit 1
fi

mkdir -p "$target_root"

count=0
for source in "$source_root"/gstack "$source_root"/gstack-*; do
  if [ ! -d "$source" ] || [ ! -f "$source/SKILL.md" ]; then
    continue
  fi

  name="$(basename "$source")"
  target="$target_root/$name"

  rm -rf "$target"
  ln -s "$source" "$target"
  count=$((count + 1))
done

if [ "$count" -eq 0 ]; then
  echo "No G-Stack skills found in: $source_root" >&2
  exit 1
fi

echo "Synced $count G-Stack skills from $source_root."
