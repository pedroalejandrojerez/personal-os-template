# {COMPANY_NAME} Skills Library

Skills are documented patterns that make every future AI session faster. When you solve a problem well, you extract the pattern so it never has to be solved from scratch again.

## How Skills Work

1. Your AI reads the skill file before starting work
2. It follows the pattern instead of reinventing it
3. The gotchas section prevents the mistakes you already made
4. Each session builds on previous sessions instead of starting from zero

## Tiers

### Tier 3: Meta (`meta/`)
Skills that generate other skills. Exponential value.
- These are process patterns, decision frameworks, and methodologies
- Examples: presentation builders, product development flows, multi-model consensus

### Tier 2: Domain (`domain/`)
Company-specific institutional knowledge. Multiplicative value.
- These encode YOUR business knowledge — customer patterns, brand rules, internal workflows
- Examples: brand guide, customer ICPs, pricing models, compliance rules

### Tier 1: Commodity (`commodity/`)
Generic reusable patterns. Save time, not unique to your company.
- These are technical recipes anyone could use
- Examples: OAuth flows, deployment patterns, API integration templates

### Prompts (`prompts/`)
Reusable prompt patterns for specific tasks.
- These are structured prompts that produce consistent output for repeated tasks

## How to Add a New Skill

When you solve something non-obvious, extract it:

1. **Create the file** in the right tier folder
2. **Include these sections**:
   - What it does (1 paragraph)
   - Prerequisites (what you need before starting)
   - Architecture / flow (the pattern, not full code)
   - Key gotchas (the stuff that wastes time — highest-value section)
   - Copy-and-adapt snippets (actual reusable code)
   - Lessons learned (what went wrong the first time)
3. **Never include credentials** — reference file locations instead (e.g., "API key in `~/.env`")
4. **Commit with the feature** — skills are part of the Definition of Done

## Credential Policy

Skill files reference WHERE credentials live, never the credentials themselves.
- Use patterns like: `API key in ~/project/.env as KEY_NAME`
- Never hardcode tokens, secrets, or API keys in skill files
- This repo is shared — treat every file as potentially public
