# Minimal State

No derived state in `useState`. If a value can be computed from existing state or props, compute it inline at the point of use.

## Pattern

```tsx
// ✅ One source of truth, everything else computed at render
const [items, setItems] = useState<CartItem[]>([])

const total = items.reduce((sum, i) => sum + i.price * i.quantity, 0)
const isEmpty = items.length === 0
const expensiveItems = items.filter((i) => i.price > 100)
```

## Why

Stored derived state needs an effect (or discipline) to stay in sync, and it always eventually doesn't. Computing at render is correct by construction — there is nothing to forget to update.

## Rules

- **Before `useState`, ask: can this be computed?** If yes, it's a `const`, not state.
- **Re-computing on every render is fine.** Reach for `useMemo` only when the computation is *measured* to be expensive.
- **Don't mirror props into state** — use the prop. If you need a reset-on-change, use `key`.
- **Don't copy React Query data into state** — read from the query (see `react-query`).

## Not This

```tsx
// ❌ Derived state + the effect that babysits it
const [items, setItems] = useState<CartItem[]>([])
const [total, setTotal] = useState(0)

useEffect(() => {
  setTotal(items.reduce((sum, i) => sum + i.price * i.quantity, 0))
}, [items])   // extra render, sync bug waiting, useless code
```

The type-level version of this rule is `typescript/no-derived-state`.
