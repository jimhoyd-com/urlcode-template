.DEFAULT_GOAL := help
NPM ?= npm
HOST ?= 127.0.0.1
PORT ?= 3000
.PHONY: help setup dev start validate test doctor
help:
	@echo "make dev       Install if needed, then run with reload"
	@echo "make test      Run local HTTP examples"
	@echo "make validate  Check YAML, functions and bindings"
	@echo "make start     Serve a fixed snapshot"
	@echo "make setup     Reinstall locked dependencies"
	@echo "Options: PORT=3001 HOST=127.0.0.1"
setup:
	$(NPM) ci
node_modules/.package-lock.json: package.json package-lock.json
	$(NPM) ci
dev: node_modules/.package-lock.json
	$(NPM) run dev -- --host "$(HOST)" --port "$(PORT)"
start: node_modules/.package-lock.json
	$(NPM) start -- --host "$(HOST)" --port "$(PORT)"
validate test doctor: node_modules/.package-lock.json
	$(NPM) run $@
