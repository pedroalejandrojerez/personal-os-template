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

## How You Talk To Me

Customize this section with your own communication preferences. Examples below — replace, edit, or delete.

- **Reading level:** Write at a {fifth-grade / plain-language / technical} reading level. {Short sentences. Common words. Define jargon the first time it appears.}
- **Tone:** Be direct. Don't soften answers. If something's wrong, say so.
- **Format:** Use tables and bullets when comparing options. Avoid walls of text.
- **Recommendations:** Lead with a recommendation. Don't present equal-weight options. Say which and why, then share alternatives.

This rule applies to **chat responses**, not to artifacts written for other agents or production code. A spec written for a builder agent can be technical; the explanation back to me is plain-language.

---

## Session Start
1. Read `handoff.md` — what happened last session (under 20 lines)
2. Check `active-backlog.md` — find the item closest to shipped
3. Read `~/{team-repo}/learnings/` — new team learnings (files modified in last 3 days)
4. Read `~/{team-repo}/skills-library/README.md` — check for new team skills
5. Present: "**[X] is closest to done.** It needs [specific task]. Ship it, or work on something else?"

Default action is always: **close an open loop**.

**WIP Limit:** Max 3 items "in progress" at a time. To start a 4th, finish or kill one first.

---

## The Ship Test — Before Starting Anything New

> "Is there something already built that could ship instead?"

If yes, ship it first. New work only starts when nothing is at 80%+.

If you explicitly want to start something new, that's fine — but name what's being deprioritized.

---

## Session Close
1. **Learning gate (the gate, not optional)** — Before writing the handoff, ask: "What did we learn today that would save >10 minutes next time? Any new skills to extract?"
   - Reusable pattern → `memory/skills/{name}.md` (personal first; promote to `~/{team-repo}/skills-library/` once polished)
   - Team-level learning → `~/{team-repo}/learnings/YYYY-MM-DD-{slug}.md`, then `cd ~/{team-repo} && git add learnings/ && git commit -m "learning: {title}" && git push`
   - Decision with non-obvious reasoning → `memory/decisions/YYYY-MM-DD-{slug}.md`
2. Update `handoff.md` (under 20 lines) — what was done + top 3 next actions
3. Update `active-backlog.md` — mark completed, add new items, park anything stalled 3+ sessions

---

## Compounding Learning Protocol — Three Capture Triggers

Capture **during** sessions, not after. By the end, the freshness is gone.

**Trigger 1 — "We just built something reusable"**
Any integration, automation, pipeline, or pattern that could apply elsewhere.
→ Extract to `memory/skills/{name}.md` before moving on.

**Trigger 2 — "I just explained something that took >2 minutes"**
Any concept, framework, decision rationale, or technical explanation.
→ Log immediately to the relevant memory spoke. Right then, not later.

**Trigger 3 — "This problem feels familiar"**
If you recognize a problem type:
→ Check `~/{team-repo}/skills-library/` and `memory/skills/` FIRST.
→ If a pattern exists, use it. If this is the second time and no pattern exists — create one now.

**The Compound Test:** "If a brand new session started this exact same task tomorrow, would it be faster because of what we logged today?"

If the answer is no, something should have been captured.

---

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

---

## Verify Before Declaring Done

Don't say "done" based on code looking correct. Verify the actual output:

- **Database writes** → query and check the rows
- **API calls** → check the response, not just that the call didn't error
- **Deploys** → hit the endpoint and verify the behavior
- **Visual / layout work** (HTML, slides, design) → screenshot the rendered output. Multi-slide decks: screenshot every slide. Never declare done from code alone.
- **Source-of-truth claims** → check the deploy config (Vercel, git log, build scripts) before diffing two trees as if they're versions of the same file.
- **Strategic shifts** → audit all existing content on the affected surface for consistency. A changed thesis must not leave stale claims behind.

If you cannot verify (no browser, no deploy access, no DB access), say so explicitly instead of claiming success.

---

## Friction Capture — The Compounding System

Goal: turn in-the-moment frustrations into system improvements that make next week faster. Reviews don't work because friction is freshest when it happens. Capture at peak signal, process weekly.

### Trigger phrases — capture immediately

When the user says any of these, **immediately** append an entry to `memory/pending-improvements.md`:
- "log it" / "log that"
- "that was dumb" / "that was annoying"
- "don't do that again"
- "capture this"
- "friction"

Don't ask the user to describe the friction. Extract it from recent conversation context yourself. Entry format:

```
### YYYY-MM-DD HH:MM — [one-line title]
- **What happened:** [specific — what the AI did, what the user expected, what broke]
- **Why it's friction:** bug | repetition | workflow | quality | speed
- **Fix hypothesis:** [hook | feedback memory | CLAUDE.md edit | skill update | none]
```

After appending, confirm in one line: "Logged — [title]. Processed in next weekly review."

### Weekly processing

Run a weekly review on your cadence. The review **must produce at least one durable artifact** — a hook rule, feedback memory, CLAUDE.md edit, or skill update. No journaling allowed.

**Preference order:** prevention (hook that blocks the bad behavior) > guidance (feedback memory the AI loads) > behavior (CLAUDE.md edit) > capability (new skill).

The point: friction that gets captured but never converted is just complaining. Force conversion.

---

## Coding Guidelines

Behavioral guidelines to reduce common LLM coding mistakes. **Tradeoff:** these bias toward caution over speed. For trivial tasks, use judgment.

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.

When your changes create orphans:
- Remove imports / variables / functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

## Tool Routing — Use the Right Tool Automatically

Map the work types you do most often to the tools / commands you use to do them. Your AI should detect the type of work and route to the right tool without being asked.

| Signal | Tool / Command | What it does |
|--------|----------------|--------------|
| {e.g., Plan a new feature} | `{your planning command}` | {one-line note} |
| {e.g., Code review before merging} | `{your review command}` | {one-line note} |
| {e.g., QA test in a real browser} | `{your QA command}` | {one-line note} |
| {e.g., Debug a recurring bug} | `{your debug command}` | {one-line note} |

<!--
Fill this with the tools you actually use. Group by domain (coding, writing,
research) if you have many. Keep entries concrete: "plan a feature" beats
"do planning." If you don't have specific commands yet, delete this section
and add it back when you do.
-->

---

## Domain Protocols (Customize These)

Domain protocols are automatic behaviors that fire when specific work types are detected. They ensure your AI loads the right context before doing domain-specific work.

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
