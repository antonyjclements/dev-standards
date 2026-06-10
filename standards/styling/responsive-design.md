# Responsive Design

Use mobile-first responsive design with Tailwind's standard breakpoints.

## Breakpoints

- **Base** — Mobile styles (< 640px)
- **sm:** — Small tablets and up (≥ 640px)
- **md:** — Tablets (≥ 768px)
- **lg:** — Laptops (≥ 1024px)
- **xl:** — Desktops (≥ 1280px)
- **2xl:** — Large desktops (≥ 1536px)

## Pattern

```typescript
// ✅ Mobile-first approach
<div className="px-4 sm:px-6 lg:px-8">
    <h1 className="text-2xl sm:text-3xl lg:text-4xl">
        Responsive heading
    </h1>
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        {/* Grid items */}
    </div>
</div>
```

## Rules

- **Mobile-first** — Base styles target mobile, add breakpoints for larger screens
- **Progressive enhancement** — Start simple, add complexity at larger breakpoints
- **Test all breakpoints** — Verify layout at mobile, tablet, and desktop sizes

## Common Patterns

**Spacing:**
```typescript
className="px-4 sm:px-6 lg:px-8"  // Padding increases with screen size
className="gap-4 sm:gap-6 lg:gap-8"  // Gap increases with screen size
```

**Typography:**
```typescript
className="text-sm sm:text-base lg:text-lg"  // Font size scales up
className="text-2xl sm:text-3xl lg:text-4xl"  // Heading scales up
```

**Layout:**
```typescript
className="grid-cols-1 sm:grid-cols-2 lg:grid-cols-3"  // More columns on larger screens
className="flex-col sm:flex-row"  // Stack on mobile, row on larger screens
```

## Not This

```typescript
// ❌ Desktop-first (requires overriding at smaller sizes)
<div className="px-8 sm:px-6 px-4">  // Wrong order
```
