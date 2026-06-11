# Stable Abstractions Principle

The more stable a module is, the more abstract it must be. Common code uses generics and generic props, not concrete domain types.

## Why

Stability without abstraction is concrete code everyone depends on but nobody can change. Abstraction is what lets a stable module serve many callers *without* knowing about any of them.

## Pattern

```tsx
// ✅ common: abstract over the item type
type SelectProps<T> = {
  options: T[]
  getLabel: (option: T) => string
  getKey: (option: T) => string
  onSelect: (option: T) => void
}
export function Select<T>({ options, getLabel, getKey, onSelect }: SelectProps<T>) { ... }
```

```tsx
// Feature supplies the concrete meaning
<Select options={plans} getLabel={(p) => p.name} getKey={(p) => p.id} onSelect={choosePlan} />
```

## Rules

- **Common components and hooks are generic** — `List<T>`, `useDebounced<T>`, `Result<T, E>`.
- **Domain knowledge enters through parameters** (generics, callbacks, render props), never through imports.
- **Concrete is fine where volatile** — a feature component can be as concrete as it likes; it has one caller and changes freely.

## Not This

```tsx
// ❌ "Stable" common component hardcoding one domain
export function PlanSelect({ plans }: { plans: SubscriptionPlan[] }) { ... }
// Now common changes every time pricing does, and no other domain can use it
```
