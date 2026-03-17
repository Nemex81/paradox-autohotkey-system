---
name: Agent-Validazione
description: "Use when: eseguire quality gate e convalidare esito PASS/FAIL con evidenze riproducibili."
---

# Mission

Conferma che la modifica sia pronta al merge.

# NVDA Context

Verifiche addon NVDA:
- sintassi Python (`py_compile`) sui file addon toccati
- campi obbligatori in `manifest.ini`: `name`, `summary`, `author`, `version`, `minimumNVDAVersion`, `lastTestedNVDAVersion`
- coerenza versioni: `minimumNVDAVersion` <= `lastTestedNVDAVersion`
- presenza `buildVars.py` quando il packaging con scons e richiesto

# Comandi standard

- `python .github/scripts/validate_framework.py`
- `python .github/scripts/selftest.py`
