# Engineering Stack — Onboarding One-Pager

For new engineers, human and agent. This is what we build with and how we work. Read it first; follow the linked standards when you write code.

## TL;DR

TypeScript everywhere. React + Vite on the front end, AWS Lambda for APIs, small Node CLIs for tooling. Zod validates every boundary. Vitest + Testing Library for tests, ESLint (flat config) for lint, `tsc` for types. Git for everything.

## Languages & runtime

- **TypeScript** (`~5.8`, `strict`) — the only application language. No plain JS in `src/`.
- **Node** (`>= 20`, see `.nvmrc` where present) — runtime for tooling, CLIs, and Lambda.
- **Git** — trunk-based with short-lived branches and PRs. Conventional commit style (`feat:`, `fix:`, `docs:`…).

## Tooling

| Concern | Tool |
| --- | --- |
| Build / dev server | **Vite 7** (`@vitejs/plugin-react`) |
| Types | **TypeScript** `tsc -b` (project references) |
| Lint | **ESLint 9** flat config + `typescript-eslint`, `eslint-plugin-react-hooks` |
| Tests | **Vitest 3** + **Testing Library** (`react`, `jest-dom`, `user-event`), `jsdom` |
| Validation | **Zod 4** at every boundary (API input, env, untrusted data) |
| Package manager | npm (lockfile committed) |

Standard scripts in every repo: `dev`, `build` (`tsc -b && vite build`), `lint`, `test`, `preview`.

## Front end

- **React 19** with named **function components** (no default exports).
- **React Router 7** for routing; pages use a `Page` suffix and a consistent structure.
- **Tailwind CSS 4** (`@tailwindcss/vite`) for styling; mobile-first, dark-mode aware.
- Custom **hooks** live in a `hooks/` dir, `use`-prefixed, with consistent return shapes.

→ Standards: [`react`](standards/react), [`typescript`](standards/typescript), [`architecture`](standards/architecture)

## Back end (APIs)

- **AWS Lambda** HTTP handlers in TypeScript.
- Handlers are **thin**: validate input with Zod, delegate to a service, shape the response.
- Layered like the front end: `handlers → services → adapters`; the AWS SDK lives only in adapters.

→ Standard: [`lambda-api`](standards/lambda-api)

## CLIs & tooling

- Small **Node/TypeScript CLIs** for repeatable tasks (one subcommand per file, thin entry point).
- Unix-friendly: data on stdout, logs on stderr, meaningful exit codes, `--json` for machines.

→ Standard: [`cli`](standards/cli)

## How we structure code

A **three-layer architecture** across front end and back end:

```
foundation → features → app          (stability: most → least stable)
```

- **foundation** — reusable infrastructure, no business logic.
- **features** — business domains; no feature imports another feature.
- **app** — routing, composition, wiring.

Cross-module imports use **path aliases** (`@features/`, `@foundation/`); public surfaces are exposed through **barrel exports** (`index.ts`).

→ Standard: [`architecture`](standards/architecture)

## Quality gates (before a PR)

1. `tsc -b` — no type errors.
2. `npm run lint` — clean.
3. `npm test` — green; new behavior has tests near related coverage.
4. Boundary input is validated with Zod.
5. The relevant standards in `docs/standards/` are followed (and updated if behavior changed).

## Getting started

```bash
nvm use            # match the Node version
npm install
npm run dev        # Vite dev server
npm test           # Vitest
```

Pull the standards that apply to what you're building:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/antonyjclements/dev-standards/main/install.sh) add react typescript architecture
```
