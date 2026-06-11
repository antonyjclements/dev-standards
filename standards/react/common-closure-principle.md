# Common Closure Principle

Code that changes together lives together. Group files by their reason to change — the business domain — not by what kind of file they are.

## Pattern

```
✅ Everything that changes when "checkout" changes, in one place:
src/features/checkout/
  components/CheckoutForm.tsx
  components/OrderSummary.tsx
  hooks/useCheckout.ts
  schemas/checkoutSchemas.ts
  types/checkout.ts
```

A change to checkout touches one directory. A reviewer sees the whole change in one place. Deleting the feature is `rm -rf`.

## Rules

- **Group by reason to change** — domain first, kind second (the `components/`, `hooks/` split lives *inside* the domain).
- **A change request should map to one directory.** If routine changes fan out across many directories, the grouping is wrong.
- **This is why category files are banned** (`file-naming-conventions`) — `utils.ts` collects unrelated reasons to change into one file.

## Not This

```
❌ Grouped by kind — one checkout change touches four trees
src/
  components/checkout/CheckoutForm.tsx
  hooks/useCheckout.ts
  schemas/checkout.ts
  types/checkout.ts
```
