# Agentic Coding Sandbox

A minimal template repository for the agentic-coding course. Get from `git clone` to a running FastAPI + SQLite + vanilla-JS app in under 60 seconds. No Node, no Docker, no build step, no runtime network calls.

It ships one end-to-end smoke-test feature (`Ping`) that exercises every layer — env, web framework, database, static-file serving, frontend→backend call — so you can verify the environment works before you start building.

## Prerequisites

- [uv](https://docs.astral.sh/uv/) (Python package manager). Install with `brew install uv` on macOS, or follow the [uv install guide](https://docs.astral.sh/uv/getting-started/installation/) on Linux / WSL2 / Windows.
- Python 3.13 — `uv` will install it automatically using the version pinned in `.python-version`.

No Node, no Docker, no global Python required.

## Setup

```bash
git clone <your-fork-url>
cd agentic-coding-sandbox
uv sync
```

`uv sync` resolves dependencies from `uv.lock` and creates a local `.venv/`. Expect under 30 seconds on a warm cache.

## Run

```bash
make run
```

Then open http://localhost:8000 in a browser. You should see the page render with backend health = `ok` and a "Send ping" button.

## Test

```bash
make test
```

Runs the backend pytest suite against an in-memory SQLite database (your local `sandbox.db` is untouched). Expect under 5 seconds.

## Lint

```bash
make lint
```

Runs `ruff check .` followed by `ruff format --check .` — both must be clean.

## Reset the database

```bash
make reset
```

Deletes the local `sandbox.db` file at the repository root. The app will recreate the schema on next boot via `Base.metadata.create_all`.

## Folder structure

```
backend/
  app/
    main.py          # FastAPI app: routers, StaticFiles mount, create_all on startup
    database.py      # SQLAlchemy engine, session, get_db dependency
    models.py        # SQLAlchemy ORM models (Ping)
    schemas.py       # Pydantic response schemas
    routers/
      health.py      # GET /api/health
      pings.py       # POST /api/pings, GET /api/pings
  tests/
    conftest.py      # in-memory SQLite + dependency override
    test_health.py
    test_pings.py
frontend/
  index.html         # served at /
  app.js             # frontend logic — fetch /api/health, /api/pings
  vendor/
    tailwind.js      # vendored @tailwindcss/browser v4.3.0 (SHA-256 in header)
  README.md          # frontend-specific notes
pyproject.toml       # Python project + dep + tool config
uv.lock              # resolved dependency graph
Makefile             # test / lint / run / reset
sandbox.db           # SQLite database at repo root (created on first run; gitignored)
LICENSE
CLAUDE.md            # notes for Claude Code agents working in this repo
```

## SQLite database location

The runtime database lives at `./sandbox.db` (repo root). It is created on first app boot. It is in `.gitignore` — never commit it.

## Schema-change workflow

This template uses `Base.metadata.create_all` rather than Alembic migrations. After modifying any SQLAlchemy model in `backend/app/models.py`:

```bash
make reset
```

This deletes `sandbox.db`. The next time the app boots (`make run`), it recreates the schema from the current models. You will lose any local data. Once data persistence matters, swap in Alembic — see the course materials for a later lesson.
