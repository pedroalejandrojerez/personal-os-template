# Workflow Skills

This public template includes only the skills that are built into the operating workflow.

It does not include private marketing, company, customer, finance, or project-specific skills.

## Included By Default

| Skill | Command | Role In Workflow |
|-------|---------|------------------|
| Compound Engineering | `/ce` | Full idea to build to review to learning loop. |
| Grill Me | `/grill-me` | Tactical question loop before a Build PRD. |
| Build PRD | `/build-prd` | Writes `.context/builds/{feature}/prd.md`. |
| PRD To Slices | `/prd-to-slices` | Writes `.context/builds/{feature}/slices.md`. |
| Review Week | `/review-week` | Weekly workflow adoption and improvement audit. |

## Synced When Installed

G-Stack skills are synced by:

```bash
./scripts/setup-gstack-skills.sh
```

Expected G-Stack workflow:

1. `/gstack-office-hours`
2. `/gstack-plan-ceo-review`
3. `/gstack-plan-design-review`, when UI exists
4. `/gstack-plan-eng-review`
5. `/gstack-plan-devex-review`, when developer workflow changes
6. `/gstack-review`
7. `/gstack-qa <url>`
8. `/gstack-cso`, before public launches
9. `/gstack-ship`
10. `/gstack-land-and-deploy`, only with explicit approval
11. `/gstack-canary`
12. `/gstack-retro`

## Not Included

Do not add broad private skill libraries to the public template by default.

Examples that belong in private memory unless the user installs them:

- Company-specific copy systems.
- Brand voice systems.
- Customer research.
- Financial operating details.
- Pitch strategy with private fundraising context.
- Any skill that names a real company, customer, product, revenue number, or private project.
