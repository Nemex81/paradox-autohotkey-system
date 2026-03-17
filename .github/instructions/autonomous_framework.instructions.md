---
description: "Use when: lavori sul framework NVDA, su scripts/prompt/skills/agents o su feature implementative con impatto su documentazione e changelog."
applyTo: "**"
---

# Regole operative framework

1. Se la richiesta comporta implementazione, applica flusso: requisiti -> implementazione -> review -> validazione -> documentazione.
2. Dopo ogni implementazione aggiorna `changelog.md` con una voce sintetica e verificabile.
3. Aggiorna commenti nel codice solo quando chiariscono blocchi non banali.
4. Prima di chiudere esegui sempre:
   - `python .github/scripts/validate_framework.py`
   - `python .github/scripts/selftest.py`
5. In caso di FAIL fermati, correggi e riesegui i gate.
