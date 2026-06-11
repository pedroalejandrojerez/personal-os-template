# Auth QA Checklist

Use for login, logout, OAuth, callback, session, roles, invite, or account access changes.

## Source Of Truth

- Auth spec, provider dashboard, production behavior, and session tests.

## Surfaces

- Login, logout, callback, and refresh/resume paths.
- Protected routes and role-gated surfaces.

## Failures To Catch

- Users land on the wrong route after auth.
- Expired sessions look logged in.
- Cross-user data appears.
- OAuth deny or error path leaves users stuck.

## Checks

- Login and logout.
- OAuth success, deny, and callback error when relevant.
- Refresh a protected route.
- Test one allowed role and one blocked role.
- Verify no route leaks another user's data.

## Report

- PASS or FAIL for login, logout, callback, refresh, role gate, and data isolation.

## Stop And Ask

- Redirect URIs, provider credentials, production auth settings, or role rules must change.
