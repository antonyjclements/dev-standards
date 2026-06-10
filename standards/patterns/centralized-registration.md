# Centralized Registration

All registry registrations happen in `src/app/register-services.ts`.

## Pattern

```typescript
// src/app/register-services.ts
export function registerServices() {
  // Slice registry
  const sliceRegistry = createSliceRenderRegistry();
  sliceRegistry.register('mission', () => MissionSliceRenderer);
  sliceRegistry.register('bento_grid', () => BentoSliceRenderer);
  SynDiContainer.bindFactory(SliceRenderRegistrySymbol, () => sliceRegistry);

  // Content component registry
  const contentComponentRegistry = createContentComponentRegistry();
  contentComponentRegistry.register('paragraph', () => ParagraphContentRenderer);
  SynDiContainer.bindFactory(ContentComponentRegistrySymbol, () => contentComponentRegistry);
}
```

## Rules

- **All registrations in one place** — Never register outside `register-services.ts`
- **Called at app startup** — `registerServices()` runs before app renders
- **Group by registry type** — Keep slice registrations together, content registrations together

## Common Mistake

**Forgetting to register** — Most common error when adding new slices/components:

1. Create new slice component ✅
2. Export from module ✅
3. **Forget to register in `register-services.ts`** ❌
4. Component doesn't render, no error thrown

## Checklist for New Slices

- [ ] Create slice component
- [ ] Export from module's `index.ts`
- [ ] **Add registration in `register-services.ts`**
- [ ] Import component at top of `register-services.ts`
