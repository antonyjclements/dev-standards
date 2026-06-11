# Self-Contained Tests

No shared mutable state between tests. Each test creates its own prerequisites.

## Pattern

```typescript
// ✅ Every test builds its own world
it("adds an item to the cart", () => {
  const cart = CartMother.empty()

  const result = addItem(cart, ItemMother.default())

  expect(result.items).toHaveLength(1)
})

it("totals the cart", () => {
  const cart = CartMother.withItems(3)   // its own cart, not the last test's

  expect(cartTotal(cart)).toBe(30)
})
```

## Rules

- **No module-level mutable fixtures** — a `let cart` mutated across tests couples every test to the ones before it.
- **`beforeEach` is for infrastructure reset only** — clearing mocks, resetting timers, fresh render container. Never for building domain state that tests then share and mutate.
- **Every test passes alone** — `it.only` on any test must be green — and in any order.
- Use object mothers (see `object-mothers`) so per-test setup stays one line.

## Not This

```typescript
// ❌ Shared mutable fixture — test order is now load-bearing
let cart: Cart
beforeAll(() => { cart = makeCart() })

it("adds an item", () => {
  addItemInPlace(cart, item)
  expect(cart.items).toHaveLength(1)
})

it("totals the cart", () => {
  expect(cartTotal(cart)).toBe(10)   // depends on the previous test having run
})
```
