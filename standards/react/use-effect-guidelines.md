# useEffect Guidelines

`useEffect` is only for synchronizing with external systems. Not for data fetching. Not for derived state.

## Legitimate uses

```tsx
// ✅ Subscribing to something outside React
useEffect(() => {
  const sub = websocket.subscribe(channel, onMessage)
  return () => sub.unsubscribe()
}, [channel])

// ✅ Imperative browser APIs
useEffect(() => {
  document.title = `${unread} unread`
}, [unread])

// ✅ Analytics on view
useEffect(() => { analytics.pageView(pageId) }, [pageId])
```

## Not legitimate

```tsx
// ❌ Data fetching — that's React Query (see react-query)
useEffect(() => { fetchOrders().then(setOrders) }, [])

// ❌ Derived state — that's a const (see minimal-state)
useEffect(() => { setTotal(sum(items)) }, [items])

// ❌ Reacting to a state change to set other state — restructure:
// derive it, or set both in the same event handler
useEffect(() => { if (submitted) setShowBanner(true) }, [submitted])
```

## Rules

- **The test: is there an external system on the other side?** (network socket, DOM, timer, analytics, storage). If both ends of the effect are React state, the effect shouldn't exist.
- **Every subscription returns a cleanup.**
- **Event logic belongs in the event handler**, not in an effect that watches for the event's results.
- When tempted by an effect, the fix is usually one of: compute it (`minimal-state`), move it to the handler, or use React Query (`react-query`).
