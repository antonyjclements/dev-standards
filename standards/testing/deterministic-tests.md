# Deterministic Tests

A test produces the same result on every run, on every machine. Mock the clock, mock the network, and never assert against random data.

## Pattern

```typescript
// ✅ Frozen time
beforeEach(() => {
  vi.useFakeTimers()
  vi.setSystemTime(new Date("2026-06-01T09:00:00Z"))
})
afterEach(() => vi.useRealTimers())

it("marks the invoice overdue 30 days after issue", () => { ... })
```

```typescript
// ✅ Mocked network — no real calls in unit tests
vi.mock("./api", () => ({ fetchOrders: vi.fn().mockResolvedValue([OrderMother.default()]) }))
```

```typescript
// ✅ Fixed, meaningful fixtures
const order = OrderMother.with({ total: 100 })
expect(applyDiscount(order, "SAVE10").value.total).toBe(90)
```

## Rules

- **Mock dates with `vi.setSystemTime()`** — never compare against `new Date()` taken during the test.
- **Mock all network calls** — a unit test that hits the network is a flake with latency.
- **No random data in assertions** — faker-style data is fine for irrelevant fields, never for values the assertion depends on.
- **No order dependence** — every test passes alone and under `--shuffle` (see `self-contained-tests`).

## Not This

```typescript
// ❌ Passes until midnight, fails after
expect(invoice.dueDate).toEqual(addDays(new Date(), 30))

// ❌ Random value in an assertion
const amount = faker.number.int()
expect(formatMoney(amount)).toBe(`$${amount}.00`)   // sometimes 4 digits, sometimes 7
```
