# Request Validation

Validate everything that crosses the boundary with Zod before it reaches business logic. Parse, don't trust.

## Pattern

```typescript
// schemas/user.ts
import { z } from "zod"

export const CreateUserInput = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(120),
  role: z.enum(["member", "admin"]).default("member"),
})
export type CreateUserInput = z.infer<typeof CreateUserInput>
```

```typescript
// lib/http.ts
export function parse<T>(schema: z.ZodType<T>, body: string | null): T {
  const json = body ? JSON.parse(body) : {}
  const result = schema.safeParse(json)
  if (!result.success) throw new ValidationError(result.error)
  return result.data
}
```

## Rules

- **One schema per input** — request body, path params, and query each get a schema.
- **Infer types from schemas** — never hand-write a type that duplicates a schema.
- **Validate at the edge** — services receive already-valid, typed data.
- **A validation failure is a `400`** — map `ValidationError` to a 400 with field details, never a 500.

## Not This

```typescript
// ❌ Casting untrusted input to a type is not validation
const input = JSON.parse(event.body) as CreateUserInput
```
