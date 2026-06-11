# Billing QA Checklist

Use for billing, payment, subscription, trial, checkout, renewal, plan, or entitlement changes.

## Source Of Truth

- Payment provider test or live dashboard, billing spec, app entitlement rows, and production behavior.

## Surfaces

- Billing UI or settings UI.
- Checkout, customer portal, webhook route, and entitlement gate.
- Production only for read-only comparison unless deploy is explicitly approved.

## Failures To Catch

- Renewal date is wrong or hidden.
- Upgrade display shows the wrong savings, price, or state.
- Trial, canceled, past-due, and active users see the wrong CTA.
- Product entitlement does not match provider state.

## Browser And Device Checks

- Desktop and mobile billing/settings UI.
- Checkout start path in test mode only.
- Return path after checkout or portal.

## Data Checks

- Verify customer, subscription, price, and period end.
- Verify entitlement or subscription mirror rows.
- Verify webhook signature checks are still enforced.

## Report

- PASS or FAIL for plan display, renewal date, upgrade CTA, checkout path, webhook, and entitlement.

## Stop And Ask

- A real customer, charge, subscription, production entitlement, or production DB row could change.
