# Project Structure

A Lambda API mirrors the three-layer idea: handlers orchestrate, services hold domain logic, adapters talk to the outside world.

## Layout

```
src/
  handlers/        # one file per route; thin, no business logic
  services/        # domain logic; pure where possible, no AWS SDK types
  adapters/        # I/O: DynamoDB, S3, external APIs (SDK lives here)
  schemas/         # Zod schemas + inferred types (the boundary contract)
  lib/             # http parse, responses, errors, shared utilities
  config.ts        # env parsing (validate process.env with Zod once)
```

## Dependency Rules

```
adapters → services → handlers
schemas and lib are shared and depend on nothing app-specific
```

- **Handlers** depend on services, schemas, lib. Never on adapters directly.
- **Services** depend on adapters (via injected interfaces) and schemas. No `event`/`APIGatewayProxyEvent` types.
- **Adapters** are the only place the AWS SDK is imported.

## Rules

- **No business logic outside `services/`.**
- **No AWS SDK imports outside `adapters/`** — keeps services testable without mocking AWS.
- **Validate `process.env` once** in `config.ts` and import typed config elsewhere.
- **One deployable concern per package** — don't co-locate unrelated APIs.
