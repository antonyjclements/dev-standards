# Stable Dependencies Principle

Dependencies point toward stability. Volatile code depends on stable code — never the reverse.

## The gradient

```
common (most stable)  ←  features  ←  app (most volatile)
```

A page can change daily; `common/ui/Button` changing breaks everything. So pages may depend on Button; Button may never depend on anything about pages.

## Rules

- **Before adding an import, ask: is the thing I'm importing more stable than me?** If not, the design is wrong.
- **When stable code needs volatile behavior, invert it** — take a callback, a render prop, or a generic parameter instead of importing the volatile thing:

```tsx
// ✅ Stable List doesn't import volatile OrderRow — it receives it
<List items={orders} renderItem={(order) => <OrderRow order={order} />} />
```

- **Stability is earned by abstraction** — if a module must be widely depended on, make it abstract enough to stop changing (see `stable-abstractions-principle`).

## Not This

```typescript
// ❌ common importing from a feature — the most stable layer now
// changes whenever the checkout domain does
// in src/common/ui/SummaryCard.tsx
import { CartTotals } from "@features/checkout"
```
