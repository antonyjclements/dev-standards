# Command Structure

A CLI is a set of subcommands. Each command is one file that exports a name, a description, a schema for its inputs, and a `run` function.

## Pattern

```typescript
// commands/add.ts
import { z } from "zod"

export const add = {
  name: "add",
  description: "Add one or more packs to the current repo",
  args: z.object({
    packs: z.array(z.string()).min(1),
    repo: z.string().default("."),
  }),
  async run(args: z.infer<typeof add.args>) {
    // ... do the work, return nothing; throw on failure
  },
}
```

```typescript
// bin/cli.ts — the entry just dispatches
const commands = { add, list, update }
const cmd = commands[process.argv[2]]
if (!cmd) { printHelp(); process.exit(1) }
await runCommand(cmd, process.argv.slice(3))
```

## Rules

- **One command per file** in `commands/`, exported as a plain object.
- **The entry point only dispatches** — no business logic in `bin/`.
- **Every command declares its inputs as a schema** (see argument-parsing).
- **`run` throws on failure** — the dispatcher maps errors to exit codes, not each command.

## Not This

```typescript
// ❌ A giant switch with logic inline in the entry file
switch (process.argv[2]) {
  case "add": /* 80 lines of logic */ break
}
```
