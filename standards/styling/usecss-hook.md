# useCss Hook for Theming

Use the `useCss()` hook for dynamic theme-aware colors, direct Tailwind classes for static styles.

## Pattern

```typescript
import { useCss } from "@foundation/ui";

export function MyComponent() {
    const css = useCss();
    
    return <div className={`${css.bg} ${css.text}`}>
        <p className={css.mdText}>Dynamic themed content</p>
        <button className="px-4 py-2 rounded-lg">Static styles</button>
    </div>
}
```

## Available CSS Properties

```typescript
const css = useCss();

css.colorMode    // "dark" | "light"
css.bg           // bg-gray-200 | bg-gray-900
css.text         // text-gray-900 | text-gray-50
css.mdText       // text-gray-600 | text-gray-400
css.hoverText    // text-gray-700 | text-gray-400
css.border       // border-gray-200 | border-gray-800
css.bgAlt1       // bg-gray-100 | bg-gray-800
css.bgAlt2       // bg-gray-200 | bg-gray-700
css.bgAlt3       // bg-gray-300 | bg-gray-600
```

## When to Use

- **Use `useCss()`** — For colors that change based on theme
- **Use direct classes** — For static styles (spacing, sizing, layout)
- **Use direct classes** — For brand colors that don't change with theme

## Examples

**Dynamic colors:**
```typescript
const css = useCss();
<div className={css.bg}>  // Changes with theme
```

**Static styles:**
```typescript
<div className="px-6 py-4 rounded-lg">  // Always the same
```

**Brand colors:**
```typescript
<button className="bg-primary text-white">  // Brand colors stay consistent
```
