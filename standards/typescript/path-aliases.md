# Path Aliases

Use `@features/` and `@foundation/` aliases for cross-module imports.

## Rules

- **Cross-module imports** — Use path aliases when importing from another module
- **Within same module** — Use relative paths for sibling files
- **No feature-to-feature imports** — Feature A cannot import from Feature B (enforced by architecture)

## Examples

**Good:**
```typescript
// In src/features/signup/components/SignUpForm.tsx
import { SlideOver } from "@foundation/ui"
import { createSignup } from "../factories/createSignup"
```

**Good:**
```typescript
// In src/app/pages/home/index.tsx
import { MissionSliceRenderer } from "@features/slice"
import { usePage } from "@foundation/pages"
```

**Bad:**
```typescript
// ❌ Don't use relative paths for cross-module imports
import { SlideOver } from "../../../foundation/ui"

// ❌ Don't import feature-to-feature
import { SignUpForm } from "@features/signup"  // from another feature
```

## Available Aliases

- `@features/` → `src/features/`
- `@foundation/` → `src/foundation/`
