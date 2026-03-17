# Scripts

Automazioni CLI del framework.

## Script principali

- bootstrap_addon.py: genera scaffold addon (global/app).
- validate_framework.py: controlla required_paths e consistenza manifesto.
- selftest.py: test end-to-end dei flussi principali.
- lint_addon.py: sintassi Python addon + controlli manifest.
- run_agent_pipeline.py: risolve pipeline agenti da task-type.
- update_changelog.py: inserisce voci changelog strutturate.
- release_prep.py: bump patch version su manifest.

## Sequenza consigliata

1. bootstrap (se serve scaffold)
2. validate
3. selftest
4. lint_addon (quando si validano addon generati)
