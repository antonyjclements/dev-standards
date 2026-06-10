# Three-Layer Architecture

The codebase uses a three-layer architecture: `app`, `features`, and `foundation`.

## Dependency Rules

**Stability hierarchy (most to least stable):**
```
foundation → features → app
```

- **App layer** — Most unstable, no other layer can depend on it
- **Features layer** — Mid-stability, can depend on foundation only
- **Foundation layer** — Most stable/abstract, can have cross-dependencies

## Layer Responsibilities

**App (`src/app/`):**
- Routing, page composition, service registration
- Orchestrates features and foundation modules
- Most likely to change

**Features (`src/features/`):**
- Business domain logic (slices, signup, schedule, faculty)
- **No cross-feature dependencies** — feature A cannot import from feature B
- Follows Common Closure Principle — code that changes together lives together
- Can depend on foundation layer

**Foundation (`src/foundation/`):**
- Reusable infrastructure (UI, DI, content system, pages)
- Most abstract — **no business logic**
- Can have cross-dependencies between foundation modules
- Least likely to change

## When to Use Each Layer

- **Foundation:** Shared types, UI components, framework abstractions
- **Features:** Domain-specific logic tied to business requirements
- **App:** Page-level composition, routing, initialization

Sometimes a feature has a corresponding foundation module containing the abstracted common code.
