# TODO Implementazione Piano Integrazione NVDA Framework

Fonte piano validato: [todo - PIANO_INTEGRAZIONE_NVDA_FRAMEWORK.md]
Fonte API NVDA: repository locale nvda, branch master, commit be350b052.

## Fase 1 - Skill NVDA Core
- [x] Creare .github/skills/nvda_addon_development.skill.md
- [x] Inserire struttura addon obbligatoria e moduli NVDA confermati
- [x] Correggere regola versioni manifest: stringa Year.Major(.Minor), non tuple
- [x] Aggiungere riferimento skill in .github/config/framework.json
- [x] Eseguire validate_framework.py
- [x] Eseguire selftest.py
- [x] Aggiornare changelog.md

## Fase 2 - Specializzazione Agenti NVDA
- [x] Aggiungere sezione NVDA Context in requirements.agent.md
- [x] Aggiungere sezione NVDA Context in architecture.agent.md
- [x] Aggiungere sezione NVDA Context in implementation.agent.md
- [x] Aggiungere sezione NVDA Context in review.agent.md
- [x] Aggiungere sezione NVDA Context in validation.agent.md
- [x] Aggiungere sezione NVDA Context in release.agent.md
- [x] Aggiornare orchestrator.agent.md per routing task NVDA
- [x] Aggiungere sezione NVDA Context in docs_maintenance.agent.md
- [x] Eseguire validate_framework.py
- [x] Eseguire selftest.py
- [x] Aggiornare changelog.md

## Fase 3 - Template Addon
- [x] Creare buildVars.py.template
- [x] Creare sconstruct.template
- [x] Creare template locale it/en
- [x] Estendere template global plugin con @script e terminate
- [x] Creare template appModules
- [x] Completare templates/feature_script
- [x] Aggiornare bootstrap_addon.py
- [x] Aggiornare framework.json required_paths
- [x] Eseguire validate_framework.py
- [x] Eseguire selftest.py
- [x] Aggiornare changelog.md

## Fase 4 - Prompt NVDA
- [x] Creare nvda_new_addon.prompt.md
- [x] Creare nvda_addon_review.prompt.md
- [x] Creare nvda_bugfix.prompt.md
- [x] Aggiornare prompt esistenti con riferimenti NVDA
- [x] Eseguire validate_framework.py
- [x] Eseguire selftest.py
- [x] Aggiornare changelog.md

## Fase 5 - CI e Script
- [x] Creare .github/scripts/lint_addon.py
- [x] Aggiornare .github/workflows/ci.yml
- [x] Aggiornare validate_framework.py
- [x] Eseguire validate_framework.py
- [x] Eseguire selftest.py
- [x] Eseguire lint_addon.py
- [x] Aggiornare changelog.md

## Fase 6 - Istruzioni Globali
- [x] Aggiornare .github/copilot-instructions.md
- [x] Aggiornare .github/instructions/autonomous_framework.instructions.md
- [x] Eseguire validate_framework.py
- [x] Eseguire selftest.py
- [x] Aggiornare changelog.md

## Fase 7 - Addon Pilota
- [x] Definire addon pilota helloNVDA
- [x] Generare addon con bootstrap_addon.py
- [x] Validare struttura output
- [x] Eseguire lint_addon.py su output
- [x] Eseguire validate_framework.py
- [x] Eseguire selftest.py
- [x] Documentare test manuale in docs/test_pilota.md
- [x] Aggiornare changelog.md

## Stato complessivo
- [x] Piano di integrazione completato e allineato ai deliverable presenti nel repository
