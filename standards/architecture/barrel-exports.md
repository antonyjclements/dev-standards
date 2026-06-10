# Barrel Exports

Every module has an `index.ts` that exports only its public API.

## Rules

- **Export only public API** — Hide internal implementation details
- **No wildcard re-exports of internals** — Be explicit about what's public
- **Import from module root** — Other modules import from the barrel, not deep paths

## Examples

**Good:**
```typescript
// src/features/slice/mission/index.ts
export * from "./components/MissionSliceRenderer"
// types.ts not exported if only used internally
```

**Good:**
```typescript
// src/features/slice/class-details/index.ts
export * from "./components/ClassDetailsRenderer"
export * from "./types"
export * from "./components/ClassBrief"
```

**Bad:**
```typescript
// ❌ Don't export everything indiscriminately
export * from "./components/InternalHelper"
export * from "./utils/privateHelpers"
```

**Bad:**
```typescript
// ❌ Don't import from deep paths
import { MissionSliceRenderer } from "@features/slice/mission/components/MissionSliceRenderer"

// ✅ Import from barrel
import { MissionSliceRenderer } from "@features/slice"
```

## What to Export

- Main components/functions that other modules need
- Types used in public APIs
- Hooks, factories, validators if used externally

## What NOT to Export

- Helper components used only within the module
- Internal utility functions
- Types only used internally
