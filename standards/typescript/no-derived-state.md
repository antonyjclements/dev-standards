# No Derived State

Never store what you can compute. Derived values are computed at the point of use, not kept in types or runtime state.

## Pattern

```typescript
// ✅ Single source of truth; everything else is computed
type Cart = {
  items: CartItem[]
}

const total = cart.items.reduce((sum, item) => sum + item.price * item.quantity, 0)
const isEmpty = cart.items.length === 0
```

## Why

Stored derived values have two sources of truth, and they *will* disagree. Every mutation now has to remember to update the derived copies; forgetting one is a silent data bug.

## Rules

- **Types carry facts, not conclusions** — if a field can be computed from other fields, it doesn't belong on the type.
- **Compute at point of use** — a `reduce` or `filter` at render/call time is almost always cheap enough.
- **Extract a named function** when the computation is reused: `cartTotal(cart)`.
- If a computation is *measured* to be expensive, memoize it (`useMemo`, a cached selector) — that's still computing, not storing.

## Not This

```typescript
// ❌ totalPrice and isEmpty will go stale the first time someone
// updates items without recomputing them
type Cart = {
  items: CartItem[]
  totalPrice: number
  isEmpty: boolean
}
```

The React-state version of this rule is `react/minimal-state`.
