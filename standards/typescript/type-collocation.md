# Type Collocation

Types live close to where they're used, not in a global types folder.

## Rules

- **Shared across multiple modules** — Put in foundation module's `types.ts`
- **Shared within a feature** — Put in feature's `types.ts`
- **Single-use types** — Declare inline in the component/function file

## Examples

**Foundation shared types:**
```typescript
// src/foundation/content/types.ts
export type Image = {
    alt: string;
    url: string;
}

export type ContentComponent = ParagraphContentComponent | ImageContentComponent;
```

**Feature-level types:**
```typescript
// src/features/signup/types.ts
export type SignUpModel = {
    dancers: { ... }[],
    primaryEmail: string,
    // ...
}
```

**Inline single-use types:**
```typescript
// src/foundation/ui/forms/FormField.tsx
export function FormField({label, children, error, required}: {
    label: string, 
    children: React.ReactNode, 
    error?: string, 
    required?: boolean
}) {
    // ...
}
```

## Not This

❌ Global types folder:
```
src/
├── types/
│   ├── global.ts
│   ├── components.ts
│   └── models.ts
```

## When to Move Types

- Type used in 2+ features → Move to foundation
- Type used in 2+ files in same feature → Move to feature's `types.ts`
- Type used in 1 file → Keep inline
