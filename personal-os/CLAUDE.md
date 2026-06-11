# {YOUR_NAME}'s Operating System

You are working inside {YOUR_NAME}'s personal workspace. This is a private operating system for capturing learnings, decisions, skills, and work in progress.

For non-Claude agents, keep `AGENTS.md` in sync with this file.

## Who I Am

- **Name**: {YOUR_NAME}
- **Role**: {YOUR_ROLE}
- **Focus areas**: {YOUR_FOCUS_AREAS}
- **Time zone**: {YOUR_TIMEZONE}
- **Word of the year**: {OPTIONAL_WORD}

## What This Repo Is

This repo is a personal operating system. It is not necessarily a software project. Do not assume build, lint, or test commands exist.

## Key Directories

- **My workspace**: `~/{workspace-name}/`
- **Primary project**: `{primary-project}/`
- **Shared team brain**: `~/{team-repo}/` (optional, remove if solo)

## Session Start

1. Read `handoff.md`, under 20 lines.
2. Check `active-backlog.md`, find the item closest to shipped.
3. Read `memory/MEMORY.md`, the master index.
4. Present: "**[X] is closest to done.** It needs [specific task]. Ship it, or work on something else?"

Default action is always: close an open loop.

## The Ship Test

Before starting anything new, ask:

> "Is there something already built that could ship instead?"

If yes, ship it first. New work starts only when nothing is at 80% or more.

If the user explicitly wants to start something new, that is fine. Name what is being deprioritized.

## Conductor Workspace States

Every Conductor workspace must have one visible state:

| State | Meaning | Exit Rule |
|-------|---------|-----------|
| `planning` | The agent is shaping the work. No production code yet. | Plan, scope, risks, and owner are clear. |
| `in progress` | The agent is building. | Diff is ready for review. |
| `review` | The user or another reviewer is checking the diff. | Comments are fixed and checks pass. |
| `merged` | The PR landed on `main`. | The real app, endpoint, or artifact was verified. |
| `done` | The loop is closed. | Handoff and backlog are updated, then archive the workspace. |

At the start of any Conductor status update, report:

```text
State: [planning | in progress | review | merged | done]
Next action: [one concrete next step]
Owner: [user | agent | reviewer]
Risk: [low | medium | high]
```

Use `.context/active-workspaces.md` only when there are two or more active workspaces, or when one large build has multiple slices.

## Workflow Approval Rules

Short approvals are narrow. Treat "yes", "ok", "sure", "go", "push", or similar replies as approval for the last explicitly named action only.

- "push" means push the current approved commit only. It does not mean merge, deploy, edit unrelated files, or update a parent repo.
- "ship" requires the agent to restate branch, files changed, tests run, deploy target, rollback plan, and exact next action before doing anything.
- If the next action changes repo state beyond the named action, ask again.
- Any production DB mutation requires this exact phrase from the user: `approved for production DB mutation`.
- Any production deploy requires this exact phrase from the user: `approved to deploy production`.

Before risky fixes, name files in scope, files out of scope, the symptom that proves success, the symptom that means stop and report, and whether deploy is allowed.

Risky means billing, payments, database migrations, auth, intake/state machines, settings, voice/audio, safety, or production deploy paths. Edit this list for your product.

## Agent Workflow Router

Use existing workflow assets before creating anything new.

| Moment | Use | Required action |
|--------|-----|-----------------|
| Before non-trivial edits | `docs/agent-task-templates.md` | Fill one lane with task, outcome, source of truth, scope, checks, stop condition, and approval needed. |
| UI or product work | `docs/qa/ui-source-of-truth.md` plus the relevant `docs/qa/*` checklist | Name the source of truth before editing. Localhost is only a viewer. |
| Risky area | `docs/agent-task-templates.md` and `scripts/detect-change-risk` | Name in-scope files, out-of-scope files, success symptom, stop symptom, and deploy permission before patching. |
| After edits | `scripts/detect-change-risk` | Run it and follow every checklist it prints. |
| Before commit, push, PR, merge, or deploy | `scripts/verify-before-ship` | Run the pre-ship report, check dirty files, and keep approvals narrow. |
| Before ending a session | Session Close section | Update `handoff.md`, update `active-backlog.md`, and log reusable memory only when useful. |

## Startup Engineering Mode

Keep things simple and ship useful work fast. Handle the most important cases first.

If the product handles sensitive data, never skip safety, privacy, auth, payment, or crisis edge cases.

### Small Code Doctrine

Before coding:

- Name the smallest path.
- Estimate files touched.
- Reuse existing modules first.
- Avoid new abstractions unless they remove real duplication.

During coding:

- Touch only needed files.
- Do not add fallback systems for unlikely cases.
- Stop and re-plan if the patch grows past the plan.

Before declaring done:

- Run `git diff --stat`.
- Explain why the patch is smaller than the obvious version.
- Remove code your change made unused.

Pause and explain before continuing if a change adds more than 200 lines or touches more than 5 files, unless the user already approved that scope.

## Review Agents With Comments

When reviewing agent work, do not rewrite the code first. Leave a focused review comment and let the agent fix it.

Use this format:

```md
Review comment:
File: [path]
Issue: [what looks wrong]
Request: [explain or fix]
Constraint: Keep the patch small and reuse existing code where possible.
```

## Planning To Build Bridge

Use this path for larger builds:

1. Pressure-test the idea.
2. Review strategy, design, engineering, and developer experience as needed.
3. Run `/grill-me` to force tactical decisions, one question at a time.
4. Run `/build-prd` to write `.context/builds/{feature}/prd.md`.
5. Run `/prd-to-slices` to write `.context/builds/{feature}/slices.md`.
6. Run the first slice human-in-the-loop.
7. Open one Conductor workspace per independent AFK slice only after the first slice proves the format.
8. Review, QA, ship, and update the board with `scripts/slice-board.py`.

## Tool Routing

Customize this table with the tools you use.

| Signal | Tool or Skill | What it does |
|--------|---------------|--------------|
| Pressure-test a new feature idea | `{planning skill}` | Checks whether the work is worth doing. |
| Tactical implementation decisions | `grill-me` | Asks one question at a time before the PRD. |
| Build-ready PRD | `build-prd` | Writes `.context/builds/{feature}/prd.md`. |
| Vertical slice board | `prd-to-slices` | Writes `.context/builds/{feature}/slices.md`. |
| Code review before shipping | `{review skill}` | Reviews the diff for production bugs. |
| Browser QA | `{qa skill}` | Tests the real app or preview. |
| Ship workflow | `{ship skill}` | Prepares PR, checks, and release steps. |

## Memory Architecture

```text
memory/MEMORY.md (master index, under 50 lines)
  ├── skills/            <- personal skills vault
  ├── decisions/         <- decisions with reasoning
  ├── {project}/index.md <- project hub
  └── journal/           <- session observations
```

Rules:

- `MEMORY.md` stays under 50 lines.
- Hubs stay under 60 lines. Use spokes for detail.
- Read `memory/MEMORY.md` at session start for full context.

## Communication Preferences

Customize these.

- Use first names when known. If unavailable, drop the greeting.
- Use short sentences and common words in chat.
- Lead with a recommendation. Say which option and why.
- Do it yourself first. Ask only for credentials, accounts, or real decisions.
- No em dashes in user-facing copy.
- No dangling single-word lines in user-facing copy.

## Verify Before Declaring Done

Do not say "done" based on code looking correct.

- Database writes: query and check rows.
- API calls: check the response.
- Deploys: hit the endpoint and verify.
- Visual/layout work: screenshot and verify the rendered surface.
- Source-of-truth claims: check the real source before comparing files.

If you cannot verify, say so.

## Session Close

1. Update `handoff.md`, under 20 lines.
2. Update `active-backlog.md`, mark completed and add new items.
3. If something reusable was learned, log it to `memory/`.

Every completed implementation ends with:

- Files changed
- Commands run
- Test results
- Screenshots or preview links if UI changed
- Production touched: yes/no
- Deploy touched: yes/no
- Unrelated dirty files: yes/no
- Known gaps
- Outcome achieved: yes/no
- Exact next safe action
- Workflow assets used: [task lane], [QA checklist or N/A], [ship verification or skipped reason]
