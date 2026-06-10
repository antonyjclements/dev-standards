# Responses and Errors

Every response goes through shared helpers so status codes, headers, and the error envelope are consistent across the API.

## Pattern

```typescript
// lib/responses.ts
const json = (statusCode: number, body: unknown) => ({
  statusCode,
  headers: { "content-type": "application/json" },
  body: JSON.stringify(body),
})

export const ok = (data: unknown) => json(200, data)
export const created = (data: unknown) => json(201, data)
export const noContent = () => ({ statusCode: 204, body: "" })

export function handleError(err: unknown) {
  if (err instanceof ValidationError) return json(400, { error: "invalid_request", details: err.fields })
  if (err instanceof NotFoundError)   return json(404, { error: "not_found" })
  console.error(err)                              // log the real cause
  return json(500, { error: "internal_error" })  // never leak internals
}
```

## Rules

- **Use the helpers** — handlers never build raw `{ statusCode, body }` objects.
- **Error envelope is `{ error, details? }`** with a stable machine-readable `error` code.
- **Map known errors to status codes** in one place (`handleError`).
- **Never leak internals** — stack traces and messages go to logs, not the client.
- **Log before returning 500** so the cause is recoverable from CloudWatch.

## Not This

```typescript
// ❌ Leaks the error message and uses the wrong status code
return { statusCode: 200, body: JSON.stringify({ error: err.message }) }
```
