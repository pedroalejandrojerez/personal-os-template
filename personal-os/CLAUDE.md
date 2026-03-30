# {YOUR_NAME}'s Operating System

You are working inside {YOUR_NAME}'s personal workspace. This is a private scratchpad for capturing learnings, decisions, and work-in-progress.

## Who I Am
- **Name**: {YOUR_NAME}
- **Role**: {YOUR_ROLE}
- **Focus areas**: {YOUR_FOCUS_AREAS}
- **Time zone**: {YOUR_TIMEZONE}

## Key Directories
- **My workspace**: `~/{workspace-name}/`
- **Shared team brain**: `~/{team-repo}/` (optional — remove if working solo)

---

## Session Start Protocol
1. Read `handoff.md` — quick scan, what happened last session (under 20 lines)
2. If deeper context needed → read `active-backlog.md`
3. Read `~/{team-repo}/learnings/` — check for new team learnings (files modified in last 3 days)
4. Read `~/{team-repo}/skills-library/README.md` — check for new team skills
5. **WIP check**: Before starting new work, check active-backlog.md — surface the top unfinished item:
   > "Before we start something new — [X] has been at ~80% for [N] days. It needs [specific task]. Want to close it out first?"
6. Present top actions and ask what to work on

**WIP Limit:** Max 3 items "in progress" at a time. To start a 4th, finish or kill one first.

## Session Planning Gate — Before ANY Build Work
Before starting any coding or building task, run this checklist:

> **Session Planning Gate**
> 1. What's the ONE outcome for this session? (Write it in past tense: "We ___")
> 2. What does "done" look like? (Specific, verifiable)
> 3. How long should this take? (If we exceed 2x, stop and reassess)
> 4. What are we NOT doing? (Name at least one adjacent thing we'll ignore)
> 5. Is there anything in-flight that should finish first? (Check active-backlog.md)

After answers, restate the session scope in one sentence and pin it. Reference it if scope drifts.
Skip conditions: Session is explicitly a brainstorm, exploration, or brief generation.

---

## Compounding Learning Protocol — Never Solve the Same Problem Twice

### Three Capture Triggers (During Every Session — Not After)

**Trigger 1 — "We just built something reusable"**
Any integration, automation, pipeline, or pattern that could apply elsewhere.
→ Extract to `memory/skills/{name}.md` before moving on.

**Trigger 2 — "I just explained something that took >2 minutes"**
Any concept, framework, decision rationale, or technical explanation.
→ Log immediately to the relevant memory spoke. Not at session end — right then.

**Trigger 3 — "This problem feels familiar"**
If you recognize a problem type you've seen before:
→ Check `~/{team-repo}/skills-library/` and `memory/skills/` FIRST.
→ If a pattern exists, use it. If this is the second time and no pattern exists — create one now.

### Before Building Anything
1. Search `~/{team-repo}/skills-library/` for existing team patterns
2. Search `memory/skills/` for personal patterns
3. If a skill exists → use it. If close → adapt it. Only build from zero when nothing matches.
4. If you skip an existing skill → explain why.

### Session Close Learning Gate
Before writing the handoff, always ask:
> "What did we learn today that would save >10 minutes next time? Any new skills to extract?"

This is a gate — the handoff doesn't get written until learning capture is done.

**The Compound Test:** "If a brand new session started this exact same task tomorrow, would it be faster because of what we logged today?"

---

## Session Close Protocol
Before ending any session, run this in order:

### 1. Learning Capture (the gate)
- **Learnings check**: "Did we learn anything the team should know?"
  - If yes → write to `~/{team-repo}/learnings/YYYY-MM-DD-{slug}.md`
  - Then: `cd ~/{team-repo} && git add learnings/ && git commit -m "learning: {title}" && git push`
- **Skill check**: "Did we solve something that would save >10 min next time?"
  - If yes → write to `memory/skills/{name}.md` (personal first)
  - When polished → promote to `~/{team-repo}/skills-library/` and push
- **Decision check**: "Did we make a decision with non-obvious reasoning?"
  - If yes → write to `memory/decisions/YYYY-MM-DD-{slug}.md`

### 2. Handoff (two-file system)
**Quick scan** — update `handoff.md` (under 20 lines):
```
# Session Handoff — {date}
## What Was Done
- [bullet points, one line each]

## Top 3 Next Actions
1. **[Action]** — [one line of context]
2. **[Action]** — [one line of context]
3. **[Action]** — [one line of context]

## Full Backlog
→ `active-backlog.md`
```

**Full backlog** — update `active-backlog.md`:
- Add new items discovered this session
- Remove items that were completed
- Items sitting 3+ sessions without movement → mark as "parked" or remove

---

## Routing Rules — Where to Save What

| Type of information | Where it goes |
|---|---|
| Project-specific insight or data | `memory/{project}/{topic}.md` (spoke) |
| Strategic decision with reasoning | `memory/decisions/YYYY-MM-DD-{slug}.md` |
| Reusable pattern or template | `memory/skills/{name}.md` → promote to team repo |
| Something the whole team should know | `~/{team-repo}/learnings/YYYY-MM-DD-{slug}.md` |
| Session observation | `memory/journal/pattern-journal.md` |

**Rule:** If it only matters to you → personal memory. If the team should know → team repo.

## Memory Architecture: Hub & Spoke

```
memory/MEMORY.md (master index — always loaded, <50 lines)
  ├── {project}/index.md    ← project hub (<60 lines)
  │     ├── {topic-a}.md    ← spoke: topic-specific detail
  │     └── {topic-b}.md    ← spoke: grows as needed
  ├── skills/               ← personal skills vault
  ├── decisions/            ← decisions with reasoning
  └── journal/              ← session observations (optional)
```

**Rules:**
- MEMORY.md stays under 50 lines (it's a table of contents, not content)
- Hubs stay under 60 lines — use spokes for detail
- Don't duplicate what's in the team repo — personal memory is for YOUR context

## Verify Outcomes Before Declaring Done
Never say "done" based on code looking correct — verify the actual output:
- If it writes to a database → query and check the rows
- If it generates messages → run it and read the actual messages
- If it calls an API → check the API response, not just that the call didn't error
- If it deploys → hit the endpoint and verify the behavior

---

## Domain Protocols (Customize These)

Domain protocols are automatic behaviors that fire when specific work types are detected.
They ensure your AI loads the right context before doing domain-specific work.

Below is an example template. Create your own for the types of work you do repeatedly.

### Example: {Domain} Protocol — Automatic for {Work Type}
**Trigger:** Any time {description of when this should fire}.

**Order of operations:**
1. Read `memory/skills/{relevant-skill}.md` — {what this provides}
2. Read `{other-reference-file}` — {what this provides}
3. {Domain-specific validation step}

**Do not skip steps 1-2.** {Why this context matters.}

<!--
Real examples of domain protocols:
- Copywriting: Load brand guide + customer psychology before writing any copy
- Code review: Load style guide + architecture decisions before reviewing PRs
- Sales outreach: Load ICP profiles + objection patterns before drafting messages
- Content creation: Load voice guide + past performance data before creating content
- Architecture decisions: Load existing patterns + tech debt inventory before proposing changes
-->

---

## The Learning System
The most important system. Every session should leave you smarter.
- Before building anything: search for existing patterns
- After discovering something: write it immediately, don't wait until session end
- When citing a past learning: reference when it was discovered and why it matters now
