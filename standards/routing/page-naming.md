# Page Component Naming

All page components use the `Page` suffix in their name.

## Pattern

```typescript
// ✅ Correct page component names
export function HomePage() { }
export function ClassPage() { }
export function EventPage() { }
export function EventsPage() { }
export function ContactUsPage() { }
export function NotFoundPage() { }
```

## Rules

- **Always use `Page` suffix** — Every page component ends with `Page`
- **PascalCase naming** — Component name in PascalCase
- **Match route purpose** — Name reflects what the page displays
- **No exceptions** — Even special pages like home use the suffix

## Naming Examples

**Single entity pages:**
```typescript
ClassPage      // /classes/:slug
EventPage      // /events/:slug
FacultyPage    // /faculty
```

**List/collection pages:**
```typescript
ClassesPage    // /classes (plural)
EventsPage     // /events (plural)
```

**Special pages:**
```typescript
HomePage       // /
NotFoundPage   // 404
ContactUsPage  // /contact-us
```

## File Exports

Page component names match their export:
```typescript
// app/pages/class/index.tsx
export function ClassPage() { }

// app/pages/home/index.tsx
export function HomePage() { }
```

## Not This

```typescript
// ❌ Missing Page suffix
export function Home() { }
export function Class() { }
export function Events() { }

// ❌ Wrong casing
export function classPage() { }
export function home_page() { }
```
