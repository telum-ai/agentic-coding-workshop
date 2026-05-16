# AGENTS.md

Operating notes for coding agents (Claude Code, etc.) in this repository. `CLAUDE.md` is a one-line shim that imports this file.

## Schema-change workflow

This template uses `Base.metadata.create_all` to manage the SQLite schema — there is no Alembic and no migrations framework. After modifying any SQLAlchemy model in `backend/app/models.py`, run:

```bash
rm -f sandbox.db
```

The next app boot will recreate the schema from the current model definitions. If you skip this step after a model change, the app will run against the old schema and you will see "no such column" or "no such table" errors at request time.

## No JavaScript package manager

This template ships zero JavaScript tooling: no `package.json`, no `node_modules/`, no npm/yarn/pnpm, no Node.js runtime, no bundler, no transpiler.

Additional client-side JavaScript goes directly into `frontend/app.js` (own code), OR is vendored as a single static file under `frontend/vendor/` following the procedure in `frontend/README.md`: pin a version, record a SHA-256, prepend a header comment. Never introduce `package.json`, npm, or a JS bundler — doing so violates a load-bearing constraint of this template.

## Code principles

Apply when writing or reviewing code. Rationale and examples: [`docs/code-principles.md`](docs/code-principles.md).

- **Subtract code first.** Prefer deletion to addition; the smallest diff that satisfies the requirement wins.
- **Comments explain *why*, not *what*.** If the code shows what it does, the comment should explain the non-obvious reason it does it that way.
- **Trust internal code; validate at boundaries.** Pydantic/SQLAlchemy at the HTTP/DB edge; plain types in between.
- **No premature abstraction.** Wait for the third concrete use before extracting a helper.
- **Keep functions small and named for intent.** A function name that needs "and" is two functions.

## Subdirectory notes

- `backend/AGENTS.md` — test-isolation pattern.
