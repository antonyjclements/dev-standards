# Function Declarations

Top-level functions use `function` declarations, not arrow functions.

## Pattern

```typescript
// ✅
export function calculateTotal(items: LineItem[]): Money {
  return items.reduce(addLinePrice, zeroMoney())
}
```

## Why

- **Better stack traces** — the function name is always present in errors and profiles.
- **Hoisting** — files read top-down: public functions first, helpers below.
- **Clear intent** — `function` at the start of a line signals a unit of behavior; `const` signals a value.

## Not This

```typescript
// ❌ Top-level arrow assigned to a const
export const calculateTotal = (items: LineItem[]): Money => {
  return items.reduce(addLinePrice, zeroMoney())
}
```

## Exception

Arrow functions are fine where a function is a value, not a top-level unit:

```typescript
// ✅ Inline callbacks
items.filter((item) => item.quantity > 0)

// ✅ Local handlers inside a component or function body
const handleClick = () => setOpen(true)
```
