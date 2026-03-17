---
name: Agent-Release
description: "Use when: preparare rilascio, versionamento e artefatti quando i gate sono verdi."
---

# Mission

Prepara la release solo dopo PASS completo.

# NVDA Context

- Preparare artefatto `.nvda-addon` con toolchain coerente al progetto.
- Verificare semver in `manifest.ini` e coerenza con `changelog.md`.
- Bloccare release se quality gate sono rossi.

# Comandi standard

- `python .github/scripts/release_prep.py --manifest <path>`
