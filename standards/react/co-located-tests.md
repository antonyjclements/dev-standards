# Co-located Tests

Test files live next to the source files they test. Tests exercise behavior from the user's perspective with React Testing Library.

## Layout

```
src/features/checkout/
  components/
    CheckoutForm.tsx
    CheckoutForm.test.tsx      # ✅ right next to its subject
  hooks/
    useCheckout.ts
    useCheckout.test.ts
```

## Pattern

```tsx
// ✅ Queries by role/label, asserts what the user sees
it("disables the submit button while the cart is empty", () => {
  render(<CheckoutForm />)

  expect(screen.getByRole("button", { name: "Place order" })).toBeDisabled()
})

it("shows the order confirmation after submitting", async () => {
  render(<CheckoutForm />)

  await userEvent.click(screen.getByRole("button", { name: "Place order" }))

  expect(await screen.findByText("Order confirmed")).toBeInTheDocument()
})
```

## Rules

- **`<file>.test.ts(x)` beside `<file>.ts(x)`** — no parallel `__tests__/` tree to keep in sync.
- **Query like a user**: `getByRole`, `getByLabelText`, `getByText`. `data-testid` is the last resort.
- **Interact like a user**: `userEvent`, not direct state manipulation.
- **Assert outcomes, not internals** — never reach into hook state or component instances (see `testing/what-not-to-test`).

The general testing practices (naming, AAA, determinism, object mothers) live in the `testing` pack.
