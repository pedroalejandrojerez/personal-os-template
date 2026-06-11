---
name: prd-to-slices
description: Turn a local Build PRD into a Kanban-style vertical Slice Board at .context/builds/{feature-slug}/slices.md for Conductor workspaces. Use after build-prd, before AFK agent execution.
---

# PRD To Slices Skill

## Purpose

Turn a Build PRD into a Kanban-style vertical Slice Board for Conductor
workspaces.

A vertical slice is a thin end-to-end path through the real system. It should be
small enough for one agent to implement, but complete enough to verify.

Use this after `/build-prd`.

Do not write application code.

## Input

Read the Build PRD, usually:

`.context/builds/{feature-slug}/prd.md`

Also read the eng test plan and `.gstack/build-lock.md` if referenced.

## Output Path

Write:

`.context/builds/{feature-slug}/slices.md`

Also include the absolute board path in the file:

`Board Path: {absolute-path-to-slices.md}`

Also include the HTML board path:

`HTML Board Path: {absolute-path-to-slices.html}`

## Required Slice Board Shape

```markdown
# Slice Board: {feature}

Date:
Status: Draft
Parent PRD:
Board Path:
HTML Board Path:

## Slicing Principle

The first slice proves the narrowest real user flow end to end.

## Kanban Board

Move slice IDs across columns as work changes.

### Ready
- [ ] 001 - {title} (HITL)

### In Progress

### Blocked

### Review

### Done

## Slice Index
| ID | Slice | Blocks | Human or AFK | Workspace | Status | Verification |
|----|-------|--------|--------------|-----------|--------|--------------|
| 001 |       | none   | HITL         |           | Ready  |              |

## Slice Details

### 001 - {title}
- Type: HITL or AFK
- Blocked by:
- User stories:
- Files likely touched:
- Acceptance criteria:
  - [ ]
- Tests:
  - [ ]
- Manual QA:
  - [ ]
- Done means:
- Board updates:
  - Start: `./scripts/slice-board.py claim {feature-slug} 001 --board "{absolute-path-to-slices.md}"`
  - Blocked: `./scripts/slice-board.py block {feature-slug} 001 --board "{absolute-path-to-slices.md}" --note "{reason}"`
  - Review: `./scripts/slice-board.py review {feature-slug} 001 --board "{absolute-path-to-slices.md}" --note "{verification}"`
  - Done: `./scripts/slice-board.py done {feature-slug} 001 --board "{absolute-path-to-slices.md}" --note "{verification}"`
  - Regenerate HTML: `./scripts/slice-board.py html {feature-slug} --board "{absolute-path-to-slices.md}"`

## Parallelization Notes

## Human-Owned Gates
- Architecture changes:
- UI/taste changes:
- QA:
- Final review:
```

## Rules

- Never publish this to an issue tracker by default. The Slice Board writes locally to
  `.context/builds/{feature-slug}/slices.md`.
- First slice should usually be HITL so the user can watch the first agent run.
- Avoid horizontal slices like "database only" or "all UI only."
- Each AFK slice must have clear acceptance criteria and verification.
- Mark blockers by slice ID.
- If a slice is too large, split it.
- If a slice needs a new design lock, mark it HITL.
- Prefer thin tracer bullets. Each slice should touch the real flow end to end
  and be demoable or verifiable on its own.
- The Kanban Board is the live status surface. The Slice Index is the dependency
  and verification reference.
- The user should not maintain the board by hand.
- Agents must update the board by running `scripts/slice-board.py`.
- Agents must run `claim` before implementation starts.
- Agents must run `block` before asking for help on a blocker.
- Agents must run `review` before handing work to the user or a reviewer.
- Agents must run `done` only after tests and verification pass.
- `scripts/slice-board.py` regenerates `slices.html` after every status update.
- After writing the initial `slices.md`, run `scripts/slice-board.py html` once so
  the user has the visual board immediately.
- Ask the user to review the breakdown before opening many Conductor workspaces.
- End by naming which slice should run first and whether it is safe to parallelize.
