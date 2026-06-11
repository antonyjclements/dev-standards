# Object Mothers

Test data comes from object mother factories — `<Domain>Mother` in `test-support/mothers/` — not from hand-built literals in every test.

## Pattern

```typescript
// test-support/mothers/UserMother.ts
export const UserMother = {
  default(): User {
    return {
      id: userId("user-1"),
      email: "test@example.com",
      role: "member",
      createdAt: new Date("2026-01-01T00:00:00Z"),
    }
  },

  admin(): User {
    return { ...UserMother.default(), role: "admin" }
  },

  with(overrides: Partial<User>): User {
    return { ...UserMother.default(), ...overrides }
  },
}
```

```typescript
// In tests: one line of arrange, only the relevant detail visible
const admin = UserMother.admin()
const banned = UserMother.with({ status: "banned" })
```

## Rules

- **One mother per domain type**, named `<Domain>Mother`, in `test-support/mothers/`.
- **`default()` returns a fully valid instance** with fixed, deterministic values (see `deterministic-tests`).
- **Named variants for meaningful states** (`admin()`, `expired()`, `withItems(n)`) — the variant name documents the scenario.
- **`with(overrides)` for one-off tweaks** — the test shows only the field that matters to it.
- When a type changes, the mother is the *single place* test data is fixed.

## Not This

```typescript
// ❌ Hand-built literal in every test — 30 copies to update when User grows a field,
// and the reader can't tell which of these values the test actually cares about
const user: User = { id: "u1", email: "a@b.c", role: "member", createdAt: new Date() }
```
