# Local State

State lives at the lowest component that needs it. Lift only when sharing is actually required.

## Pattern

```tsx
// ✅ Only SearchInput cares about the draft text — it owns it
function SearchInput({ onSearch }: SearchInputProps) {
  const [draft, setDraft] = useState("")
  return <input value={draft} onChange={(e) => setDraft(e.target.value)}
                onKeyDown={(e) => e.key === "Enter" && onSearch(draft)} />
}
```

```tsx
// ✅ Lifted exactly as far as the sharing requires — to the common parent
function OrdersPage() {
  const [selectedId, setSelectedId] = useState<OrderId | null>(null)
  return (
    <>
      <OrderList onSelect={setSelectedId} />
      <OrderDetail orderId={selectedId} />
    </>
  )
}
```

## Rules

- **Start local.** Move state up only when a second component genuinely needs it — and then only to the nearest common parent.
- **Don't default to context or a store.** Context is for true cross-cutting concerns (theme, auth session), not for skipping two levels of props.
- **Server state isn't local state** — that belongs to React Query (see `react-query`).
- Keeping state low also keeps re-renders low: a keystroke in `SearchInput` shouldn't re-render the page.

## Not This

```tsx
// ❌ Page-level state for an input only one child uses
function OrdersPage() {
  const [draft, setDraft] = useState("")        // hoisted "just in case"
  return <SearchInput value={draft} onChange={setDraft} ... />
}
```
