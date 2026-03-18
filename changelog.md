# Changelog

## [Unreleased]

### Changed

- Aggiunti agenti specializzati con routing manuale e automatico
- Aggiunto agente Documentazione con obbligo aggiornamento changelog
- Aggiunti script run_agent_pipeline.py e update_changelog.py con validazione in selftest
- Rimosso workspace obsoleto non coerente con il repository
- README riallineato al framework attuale e al perimetro .github
- Aggiunte reference di riciclo legacy in docs/legacy_recycle_matrix.md e docs/legacy_hotkeys_reference.md
- Aggiunta skill NVDA core `.github/skills/nvda_addon_development.skill.md` con API verificate su repository NVDA locale
- Aggiornato `.github/config/framework.json` con path obbligatorio della nuova skill NVDA
- Specializzati 8 agenti con sezione `# NVDA Context` e regole operative per addon global/app
- Completata Fase 3 template addon: aggiunti buildVars, sconstruct, locale it/en, appModules e feature template; esteso bootstrap con supporto `--type` e `--app-name`
- Completata Fase 4 prompt NVDA: aggiunti `nvda_new_addon`, `nvda_addon_review`, `nvda_bugfix` e aggiornati prompt esistenti
- Completata Fase 5 quality gate addon: aggiunto `.github/scripts/lint_addon.py`, aggiornata CI e migliorato `validate_framework.py` con controllo duplicati
- Completata Fase 6 istruzioni globali: aggiornate policy NVDA in `.github/copilot-instructions.md` e `.github/instructions/autonomous_framework.instructions.md`
- Completata Fase 7 addon pilota `helloNVDA` con lint PASS e documentazione test manuale in `docs/test_pilota.md`
- Documentazione framework estesa: aggiornato `README.md` root e aggiunti `README.md` in tutte le cartelle e sottocartelle di `.github/` per panoramica componenti e strumenti

### Docs

- Creato .github/copilot-instructions.md con architettura, comandi e convenzioni operative
- Aggiunti link a documentazione esistente per evitare duplicazioni
- Aggiunta knowledge base `docs/nvda_addon_sources.md` con fonti web curate per sviluppo addon NVDA (API, community, Python, accessibilita e quality)
- Integrata policy di consultazione read-only dei repository NV Access locali per analisi incrociate in `.github/copilot-instructions.md`, `.github/instructions/autonomous_framework.instructions.md` e `docs/nvda_addon_sources.md`

## [1.0.0] - 2025-11-22

### Added

- Sistema base per Crusader Kings 3
