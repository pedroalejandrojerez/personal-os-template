---
name: grill-me
description: Interview the user one question at a time before a PRD, Build PRD, or slice board. Explore files first, recommend an answer for every question, and end with locked implementation decisions.
---

# Grill Me Skill

Source: https://github.com/mattpocock/skills/tree/733d312884b3878a9a9cff693c5886943753a741/skills/productivity/grill-me

## Purpose

Interview the user about a plan until the agent and user share the same picture of
what should be built.

Use this before writing a PRD, Build PRD, or implementation issue list.

Do not write application code while running this skill.

## Protocol

1. Start with the user's rough idea, plan, transcript, or design doc.
2. Explore the codebase first when a question can be answered from files.
3. Ask one question at a time.
4. For every question, give a recommended answer and why.
5. Walk down the decision tree. Resolve dependencies before moving on.
6. Keep going until the problem, scope, edge cases, module shape, tests, and
   out-of-scope decisions are clear.
7. Stop with a compact decision summary that can feed a PRD.

## File-First Pass

Before asking the user, inspect any source files that can answer the question:

- The plan or review artifact named by the user
- `.context/builds/{feature}/prd.md`, if it exists
- `.context/builds/{feature}/slices.md`, if it exists
- `.gstack/build-lock.md`, if UI is involved
- Existing code paths, tests, routes, migrations, or docs named by the plan

If the repo already answers a question, state the answer and move to the next
unresolved decision.

## Question Format

Ask exactly one question at a time.

Use this shape:

```md
Question: [the one decision the user needs to make]
Recommended answer: [your call]
Why: [short reason tied to this feature]
What changes if you disagree: [scope, risk, or file impact]
```

Do not offer a broad menu unless the choice is truly open. Lead with the
recommended answer.

## Good Question Areas

- What is the smallest useful version?
- Which user flow proves the feature works?
- What is explicitly out of scope?
- What must be retroactive or backfilled?
- What states can fail, be empty, or be stale?
- Which module boundary should humans own?
- Which internals can agents implement AFK?
- What test proves this slice works?
- What must be manually QA'd by the user?

## Decision Tree

Resolve decisions in this order:

1. Outcome and smallest useful version
2. First real user flow
3. In-scope and out-of-scope boundaries
4. Data shape, backfills, and migration risk
5. Empty, stale, failed, loading, and retry states
6. Rollout, rollback, and feature flags
7. Human-owned interfaces and deep module boundaries
8. AFK-safe internals
9. Test proof and manual QA proof

Stop early only if the user says the plan is cancelled, or if a missing answer
blocks a safe PRD.

## Output

End with:

- Problem
- Recommended solution
- Locked decisions
- Open risks
- Out of scope
- Suggested first vertical slice
- Suggested tests
