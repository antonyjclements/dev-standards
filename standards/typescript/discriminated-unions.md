# Discriminated Unions

Model states as discriminated unions. Make illegal states unrepresentable.

## Pattern

```typescript
// ✅ Each state carries exactly the data that exists in that state
type FetchState<T> =
  | { status: "idle" }
  | { status: "loading" }
  | { status: "success"; data: T }
  | { status: "error"; error: AppError }
```

```typescript
// Exhaustive handling — adding a state breaks compilation until handled
switch (state.status) {
  case "idle":     return null
  case "loading":  return <Spinner />
  case "success":  return <List data={state.data} />
  case "error":    return <ErrorBanner error={state.error} />
  default:         return assertNever(state)
}
```

## Rules

- **One discriminant field** (`status`, `kind`, `type`) with literal values.
- **State-specific data lives on its branch** — `data` only exists on `success`.
- **Switch exhaustively** with an `assertNever` default so new states can't be silently unhandled.

## Not This

```typescript
// ❌ Flag soup — allows isLoading && error && data simultaneously
type FetchState<T> = {
  isLoading: boolean
  data?: T
  error?: AppError
}
```

Eight combinations are representable; three are legal. The type system should know the difference.
