# No `any`. Use `unknown`.

`any` is banned everywhere. When a type is genuinely indeterminate, use `unknown` and narrow it with type guards.

## Pattern

```typescript
// ✅ unknown forces you to prove the shape before using it
function parseJson(raw: string): unknown {
  return JSON.parse(raw)
}

function isUser(value: unknown): value is User {
  return typeof value === "object" && value !== null && "id" in value
}

const data = parseJson(raw)
if (isUser(data)) {
  data.id // narrowed, type-safe
}
```

At runtime boundaries, prefer Zod over hand-written guards (see `zod-validation`).

## Why

- `any` disables the type checker for everything it touches, and it spreads through inference.
- `unknown` is the honest version of the same claim: "I don't know what this is" — but you must check before you use it.

## Not This

```typescript
// ❌ any leaks: result, user, and everything downstream are unchecked
function parseJson(raw: string): any { return JSON.parse(raw) }
const user = parseJson(raw)
user.naem // no error, runtime bug

// ❌ Casting through any to silence errors
const order = response as any as Order
```

Enforce with `@typescript-eslint/no-explicit-any` set to `error`.
