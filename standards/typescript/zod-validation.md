# Zod at Runtime Boundaries

Validate everything that crosses a runtime boundary with Zod, and derive the static type from the schema with `z.infer`.

## Pattern

```typescript
// schemas/user.ts
import { z } from "zod"

export const User = z.object({
  id: z.string(),
  email: z.string().email(),
  role: z.enum(["member", "admin"]),
})
export type User = z.infer<typeof User>
```

```typescript
// ✅ At the boundary: parse, don't trust
const result = User.safeParse(await response.json())
if (!result.success) return err({ kind: "invalid_response", issues: result.error.issues })
result.data // typed User
```

## Where boundaries are

- API responses and request bodies
- Form input
- `process.env` / runtime config
- localStorage, query params, file contents
- Anything from a queue, webhook, or third party

## Rules

- **Schema is the source of truth** — never hand-write a type that duplicates a schema; use `z.infer`.
- **Validate once, at the edge** — inside the app, trust the types.
- **`safeParse` + `Result`** for expected invalid input; reserve `.parse()` for config that should fail the boot.

## Not This

```typescript
// ❌ A cast is not validation
const user = (await response.json()) as User

// ❌ Parallel hand-written type drifts from the schema
type User = { id: string; email: string }   // schema also defines role
```
