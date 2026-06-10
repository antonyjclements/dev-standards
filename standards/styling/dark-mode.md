# Dark Mode Support

All color-related classes must include `dark:` variants for dark mode support.

## Pattern

```typescript
// ✅ Always include dark: variant
<div className="bg-gray-200 text-gray-900 dark:bg-gray-900 dark:text-gray-50">
    Content
</div>

<p className="text-gray-600 dark:text-gray-400">
    Secondary text
</p>
```

## Rules

- **Always include `dark:` variant** — Every color class needs a dark mode equivalent
- **No exceptions** — Even decorative elements must support dark mode
- **Test both modes** — Verify appearance in light and dark mode

## Common Color Pairs

```typescript
// Background
bg-gray-200 dark:bg-gray-900
bg-gray-100 dark:bg-gray-800
bg-white dark:bg-gray-900

// Text
text-gray-900 dark:text-gray-50
text-gray-600 dark:text-gray-400
text-gray-700 dark:text-gray-300

// Borders
border-gray-200 dark:border-gray-800
border-gray-300 dark:border-gray-700
```

## Not This

```typescript
// ❌ Missing dark mode variant
<div className="bg-gray-200 text-gray-900">
    Content
</div>

// ❌ Inconsistent contrast in dark mode
<div className="bg-gray-900 text-gray-800 dark:bg-gray-100 dark:text-gray-200">
    Low contrast in both modes
</div>
```

## Dark Mode Detection

Dark mode is automatically detected via system preferences using `useColorMode()` hook.
