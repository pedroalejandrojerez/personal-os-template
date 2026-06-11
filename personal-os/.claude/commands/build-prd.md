# Build PRD

Use `.agents/skills/build-prd/SKILL.md` if present.
Fallback: `memory/skills/build-prd/skill.md`.

Turn the approved plan, review artifacts, and `/grill-me` decisions into a build-ready PRD.

Write it to `.context/builds/{feature-slug}/prd.md`.

Do not write application code. End with the PRD path and the next action: `/prd-to-slices`.

$ARGUMENTS
