# Piano di Integrazione NVDA Framework — v1.0.0
<!-- PIANO OPERATIVO VINCOLANTE PER COPILOT -->
<!-- Copilot DEVE leggere questo file prima di ogni implementazione -->
<!-- Copilot DEVE aggiornare le checkbox durante l'implementazione -->
<!-- Copilot DEVE correggere il piano al volo se trova incongruenze -->

---

## Regole Operative Inderogabili per Copilot

1. **Consultare questo piano** prima di iniziare qualsiasi fase o sottofase.
2. **Aggiornare le checkbox** `[ ]` → `[x]` man mano che si completano i punti, con data ISO e nota sintetica inline (es. `[x] 2026-03-17 — fatto`).
3. **Consultare le API NVDA** nel repository `nvaccess/nvda` (spazio di lavoro locale e GitHub) prima di scrivere qualsiasi codice che tocchi moduli NVDA. Non inventare nomi di classi, metodi o eventi.
4. **Autonomia corretta**: se durante l'implementazione si rileva un'incongruenza, un conflitto o un errore rispetto al piano, Copilot deve:
   a. fermarsi;
   b. elaborare una mini patch correttiva inline (sezione `## Patch Correttive` in fondo a questo file);
   c. aggiornare la fase/sottofase interessata con nota `[PATCH #N applicata]`;
   d. proseguire con la strategia corretta.
5. **Mai procedere** se un gate di qualità è rosso senza prima risolverlo o aprire una patch correttiva documentata.
6. **Ricalcolo di strategia**: se una sottofase risulta non implementabile come pianificata, Copilot genera una sottofase alternativa numerata con suffisso `.bis` (es. `2.3.bis`) e la documenta qui.
7. **Ogni fase** si chiude con l'esecuzione di:
   - `python .github/scripts/validate_framework.py`
   - `python .github/scripts/selftest.py`
   - aggiornamento di `changelog.md`

---

## Mappa del Framework Attuale (Baseline)

```
paradox-autohotkey-system/
├── .github/
│   ├── agents/              # 8 agenti (scheletri generici — da specializzare NVDA)
│   ├── config/
│   │   ├── agent_registry.json   # routing agenti e pipeline
│   │   └── framework.json        # manifesto path obbligatori
│   ├── instructions/
│   │   └── autonomous_framework.instructions.md
│   ├── prompts/             # 4 prompt generici — da estendere per NVDA
│   ├── scripts/             # 6 script Python operativi
│   ├── skills/              # 4 skill generiche — manca skill NVDA
│   ├── templates/
│   │   ├── addon_base/      # manifest.ini + globalPlugins/__init__.py (incompleto)
│   │   └── feature_script/  # vuoto
│   ├── workflows/
│   │   └── ci.yml           # validate + selftest su push/PR
│   ├── CODEOWNERS
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── copilot-instructions.md
│   └── dependabot.yml
├── docs/
├── PIANO_FRAMEWORK_COPILOT_NVDA.md   # piano strategico precedente
├── PIANO_INTEGRAZIONE_NVDA_FRAMEWORK.md  # questo file
├── README.md
├── changelog.md
└── licenze.md
```

---

## Obiettivo del Piano

Integrare nel framework esistente tutte le componenti mancanti specifiche per lo sviluppo di addon NVDA, rendendolo un laboratorio autonomo, completo e operativo. Il risultato finale deve permettere a Copilot di creare, revisionare, validare e rilasciare addon NVDA in modo indipendente, coerente e verificabile.

---

## Gate di Qualità Globali

| Gate | Condizione | Stato |
|------|-----------|-------|
| G0 | Path framework coerenti (già PASS) | ✅ PASS |
| G1 | Skill NVDA presente e referenziata dagli agenti | ✅ PASS |
| G2 | Tutti gli agenti hanno sezione `# NVDA Context` | ✅ PASS |
| G3 | Template addon completo (buildVars, locale, appModules) | ✅ PASS |
| G4 | Prompt NVDA-specifici presenti e testati | ✅ PASS |
| G5 | CI verifica sintassi Python addon e manifest | ✅ PASS |
| G6 | Ciclo completo testato su addon pilota | ✅ PASS |

Stato operativo dettagliato allineato in `todo.md` (tutte le fasi 1-7 completate).

---

## FASE 1 — Skill NVDA Core
**Priorità: CRITICA — prerequisito per tutte le fasi successive**
**Output atteso**: `.github/skills/nvda_addon_development.skill.md`

Questa skill è la base di conoscenza NVDA che tutti gli agenti devono referenziare.
Copilot deve consultare `nvaccess/nvda` per verificare nomi di moduli, classi e pattern prima di scrivere questa skill.

- [ ] 1.1 — Creare `.github/skills/nvda_addon_development.skill.md` con:
  - [ ] 1.1.1 — Struttura obbligatoria addon: `manifest.ini`, `buildVars.py`, `globalPlugins/`, `appModules/`, `locale/`
  - [ ] 1.1.2 — Moduli NVDA fondamentali: `globalPluginHandler`, `appModuleHandler`, `NVDAObjects`, `scriptHandler`, `ui`, `speech`, `tones`, `braille`, `config`, `gui`
  - [ ] 1.1.3 — Pattern `GlobalPlugin`: eredità, `scriptCategory`, `__gestures`, decoratore `@script`
  - [ ] 1.1.4 — Pattern `AppModule`: `event_NVDAObject_init`, overlay class, `chooseNVDAObjectOverlayClasses`
  - [ ] 1.1.5 — Ciclo di vita addon: `__init__`, `terminate`, gestione `config.conf`
  - [ ] 1.1.6 — Compatibilità versioni: `minimumNVDAVersion`, `lastTestedNVDAVersion`, formato tuple `(anno, major, minor)`
  - [ ] 1.1.7 — Convenzioni naming: `script_nomeAzione`, `event_nomeEvento`, `NomeClasseOverlay`
  - [ ] 1.1.8 — Gestione errori e logging: uso di `log.error`, `log.warning`, `log.debug` da `logHandler`
  - [ ] 1.1.9 — Internazionalizzazione: uso di `_()` e file `.po`/`.mo` in `locale/`
  - [ ] 1.1.10 — Packaging: uso di `scons` e `buildVars.py`, struttura `.nvda-addon`

- [ ] 1.2 — Aggiungere riferimento alla skill in `framework.json` sotto `required_paths`
- [ ] 1.3 — Verificare coerenza con `nvaccess/nvda` (Copilot deve dichiarare quale commit/tag ha consultato)
- [ ] 1.4 — Eseguire `validate_framework.py` e `selftest.py` — gate G1

**Nota Copilot**: se durante la stesura della skill trovi API deprecate o cambiate rispetto alla versione target `2023.1`–`2025.1`, apri una Patch Correttiva e documenta il delta di compatibilità.

---

## FASE 2 — Specializzazione Agenti per NVDA
**Priorità: ALTA**
**Dipendenza**: Fase 1 completata (skill nvda_addon_development disponibile)
**Output atteso**: 8 file `.agent.md` aggiornati con sezione `# NVDA Context`

### 2.1 — Agent-Requisiti
- [ ] 2.1.1 — Aggiungere sezione `# NVDA Context` con: tipi di addon (global/app-specific), vincoli compatibilità, formato acceptance criteria NVDA
- [ ] 2.1.2 — Aggiungere output obbligatorio: `addon_type` (global|app), `target_app` (se app-specific), `nvda_version_range`

### 2.2 — Agent-Architettura
- [ ] 2.2.1 — Aggiungere sezione `# NVDA Context` con: scelta tra `globalPlugins` vs `appModules`, pattern overlay class, impatto su `NVDAObjects`
- [ ] 2.2.2 — Aggiungere decisione obbligatoria: struttura cartelle addon, presenza/assenza `appModules`, necessità `locale/`

### 2.3 — Agent-Implementazione *(più urgente)*
- [ ] 2.3.1 — Aggiungere sezione `# NVDA Context` con riferimento esplicito a `nvda_addon_development.skill.md`
- [ ] 2.3.2 — Aggiungere regola: **consultare sempre le API NVDA prima di scrivere codice**
- [ ] 2.3.3 — Aggiungere regola: patch incrementali — un file alla volta, con verifica sintassi Python dopo ogni file
- [ ] 2.3.4 — Aggiungere regola: non usare `import *`, mai importare moduli NVDA non esistenti nella versione target
- [ ] 2.3.5 — Aggiungere stop condition: se un'API NVDA è ambigua o non trovata → aprire patch correttiva, NON procedere con un'ipotesi

### 2.4 — Agent-Review
- [ ] 2.4.1 — Aggiungere checklist review specifica NVDA: gesture conflicts, memory leaks in event handlers, uso scorretto di `wx` fuori dal thread UI, blocking calls nel thread principale
- [ ] 2.4.2 — Aggiungere verifica: `__gestures` non in conflitto con gesti NVDA nativi comuni

### 2.5 — Agent-Validazione
- [ ] 2.5.1 — Aggiungere step: verifica sintattica Python (`py_compile` o `flake8`)
- [ ] 2.5.2 — Aggiungere step: verifica campi obbligatori `manifest.ini` (name, summary, author, version, minimumNVDAVersion, lastTestedNVDAVersion)
- [ ] 2.5.3 — Aggiungere step: verifica esistenza `buildVars.py` se il packaging è richiesto

### 2.6 — Agent-Release
- [ ] 2.6.1 — Aggiungere step: generazione `.nvda-addon` tramite `scons` o equivalente
- [ ] 2.6.2 — Aggiungere verifica: semver nel `manifest.ini` coerente con `changelog.md`

### 2.7 — Agent-Architettura (orchestrator update)
- [ ] 2.7.1 — Aggiornare `orchestrator.agent.md`: aggiungere contesto NVDA nel routing (distinguere task `global-plugin` da `app-module` da `framework`)

### 2.8 — Agent-Docs
- [ ] 2.8.1 — Aggiungere sezione `# NVDA Context`: struttura `doc/` addon, formato `readme.md` per NV Access addon store, note per utenti screen reader

- [ ] 2.9 — Eseguire `validate_framework.py` e `selftest.py` — gate G2

---

## FASE 3 — Completamento Template Addon
**Priorità: ALTA**
**Dipendenza**: Fase 1 completata
**Output atteso**: template addon completo e funzionante per `globalPlugins` e `appModules`

### 3.1 — Template `addon_base` — file mancanti
- [ ] 3.1.1 — Creare `.github/templates/addon_base/buildVars.py.template` con: `addon_info` dict, campi obbligatori (`addon_name`, `addon_summary`, `addon_version`, `addon_minimumNVDAVersion`, `addon_lastTestedNVDAVersion`, `addon_url`)
- [ ] 3.1.2 — Creare `.github/templates/addon_base/sconstruct.template` (Sconstruct minimale per build `.nvda-addon`)
- [ ] 3.1.3 — Creare `.github/templates/addon_base/locale/it/LC_MESSAGES/nvda.po.template` (file PO minimale italiano)
- [ ] 3.1.4 — Creare `.github/templates/addon_base/locale/en/LC_MESSAGES/nvda.po.template` (file PO minimale inglese)
- [ ] 3.1.5 — Aggiornare `__init__.py.template` esistente: aggiungere `@script` decorator con `description`, `gesture`, aggiungere `terminate()`, aggiungere docstring con parametri NVDA

### 3.2 — Template `appModules` (nuovo)
- [ ] 3.2.1 — Creare `.github/templates/addon_base/appModules/__APP_NAME__/__init__.py.template` con: struttura `AppModule`, `event_NVDAObject_init`, esempio `chooseNVDAObjectOverlayClasses`
- [ ] 3.2.2 — Creare overlay class template con pattern completo

### 3.3 — Template `feature_script` (completare cartella vuota)
- [ ] 3.3.1 — Creare `.github/templates/feature_script/script_command.py.template`: script con `@script`, gesture, `ui.message`
- [ ] 3.3.2 — Creare `.github/templates/feature_script/settings_panel.py.template`: pannello impostazioni con `gui.settingsDialogs.SettingsPanel`
- [ ] 3.3.3 — Creare `.github/templates/feature_script/overlay_class.py.template`: overlay class con eventi e script

### 3.4 — Aggiornare `bootstrap_addon.py`
- [ ] 3.4.1 — Aggiungere supporto per `addon_type` (global|app): genera struttura corretta in base al tipo
- [ ] 3.4.2 — Aggiungere copia di `buildVars.py.template` e `sconstruct.template`
- [ ] 3.4.3 — Aggiungere generazione cartella `locale/` con PO template
- [ ] 3.4.4 — Aggiungere placeholder `__APP_NAME__` per app-specific addon

### 3.5 — Aggiornare `framework.json`
- [ ] 3.5.1 — Aggiungere tutti i nuovi path template a `required_paths`

- [ ] 3.6 — Eseguire `validate_framework.py` e `selftest.py` — gate G3

---

## FASE 4 — Prompt NVDA-Specifici
**Priorità: MEDIA-ALTA**
**Dipendenza**: Fase 1 e Fase 2 completate
**Output atteso**: 3 nuovi prompt `.prompt.md` nella cartella `.github/prompts/`

### 4.1 — Prompt `nvda_new_addon.prompt.md`
- [ ] 4.1.1 — Creare prompt con variabili: `{{addon_name}}`, `{{addon_type}}`, `{{target_app}}`, `{{nvda_version_range}}`, `{{description}}`
- [ ] 4.1.2 — Includere istruzione esplicita: "consulta `.github/skills/nvda_addon_development.skill.md` prima di generare codice"
- [ ] 4.1.3 — Includere step-by-step: requisiti → architettura → implementazione → validazione

### 4.2 — Prompt `nvda_addon_review.prompt.md`
- [ ] 4.2.1 — Creare checklist review: compatibilità versioni, gesture conflicts, thread safety, memory leaks, i18n
- [ ] 4.2.2 — Includere output atteso: lista problemi con severità (BLOCCANTE / ATTENZIONE / SUGGERIMENTO)

### 4.3 — Prompt `nvda_bugfix.prompt.md`
- [ ] 4.3.1 — Creare prompt con sezioni: descrizione bug, traceback/log NVDA, comportamento atteso, fix minimo proposto
- [ ] 4.3.2 — Aggiungere regola: fix minimo — non refactorizzare oltre lo scope del bug

### 4.4 — Aggiornare prompt esistenti
- [ ] 4.4.1 — `new_addon.prompt.md`: aggiungere riferimento a `nvda_new_addon.prompt.md` o sostituire
- [ ] 4.4.2 — `feature_implementation.prompt.md`: aggiungere contesto NVDA e riferimento alla skill

- [ ] 4.5 — Eseguire `validate_framework.py` e `selftest.py` — gate G4

---

## FASE 5 — Miglioramento CI e Script
**Priorità: MEDIA**
**Dipendenza**: Fase 3 completata
**Output atteso**: CI aggiornata, nuovo script `lint_addon.py`

### 5.1 — Nuovo script `lint_addon.py`
- [ ] 5.1.1 — Creare `.github/scripts/lint_addon.py`: cerca tutti i file `*.py` in cartelle addon generate, esegue `py_compile` su ciascuno, stampa PASS/FAIL per file
- [ ] 5.1.2 — Aggiungere verifica campi obbligatori `manifest.ini`
- [ ] 5.1.3 — Aggiungere verifica esistenza `buildVars.py` se presente `sconstruct`
- [ ] 5.1.4 — Exit code 0 = PASS, 1 = FAIL — obbligatorio per integrazione CI

### 5.2 — Aggiornare `ci.yml`
- [ ] 5.2.1 — Aggiungere step `lint_addon.py` dopo `selftest.py`
- [ ] 5.2.2 — Aggiungere step check presenza file obbligatori framework (già coperto da `validate_framework.py` ma esplicitare nel log CI)

### 5.3 — Aggiornare `validate_framework.py`
- [ ] 5.3.1 — Aggiungere verifica nuovi path aggiunti in Fase 3 e Fase 1

- [ ] 5.4 — Eseguire `validate_framework.py` e `selftest.py` e `lint_addon.py` — gate G5

---

## FASE 6 — Aggiornamento Istruzioni Globali Copilot
**Priorità: MEDIA**
**Dipendenza**: Fase 1, 2, 3 completate
**Output atteso**: `copilot-instructions.md` e `autonomous_framework.instructions.md` aggiornati

- [ ] 6.1 — Aggiornare `.github/copilot-instructions.md`:
  - [ ] 6.1.1 — Aggiungere sezione `## NVDA API Reference` con link a `nvaccess/nvda` e istruzione di consultazione obbligatoria
  - [ ] 6.1.2 — Aggiungere sezione `## Addon Types` con distinzione global/app-specific e quando usare quale
  - [ ] 6.1.3 — Aggiungere riferimento a `nvda_addon_development.skill.md`

- [ ] 6.2 — Aggiornare `.github/instructions/autonomous_framework.instructions.md`:
  - [ ] 6.2.1 — Aggiungere regola: prima di ogni task implementativo che tocca API NVDA, dichiarare esplicitamente quali moduli si useranno e verificarli nella skill
  - [ ] 6.2.2 — Aggiungere regola: aggiornare questo piano (`PIANO_INTEGRAZIONE_NVDA_FRAMEWORK.md`) con le checkbox durante l'implementazione
  - [ ] 6.2.3 — Aggiungere regola: in caso di patch correttiva, documentarla nella sezione `## Patch Correttive` di questo file

- [ ] 6.3 — Eseguire `validate_framework.py` e `selftest.py`

---

## FASE 7 — Addon Pilota di Test
**Priorità: ALTA (validazione finale)**
**Dipendenza**: Fasi 1–6 completate
**Output atteso**: addon NVDA funzionante generato dal framework, testabile con NVDA reale

- [ ] 7.1 — Definire addon pilota: `helloNVDA` — global plugin che annuncia un messaggio con NVDA+Shift+H
- [ ] 7.2 — Generare struttura con `python .github/scripts/bootstrap_addon.py --name helloNVDA --type global --author Nemex81 --version 1.0.0`
- [ ] 7.3 — Verificare struttura generata: `manifest.ini`, `buildVars.py`, `globalPlugins/helloNVDA/__init__.py`, `locale/`
- [ ] 7.4 — Eseguire `lint_addon.py` sulla struttura generata — PASS richiesto
- [ ] 7.5 — Eseguire `validate_framework.py` e `selftest.py` — gate G6
- [ ] 7.6 — Istruzioni test manuale con NVDA (da documentare in `docs/test_pilota.md`):
  1. Copiare cartella addon in `%APPDATA%\nvda\addons\`
  2. Riavviare NVDA
  3. Premere `NVDA+Shift+H`
  4. Verificare che NVDA annunci "helloNVDA active"
  5. Aprire menu NVDA → Preferenze → Gesti di immissione e verificare presenza script nella categoria `helloNVDA`
- [ ] 7.7 — Aggiornare `changelog.md` con voce addon pilota
- [ ] 7.8 — Aggiornare gate G6 in tabella gate sopra

---

## Matrice Dipendenze tra Fasi

```
Fase 1 (Skill NVDA)
  └─→ Fase 2 (Agenti)
  └─→ Fase 3 (Template)
        └─→ Fase 5 (CI/Script)
  └─→ Fase 4 (Prompt)
        Fase 2 + Fase 3 + Fase 4
              └─→ Fase 6 (Istruzioni Globali)
                    └─→ Fase 7 (Addon Pilota)
```

---

## Struttura Target Finale `.github/`

```
.github/
├── agents/
│   ├── orchestrator.agent.md          [NVDA Context aggiunto — Fase 2.7]
│   ├── requirements.agent.md          [NVDA Context aggiunto — Fase 2.1]
│   ├── architecture.agent.md          [NVDA Context aggiunto — Fase 2.2]
│   ├── implementation.agent.md        [NVDA Context aggiunto — Fase 2.3] ★
│   ├── review.agent.md                [NVDA Context aggiunto — Fase 2.4]
│   ├── validation.agent.md            [NVDA Context aggiunto — Fase 2.5]
│   ├── release.agent.md               [NVDA Context aggiunto — Fase 2.6]
│   └── docs_maintenance.agent.md      [NVDA Context aggiunto — Fase 2.8]
├── config/
│   ├── agent_registry.json            [invariato]
│   └── framework.json                 [aggiornato — Fase 3.5 + 1.2]
├── instructions/
│   └── autonomous_framework.instructions.md  [aggiornato — Fase 6.2]
├── prompts/
│   ├── documentation_maintenance.prompt.md   [invariato]
│   ├── feature_implementation.prompt.md      [aggiornato — Fase 4.4]
│   ├── new_addon.prompt.md                    [aggiornato — Fase 4.4]
│   ├── run_agent_pipeline.prompt.md           [invariato]
│   ├── nvda_new_addon.prompt.md               [NUOVO — Fase 4.1]
│   ├── nvda_addon_review.prompt.md            [NUOVO — Fase 4.2]
│   └── nvda_bugfix.prompt.md                  [NUOVO — Fase 4.3]
├── scripts/
│   ├── bootstrap_addon.py             [aggiornato — Fase 3.4]
│   ├── lint_addon.py                  [NUOVO — Fase 5.1]
│   ├── release_prep.py                [invariato]
│   ├── run_agent_pipeline.py          [invariato]
│   ├── selftest.py                    [invariato]
│   ├── update_changelog.py            [invariato]
│   └── validate_framework.py          [aggiornato — Fase 5.3]
├── skills/
│   ├── agent_orchestration.skill.md       [invariato]
│   ├── analysis.skill.md                  [invariato]
│   ├── documentation_maintenance.skill.md [invariato]
│   ├── validation.skill.md                [invariato]
│   └── nvda_addon_development.skill.md    [NUOVO — Fase 1] ★
├── templates/
│   ├── addon_base/
│   │   ├── buildVars.py.template          [NUOVO — Fase 3.1]
│   │   ├── sconstruct.template            [NUOVO — Fase 3.1]
│   │   ├── manifest.ini.template          [aggiornato — Fase 3.1]
│   │   ├── globalPlugins/__ADDON_ID__/__init__.py.template  [aggiornato — Fase 3.1]
│   │   ├── appModules/__APP_NAME__/__init__.py.template      [NUOVO — Fase 3.2]
│   │   └── locale/
│   │       ├── it/LC_MESSAGES/nvda.po.template  [NUOVO — Fase 3.1]
│   │       └── en/LC_MESSAGES/nvda.po.template  [NUOVO — Fase 3.1]
│   └── feature_script/
│       ├── script_command.py.template     [NUOVO — Fase 3.3]
│       ├── settings_panel.py.template     [NUOVO — Fase 3.3]
│       └── overlay_class.py.template      [NUOVO — Fase 3.3]
├── workflows/
│   └── ci.yml                         [aggiornato — Fase 5.2]
├── CODEOWNERS                         [invariato]
├── PULL_REQUEST_TEMPLATE.md           [invariato]
├── copilot-instructions.md            [aggiornato — Fase 6.1]
└── dependabot.yml                     [invariato]
```

---

## Patch Correttive
<!-- Copilot deve documentare qui ogni deviazione dal piano con formato standard -->

### Formato standard patch
```
### Patch #N — [data ISO]
**Fase interessata**: X.Y
**Problema riscontrato**: descrizione
**Strategia originale**: cosa era previsto
**Strategia corretta**: cosa si fa invece
**File modificati**: lista
**Impatto su altre fasi**: nessuno / specificare
```

*(sezione vuota — nessuna patch applicata finora)*

---

## Riepilogo Contatori

| Categoria | File NUOVI | File AGGIORNATI | Totale modifiche |
|-----------|-----------|-----------------|-----------------|
| Skills | 1 | 0 | 1 |
| Agents | 0 | 8 | 8 |
| Prompts | 3 | 2 | 5 |
| Templates | 7 | 2 | 9 |
| Scripts | 1 | 3 | 4 |
| Instructions | 0 | 2 | 2 |
| Workflows | 0 | 1 | 1 |
| **Totale** | **12** | **18** | **30** |

---

*Documento generato il 2026-03-17 — versione 1.0.0*
*Aggiornare questo file ad ogni implementazione. Non rimuovere le checkbox completate: archiviano la storia delle modifiche.*
