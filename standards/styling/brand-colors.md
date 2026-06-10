# Brand Colors

Use Tailwind config aliases for brand colors instead of hex values.

## Brand Color Palette

- **Primary (Pink)** — `#ED1C7B` → Use `bg-primary`, `text-primary`, `border-primary`
- **Secondary (Teal)** — `#34BFC9` → Use `bg-secondary`, `text-secondary`, `border-secondary`
- **Accent (Yellow)** — `#FBCF2E` → Use `bg-accent`, `text-accent`, `border-accent`

## Pattern

```typescript
// ✅ Use Tailwind config aliases
<button className="bg-primary text-white hover:bg-primary/80">
    Click Me
</button>

<div className="border-secondary text-secondary">
    Secondary content
</div>
```

## Not This

```typescript
// ❌ Don't use hex values directly
<button className="bg-[#ED1C7B] text-white">
    Click Me
</button>
```

## Usage Guidelines

- **Primary** — Main CTAs, important actions, brand emphasis
- **Secondary** — Supporting actions, secondary CTAs
- **Accent** — Donation buttons, special highlights, attention-grabbing elements

## Opacity Modifiers

Use Tailwind's opacity syntax for variations:
```typescript
className="bg-primary/80"  // 80% opacity
className="hover:bg-primary/90"  // 90% on hover
```
