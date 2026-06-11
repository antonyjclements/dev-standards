# Feature Module Structure

Features are organized by domain, each with the same internal shape.

## Layout

```
src/features/checkout/
  components/        # display components for this domain
  hooks/             # business logic hooks (useCheckout, useDiscounts)
  types/             # domain types
  schemas/           # Zod schemas for this domain's boundaries
  index.ts           # public API — the only entry point for outsiders
```

## Rules

- **One directory per domain**, named after the business concept (`checkout`, not `forms-v2`).
- **The barrel (`index.ts`) is the public API** — app-layer code imports from `@features/checkout`, never from deep paths inside it.
- **Inside the feature, use relative imports** between siblings.
- Subdirectories are optional until needed — a small feature can be flat; adopt the structure as it grows.
- Tests co-locate with the files they test (see `co-located-tests`).

## Not This

```
// ❌ Organized by kind instead of domain — checkout logic scattered
src/
  components/CheckoutForm.tsx
  hooks/useCheckout.ts
  types/checkout.ts
```

```typescript
// ❌ Deep import bypassing the public API
import { applyDiscount } from "@features/checkout/hooks/useDiscounts"
```
