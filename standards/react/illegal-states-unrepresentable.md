# Make Illegal States Unrepresentable

Use the type system to prevent invalid states from existing — discriminated unions for state shapes, branded types for identifiers.

## Discriminated unions

```typescript
// ✅ "submitted with no answer" cannot be constructed
type Submission =
  | { status: "draft" }
  | { status: "submitted"; answer: Answer; submittedAt: Date }
  | { status: "graded"; answer: Answer; submittedAt: Date; score: number }
```

```typescript
// ❌ Allows score without answer, submittedAt on a draft, etc.
type Submission = {
  status: string
  answer?: Answer
  submittedAt?: Date
  score?: number
}
```

## Branded types

```typescript
// ✅ A UserId can't be passed where an OrderId is expected
type UserId = string & { readonly __brand: "UserId" }
type OrderId = string & { readonly __brand: "OrderId" }

function userId(raw: string): UserId { return raw as UserId }

fetchOrder(user.id)   // ❌ compile error — caught the swapped-ID bug
```

## Rules

- **If a combination of fields is invalid, restructure so it can't be expressed** — optional-field soup is the smell (see `typescript/discriminated-unions`).
- **Brand IDs and unit-bearing values** (`Money`, `Email`, `Iso8601`) where mixing them up is a plausible bug.
- **Constructor functions are the only way to mint a branded value**, which is where validation lives (see `typescript/factories`).
