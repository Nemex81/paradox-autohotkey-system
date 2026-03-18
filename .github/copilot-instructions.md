# Project Guidelines

## Scope

These instructions apply to all tasks in this workspace.

## Architecture

- Framework runtime assets live under `.github/`.
- Agent definitions are in `.github/agents/`.
- Agent routing and aliases are in `.github/config/agent_registry.json`.
- Validation/reporting scripts are in `.github/scripts/`.
- Strategic roadmap and governance are in `PIANO_FRAMEWORK_COPILOT_NVDA.md`.

See [README.md](../README.md) for overview.
See [PIANO_FRAMEWORK_COPILOT_NVDA.md](../PIANO_FRAMEWORK_COPILOT_NVDA.md) for process and gates.

## Build And Test

Run from repository root:

- `python .github/scripts/validate_framework.py`
- `python .github/scripts/selftest.py`

Useful operational commands:

- `python .github/scripts/run_agent_pipeline.py --task-type feature --mode auto`
- `python .github/scripts/update_changelog.py --title "Title" --category Changed --details "Detail"`

## Conventions

- Use small, reviewable changes and preserve existing behavior unless explicitly requested.
- Keep path alignment to `.github/`; avoid introducing `framework/...` references.
- Update `changelog.md` after each implementation with a concise, verifiable entry.
- Add code comments only where logic is non-trivial.
- Prefer linking existing docs instead of duplicating long explanations.

## NVDA API Reference

- Use local `nvda` workspace repository as primary API source of truth.
- Before implementation touching NVDA APIs, verify module and symbol names against `nvda/source` and `nvda/projectDocs/dev/developerGuide/developerGuide.md`.
- Treat local NV Access repositories (for example `nvda`, `nvda-misc-deps`, `NSIS-build`, `javaAccessBridge32-bin`) as read-only sources for cross-analysis and compatibility checks.
- Never modify files in those external source repositories from this framework workspace; use them only for consultation and evidence.
- Use `.github/skills/nvda_addon_development.skill.md` as mandatory operational baseline.

## Addon Types

- `global` addon: use `globalPlugins/` for functionality available across applications.
- `app` addon: use `appModules/` for per-application behavior.
- For `app` addons, always declare target application and evaluate need for overlay classes (`chooseNVDAObjectOverlayClasses`) and `event_NVDAObject_init`.

## Pitfalls

- Path mismatches between config/scripts/CI break both validation gates.
- `selftest.py` uses temporary folders under `.github/.tmp_selftest`; let script cleanup handle them.
- `release_prep.py` requires strict semver (`X.Y.Z`) in manifest version fields.

## Linked Docs

- [README.md](../README.md)
- [PIANO_FRAMEWORK_COPILOT_NVDA.md](../PIANO_FRAMEWORK_COPILOT_NVDA.md)
- [docs/legacy_recycle_matrix.md](../docs/legacy_recycle_matrix.md)
- [docs/legacy_hotkeys_reference.md](../docs/legacy_hotkeys_reference.md)
- [.github/instructions/autonomous_framework.instructions.md](instructions/autonomous_framework.instructions.md)
