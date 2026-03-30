# {COMPANY_NAME} OS — Shared Company Operating System

You are working inside {COMPANY_NAME}'s shared operating system. This repo is the team's collective brain — every insight, process, and decision that matters lives here.

## Who Works Here

- **{Name}** ({Role}) — {responsibilities}
- **{Name}** ({Role}) — {responsibilities}
<!-- Add all team members. Each person's Claude reads this, so everyone benefits from context here. -->

## How This Repo Works

Each team member has their own `{name}-os` repo (private workspace). This `{company}-os` repo is the **shared layer** — when something is ready for the team, it gets pushed here. Everyone's Claude reads this repo, so anything committed here compounds across the whole team.

## Directory Structure

```
{company}-os/
├── CLAUDE.md              ← You are here. Read this every session.
├── learnings/             ← Team knowledge base. READ AT SESSION START.
├── skills-library/        ← Reusable patterns organized by tier.
├── operations/processes/  ← Process docs the team follows.
├── sprints/               ← Active and archived sprint plans.
├── team/{name}/           ← Per-person notes, logs, context.
├── decisions/             ← Company-level decisions with reasoning.
├── ai-office/             ← AI agent templates and setup guides.
└── projects/              ← Cross-functional project folders.
```

## The Learning System

This is the most important part of {COMPANY_NAME} OS. Every session should leave the repo smarter than it found it.

### Reading Learnings (every session)

At the start of every session, read the `learnings/` directory to understand what the team has already discovered. When a learning is relevant to the current task, **surface it with attribution**:

> "Based on a learning from {Name} (Feb 10): {key insight}. Consider {how it applies now}."

Always cite: **who** discovered it, **when**, and **why** it's relevant now. This reinforces the learning and builds trust in the system.

### Writing Learnings (during sessions)

When you discover something important during a session — a pattern, a fix, an insight, a mistake — write it to `learnings/` immediately. Don't wait until the end.

**File naming**: `learnings/YYYY-MM-DD-{short-slug}.md`

**Template**:
```markdown
# {Title}

**Discovered by**: {team member name}
**Date**: {YYYY-MM-DD}
**Context**: {What were we working on when we learned this?}

## The Learning

{What did we discover? Be specific and actionable.}

## Why It Matters

{How does this affect our work? Who should know about this?}

## Applied To

- {List where this learning has been applied or should be applied}
```

### Where Learnings Come From

Learnings don't just come from AI sessions. The richest sources are:
- **Meeting transcripts** — client calls, team syncs, strategy sessions
- **Slack/chat conversations** — real-time problem solving, decisions made in threads
- **AI coding sessions** — patterns discovered while building or analyzing
- **Customer interactions** — feedback, complaints, wins

When a team member shares context from a meeting or conversation, capture it as a learning with the original source noted.

### What Gets Written as a Learning

Write a learning when:
- A process breaks and you find the root cause
- You discover a pattern across multiple customers
- A metric reveals something unexpected
- An assumption turns out to be wrong
- A workaround or trick saves significant time
- A decision is made with non-obvious reasoning

Do NOT write a learning for:
- Routine task completion
- Obvious facts or common knowledge
- Temporary blockers that won't recur

### End of Session

At the end of every session, check:
1. Did we discover anything the team should know? → Write to `learnings/`
2. Did we update any process docs? → Commit to `operations/processes/`
3. Did we make progress on the sprint? → Update the sprint file
4. Were any reusable patterns created? → Add to `skills-library/`
5. Remind the user: "Don't forget to push to GitHub so the team gets these updates."

## Sprint Conventions

- Active sprint: `sprints/sprint-{date-range}.md`
- Completed sprints move to `sprints/archive/`
- Each sprint file includes: objectives, ownership (who owns what), status updates, and retrospective notes

## Process Doc Conventions

- Process docs live in `operations/processes/`
- Every process doc includes a "Last updated" date and "Owner" name
- When changing a process, include a brief "Why we changed this" note at the top
- Never delete process history — move outdated versions to a `## Previous Versions` section at the bottom

## Key Business Context

<!-- Fill in the essentials about your business that every team member's AI should know -->
- {What does the company do? One sentence.}
- {Revenue or growth stage}
- {Core product or service}
- {Key metrics the team tracks}
- {Critical problems or focus areas}

## The Learning System (Summary)

Every session should leave the repo smarter.
- Before building anything: search `skills-library/` for existing patterns
- After discovering something: write it immediately, don't wait until session end
- When citing a team learning: say who discovered it, when, and why it matters now
