# Agent Runtime Files

Conductor and other local agents can use this directory for generated or synced skill files.

The template gitignores `.agents/` because synced skills are machine-local. Run:

```bash
./scripts/setup-bridge-skills.sh
./scripts/setup-gstack-skills.sh
```

The bridge skills come from `memory/skills/*/skill.md`.
