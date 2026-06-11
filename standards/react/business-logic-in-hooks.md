# Business Logic in Hooks

Hooks own business logic. Components own display logic. The separation is strict.

## Pattern

```typescript
// ✅ The hook: data, rules, actions — no JSX
function useCheckout() {
  const { data: cart } = useQuery({ queryKey: ["cart"], queryFn: fetchCart })
  const submit = useMutation({ mutationFn: submitOrder })

  const total = cart ? cartTotal(cart) : zeroMoney()
  const canSubmit = cart !== undefined && cart.items.length > 0

  return { cart, total, canSubmit, submit: () => submit.mutate(cart!) }
}
```

```tsx
// ✅ The component: rendering only
export function CheckoutPage() {
  const { cart, total, canSubmit, submit } = useCheckout()

  if (!cart) return <Spinner />
  return (
    <section>
      <CartList items={cart.items} />
      <Total amount={total} />
      <Button disabled={!canSubmit} onClick={submit}>Place order</Button>
    </section>
  )
}
```

## Rules

- **Components read like markup** — branching limited to what renders; no domain rules inline in JSX.
- **Hooks return a ready-to-render view of the domain** — data, derived values, capability flags, actions.
- **Heavy lifting goes one level further down** — hooks orchestrate pure functions (`cartTotal`), they don't inline the math (see `functional-patterns`).
- A component needing two unrelated hooks is fine; a component computing business rules between them is the smell.
