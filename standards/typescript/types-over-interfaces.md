# Types Over Interfaces

Always use `type`. Never use `interface`.

## Pattern

```typescript
// ✅
type User = {
  id: string
  name: string
}

type Status = "active" | "archived"
type WithTimestamps<T> = T & { createdAt: Date; updatedAt: Date }
```

## Why

- **More powerful** — types express unions, intersections, mapped types, and conditional types. Interfaces can't.
- **No declaration merging** — interfaces with the same name silently merge. That's a bug vector, not a feature:

```typescript
// ❌ Two declarations, zero errors — Config now requires both fields
interface Config { url: string }
interface Config { retries: number }
```

- **One keyword everywhere** — no "when do I use which" debates in review.

## Not This

```typescript
// ❌
interface User {
  id: string
  name: string
}

// ❌ extends — use intersection instead
interface AdminUser extends User { role: "admin" }

// ✅
type AdminUser = User & { role: "admin" }
```
