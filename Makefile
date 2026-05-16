.PHONY: test lint run reset

test:
	uv run pytest backend/tests/

lint:
	uv run ruff check .
	uv run ruff format --check .

run:
	uv run uvicorn app.main:app --reload --app-dir backend --port 8000

reset:
	rm -f sandbox.db
