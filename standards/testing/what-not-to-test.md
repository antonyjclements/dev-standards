# What Not to Test

Test outcomes, not implementation details. Don't test other people's code, and don't re-test the type checker.

## Don't test implementation details

```typescript
// ❌ Asserts how it works — breaks on harmless refactors
expect(setStateSpy).toHaveBeenCalledWith([...items, newItem])
expect(component.state.isOpen).toBe(true)

// ✅ Asserts what it does
expect(screen.getByRole("dialog")).toBeInTheDocument()
```

If a refactor that preserves behavior breaks the test, the test was wrong.

## Don't test third-party libraries

```typescript
// ❌ Testing that Zod validates emails / React Query caches — they have their own tests
expect(z.string().email().safeParse("nope").success).toBe(false)

// ✅ Test YOUR configuration of them
expect(UserSchema.safeParse(userWithoutRole).success).toBe(false)
```

## Don't test type correctness

```typescript
// ❌ The compiler already guarantees this
it("returns an array", () => {
  expect(Array.isArray(listOrders())).toBe(true)
})
```

Type-level guarantees are `tsc`'s job. Runtime tests are for behavior the types can't express.

## Rules

- **The question every test answers: "does the observable behavior match the requirement?"** Spies on internals, snapshot dumps of structure, and state inspection don't answer it.
- **Mock at boundaries you own** (your API module), not inside the unit under test.
- Coverage of trivial pass-throughs (a component that renders a prop) is allowed to not exist.
