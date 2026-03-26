.PHONY: install install-backend install-frontend start stop start-backend start-frontend test test-backend test-frontend logs clean help

# Default target
help:
	@echo "Factory Inventory Management System"
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "  install           Install all dependencies"
	@echo "  install-backend   Install backend (Python) dependencies"
	@echo "  install-frontend  Install frontend (Node) dependencies"
	@echo ""
	@echo "  start             Start both servers in background"
	@echo "  start-backend     Start backend server only"
	@echo "  start-frontend    Start frontend server only"
	@echo "  stop              Stop all servers"
	@echo ""
	@echo "  test              Run all tests"
	@echo "  test-backend      Run backend tests"
	@echo "  test-frontend     Run frontend tests"
	@echo ""
	@echo "  logs              Tail server logs"
	@echo "  clean             Remove generated files and caches"
	@echo ""

# ── Install ──────────────────────────────────────────────

install: install-backend install-frontend

install-backend:
	cd server && uv venv && uv sync

install-frontend:
	cd client && npm install

# ── Start / Stop ─────────────────────────────────────────

start: stop
	@echo "Starting backend on http://localhost:8001 ..."
	@cd server && uv run python main.py > /tmp/inventory-backend.log 2>&1 & echo $$! > /tmp/inventory-backend.pid
	@sleep 2
	@echo "Starting frontend on http://localhost:3000 ..."
	@cd client && npm run dev > /tmp/inventory-frontend.log 2>&1 & echo $$! > /tmp/inventory-frontend.pid
	@sleep 2
	@echo ""
	@echo "Frontend:  http://localhost:3000"
	@echo "Backend:   http://localhost:8001"
	@echo "API Docs:  http://localhost:8001/docs"
	@echo ""
	@echo "Run 'make logs' to tail logs, 'make stop' to shut down."

start-backend:
	@echo "Starting backend on http://localhost:8001 ..."
	cd server && uv run python main.py

start-frontend:
	@echo "Starting frontend on http://localhost:3000 ..."
	cd client && npm run dev

stop:
	@-if [ -f /tmp/inventory-backend.pid ]; then \
		kill $$(cat /tmp/inventory-backend.pid) 2>/dev/null; \
		rm -f /tmp/inventory-backend.pid; \
	fi
	@-if [ -f /tmp/inventory-frontend.pid ]; then \
		kill $$(cat /tmp/inventory-frontend.pid) 2>/dev/null; \
		rm -f /tmp/inventory-frontend.pid; \
	fi
	@-lsof -ti:8001 | xargs kill 2>/dev/null || true
	@-lsof -ti:3000 | xargs kill 2>/dev/null || true
	@rm -f /tmp/inventory-backend.log /tmp/inventory-frontend.log

# ── Test ─────────────────────────────────────────────────

test: test-backend test-frontend

test-backend:
	cd tests && uv run pytest backend/ -v

test-frontend:
	cd client && npm test

# ── Utilities ────────────────────────────────────────────

logs:
	@tail -f /tmp/inventory-backend.log /tmp/inventory-frontend.log

clean:
	@rm -rf server/__pycache__ server/.venv
	@rm -rf client/node_modules client/dist
	@rm -rf tests/__pycache__ tests/backend/__pycache__
	@rm -f /tmp/inventory-backend.log /tmp/inventory-frontend.log
	@rm -f /tmp/inventory-backend.pid /tmp/inventory-frontend.pid
	@echo "Cleaned."
