.PHONY: help generate generate-enums generate-rest generate-ws clean test

OPENCCU_LOOM_REPO ?= ../openccu-loom
PKG := openccu_loom_types

help: ## show this help
	@awk -F':.*?## ' '/^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-22s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

generate: generate-enums generate-rest generate-ws ## regenerate every Pydantic / Enum module from the daemon's schema assets

generate-enums: ## regenerate openccu_loom_types/enums.py from $(OPENCCU_LOOM_REPO)/assets/schemas/enums.json
	python3 scripts/gen_enums.py \
		--enums-json $(OPENCCU_LOOM_REPO)/assets/schemas/enums.json \
		--out-py $(PKG)/enums.py

generate-rest: ## regenerate openccu_loom_types/rest.py via datamodel-codegen
	@command -v datamodel-codegen >/dev/null 2>&1 || { \
		echo "datamodel-codegen not on PATH — install via 'pip install -e .[dev]'"; exit 1; }
	datamodel-codegen \
		--input $(OPENCCU_LOOM_REPO)/assets/openapi.yaml \
		--input-file-type openapi \
		--output $(PKG)/rest.py \
		--output-model-type pydantic_v2.BaseModel \
		--target-python-version 3.11 \
		--use-standard-collections \
		--use-double-quotes \
		--field-constraints \
		--formatters ruff-format ruff-check

generate-ws: ## regenerate openccu_loom_types/ws.py (envelope + push payloads)
	@echo "WS payloads share components.schemas with REST — see rest.py for now."
	@echo "A dedicated ws.py with just the push-payload subset is planned"
	@echo "once the schema-grouping in openapi.yaml stabilises."

clean: ## remove generated modules
	rm -f $(PKG)/enums.py $(PKG)/rest.py $(PKG)/ws.py

test: ## run pytest
	pytest -q
