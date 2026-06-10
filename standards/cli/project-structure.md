# Project Structure

Keep the entry point thin and the logic testable. Commands orchestrate; `lib/` does the work.

## Layout

```
bin/
  cli.ts           # entry: parse argv, dispatch, map errors to exit codes
src/
  commands/        # one file per subcommand (name, description, args, run)
  lib/             # argv parsing, output helpers, fs/network utilities
  schemas/         # shared Zod schemas
package.json       # "bin" field points at the built entry
```

## Rules

- **`bin/` only dispatches** — no business logic, so it stays trivial.
- **Commands are thin orchestration** — real work lives in `lib/` functions that are unit-testable without spawning a process.
- **Side effects (fs, network, process.exit) live behind small lib helpers** so commands can be tested by asserting calls, not by shelling out.
- **The `bin` field in `package.json`** maps the command name to the built entry; never ship `ts-node` as the runtime entry.

## Why

- Logic in `lib/` is testable with plain function calls — fast, no child processes.
- A thin entry means `--help`, dispatch, and exit-code handling exist in exactly one place.
