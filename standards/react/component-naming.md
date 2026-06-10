# Component Naming

Follow consistent naming conventions for React components.

## Slice Renderers

Components that render Prismic slices must end with `SliceRenderer`:

```typescript
export function MissionSliceRenderer({value}: SliceRendererProps) {
    // ...
}

export function ContentSliceRenderer({value}: SliceRendererProps) {
    // ...
}
```

## Other Components

Use descriptive PascalCase names without strict suffix requirements:

```typescript
export function Button({variant, size}: ButtonProps) { }
export function TextInput({value, onChange}: TextInputProps) { }
export function Hero({title, subtitle}: HeroProps) { }
```

## Naming Guidelines

- **PascalCase** — All component names use PascalCase
- **Descriptive** — Name describes what the component does/displays
- **No abbreviations** — Use full words (e.g., `Button` not `Btn`)
- **Domain-specific** — Include domain context when helpful (e.g., `ClassBrief`, `EventBrief`)

## File Names

Component file names match component names:
```
MissionSliceRenderer.tsx
Button.tsx
TextInput.tsx
```

## Not This

```typescript
// ❌ Missing SliceRenderer suffix for slice
export function Mission({value}: SliceRendererProps) { }

// ❌ Inconsistent casing
export function buttonComponent() { }

// ❌ Abbreviations
export function Btn() { }
```
