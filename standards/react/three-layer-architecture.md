# Three-Layer Architecture

The codebase has three layers — `app`, `features`, `common` — with strict one-directional dependencies.

## Dependency Direction

```
app → features → common        (imports flow left to right only)
common → features → app        (stability: most stable → least stable)
```

## Layer Responsibilities

**App (`src/app/`)**
- Routing, page composition, providers, wiring
- Orchestrates features; the only layer that may import from any feature
- Most volatile — nothing imports from app

**Features (`src/features/`)**
- Business domains (checkout, accounts, schedule)
- May import from `common` only
- **Never from another feature** (see `cross-feature-dependency-resolution`)

**Common (`src/common/`)**
- Reusable, abstract infrastructure: UI primitives, generic hooks, shared types
- **No business logic** (see `common-design-principles`)
- Most stable — depends on nothing app-specific

## Rules

- An import that goes "rightward" (`common` importing from `features`, `features` importing from `app`) is an architecture violation, full stop.
- New code goes in the *least stable layer that works*: app if it's wiring, a feature if it's domain logic, common only when it's genuinely generic.
- When a feature needs something from another feature, the answer is composition at the app layer or extraction to common — never a cross-feature import.
