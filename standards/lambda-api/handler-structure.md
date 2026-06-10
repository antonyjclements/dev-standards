# Handler Structure

Lambda handlers are thin. They parse and validate input, call a service, and shape the response. Business logic lives in services, not handlers.

## Pattern

```typescript
// handlers/createUser.ts
import { parse } from "../lib/http"
import { CreateUserInput } from "../schemas/user"
import { createUser } from "../services/user"
import { ok, created, handleError } from "../lib/responses"

export async function handler(event: ApiEvent) {
  try {
    const input = parse(CreateUserInput, event.body)
    const user = await createUser(input)
    return created(user)
  } catch (err) {
    return handleError(err)
  }
}
```

## Rules

- **One handler per route/operation** — no multiplexing many operations behind one function.
- **No business logic in the handler** — validate, delegate, respond.
- **No direct AWS SDK calls in the handler** — those live in services or adapters.
- **Always wrap in try/catch** and route errors through a single `handleError`.

## Not This

```typescript
// ❌ Validation, DB access, and business rules all inline in the handler
export async function handler(event) {
  const body = JSON.parse(event.body)              // unvalidated
  const item = await dynamo.put({ ... }).promise() // SDK in handler
  if (body.role === "admin") { /* business rule */ }
  return { statusCode: 200, body: JSON.stringify(item) }
}
```
