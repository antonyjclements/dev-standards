# Result Types

Operations that can fail return `Result<T, E>`. Error handling is explicit and the compiler makes it required.

## Pattern

```typescript
type Result<T, E> =
  | { ok: true; value: T }
  | { ok: false; error: E }

export function ok<T>(value: T): Result<T, never> {
  return { ok: true, value }
}

export function err<E>(error: E): Result<never, E> {
  return { ok: false, error }
}
```

```typescript
type ParseMoneyError = { kind: "invalid_format" } | { kind: "negative_amount" }

export function parseMoney(input: string): Result<Money, ParseMoneyError> { ... }

const result = parseMoney(raw)
if (!result.ok) {
  return result            // propagate, or map the error
}
result.value               // narrowed to Money
```

## Rules

- **Expected failures return `Result`** — validation, parsing, not-found, domain rule violations.
- **Throwing is for bugs** — broken invariants and programmer errors may throw; control flow never does.
- **Errors are typed** — `E` is a discriminated union of failure cases, not `Error` or `string`.
- **Callers must branch on `ok`** before touching `value`. The type system enforces it.

## Not This

```typescript
// ❌ Throwing for an expected failure — invisible in the signature
function parseMoney(input: string): Money {
  if (!isValid(input)) throw new Error("invalid")
  ...
}

// ❌ Sentinel values
function parseMoney(input: string): Money | null
```
