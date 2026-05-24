# Version 0.1.1 (2026-05-24)

- Fix: `scripts/gen_enums.py` now escapes Python reserved words. Before this fix `pkg/hmenum` constants whose stripped member name resolved to a reserved word (`None`, `True`, `False`, `class`, …) were emitted verbatim — e.g. `class FailureReason(str, Enum): None = "none"` — which is a `SyntaxError` and made `openccu_loom_types.enums` unimportable. Affected members in 0.1.0: `FailureReason.None`, `Quantity.None`, `RPCServerType.None`, `ValueBehavior.None`. They are now exposed as `*.None_` (PEP 8 trailing-underscore convention); wire values are unchanged.
- Add: regression test `tests/test_reserved_words.py` covering the four affected members and a guard against future keyword regressions.
- Feat: generate-ws — populate ws.py as re-export from rest.py

# Version 0.1.0 (2026-05-24)

- Initial release: generated Pydantic / enum types for the openccu-loom REST + WebSocket contract.

# Version 0.0.0 (2026-05-24)

- Repository bootstrap (no published artifacts).
