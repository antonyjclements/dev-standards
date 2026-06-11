# Props Naming

Prop names follow four conventions: booleans use `is*`, event handlers use `on*`, render props use `render*`, refs use `*Ref`.

## Pattern

```typescript
type DialogProps = {
  // ✅ booleans: is*
  isOpen: boolean
  isDismissable: boolean

  // ✅ event handlers: on*
  onClose: () => void
  onConfirm: (result: ConfirmResult) => void

  // ✅ render props: render*
  renderFooter?: (close: () => void) => ReactNode

  // ✅ refs: *Ref
  initialFocusRef?: RefObject<HTMLElement>
}
```

## Rules

- **`is*` for booleans** — `isLoading`, `isDisabled`, `isSelected`. Reads as a yes/no question at the call site.
- **`on*` for handler props** — named for the *event* (`onSelect`), not the implementation (`handleSelect`). `handle*` is for the functions inside the component that get passed to them.
- **`render*` for render props** — signals the caller supplies JSX-producing behavior.
- **`*Ref` for refs** — `inputRef`, `containerRef`, `initialFocusRef`.

## Not This

```typescript
type DialogProps = {
  open: boolean                  // ❌ ambiguous: state or command?
  close: () => void              // ❌ handler without on*
  handleConfirm: () => void      // ❌ handle* belongs inside, not on the API
  footer: (close: () => void) => ReactNode  // ❌ function child without render*
}
```
