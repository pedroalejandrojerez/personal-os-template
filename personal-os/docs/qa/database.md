# Database QA Checklist

Use for schema, migration, policy, trigger, function, RLS, access control, or data-shape changes.

## Source Of Truth

- Existing migrations, current schema, product spec, and access-control model.

## Surfaces

- Local database or test branch.
- API or UI paths that read or write changed data.

## Failures To Catch

- Migration does not apply cleanly.
- Access rules leak data across users or roles.
- Backfill changes the wrong rows.
- App code assumes the old schema.

## Checks

- Apply or dry-run migration locally.
- Query proof rows after key writes.
- Test allowed and blocked access.
- Test rollback or name why rollback is manual.

## Report

- PASS or FAIL for migration apply, data proof, access rules, app read/write path, and rollback plan.

## Stop And Ask

- Migration is destructive.
- Production data could change.
- Backfill scope is unclear.
