# backend/AGENTS.md

Backend-specific notes. Schema-reset workflow and code principles live in [`../AGENTS.md`](../AGENTS.md) — not repeated here.

## Test isolation

Tests must never touch `sandbox.db`. The pattern in [`tests/conftest.py`](tests/conftest.py):

- A function-scoped `engine` fixture creates a fresh `sqlite:///:memory:` engine with `StaticPool` so the single in-memory connection is shared across threads within one test.
- The `client` fixture overrides FastAPI's `get_db` dependency to yield the in-memory session, and constructs `TestClient(app)` *without* `with` — using `with` would trigger the lifespan and call `Base.metadata.create_all` against the real engine, creating an empty `sandbox.db` at the repo root.

When adding a new test module, request the `client` fixture (not `engine` or `db_session` directly) unless you specifically need lower-level DB access.
