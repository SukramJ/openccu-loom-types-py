# openccu-loom-types-py

Generated Pydantic models + enum definitions for the openccu-loom
REST + WebSocket contract. Sister-repo to the
[openccu-loom daemon](https://github.com/SukramJ/openccu-loom);
publishable as `openccu-loom-types` on PyPI.

## What this package provides

- `openccu_loom_types.enums` — every enum from the daemon's
  `pkg/hmenum`. Each enum is a `str`-typed Python `Enum` whose values
  match the wire strings the CCU emits. Source of truth:
  `assets/schemas/enums.json` in the openccu-loom repo.
- `openccu_loom_types.rest` — Pydantic models for the REST surface.
  Generated from `assets/openapi.yaml` via `datamodel-code-generator`.
- `openccu_loom_types.ws` — Pydantic models for the WebSocket
  envelope + push payloads. Generated from the same OpenAPI document
  (the WS envelope schemas live in `components.schemas` per ADR-0020).

## Why this exists (asks.md C1 + C3)

Higher-level clients (`py-openccu-loom-client`, the future
homematicip_local refactor) need stable typed bindings against the
daemon. Without a published types package each consumer would
duplicate the model code and drift away from the daemon's wire
contract. This package is the single import every Python consumer
shares — version-pinned and CI-rebuilt on every openccu-loom release.

## Regeneration workflow

Set `OPENCCU_LOOM_REPO` to a local checkout of the daemon repo
(default: `../openccu-loom`):

```sh
# Step 1 — make sure the daemon repo's schema export is fresh:
make -C "$OPENCCU_LOOM_REPO" export-schemas

# Step 2 — regenerate this package's models:
make generate
```

The two-step split keeps the daemon repo authoritative; this package
never re-parses Go source.

### Tooling required

- Python >= 3.11
- `datamodel-code-generator` >= 0.25 (for REST + WS Pydantic models)

Install both with `pip install -e '.[dev]'`.

## Versioning

The package version (`pyproject.toml`) tracks the daemon's
`api_version` (currently `1.0.0`). Minor bumps add fields without
breaking existing consumers; major bumps remove or rename payload
fields, scopes, or capabilities — see ADR-0020 in the daemon repo
for the contract evolution policy.

## What this package does NOT contain

- HTTP / WebSocket transport — see `py-openccu-loom-client`
  (when published) for the higher-level client.
- Any business logic — types only.
- Async helpers — types are framework-neutral.

## License

MIT. See [LICENSE](./LICENSE).
