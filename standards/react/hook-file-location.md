# Hook File Location

All custom hooks must be placed in a `hooks/` subdirectory within their module.

## Pattern

```
features/faculty/
├── components/
├── hooks/
│   └── useFaculty.ts
├── types.ts
└── index.ts

foundation/pages/
├── hooks/
│   ├── usePage.ts
│   └── usePagesOfType.ts
├── types/
└── index.ts
```

## Rules

- **Always in `hooks/` subdirectory** — Never place hooks flat in module root
- **No inline hooks** — Extract reusable logic into separate hook files
- **One hook per file** — Each hook gets its own file matching the hook name

## File Naming

Hook file names match the hook function name:
```
usePage.ts → export function usePage()
useFaculty.ts → export function useFaculty()
useColorMode.ts → export function useColorMode()
```

## Not This

```
// ❌ Hook in module root
features/faculty/
├── components/
├── useFaculty.ts  // Wrong location
└── index.ts

// ❌ Inline hook in component
export function MyComponent() {
    const useCustomLogic = () => { ... }  // Extract to hooks/
}
```

## Why Hooks Subdirectory?

- **Consistent organization** — Hooks always in predictable location
- **Clear separation** — Distinguishes hooks from components and utilities
- **Scalability** — Easy to find and manage as hooks grow
