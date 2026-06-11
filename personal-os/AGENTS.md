# {YOUR_NAME}'s Operating System - Agent Instructions

This file is the source of truth for non-Claude agents such as Codex. Keep it aligned with `CLAUDE.md`.

## Session Start

1. Read `handoff.md`.
2. Check `active-backlog.md`.
3. Read `memory/MEMORY.md`.
4. Present: "**[X] is closest to done.** It needs [specific task]. Ship it, or work on something else?"

Default action is always: close an open loop.

## Conductor Status

At the start of any Conductor status update, report:

```text
State: [planning | in progress | review | merged | done]
Next action: [one concrete next step]
Owner: [user | agent | reviewer]
Risk: [low | medium | high]
```

Use `.context/active-workspaces.md` only for two or more active workspaces, or a large multi-slice build.

## Before Editing

For non-trivial edits, fill one lane from `docs/agent-task-templates.md`.

For UI or product edits, name the source of truth before editing. Allowed sources are production behavior, preview deploy, approved mockup, design-system HTML, spec file, screenshot, or user-visible copy. Localhost is a viewer, not the source of truth.

For risky areas, name files in scope, files out of scope, success symptom, stop symptom, and whether deploy is allowed.

Risky areas include billing, payments, database migrations, auth, state machines, settings, voice/audio, safety, and production deploy paths. Edit this list for your product.

## Approval Rules

Short approvals are narrow. Treat "yes", "ok", "sure", "go", "push", or similar replies as approval for the last explicitly named action only.

- "push" means push the current approved commit only.
- "ship" requires restating branch, files changed, tests run, deploy target, rollback plan, and exact next action.
- Production DB mutation requires: `approved for production DB mutation`.
- Production deploy requires: `approved to deploy production`.

## After Editing

Run:

```bash
scripts/detect-change-risk
git diff --stat
```

Before commit, push, PR, merge, or deploy, run:

```bash
scripts/verify-before-ship
```

## Small Code Doctrine

- Touch only needed files.
- Reuse existing modules first.
- Avoid new abstractions unless they remove real duplication.
- Stop and re-plan if the patch grows past the stated scope.
- Pause before continuing if a change adds more than 200 lines or touches more than 5 files, unless the user approved that scope.

## Review Comments

When reviewing another agent's work, do not rewrite first. Leave a focused comment:

```md
Review comment:
File: [path]
Issue: [what looks wrong]
Request: [explain or fix]
Constraint: Keep the patch small and reuse existing code where possible.
```

## Build Workflow

For larger builds:

1. `/grill-me`
2. `/build-prd`
3. `/prd-to-slices`
4. First slice human-in-the-loop
5. One Conductor workspace per independent AFK slice
6. Board updates through `scripts/slice-board.py`

## Session Close

1. Update `handoff.md`, under 20 lines.
2. Update `active-backlog.md`.
3. Log reusable memory only when useful.

Every completed implementation ends with the receipt listed in `CLAUDE.md`.
