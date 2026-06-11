# Factory Functions

Complex construction goes through factory functions. Defaults, derivation, and validation live in one place — and a factory that can fail returns `Result`.

## Pattern

```typescript
// ✅ One place that knows how to build a valid Order
export function createOrder(input: CreateOrderInput): Result<Order, OrderError> {
  if (input.items.length === 0) return err({ kind: "empty_order" })

  return ok({
    id: orderId(),
    items: input.items,
    status: "draft",
    createdAt: now(),
  })
}
```

```typescript
// ✅ Infallible construction still centralizes defaults
export function createDraftInvoice(customer: Customer): Invoice {
  return { id: invoiceId(), customer, lines: [], status: "draft" }
}
```

## Rules

- **Centralize construction logic** — IDs, defaults, timestamps, invariants in exactly one function.
- **Return `Result` when construction can fail** — never throw for invalid input.
- **Name them `create<Thing>`** so call sites read as intent.
- Object literals are fine for trivial shapes with no rules; the moment construction has logic, it gets a factory.

## Not This

```typescript
// ❌ Construction logic duplicated at every call site
const order = {
  id: nanoid(),                 // one site uses nanoid
  items,
  status: "draft" as const,     // another forgets the cast
  createdAt: new Date(),        // a third uses a different clock
}
```
