# Registry Naming Convention

Registry types and symbols follow a consistent naming pattern.

## Pattern

```typescript
// Registry type: XxxRegistry
export type SliceRenderRegistry = ReturnType<typeof createSliceRenderRegistry>;
export type ContentComponentRegistry = ReturnType<typeof createContentComponentRegistry>;

// Symbol: XxxRegistrySymbol
export const SliceRenderRegistrySymbol = Symbol('SliceRenderRegistry');
export const ContentComponentRegistrySymbol = Symbol('ContentComponentRegistry');
```

## Rules

- **Type name** — `XxxRegistry` where Xxx describes what's being registered
- **Symbol name** — `XxxRegistrySymbol` matching the type name + `Symbol`
- **Symbol string** — Same as type name (without `Symbol` suffix)
- **No exceptions** — Always follow this pattern

## Examples

**Good:**
```typescript
export type SliceRenderRegistry = ReturnType<typeof createSliceRenderRegistry>;
export const SliceRenderRegistrySymbol = Symbol('SliceRenderRegistry');
```

**Bad:**
```typescript
// ❌ Inconsistent naming
export type SliceRegistry = ReturnType<typeof createSliceRenderRegistry>;
export const SLICE_RENDER_REGISTRY = Symbol('slice-registry');
```

## Type Definition Pattern

Always use `ReturnType<typeof createXxx>`:
```typescript
export type XxxRegistry = ReturnType<typeof createXxxRegistry>;
```

This ensures the type matches the actual registry implementation.
