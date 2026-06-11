# One Test, One Thing

Each test verifies exactly one behavior. A failure points at a single, specific problem.

## Pattern

```typescript
// ✅ Three behaviors, three tests — a failure names the broken one
it("applies the discount to the cart total", () => { ... })

it("rejects an expired discount code", () => { ... })

it("keeps the original total when the code is rejected", () => { ... })
```

Multiple assertions are fine when they verify facets of the *same* behavior:

```typescript
// ✅ Still one behavior: the shape of a successful parse
const result = parseMoney("19.99")
expect(result.ok).toBe(true)
expect(result.value.amount).toBe(1999)
expect(result.value.currency).toBe("USD")
```

## Why

- A red test should be a diagnosis, not the start of an investigation.
- Multi-behavior tests stop at the first failed assertion — the later behaviors are silently untested until the first is fixed.

## Not This

```typescript
// ❌ One test, four behaviors — name can only be vague, failure is ambiguous
it("handles discounts", () => {
  expect(applyDiscount(cart, "SAVE10").value.total).toBe(90)
  expect(applyDiscount(cart, "EXPIRED").ok).toBe(false)
  expect(applyDiscount(emptyCart, "SAVE10").ok).toBe(false)
  expect(applyDiscount(cart, "SAVE10").value.items).toHaveLength(2)
})
```
