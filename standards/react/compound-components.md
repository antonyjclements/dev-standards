# Compound Components

When a component's structure varies, use composition with a namespace pattern — not an ever-growing list of props.

## Pattern

```tsx
// ✅ Structure is expressed in JSX, not configured through props
<Card>
  <Card.Header action={<IconButton icon="close" onClick={onClose} />}>
    Invoice #1042
  </Card.Header>
  <Card.Body>
    <InvoiceLines lines={invoice.lines} />
  </Card.Body>
  <Card.Footer>
    <Button onClick={pay}>Pay now</Button>
  </Card.Footer>
</Card>
```

```tsx
// Implementation: named parts attached to the root
function CardRoot({ children }: { children: ReactNode }) { ... }
function Header({ children, action }: HeaderProps) { ... }
function Body({ children }: { children: ReactNode }) { ... }
function Footer({ children }: { children: ReactNode }) { ... }

export const Card = Object.assign(CardRoot, { Header, Body, Footer })
```

## Why

Prop explosion makes one component responsible for every variation anyone ever needed. Composition lets callers build the variation they need from named parts — open for extension, closed for modification.

## Rules

- **Reach for compound components when structure varies** (optional sections, reordering, custom content per slot). A fixed-shape component can keep plain props.
- **Parts are namespaced on the root** (`Card.Header`) so the API is discoverable and imports stay single.
- **Each part stays dumb** — shared state between parts (if any) goes through internal context, not caller wiring.

## Not This

```tsx
// ❌ The prop-explosion trajectory
<Card title="Invoice #1042" showClose onClose={onClose} footerButtonLabel="Pay now"
      onFooterClick={pay} hideFooterDivider bodyPadding="lg" headerVariant="compact" />
```
