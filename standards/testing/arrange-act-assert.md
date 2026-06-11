# Arrange, Act, Assert

Every test has three phases — Arrange, Act, Assert — separated by blank lines.

## Pattern

```typescript
it("applies the discount when the code is active", () => {
  const cart = CartMother.withItems(2)
  const code = DiscountMother.active("SAVE10")

  const result = applyDiscount(cart, code)

  expect(result.ok).toBe(true)
  expect(result.value.total).toBe(90)
})
```

- **Arrange** — build the world the behavior needs (use object mothers, see `object-mothers`).
- **Act** — one line, the behavior under test.
- **Assert** — verify the outcome.

## Rules

- **Blank lines separate the phases** — no comments needed; the structure is the signpost.
- **One Act per test** — an act-assert-act-assert chain is multiple tests wearing one name (see `one-test-one-thing`).
- **Missing Arrange is fine** for pure functions of literals; the blank-line rhythm still applies between Act and Assert.
- If Arrange dwarfs the test, the setup wants an object mother or the unit wants a simpler design.

## Not This

```typescript
// ❌ Phases interleaved — unreadable and secretly three tests
it("cart behaviors", () => {
  const cart = makeCart()
  expect(cart.items).toHaveLength(0)
  cart.items.push(item)
  expect(cartTotal(cart)).toBe(10)
  const result = applyDiscount(cart, "SAVE10")
  expect(result.ok).toBe(true)
})
```
