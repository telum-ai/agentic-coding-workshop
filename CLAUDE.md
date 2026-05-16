# CLAUDE.md

Operating notes for Claude Code agents working in this repository.

## Schema-change workflow

This template uses `Base.metadata.create_all` to manage the SQLite schema — there is no Alembic and no migrations framework. After modifying any SQLAlchemy model in `backend/app/models.py`, run:

```bash
rm -f sandbox.db
```

This deletes `sandbox.db`. The next app boot will recreate the schema from the current model definitions. If you skip this step after a model change, the app will run against the old schema and you will see "no such column" or "no such table" errors at request time.

## No JavaScript package manager

This template ships zero JavaScript tooling:

- No `package.json`, no `package-lock.json`, no `node_modules/`.
- No npm, yarn, pnpm, or any other JS package manager.
- No Node.js runtime requirement.
- No bundler (Webpack, Vite, esbuild, Parcel, etc.).
- No transpiler (Babel, TypeScript compiler, etc.).

Additional client-side JavaScript goes directly into `frontend/app.js` (own code), OR is vendored as a single static file under `frontend/vendor/` following the same procedure documented for `tailwind.js`: pin a version, record a SHA-256, prepend a header comment, document the re-vendoring procedure in `frontend/README.md`. Never introduce `package.json`, npm, or a JS bundler — doing so violates a load-bearing constraint of this template.

---

*Additional best-practice content will be added in a later iteration once the environment is validated.*
