# Personal OS for Claude Code / Cursor

A system for making every AI session smarter than the last. Fork this, fill in the blanks, and stop solving the same problems twice.

## What This Is

This is a two-layer operating system that wraps around Claude Code or Cursor. It gives your AI:

- **Persistent memory** across sessions (hub & spoke architecture)
- **Session continuity** — handoff files so every session picks up where the last left off
- **Compounding learning** — triggers that capture reusable patterns in real-time, not after the fact
- **WIP discipline** — limits and gates that prevent scope creep and half-finished work
- **Skill library** — team and personal patterns that save time on repeated problem types
- **Team knowledge sharing** — learnings compound across everyone, not just you

## The Two-Layer Architecture

This system uses two repos that work together:

```
{your-name}-os/          ← PERSONAL (private to you)
  CLAUDE.md              # Your AI instructions
  memory/                # Your personal memory
  handoff.md             # Your session continuity
  active-backlog.md      # Your task tracking

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

Both Cursor and Claude Code automatically read `CLAUDE.md` from the project root. Just open your personal OS folder as your workspace, and the system boots up.

## Philosophy

Most people treat AI sessions as disposable. Start fresh, re-explain context, re-solve problems. This system makes sessions compound:

> "If a brand new session started this exact same task tomorrow, would it be faster because of what we logged today?"

If the answer is no, something should have been captured.

## Template Contents

### `personal-os/` — Your Private Workspace

| File | Purpose |
|------|---------|
| `CLAUDE.md` | AI system instructions — the core brain |
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

## Solo Use (No Team)

If you're working solo, just use the `personal-os/` folder. Delete the `~/{team-repo}/` references from CLAUDE.md, and remove the team-related steps from the session protocols. Everything else works identically.

## Tips

- **Keep MEMORY.md ruthlessly short.** It loads every session. Every line costs tokens.
- **Spokes grow organically.** Don't pre-create empty files. Let them emerge from real work.
- **Skills > learnings.** A learning says "we discovered X." A skill says "here's how to do X, step by step, with examples."
- **Decisions need reasoning.** "We chose X" is useless. "We chose X because Y, and rejected Z because W" compounds.
- **WIP limits are real.** 3 items max in progress. If you're always at 3, you're not finishing things.
- **Push the team repo.** Learnings only compound if they're committed. Remind your AI to remind you.

---

*Based on the personal OS architecture developed by Pedro Jerez.*
