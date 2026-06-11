# UI Source Of Truth QA Checklist

Use before visual edits, mockup parity work, or production versus design comparisons.

## Source Of Truth

- Name one source only: production behavior, preview deploy, approved mockup, design-system HTML, spec file, screenshot, or user-visible copy.
- Localhost is a viewer, not the source of truth.

## Surfaces

- The source surface and the changed surface.
- Desktop and mobile widths.
- The exact route or file that renders the surface.

## Failures To Catch

- Production versus design mismatch is ignored.
- Agent edits a stale mockup or wrong workspace.
- Copy, spacing, or controls match one viewport but break another.
- Text overlaps, wraps badly, or creates a dangling single-word line.

## Browser And Device Checks

- Capture before and after screenshots when UI changed.
- Check mobile width, desktop width, and any sticky header/footer area.
- Check state-dependent content when the UI depends on user data.

## Report

- Name the source of truth first.
- PASS or FAIL for route/file match, desktop, mobile, copy fit, and state-dependent content.

## Stop And Ask

- The source of truth is unclear.
- Production and mockup disagree and the user did not choose which wins.
