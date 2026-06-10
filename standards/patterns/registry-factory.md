# Registry Factory Pattern

Registries use factory functions instead of direct component references.

## Pattern

```typescript
// ✅ Register with factory function
registry.register('slice_type', () => MySliceRenderer);

// ❌ Don't register directly
registry.register('slice_type', MySliceRenderer);
```

## Why Factories?

- **Lazy evaluation** — Components aren't imported until needed
- **Breaks circular dependencies** — Factory delays evaluation until runtime
- **Consistent pattern** — All registrations follow same structure

## Example

```typescript
// src/app/register-services.ts
const sliceRegistry = createSliceRenderRegistry();
sliceRegistry.register('mission', () => MissionSliceRenderer);
sliceRegistry.register('bento_grid', () => BentoSliceRenderer);
```

## Registry Implementation

```typescript
function register(sliceType: string, renderer: () => React.FC<Props>) {
    registry.set(sliceType, renderer);
}

function createRenderer(slice: Slice) {
    const renderer = registry.get(slice.slice_type);
    return renderer(); // Call factory here
}
```

## Common Mistake

❌ Forgetting the arrow function wrapper:
```typescript
registry.register('mission', MissionSliceRenderer); // Wrong
```
