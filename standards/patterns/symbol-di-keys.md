# Symbol-based DI Keys

Use `Symbol()` for dependency injection keys to prevent collisions.

## Pattern

```typescript
// In registry file (e.g., createSliceRenderRegistry.ts)
export type SliceRenderRegistry = ReturnType<typeof createSliceRenderRegistry>;
export const SliceRenderRegistrySymbol = Symbol('SliceRenderRegistry');
```

## Why Symbols?

- **Prevent key collisions** — Symbols are guaranteed unique
- **Type safety** — Can't accidentally use wrong string key
- **Clear intent** — Symbol name documents what's being registered

## Usage

**Registration:**
```typescript
// src/app/register-services.ts
const sliceRegistry = createSliceRenderRegistry();
SynDiContainer.bindFactory(SliceRenderRegistrySymbol, () => sliceRegistry);
```

**Resolution:**
```typescript
// src/foundation/slice/SliceRender.tsx
const registry = SynDiContainer.resolve<SliceRenderRegistry>(SliceRenderRegistrySymbol);
```

## Export Location

- **Symbol** — Export from registry file alongside registry type
- **Type** — Export from same file as `ReturnType<typeof createXxx>`

## Not This

❌ String keys:
```typescript
container.bindFactory('sliceRegistry', () => sliceRegistry); // Collision risk
```
