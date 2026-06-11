# {YOUR_NAME}'s Memory — Master Index

## How This Works
- This file loads at every conversation start (~50 lines max, never truncated)
- Each project has its own hub folder with `index.md` + topic spokes
- Read the relevant hub's `index.md` when starting work on a project
- Save new context to the correct project hub, not here

## Active Projects

### {Project Name}
Hub: `memory/{project-slug}/index.md`
My role: {your role on this project}

<!-- Add more projects as needed. Keep each to 2-3 lines max. -->

## Skills (Personal)
- **G-Stack** — synced into `.agents/skills/` by `scripts/setup-gstack-skills.sh` when installed locally.
- **grill-me** — `memory/skills/grill-me/skill.md` — one-question-at-a-time tactical planning.
- **build-prd** — `memory/skills/build-prd/skill.md` — turns a plan into `.context/builds/{feature}/prd.md`.
- **prd-to-slices** — `memory/skills/prd-to-slices/skill.md` — turns a Build PRD into a Conductor slice board.
- Format for new skills: **{Skill Name}** — `memory/skills/{name}.md` — {one-line description}

## Decisions
- (log decisions with reasoning — link to `memory/decisions/YYYY-MM-DD-{slug}.md`)

## Session Continuity
- **Quick scan**: `handoff.md` — under 20 lines, top 3 next actions
- **Full backlog**: `active-backlog.md` — all open items by project

## Shared Team Brain
- **Team learnings**: `~/{team-repo}/learnings/` (read at session start)
- **Team skills**: `~/{team-repo}/skills-library/` (search before building)
- **Team processes**: `~/{team-repo}/operations/processes/`
