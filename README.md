# Personal OS for Claude Code, Codex, Cursor, and Conductor

A system for making every AI session smarter than the last. Fork this, fill in the blanks, and stop solving the same problems twice.

## What This Is

This is a two-layer operating system that wraps around Claude Code, Codex, Cursor Composer, and Conductor. It gives your AI:

- **Persistent memory** across sessions through a hub and spoke architecture
- **Session continuity** through handoff files and an active backlog
- **A clear agent stack** with Claude as planning, Composer/Codex as execution, and G-Stack as workflow
- **Agent parity** with both `CLAUDE.md` and `AGENTS.md`
- **Conductor workspace states** for planning, in progress, review, merged, and done
- **Task lanes and QA checklists** before risky edits
- **Workflow gates** for source-of-truth UI work, pre-ship checks, and production approval phrases
- **Build bridge skills** for `/grill-me`, `/build-prd`, and `/prd-to-slices`
- **Workflow commands** for `/ce`, `/grill-me`, `/build-prd`, `/prd-to-slices`, and `/review-week`
- **Team knowledge sharing** when you also use a shared team OS

## The Two-Layer Architecture

This system uses two repos that work together:

```
{your-name}-os/          ← PERSONAL (private to you)
  CLAUDE.md              # Your AI instructions
  memory/                # Your personal memory
  handoff.md             # Your session continuity
  active-backlog.md      # Your task tracking
  AGENTS.md              # Codex / non-Claude instructions
  .cursor/rules/         # Cursor Composer execution rules
  docs/                  # task lanes and QA checklists
  scripts/               # verification, risk detection, slice board helpers

{company}-os/            ← TEAM (shared, everyone commits)
  CLAUDE.md              # Team-wide AI instructions
  learnings/             # Team discoveries (date-slugged)
  skills-library/        # Shared reusable patterns (3 tiers)
  operations/processes/  # Process docs
  sprints/               # Sprint planning
  team/                  # Per-person notes
```

**Why two repos?**
- Your personal OS has YOUR context — your role, your focus, your in-progress work
- The team OS has SHARED context — learnings, skills, processes that help everyone
- When you discover a pattern personally, you log it in `memory/skills/`
- When it's polished and team-ready, you promote it to `{company}-os/skills-library/`
- Every team member's AI reads the team repo, so one person's discovery benefits everyone

## Quick Start

### Step 1: Set up the Team OS (one person does this)

```bash
mkdir ~/company-os
cp -r team-os/* ~/company-os/
cd ~/company-os
git init && git add -A && git commit -m "init: team operating system"
# Create a GitHub repo and push
gh repo create company-os --private --source . --push
```

Then customize:
- Fill in `CLAUDE.md` — team members, business context, directory paths
- Fill in `skills-library/README.md` — your company name

Share the repo with your team. Everyone clones it.

### Step 2: Each person sets up their Personal OS

```bash
mkdir ~/my-os
cp -r personal-os/* ~/my-os/
cd ~/my-os
git init && git add -A && git commit -m "init: personal operating system"
```

Then customize:
- Fill in `CLAUDE.md` — your name, role, focus, timezone
- Replace `~/{team-repo}/` references with your actual team repo path (e.g., `~/company-os/`)
- Fill in `memory/MEMORY.md` — your active projects
- Rename `memory/my-project/` to your actual project name

### Step 3: Open in Cursor / Claude Code

Claude Code reads `CLAUDE.md`. Codex reads `AGENTS.md`. Cursor Composer reads `.cursor/rules/`. Conductor can use `.conductor/settings.toml` to sync bridge skills into `.agents/skills/`.

Open your personal OS folder as the workspace. The system boots up from `handoff.md`, `active-backlog.md`, and `memory/MEMORY.md`.

### Recommended Agent Stack

| Layer | Default tool | Model posture | Job |
|-------|--------------|---------------|-----|
| Planning | Claude | Most capable model available | Think, challenge, ask questions, make plans, write PRDs, review architecture. |
| Execution | Composer or Codex | Strong coding model | Implement from the plan, keep patches small, run checks, update files. |
| Workflow | G-Stack | Skill package | Office hours, plan reviews, design review, QA, security review, ship, retro. |
| Parallel work | Conductor | Workspace manager | Run separate agents in separate workspaces with clear states. |

Default rule: Claude owns product thinking and plans. Composer/Codex own code execution after the plan is clear.

### Optional: Conductor setup

If you use Conductor, keep the included `.conductor/settings.toml` and run the setup script once:

```bash
cd ~/my-os
./scripts/setup-bridge-skills.sh
./scripts/setup-gstack-skills.sh   # optional, only if you have G-Stack skills installed
```

The template uses `.context/` for in-flight agent coordination and keeps `.agents/` generated locally.

Read the full setup guide at `personal-os/docs/setup/agent-stack.md`.

## Philosophy

Most people treat AI sessions as disposable. Start fresh, re-explain context, re-solve problems. This system makes sessions compound:

> "If a brand new session started this exact same task tomorrow, would it be faster because of what we logged today?"

If the answer is no, something should have been captured.

## Template Contents

### `personal-os/` — Your Private Workspace

| File | Purpose |
|------|---------|
| `CLAUDE.md` | AI system instructions — the core brain |
| `AGENTS.md` | Non-Claude agent instructions for Codex and similar tools |
| `.cursor/rules/` | Cursor Composer rules for execution agents |
| `.conductor/settings.toml` | Conductor workspace setup |
| `.claude/settings.json` | Claude Code hooks for workflow gates |
| `.claude/hooks/` | Guard, format, review, QA, and source-of-truth hooks |
| `.claude/commands/` | Workflow slash-command wrappers |
| `.github/` | Pull request template and verification workflow |
| `docs/agent-task-templates.md` | Lanes agents fill before non-trivial work |
| `docs/setup/agent-stack.md` | Full Claude, Composer, Codex, G-Stack, and Conductor setup guide |
| `docs/setup/workflow-skills.md` | Workflow-integrated skills only |
| `docs/qa/` | QA checklists for UI, billing, DB, auth, onboarding, and voice |
| `scripts/detect-change-risk` | Changed-file risk classifier |
| `scripts/verify-before-ship` | Read-only pre-ship report |
| `scripts/slice-board.py` | Conductor slice board updater |
| `memory/MEMORY.md` | Master index, always loaded (<50 lines) |
| `memory/my-project/index.md` | Example project hub (<60 lines) |
| `memory/skills/example-skill.md` | Skill template — reusable patterns |
| `memory/decisions/example-decision.md` | Decision log template |
| `handoff.md` | Session-to-session continuity |
| `active-backlog.md` | Full task tracking |

### `team-os/` — Shared Company Brain

| File/Dir | Purpose |
|----------|---------|
| `CLAUDE.md` | Team-wide AI instructions |
| `learnings/` | Team knowledge base (date-slugged markdown) |
| `skills-library/` | Reusable patterns in 3 tiers (meta, domain, commodity) |
| `operations/processes/` | Process documentation |
| `sprints/` | Sprint planning and archive |
| `team/` | Per-person notes and context |
| `decisions/` | Company-level decisions with reasoning |
| `projects/` | Cross-functional project folders |
| `ai-office/` | AI agent templates and setup guides |

## How the Pieces Fit Together

### Memory (Personal — Hub & Spoke)

```
memory/MEMORY.md (master index — always loaded, <50 lines)
  ├── {project}/index.md    ← project hub (<60 lines each)
  │     ├── {topic}.md      ← spoke: grows as needed
  │     └── {topic}.md      ← spoke: grows as needed
  ├── skills/               ← reusable patterns
  ├── decisions/            ← decisions with reasoning
  └── journal/              ← session observations (optional)
```

**Why this shape?**
- MEMORY.md loads every session (~50 lines = minimal token cost)
- Hubs load only when working on that project
- Spokes load only when the topic comes up
- Nothing duplicates — each fact lives in exactly one place

### Skills Library (Team — 3 Tiers)

| Tier | What Goes Here | Example |
|------|---------------|---------|
| **Meta** (`meta/`) | Skills that generate other skills | Presentation builder, product dev methodology |
| **Domain** (`domain/`) | Company-specific knowledge | Brand guide, customer ICPs, pricing models |
| **Commodity** (`commodity/`) | Generic reusable patterns | OAuth flows, deployment recipes |

### Session Bookends

**Start:** handoff.md → WIP check → planning gate → work
**Close:** learning gate → handoff update → backlog update

The learning gate is the key: you can't write the handoff until you've asked "what did we learn?"

### Compounding Learning (3 Triggers)

These fire during work, not after:

1. **"We just built something reusable"** → extract to `memory/skills/`
2. **"I just explained something that took >2 minutes"** → log to relevant spoke
3. **"This problem feels familiar"** → check skills first, create pattern if second occurrence

### Patterns Baked Into CLAUDE.md

The personal `CLAUDE.md` ships with a few opinionated behaviors. Customize or delete what doesn't fit.

| Pattern | What it does |
|---------|--------------|
| **How You Talk To Me** | Communication style preferences (reading level, tone, format) — set once, your AI matches it forever |
| **The Ship Test** | Before starting anything new, ask: "Is there something already built that could ship instead?" Forces WIP discipline |
| **Verify Before Declaring Done** | Don't trust "looks correct" — query the database, hit the endpoint, screenshot the rendered output |
| **Friction Capture** | 5 trigger phrases ("log it", "that was dumb", etc.) capture frustrations live to `memory/pending-improvements.md`. Weekly review converts them into hooks, feedback memories, or CLAUDE.md edits — no journaling allowed |
| **Coding Guidelines** | 4 rules: think before coding, simplicity first, surgical changes, goal-driven execution. Reduces common LLM mistakes |
| **Tool Routing** | A signal-to-tool table. Your AI auto-routes work types to the right command (planning, review, QA, etc.) without you having to ask |
| **Conductor States** | Every workspace reports state, next action, owner, and risk |
| **Workflow Approval Rules** | Production DB and deploy actions require exact phrases |
| **Task Lanes** | Agents fill the right lane before non-trivial edits |
| **Build Bridge** | `/grill-me` → `/build-prd` → `/prd-to-slices` turns plans into slices |
| **Agent Stack** | Claude plans with the most capable model. Composer/Codex execute. G-Stack provides the workflow. |

## Solo Use (No Team)

If you're working solo, just use the `personal-os/` folder. Delete the `~/{team-repo}/` references from CLAUDE.md, and remove the team-related steps from the session protocols. Everything else works identically.

## Workflow Commands

Run these from your personal OS root:

```bash
scripts/detect-change-risk
scripts/verify-before-ship
scripts/slice-board.py --help
```

For larger builds:

```text
/ce
/gstack-office-hours
/gstack-plan-ceo-review
/gstack-plan-design-review
/gstack-plan-eng-review
/grill-me
/build-prd
/prd-to-slices
/gstack-review
/gstack-qa <url>
/gstack-ship
```

The template intentionally does not include private marketing, company, finance, or customer-specific skills. Add those later in your private memory if you use them.

## Tips

- **Keep MEMORY.md ruthlessly short.** It loads every session. Every line costs tokens.
- **Spokes grow organically.** Don't pre-create empty files. Let them emerge from real work.
- **Skills > learnings.** A learning says "we discovered X." A skill says "here's how to do X, step by step, with examples."
- **Decisions need reasoning.** "We chose X" is useless. "We chose X because Y, and rejected Z because W" compounds.
- **WIP limits are real.** 3 items max in progress. If you're always at 3, you're not finishing things.
- **Push the team repo.** Learnings only compound if they're committed. Remind your AI to remind you.

---

*Based on the personal OS architecture developed by Pedro Jerez.*
