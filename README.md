# Paradox Accessibility Framework

Framework operativo per sviluppo semi-autonomo di addon NVDA, con orchestrazione agenti, template, prompt, skill e quality gate ripetibili.

## Obiettivo

Rendere implementazione e validazione di addon NVDA prevedibili e tracciabili:

1. requisiti e design tecnico
2. implementazione incrementale
3. review orientata al rischio
4. validazione automatizzata
5. documentazione e changelog

## Architettura ad alto livello

- runtime framework: `.github/`
- documentazione funzionale: `docs/`
- tracciamento attività piano: `todo.md`
- log modifiche: `changelog.md`

## Mappa framework (.github)

- `agents/`: ruoli specializzati del ciclo operativo
- `config/`: registry pipeline e required_paths
- `instructions/`: regole operative globali
- `prompts/`: prompt task-oriented incluse varianti NVDA
- `scripts/`: tool CLI (bootstrap, validate, selftest, lint, release prep)
- `skills/`: base conoscenza operativa (inclusa skill NVDA)
- `templates/`: scaffold addon e frammenti feature
- `workflows/`: CI quality gate
- `reports/`: evidenze di validazione/pipeline

Ogni cartella e sottocartella del framework contiene ora un `README.md` dedicato con panoramica dei componenti locali.

## Comandi operativi principali

- validazione framework:
  - `python .github/scripts/validate_framework.py`
- selftest end-to-end:
  - `python .github/scripts/selftest.py`
- lint addon generati:
  - `python .github/scripts/lint_addon.py --root generated_addons`
- bootstrap addon:
  - `python .github/scripts/bootstrap_addon.py --addon-id helloNVDA --name "helloNVDA" --type global --author Nemex81 --version 1.0.0 --description "Pilot addon" --output-dir generated_addons`
- pipeline agenti:
  - `python .github/scripts/run_agent_pipeline.py --task-type feature --mode auto`
- aggiornamento changelog:
  - `python .github/scripts/update_changelog.py --title "Titolo" --category Changed --details "Dettaglio"`

## Addon NVDA: modalità supportate

- global addon: estensioni in `globalPlugins/`
- app addon: estensioni in `appModules/` con possibile uso di overlay class

Riferimento API obbligatorio:

- repository locale `nvda`
- `nvda/source`
- `nvda/projectDocs/dev/developerGuide/developerGuide.md`

## Legacy AHK

Il runtime AutoHotkey storico e deprecato nel perimetro framework corrente.

Riferimenti di riciclo:

- `docs/legacy_recycle_matrix.md`
- `docs/legacy_hotkeys_reference.md`

## Licenza

Vedi `licenze.md`.
