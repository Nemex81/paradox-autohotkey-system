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
6. Prima di ogni task implementativo che tocca API NVDA:
   - dichiara esplicitamente i moduli NVDA da usare;
   - verifica i moduli nella skill `.github/skills/nvda_addon_development.skill.md` e nella fonte locale `nvda`.
7. Durante implementazioni guidate da piano, aggiorna il tracker operativo `todo.md` con checkbox fase/sottofase.
8. Se emerge una patch correttiva rispetto al piano, documenta problema, strategia corretta e impatto nel tracker operativo e nel changelog.
