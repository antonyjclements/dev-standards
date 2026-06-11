# Common Layer Design Principles

The common layer is stable and abstract. It contains no business logic and no domain knowledge.

## Rules

- **No business logic** — common code must make sense in any product. If a function mentions orders, users, or pricing, it isn't common.
- **Abstract over domain types** — generics and render props, never imports of feature types (see `stable-abstractions-principle`).
- **Event delegation** — common components emit semantic events and let callers attach meaning. A `Table` fires `onRowClick(row)`; it doesn't know what clicking a row *means*.
- **Stable by design** — changing common code touches every feature. Additions are cheap; breaking changes need a migration plan.

## Pattern

```tsx
// ✅ common/ui/DataTable.tsx — generic, delegates meaning to the caller
type DataTableProps<T> = {
  rows: T[]
  columns: Column<T>[]
  onRowClick?: (row: T) => void
}
export function DataTable<T>({ rows, columns, onRowClick }: DataTableProps<T>) { ... }
```

```tsx
// Feature attaches the domain meaning
<DataTable rows={orders} columns={orderColumns} onRowClick={(order) => openOrder(order.id)} />
```

## Not This

```tsx
// ❌ Business logic and a feature type in common
import { Order } from "@features/orders"          // common importing a feature
export function OrderTable({ orders }: { orders: Order[] }) {
  const overdue = orders.filter(isOverdue)         // domain rule in common
  ...
}
```
