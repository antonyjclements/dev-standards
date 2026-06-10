# Argument Parsing

Parse `argv` into a plain object, then validate it with the command's Zod schema. Commands receive typed, validated input — never raw `argv`.

## Pattern

```typescript
// lib/args.ts — tiny parser: positionals + --flags
export function parseArgv(argv: string[]) {
  const positionals: string[] = []
  const flags: Record<string, string | boolean> = {}
  for (const a of argv) {
    if (a.startsWith("--")) {
      const [k, v] = a.slice(2).split("=")
      flags[k] = v ?? true
    } else positionals.push(a)
  }
  return { positionals, flags }
}
```

```typescript
// dispatcher maps parsed argv to the command shape, then validates
const parsed = command.args.parse({ packs: positionals, ...flags })
await command.run(parsed)
```

## Rules

- **Validate with the command's schema** — a bad argument is a clear error, not a crash.
- **Prefer explicit `--flags`** over positional soup; positionals only for the primary subject.
- **Provide defaults in the schema**, not scattered through `run`.
- **`--help` is always available** and lists args with their descriptions.

## Not This

```typescript
// ❌ Reaching into process.argv by index inside a command
const pack = process.argv[3]            // unvalidated, position-coupled
if (!pack) throw new Error("missing")   // ad-hoc, inconsistent errors
```
