# Hook Naming Convention

All custom hooks use the `use` prefix followed by a PascalCase descriptive name.

## Pattern

```typescript
// ✅ Correct hook names
export function usePage() { }
export function useFaculty() { }
export function useColorMode() { }
export function useSiteSettings() { }
```

## Rules

- **Always start with `use`** — Required prefix for all hooks
- **PascalCase after `use`** — Descriptive name in PascalCase
- **No exceptions** — Every custom hook follows this pattern
- **Descriptive names** — Name describes what the hook does or provides

## Examples

**Data-fetching hooks:**
```typescript
export function usePage<T extends Page>(type: T["_type"], uid: string) { }
export function useFaculty() { }
export function useEvents() { }
```

**Utility hooks:**
```typescript
export function useColorMode() { }
export function useCss() { }
export function useMedia() { }
```

**DI hooks:**
```typescript
export function useSliceRegistry() { }
```

## Not This

```typescript
// ❌ Missing 'use' prefix
export function getPage() { }
export function colorMode() { }

// ❌ Wrong casing
export function usecolormode() { }
export function use_page() { }
```
