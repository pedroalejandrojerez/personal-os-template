---
name: build-prd
description: Turn an approved plan and grill-me decisions into a local Build PRD at .context/builds/{feature-slug}/prd.md. Use after planning reviews and grill-me, before slicing work for Conductor agents.
---

# Build PRD Skill

## Purpose

Turn an approved plan plus `/grill-me` decisions into a build-ready PRD.

Use this after:

1. `/gstack-office-hours`
2. the separate plan reviews the user chose for the feature
3. `/grill-me`

Do not write application code.

## Inputs

Read what exists. Do not require every item.

- Office-hours design doc from `~/.gstack/projects/{slug}/`
- Plan review notes from CEO, design, eng, and DX reviews
- Eng test plan artifact
- `/grill-me` decision summary
- `.gstack/build-lock.md`, if this touches UI
- Existing code files named by the plan

## Output Path

Write:

`.context/builds/{feature-slug}/prd.md`

Create the directory if needed.

## Required PRD Shape

```markdown
# Build PRD: {feature}

Date:
Status: Draft

## Source Artifacts
- Office-hours design doc:
- CEO review:
- Design review:
- Eng review:
- DX review:
- Test plan:
- Wireframe lock:

## Problem

## Solution

## User Stories

## Locked Decisions

## Out of Scope

## Architecture Boundaries
- Deep modules:
- Public interfaces humans own:
- Internals agents can implement:
- Shallow module clusters to avoid:

## Data and Migration Notes

## Test Contract
- Unit:
- Integration:
- E2E/browser:
- Manual QA:

## First Slice Recommendation

## Open Risks
```

## Rules

- Never publish this to an issue tracker by default. The Build PRD writes locally to
  `.context/builds/{feature-slug}/prd.md`.
- Keep the PRD implementation-facing. This is not a pitch doc.
- Preserve the user's locked decisions. Do not reopen strategy unless there is a real conflict.
- Explore the codebase for module and test facts.
- Ask the user only when a missing decision blocks a safe PRD. If asking, ask one
  question at a time and give the recommended answer.
- Prefer deep modules with small public interfaces. Flag shallow module clusters
  where many tiny files depend on each other and tests would need heavy mocking.
- Include user stories, implementation decisions, testing decisions, and clear
  out-of-scope calls.
- Avoid stale detail. Use file paths only for source artifacts or known likely
  touch points, not as a promise that every path must change.
- Mark unknowns plainly.
- End by telling the user the exact PRD path and the next command: `/prd-to-slices`.
