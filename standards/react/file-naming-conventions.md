# File Naming Conventions

Name files by purpose, not category. `utils.ts`, `helpers.ts`, and `constants.ts` are banned.

## Pattern

```
✅ formatCurrency.ts        # one purpose, obvious content
✅ calculateShipping.ts
✅ useCheckout.ts
✅ OrderSummary.tsx
✅ orderSchemas.ts
```

## Why

Category files are dumping grounds. `utils.ts` answers "what kind of thing is in here" instead of "what does this do" — so everything ends up in it, nothing can be found in it, and it accrues unrelated reasons to change (violating `common-closure-principle`).

## Rules

- **The filename states what the code does** — a reader should predict the contents without opening it.
- **If you can't name it by purpose, it's probably two files.** Split until you can.
- **Components**: `PascalCase.tsx` matching the component name. **Hooks**: `useThing.ts`. **Everything else**: `camelCase.ts` named for its job.
- Small related constants live with the code that uses them, not in a global `constants.ts`.

## Not This

```
❌ utils.ts          # formatCurrency + debounce + parseQuery + ???
❌ helpers.ts        # same dumping ground, different name
❌ constants.ts      # 40 unrelated values with 40 reasons to change
❌ misc.ts, common.ts, shared.ts (as filenames)
```
