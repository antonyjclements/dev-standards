# Test Naming

Test names are present-tense declarative statements of behavior. No "should". Follow `[unit] [does what] [under condition]`.

## Pattern

```typescript
// ✅ States a fact the test proves
it("returns the empty cart when no items have been added")
it("parseMoney rejects negative amounts")
it("disables the submit button while the request is in flight")
it("applyDiscount leaves the cart unchanged when the code is expired")
```

## Why

- A passing test asserts a fact about the system; the name states the fact.
- "Should" is wasted breath and softens the claim — `it("should return...")` vs `it("returns...")`.
- The `[unit] [does what] [under condition]` shape makes a failing test read as a precise bug report in the runner output.

## Not This

```typescript
// ❌ "should" filler
it("should return the correct value")

// ❌ No behavior, no condition
it("works")
it("handles errors")
it("test cart")

// ❌ Implementation-speak instead of behavior
it("calls setState with the new array")
```
