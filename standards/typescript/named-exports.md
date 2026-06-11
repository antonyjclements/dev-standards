# Named Exports

No default exports. Every export is named.

## Pattern

```typescript
// ✅
export function parseOrder(input: unknown): Result<Order, ParseError> { ... }
export type Order = { ... }
```

```typescript
// ✅ Import names match export names, everywhere
import { parseOrder } from "@features/orders"
```

## Why

- **Consistent naming** — a default export can be imported under any name, so the same function ends up with three names across the codebase.
- **Reliable refactoring** — rename a named export and the IDE updates every import. Default exports break this.
- **Better autocomplete and grep** — one canonical name to search for.

## Not This

```typescript
// ❌
export default function parseOrder() { ... }

// ❌ The door this opens:
import parse from "./parseOrder"
import parseOrderFn from "../orders/parseOrder"
import whatever from "@features/orders/parseOrder"
```

## Exception

None. Framework files that force a default export (some routing conventions) are the only tolerated case, and they should re-export a named function:

```typescript
export default HomePage  // where HomePage is a named function declared above
```
