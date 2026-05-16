.PHONY: test lint run reset

test:
	uv run pytest backend/tests/

lint:
	uv run ruff check .
	uv run ruff format --check .

run:
	uv run uvicorn app.main:app --reload --app-dir backend --port 8000

reset:
	uv run python -c "import pathlib; pathlib.Path('sandbox.db').unlink(missing_ok=True)"
