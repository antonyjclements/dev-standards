# Function Component Declaration

Use named function exports for React components.

## Pattern

```typescript
// ✅ Named function export
export function MyComponent({prop1, prop2}: Props) {
    return <div>...</div>
}
```

## Why Named Functions?

- **Better tree-shaking** — Named exports optimize bundle size
- **Better debugging** — Component name appears in React DevTools
- **Consistent imports** — No confusion about default vs named exports
- **Better refactoring** — IDEs can reliably rename across files

## Not This

```typescript
// ❌ Arrow function with default export
const MyComponent = ({prop1, prop2}: Props) => {
    return <div>...</div>
}
export default MyComponent;

// ❌ Arrow function with named export
export const MyComponent = ({prop1, prop2}: Props) => {
    return <div>...</div>
}
```

## Exception

Arrow functions are acceptable for inline callbacks:
```typescript
const handleClick = () => {
    // inline callback logic
}
```
