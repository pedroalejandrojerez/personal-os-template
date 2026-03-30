# Personal OS for Claude Code

A system for making every Claude Code session smarter than the last. Fork this, fill in the blanks, and stop solving the same problems twice.

## What This Is

This is a personal operating system that wraps around Claude Code (or any AI coding assistant). It gives your AI:

- **Persistent memory** across sessions (hub & spoke architecture)
- **Session continuity** — handoff files so every session picks up where the last left off
- **Compounding learning** — triggers that capture reusable patterns in real-time, not after the fact
- **WIP discipline** — limits and gates that prevent scope creep and half-finished work
- **Skill library** — personal patterns that save time on repeated problem types

## Philosophy

Most people treat AI sessions as disposable. Start fresh, re-explain context, re-solve problems. This system makes sessions compound:

> "If a brand new session started this exact same task tomorrow, would it be faster because of what we logged today?"

If the answer is no, something should have been captured.

## Quick Start

### 1. Create your workspace

```bash
mkdir ~/my-os
cd ~/my-os
git init
```

### 2. Copy the template files

Copy everything from this directory into your workspace:

```
my-os/
  CLAUDE.md              # AI instructions (the brain)
  handoff.md             # Session continuity (quick scan)
  active-backlog.md      # Full task tracking
  memory/
    MEMORY.md            # Master index (always loaded, <50 lines)
    my-project/
      index.md           # Project hub (<60 lines)
    skills/              # Reusable patterns you discover
    decisions/           # Decisions with reasoning
```

### 3. Customize CLAUDE.md

Open `CLAUDE.md` and fill in the placeholders:

- `{YOUR_NAME}` — your name
- `{YOUR_ROLE}` — what you do
- `{YOUR_FOCUS}` — your focus areas
- `{YOUR_TIMEZONE}` — your timezone
- `{YOUR_PROJECT}` — your main project name
- `{TEAM_REPO}` — shared team repo (if applicable, otherwise remove the team sections)

### 4. Customize MEMORY.md

Add your active projects and link to their hub files.

### 5. Start a session

Claude will automatically:
1. Read your handoff file
2. Check for unfinished work
3. Ask what to work on
4. Capture learnings before closing

## Architecture

### Hub & Spoke Memory

```
memory/MEMORY.md (master index — always loaded, <50 lines)
  ├── {project}/index.md    ← project hub (<60 lines each)
  │     ├── clients.md      ← spoke: topic-specific detail
  │     └── [topic].md      ← spoke: grows as needed
  ├── skills/               ← reusable patterns
  ├── decisions/            ← decisions with reasoning
  └── journal/              ← session observations (optional)
```

**Why this shape?**
- MEMORY.md loads every session (~50 lines = minimal token cost)
- Hubs load only when working on that project
- Spokes load only when the topic comes up
- Nothing duplicates — each fact lives in exactly one place

### Session Bookends

**Start:** handoff.md → WIP check → planning gate → work
**Close:** learning gate → handoff update → backlog update

The learning gate is the key innovation: you can't write the handoff until you've asked "what did we learn?"

### Compounding Learning

Three triggers fire during work (not after):

1. **"We just built something reusable"** → extract to `memory/skills/`
2. **"I just explained something that took >2 minutes"** → log to relevant spoke
3. **"This problem feels familiar"** → check skills first, create pattern if second occurrence

## Files in This Template

| File | Purpose |
|------|---------|
| `CLAUDE.md` | AI system instructions — the core brain |
| `memory/MEMORY.md` | Master index, always loaded |
| `memory/my-project/index.md` | Example project hub |
| `memory/skills/.gitkeep` | Personal skills directory |
| `memory/decisions/.gitkeep` | Decision log directory |
| `handoff.md` | Session-to-session continuity |
| `active-backlog.md` | Full task tracking |

## Team Use (Optional)

If you work with a team that also uses Claude Code, you can set up a shared repo:

```
team-os/
  learnings/          # Team discoveries (date-slugged)
  skills-library/     # Shared reusable patterns
  operations/         # Team processes
```

Then reference it in your CLAUDE.md so your AI checks team knowledge before building from scratch.

## Tips

- **Keep MEMORY.md ruthlessly short.** It loads every session. Every line costs tokens.
- **Spokes grow organically.** Don't pre-create empty files. Let them emerge from real work.
- **Skills > learnings.** A learning says "we discovered X." A skill says "here's how to do X, step by step, with examples."
- **Decisions need reasoning.** "We chose X" is useless. "We chose X because Y, and rejected Z because W" compounds.
- **WIP limits are real.** 3 items max. If you're always at 3, you're not finishing things.

## Adapting This System

The template includes a "Domain Protocols" section in CLAUDE.md with one example. This is where you add automatic behaviors for your specific work — e.g., "any time we write marketing copy, load the brand guide first." These are what make the system genuinely yours rather than generic.

---

*Based on the personal OS architecture developed by Pedro Jerez.*
