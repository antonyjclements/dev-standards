# Cross-Feature Dependency Resolution

Features never import from other features. When feature A needs feature B, resolve it one of three ways.

## 1. Compose at the app layer

The page renders both; neither feature knows the other exists.

```tsx
// src/app/pages/account/AccountPage.tsx
<ProfilePanel />          {/* @features/profile  */}
<BillingSummary />        {/* @features/billing  */}
```

## 2. Extension points (render props / slots)

The owning feature exposes a hole; the app layer fills it.

```tsx
// @features/orders exposes a slot
<OrderDetails order={order} renderPaymentInfo={(orderId) => <PaymentBadge orderId={orderId} />} />
```

## 3. Extract to common

If both features need the same logic or types, that piece is by definition not feature-specific — move it to `common`.

## Rules

- Prefer the options in that order: composition is cheapest, extraction is the biggest commitment.
- Shared *types* between features are the most common smell — they usually belong in `common/types` or a schema.
- If two features constantly need each other, they may be one feature wrongly split — merging is allowed.

## Not This

```typescript
// ❌ In src/features/billing/
import { useProfile } from "@features/profile"
```
