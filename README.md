# dev-standards

Reusable engineering standards you can pull into any repo, new or existing.

Building a React app? Pull in the `react` standards. Adding a Lambda API? Pull in `lambda-api`. Writing a CLI? Pull in `cli`. Each pack drops focused, example-driven markdown into your repo's `docs/standards/` and registers it in `docs/standards/index.yml`, so both humans and [agentic-workflow](https://github.com/antonyjclements/agentic-workflow) agents read from the same source of truth.

See [STACK.md](STACK.md) for the one-pager on the overall stack these standards support.

## Install

List what's available:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/antonyjclements/dev-standards/main/install.sh) list
```

Add one or more packs to the current repo:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/antonyjclements/dev-standards/main/install.sh) add react typescript
```

Options: `--repo PATH` (target another repo), `--ref BRANCH`, `--force` (overwrite existing files), `--source DIR` (use a local checkout).

## Packs

| Pack | What it covers | Status |
| --- | --- | --- |
| `react` | Function components, hook naming/location/returns, props, compound components | stable |
| `typescript` | Path aliases, type collocation | stable |
| `architecture` | Three-layer architecture, module structure, barrel exports | stable |
| `lambda-api` | Thin handlers, Zod request validation, response/error shape, project structure | starter |
| `cli` | Subcommand structure, argv parsing, stdout/stderr & exit codes, project structure | starter |

`stable` packs are extracted from production use. `starter` packs are sensible defaults to adopt and refine.

## What `add` does

For each pack it:

1. Copies `standards/<pack>/*.md` into `<repo>/docs/standards/<pack>/`.
2. Deep-merges the pack's index entries into `<repo>/docs/standards/index.yml`.

Existing files are preserved unless you pass `--force`. The index merge treats the agentic-workflow placeholder (`standards: []`) as empty and replaces it with the category map.

## index.yml shape

```yaml
react:
  function-components:
    description: Use named function exports for React components
architecture:
  three-layer-architecture:
    description: Three-layer architecture with app, features, and foundation layers
```

Categories are pack names; each entry is `<standard>: { description }`. This is the shape `aw-discover-standards` and agents consume.

## Adding a new pack

1. Create `standards/<pack>/` with one focused `.md` per standard.
2. Add `standards/<pack>/index.yml` with `<pack>:` and a `description` for each standard.
3. Add a row to `catalog.yml` and the table above.

Keep each standard short and example-driven: a title, a one-line rule, a `Good` / `Not this` pair.

## Requirements

`bash`, `curl`, `tar` (for remote install) and `ruby` (for the index merge — ships with macOS; stdlib only, no gems).
