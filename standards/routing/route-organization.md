# Route Organization

All routes defined in centralized `router.tsx`, page components in `app/pages/[page-name]/index.tsx`.

## Pattern

```typescript
// app/pages/router.tsx
import { HomePage } from "./home";
import { ClassPage } from "./class";
import { EventsPage } from "./events";

export const routes = [
  { path: "/", element: <HomePage /> },
  { path: "/classes/:slug", element: <ClassPage /> },
  { path: "/events", element: <EventsPage /> },
  { path: "*", element: <NotFound /> }
];
```

## File Structure

```
app/pages/
├── router.tsx           # All route definitions
├── home/
│   └── index.tsx       # HomePage component
├── class/
│   └── index.tsx       # ClassPage component
├── events/
│   └── index.tsx       # EventsPage component
└── not-found/
    └── index.tsx       # NotFound component
```

## Rules

- **Single router file** — All routes in `app/pages/router.tsx`
- **Kebab-case folders** — Page folders use kebab-case (e.g., `contact-us`, `not-found`)
- **Index.tsx pattern** — Each page folder contains `index.tsx` with page component
- **Catch-all route last** — `{ path: "*", element: <NotFound /> }` must be last

## Route Patterns

**Static routes:**
```typescript
{ path: "/", element: <HomePage /> }
{ path: "/faculty", element: <Faculty /> }
```

**Dynamic routes:**
```typescript
{ path: "/classes/:slug", element: <ClassPage /> }
{ path: "/events/:slug", element: <EventPage /> }
```

**Nested dynamic routes:**
```typescript
{ path: "/classes/:group/:slug", element: <ClassPage /> }
```

## Not This

```typescript
// ❌ Routes scattered in multiple files
// app/pages/class/routes.tsx
export const classRoutes = [...]

// ❌ camelCase folder names
app/pages/contactUs/  // Wrong
app/pages/contact-us/  // Correct
```
