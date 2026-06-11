# React Query for Async

All async server state goes through React Query. Never `useEffect` + `useState` for data fetching.

## Pattern

```typescript
// ✅ Reads
const { data, isPending, error } = useQuery({
  queryKey: ["orders", customerId],
  queryFn: () => fetchOrders(customerId),
})
```

```typescript
// ✅ Writes — and cache invalidation in one place
const queryClient = useQueryClient()
const createOrder = useMutation({
  mutationFn: postOrder,
  onSuccess: () => queryClient.invalidateQueries({ queryKey: ["orders"] }),
})
```

## Why

Hand-rolled fetching re-implements (badly) what React Query already does: caching, deduplication, races on unmount, refetching, retries, loading/error states. Every `useEffect` fetch is a future bug about one of those.

## Rules

- **`useQuery` for reads, `useMutation` for writes.** No exceptions for "simple" cases — they don't stay simple.
- **Query keys are structured arrays** (`["orders", customerId]`) so invalidation can target them.
- **Server state lives in the cache, not in `useState`** — don't copy query data into local state (see `minimal-state`).
- Wrap queries in feature hooks (`useOrders`) so components never see query plumbing (see `business-logic-in-hooks`).

## Not This

```typescript
// ❌ The pattern React Query exists to delete
const [orders, setOrders] = useState<Order[]>([])
const [loading, setLoading] = useState(true)
useEffect(() => {
  fetchOrders(customerId).then((o) => { setOrders(o); setLoading(false) })
}, [customerId])   // races, no cache, no retry, stale on refocus…
```
