# Paradox Accessibility Framework

Framework operativo per sviluppo semi-autonomo di addon e automazioni accessibili orientate a NVDA, con pipeline agenti, skill, prompt e quality gate ripetibili.

## Stato attuale

- stack operativo: framework in `.github/`
- orchestrazione: agenti specializzati con routing manuale o automatico
- quality gate: `validate_framework.py` e `selftest.py`
- governance documentale: aggiornamento changelog automatizzato

## Componenti principali

- agenti: `.github/agents/`
- registry agenti: `.github/config/agent_registry.json`
- script framework: `.github/scripts/`
- prompt: `.github/prompts/`
- skill: `.github/skills/`
- istruzioni: `.github/instructions/`
- piano strategico: `PIANO_FRAMEWORK_COPILOT_NVDA.md`

## Comandi principali

- validazione struttura:
  - `python .github/scripts/validate_framework.py`
- selftest end-to-end:
  - `python .github/scripts/selftest.py`
- risoluzione pipeline agenti:
  - `python .github/scripts/run_agent_pipeline.py --task-type feature --mode auto`
- aggiornamento changelog:
  - `python .github/scripts/update_changelog.py --title "Titolo" --category Changed --details "Dettaglio"`

## Legacy AHK

Il precedente runtime AutoHotkey e stato deprecato nel perimetro corrente.

- elementi utili riciclati: pattern hotkey, flussi OCR/click, contenuti help
- elementi runtime rimossi: eseguibile/script AHK monolitici e config legacy

Riferimenti di riciclo:

- `docs/legacy_recycle_matrix.md`
- `docs/legacy_hotkeys_reference.md`

## Licenza

Vedi `licenze.md`.
