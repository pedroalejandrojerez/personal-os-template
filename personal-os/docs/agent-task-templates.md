# Agent Task Templates

Use one lane before any non-trivial edit. If work crosses lanes, use the strictest lane.

## Base Block

Task:
Expected outcome:
Source of truth:
Files likely in scope:
Files explicitly out of scope:
Production touched: yes/no
Deploy allowed: yes/no
Tests/checks required:
Visual/browser QA required: yes/no
Stop condition:
Exact approval needed before commit/push/merge/deploy:

## UI/mockup parity work

Task: Bring one visible surface into parity with the named source.
Expected outcome: The rendered screen matches the approved source on desktop and mobile.
Source of truth: Approved mockup file, design-system HTML, production behavior, preview deploy, screenshot, spec file, or user-visible copy.
Files likely in scope: Component, route, CSS, design token, or copy files for that surface only.
Files explicitly out of scope: Auth, billing, data model, migrations, unrelated copy, deploy config.
Production touched: no.
Deploy allowed: no.
Tests/checks required: Narrow lint/build/type check if app code changed.
Visual/browser QA required: yes. Capture desktop and mobile screenshots.
Stop condition: Source of truth is unclear, or production and mockup disagree.
Exact approval needed before commit/push/merge/deploy: "approved to commit UI parity", "approved to push UI parity", and exact production deploy phrase if deploy is later requested.

## Billing/payment work

Task: Change billing, payment, subscription, trial, entitlement, or renewal behavior.
Expected outcome: User-visible billing state and server-side entitlement state agree.
Source of truth: Payment dashboard or test fixture, database entitlement row, production behavior, and billing spec.
Files likely in scope: Payment API routes, webhook handlers, entitlement helpers, billing UI, tests.
Files explicitly out of scope: Unrelated onboarding, chat, voice, design cleanup, production DB mutation.
Production touched: no unless the user says the exact production DB phrase.
Deploy allowed: no unless the user says the exact production deploy phrase.
Tests/checks required: Unit/integration tests for changed billing paths, webhook verification, entitlement readback.
Visual/browser QA required: yes if billing UI changes.
Stop condition: A real payment, customer, subscription, or production entitlement could change.
Exact approval needed before commit/push/merge/deploy: "approved to commit billing change", "approved to push billing change", `approved for production DB mutation`, `approved to deploy production`.

## Database migration work

Task: Add or change schema, access rules, functions, triggers, policies, or seed data.
Expected outcome: Migration applies cleanly and database behavior is verified with real queries.
Source of truth: Existing migrations, database schema, access rules, affected product spec.
Files likely in scope: `migrations/*`, database tests, typed DB helpers.
Files explicitly out of scope: Production DB mutation, unrelated app routes, deploy config.
Production touched: no unless the user says the exact production DB phrase.
Deploy allowed: no unless the user says the exact production deploy phrase.
Tests/checks required: Migration dry run or local apply, direct query proof, access checks when relevant.
Visual/browser QA required: only if user-visible behavior changes.
Stop condition: Migration is destructive, backfill is needed, access impact is unclear, or local verification is unavailable.
Exact approval needed before commit/push/merge/deploy: "approved to commit migration", "approved to push migration", `approved for production DB mutation`, `approved to deploy production`.

## Auth/session work

Task: Change login, logout, OAuth, session, role, or user access behavior.
Expected outcome: Users keep access only to their own data and expected roles.
Source of truth: Auth spec, provider dashboard, production behavior, and session tests.
Files likely in scope: Auth routes, middleware, callback handlers, session helpers, user-facing auth UI, tests.
Files explicitly out of scope: Billing, unrelated onboarding, deploy config, production auth dashboard changes.
Production touched: no.
Deploy allowed: no unless the user says the exact production deploy phrase.
Tests/checks required: Login, logout, callback, refresh/resume, expired session, cross-user access check.
Visual/browser QA required: yes if auth UI changes.
Stop condition: Redirect URIs, provider credentials, roles, or production auth settings must change.
Exact approval needed before commit/push/merge/deploy: "approved to commit auth change", "approved to push auth change", `approved to deploy production`.

## Production hotfix

Task: Fix one confirmed production bug with the smallest safe patch.
Expected outcome: The production symptom is gone and no adjacent critical path regressed.
Source of truth: Production behavior, logs, monitoring, user report, or verified failing endpoint.
Files likely in scope: The smallest file set that owns the failing behavior.
Files explicitly out of scope: Cleanup, refactors, new features, style changes, unrelated tests.
Production touched: maybe, only after exact approval.
Deploy allowed: maybe, only after exact approval.
Tests/checks required: Reproduce the failure, add or run the narrowest check, verify fixed behavior.
Visual/browser QA required: yes if the bug is visual or flow-based.
Stop condition: Root cause is not clear, patch grows past named scope, or rollback path is unknown.
Exact approval needed before commit/push/merge/deploy: "approved to commit hotfix", "approved to push hotfix", `approved for production DB mutation`, `approved to deploy production`.

## Copy-only change

Task: Change only user-visible text or docs copy.
Expected outcome: Copy matches approved language and the requested voice.
Source of truth: User wording, approved copy doc, legal draft, or visible current page.
Files likely in scope: Copy constants, markdown, legal docs, single component text.
Files explicitly out of scope: Layout, logic, DB, API, billing, auth, deploy config.
Production touched: no.
Deploy allowed: no.
Tests/checks required: Read changed text in context, run formatter or narrow lint if needed.
Visual/browser QA required: yes if copy length could break layout.
Stop condition: Copy changes meaning, legal claims, pricing, medical/safety, or consent language.
Exact approval needed before commit/push/merge/deploy: "approved to commit copy", "approved to push copy", and exact production deploy phrase if deploy is later requested.

## Read-only audit

Task: Inspect code, docs, settings, product behavior, or a PR without editing.
Expected outcome: Findings are ranked by risk with file, line, or URL proof.
Source of truth: Current repo, target branch, live surface, logs, docs, or PR diff.
Files likely in scope: none.
Files explicitly out of scope: All edits, commits, pushes, deploys, production DB mutation.
Production touched: no.
Deploy allowed: no.
Tests/checks required: Read-only commands only. Use network or browser only when needed for proof.
Visual/browser QA required: only if auditing a visual surface.
Stop condition: The audit requires credentials, destructive commands, or a write action.
Exact approval needed before commit/push/merge/deploy: A new explicit task approval, then a fresh lane, before any edit.

## Release/ship workflow

Task: Prepare, review, push, PR, merge, deploy, or verify a release.
Expected outcome: The intended branch ships with checks, review, rollback plan, and post-ship verification.
Source of truth: Current branch diff, target branch, CI checks, deploy target, changelog, production endpoint.
Files likely in scope: Release notes, changelog, version file, PR body, only if the release process requires them.
Files explicitly out of scope: Feature changes, drive-by cleanup, production DB mutation unless separately approved.
Production touched: maybe, only after exact approval.
Deploy allowed: maybe, only after exact approval.
Tests/checks required: `git diff --stat`, relevant test suite, PR checks, deploy verification if approved.
Visual/browser QA required: yes if user-visible UI changed.
Stop condition: Dirty unrelated files, failing checks, unclear rollback, unreviewed high-risk diff, or missing approval.
Exact approval needed before commit/push/merge/deploy: "approved to commit release prep", "approved to push current commit", `approved to deploy production`, and separate merge approval if requested.
