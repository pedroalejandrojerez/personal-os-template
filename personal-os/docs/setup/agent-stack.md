# Full Agent Stack Setup

This template assumes a split between planning and execution.

## Default Stack

| Layer | Tool | Model posture | Job |
|-------|------|---------------|-----|
| Planning | Claude | Most capable model available | Think, challenge, plan, review architecture, and protect product taste. |
| Execution | Cursor Composer or Codex | Strong coding model | Implement from the plan, keep patches small, run checks, and produce receipts. |
| Workflow | G-Stack | Skill package | Office hours, plan reviews, design review, QA, security review, ship, canary, and retro. |
| Parallel work | Conductor | Workspace manager | Run separate agents in separate workspaces with clear state. |

## Operating Rule

Claude owns the plan. Composer and Codex own execution.

Do not ask execution agents to rediscover the whole product. Give them the Build PRD, slice board, source-of-truth files, and acceptance criteria.

## Recommended Flow

1. Claude, using the most capable model available, pressure-tests the idea.
2. G-Stack reviews the plan:
   - `/gstack-office-hours`
   - `/gstack-plan-ceo-review`
   - `/gstack-plan-design-review`, when UI exists
   - `/gstack-plan-eng-review`
   - `/gstack-plan-devex-review`, when developer workflow changes
3. Claude runs `/grill-me` to lock tactical decisions.
4. Claude runs `/build-prd` to write `.context/builds/{feature}/prd.md`.
5. Claude runs `/prd-to-slices` to write `.context/builds/{feature}/slices.md`.
6. Run the first slice human-in-the-loop.
7. Composer or Codex executes approved slices.
8. Use `scripts/slice-board.py` to update board status.
9. Run `gstack-review`, `gstack-qa <url>`, and `scripts/verify-before-ship`.
10. Use `gstack-ship`, then `gstack-land-and-deploy` only with explicit approval.
11. Use `gstack-canary` after deploy and `gstack-retro` weekly.

## Included Skills

Bundled in this template:

- `ce`
- `grill-me`
- `build-prd`
- `prd-to-slices`
- `review-week`

Synced when G-Stack is installed locally:

- `gstack`
- `gstack-office-hours`
- `gstack-plan-ceo-review`
- `gstack-plan-design-review`
- `gstack-plan-eng-review`
- `gstack-plan-devex-review`
- `gstack-review`
- `gstack-qa`
- `gstack-design-review`
- `gstack-cso`
- `gstack-ship`
- `gstack-land-and-deploy`
- `gstack-canary`
- `gstack-retro`

Run:

```bash
./scripts/setup-bridge-skills.sh
./scripts/setup-gstack-skills.sh
```

If G-Stack is not installed, the bridge skills still work. Install or sync G-Stack later.

See `docs/setup/workflow-skills.md` for the intentionally small workflow skill list. Private marketing, company, finance, and customer-specific skills are not included in this public template.

## Conductor Setup

Conductor uses `.conductor/settings.toml` to run setup in each workspace:

```toml
[scripts]
setup = "./scripts/setup-bridge-skills.sh && (./scripts/setup-gstack-skills.sh || true)"
run_mode = "concurrent"
```

Each workspace should report:

```text
State: [planning | in progress | review | merged | done]
Next action: [one concrete next step]
Owner: [user | agent | reviewer]
Risk: [low | medium | high]
```

## Composer And Codex Execution Rules

- Read `AGENTS.md` first.
- Read the Build PRD and slice board when they exist.
- Claim or update the slice with `scripts/slice-board.py`.
- Keep changes small.
- Run `scripts/detect-change-risk` after edits.
- Run `scripts/verify-before-ship` before commit, push, PR, merge, or deploy.
- Do not deploy production without the exact phrase `approved to deploy production`.
- Do not mutate production data without the exact phrase `approved for production DB mutation`.
