# Guided Onboarding

Run guided onboarding after copying `personal-os/` into your private workspace.

```bash
cd ~/my-os
./scripts/onboard-personal-os
```

## What It Asks

Personal setup:

- Full name
- Role
- Focus areas
- Timezone
- Optional word of the year
- Personal OS path

Project setup:

- Primary project name
- Primary project slug or folder
- Your role on that project

Company/team setup:

- Company or team name
- Your company role
- Whether you use a shared team OS repo
- Team OS path, if used

Agent setup:

- Planning model label
- Execution tools
- Whether you use Conductor
- Whether you use G-Stack
- Risky areas agents should treat carefully
- Communication style

## What It Writes

- Replaces placeholders in `CLAUDE.md`, `AGENTS.md`, `active-backlog.md`, `handoff.md`, and `memory/MEMORY.md`.
- Creates `memory/personal-context.md`.
- Creates `memory/company-context.md` when company info is provided.
- Renames `memory/my-project/` to your primary project slug.
- Rewrites `handoff.md` with the first next actions.
- Rewrites `active-backlog.md` with setup follow-ups.

## Privacy Rule

This script writes personal and company information into your local clone.

Do not run it in the public template repo unless you are testing with fake data.

Do not commit secrets, customer data, private financials, or API keys.
