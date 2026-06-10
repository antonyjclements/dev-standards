# Output and Exit Codes

A CLI is a Unix citizen: data on stdout, logs and errors on stderr, meaningful exit codes. Scripts and agents depend on this.

## Rules

- **stdout is for data** — the thing a caller would pipe or capture. Nothing else.
- **stderr is for everything else** — progress, warnings, errors, human chatter.
- **Exit `0` on success, non-zero on failure.** Reserve distinct codes for distinct failure classes if callers branch on them.
- **Support `--json`** for machine consumers: a single JSON document on stdout, no decorative logging.
- **Support `--quiet`** to silence stderr chatter (errors still print).
- **Never print secrets** (tokens, keys) to either stream.

## Pattern

```typescript
// human mode: friendly, on stderr
log.info(`Added ${packs.length} packs`)          // -> stderr

// data mode: the result, on stdout
if (flags.json) process.stdout.write(JSON.stringify(result) + "\n")

// failure
catch (err) {
  log.error(err.message)                          // -> stderr
  process.exit(err instanceof UsageError ? 2 : 1)
}
```

## Not This

```typescript
// ❌ Logs mixed into stdout break piping and --json consumers
console.log("Working...")            // pollutes stdout
console.log(JSON.stringify(result))  // now stdout has two kinds of thing
```
