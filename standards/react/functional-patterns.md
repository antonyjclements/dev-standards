# Functional Patterns

Domain logic is pure functions over immutable data. Domain errors are `Result` values. Side effects live at the edges, in hooks.

## Pattern

```typescript
// ✅ Pure: same input, same output, nothing mutated
export function applyDiscount(cart: Cart, code: DiscountCode): Result<Cart, DiscountError> {
  if (!isActive(code)) return err({ kind: "expired_code" })

  return ok({
    ...cart,
    items: cart.items.map((item) => ({ ...item, price: discounted(item.price, code) })),
  })
}
```

```typescript
// The hook is the impure shell: it does I/O and calls the pure core
function useCheckout() {
  const submit = useMutation({ mutationFn: () => submitOrder(buildOrder(cart)) })
  ...
}
```

## Rules

- **Pure functions for domain logic** — testable with plain assertions, no mocks, no setup.
- **Immutability everywhere** — spread/`map`/`filter`, never `push`/`splice`/property assignment on shared data. Mark types `readonly` where it helps.
- **`Result` for domain errors** (see `typescript/result-types`) — pure functions don't throw for expected failures.
- **Effects at the edges** — fetching, storage, timers live in hooks; the logic they orchestrate is pure.

## Not This

```typescript
// ❌ Mutates its input and hides a side effect
function applyDiscount(cart: Cart, code: string) {
  cart.total = cart.total * 0.9      // callers' data changed under them
  analytics.track("discount")        // surprise I/O in "logic"
}
```
