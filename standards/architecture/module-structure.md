# Module Structure

Each feature and foundation module follows a consistent directory structure.

## Standard Structure

```
module-name/
├── components/       # React components
├── hooks/           # Custom React hooks (always a subdirectory)
├── factories/       # Factory functions (always a subdirectory)
├── validators/      # Validation logic (always a subdirectory)
├── types.ts         # Type definitions
└── index.ts         # Public API exports
```

## Rules

- **Always use subdirectories** for `hooks/`, `factories/`, `validators/` — even for a single file
- **Technology-focused organization** — group by technical concern (components, hooks, etc.)
- **`types.ts` is required** — all module types go here
- **`index.ts` is required** — defines the public API

## Examples

**Minimal module:**
```
mission/
├── components/
│   └── MissionSliceRenderer.tsx
├── types.ts
└── index.ts
```

**Complex module:**
```
signup/
├── components/
│   ├── SignUpForm.tsx
│   ├── pickers/
│   └── steps/
├── factories/
│   └── createSignup.ts
├── hooks/
├── validators/
├── types.ts
└── index.ts
```

## Not This

❌ Flat structure with mixed concerns:
```
mission/
├── MissionSliceRenderer.tsx
├── useMission.ts
├── types.ts
```
