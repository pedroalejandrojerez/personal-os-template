# Onboarding QA Checklist

Use for signup, profile setup, onboarding state, resume, or onboarding-to-product handoff changes.

## Source Of Truth

- Locked onboarding plan, production behavior, approved mockup, and saved profile rows.

## Surfaces

- New-user path.
- Resume path after refresh, login, OAuth return, and browser back.
- Desktop and mobile widths.

## Failures To Catch

- Selection or text input does not save.
- Error path does not return to the right state.
- Handoff loses context.
- Returning users repeat completed screens or skip required ones.

## Browser And Device Checks

- New-user path from start through handoff.
- Refresh after each major step.
- Mobile layout for wrapping, CTA visibility, and keyboard.

## Data Checks

- Verify profile fields and step state after each save.
- Confirm rows are scoped to the current user.

## Report

- PASS or FAIL for save, resume, error return, handoff, mobile layout, and DB rows.

## Stop And Ask

- Source of truth conflicts with production.
- A fix needs migration, provider dashboard changes, or production data mutation.
