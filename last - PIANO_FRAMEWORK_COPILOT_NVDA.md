# Piano di Implementazione Mini Framework Copilot per Addon NVDA

## Esito Convalida del Piano

Stato: PASS (dopo correzioni)

## Esito Convalida Repository Corrente

Stato: PASS (al 2026-03-16, dopo implementazione G0)

Esiti rilevati durante verifica tecnica (prima del fix):

- i file del framework esistono sotto `.github/...`
- gli script e la CI referenziano invece path `framework/...`
- `validate_framework.py` fallisce per config non trovata
- `selftest.py` fallisce per script/template non trovati

Impatto:

- coerenza logica: media (asset presenti ma disallineati)
- validita operativa: bassa (quality gate non eseguibili nello stato attuale)
- affidabilita end-to-end: bassa finche non viene riallineata la struttura path

Esito finale dopo implementazione:

- validate: PASS (`python .github/scripts/validate_framework.py`)
- selftest: PASS (`python .github/scripts/selftest.py`)
- report di convalida aggiornato in `.github/reports/last_validation_report.txt`

Condizione di avanzamento:

- la pianificazione agenti puo partire subito
- il gate G0 risulta soddisfatto

Criteri usati per la convalida:

- Coerenza: fasi ordinate, dipendenze logiche, assenza di conflitti tra obiettivi e roadmap.
- Precisione: ogni fase ha output verificabili e criteri di completamento.
- Affidabilita: presenti quality gate, gestione rischi, fallback operativo e metriche.

Correzioni applicate per ottenere PASS:

- aggiunti gate di convalida misurabili
- aggiunta matrice fase -> output verificabile
- aggiunto registro rischi con mitigazioni
- aggiunte regole di fallback operativo

## Fasi di Implementazione (Checklist Operativa)

Usa questa sezione come tracker durante i lavori: spunta una fase quando completata e aggiorna le note di avanzamento.

- [ ] Fase 1 - Fondazioni del processo
  - [ ] Definire workflow end-to-end (idea -> validazione)
  - [ ] Definire ruoli agente (orchestratore, analista, implementatore, revisore, tester)
  - [ ] Definire Definition of Ready / Definition of Done
  - [ ] Definire formato output standard per ogni task
- [ ] Fase 2 - Regole e istruzioni operative
  - [ ] Creare istruzioni globali Copilot per addon NVDA
  - [ ] Definire standard Python (stile, logging, error handling)
  - [ ] Definire policy compatibilita NVDA/versioni
  - [ ] Definire policy test minimi obbligatori
- [ ] Fase 3 - Templates e scaffold
  - [ ] Template addon base (struttura + file principali)
  - [ ] Template feature (script command, gesture, settings)
  - [ ] Template i18n/localizzazione
  - [ ] Template test e regressione
- [ ] Fase 4 - Skills, prompt e agenti
  - [ ] Prompt pack (nuovo addon, nuova feature, bugfix, refactor)
  - [ ] Skill analisi requisiti e impatti
  - [ ] Skill generazione codice parametrica
  - [ ] Skill review tecnica e rischio regressioni
  - [ ] Skill convalida e report finale
  - [ ] Definire catalogo agenti specializzati (missione, input, output, limiti)
  - [ ] Definire regole di chiamata manuale e auto-invocazione orchestrata
  - [ ] Definire contratto toolchain agente (skills + istruzioni + script)
  - [ ] Definire fallback agente e handoff tra agenti
- [ ] Fase 5 - Automazione script e quality gate
  - [ ] Script bootstrap progetto
  - [ ] Script quality gate (lint/test/check)
  - [ ] Script pre-release (versione/changelog/pacchetto)
  - [ ] Comando unico per pipeline locale
- [ ] Fase 6 - Flusso autonomo end-to-end
  - [ ] Implementare orchestrazione automatica per task standard
  - [ ] Gestire stop condition e fallback
  - [ ] Generare report finale con esiti e rischi residui
  - [ ] Testare il flusso su un addon pilota
- [ ] Fase 7 - Governance e miglioramento continuo
  - [ ] Definire KPI operativi
  - [ ] Definire retro periodica
  - [ ] Aggiornare templates/skill in base ai dati
  - [ ] Consolidare standard stabili

- [ ] Fase 0 - Ideazione e discussione
  - [ ] Raccolta idea utente (descrizione breve)
  - [ ] Sessione conversazionale di chiarimento (Q&A)
  - [ ] Bozza di progetto (scope, epic, acceptance criteria)
  - [ ] Decisione sullo scope iniziale (Go/Refine/Abandon)

- [x] Fase 0.5 - Riallineamento strutturale repository
  - [x] Decidere standard path unico (`framework/` oppure `.github/`)
  - [x] Allineare config, script, CI e report allo standard scelto
  - [x] Rieseguire validate + selftest con esito PASS
  - [x] Bloccare regressioni path con check automatico in CI

## Matrice Fasi -> Output Verificabili

- Fase 1 output: documento workflow + DoR/DoD + template report task.
- Fase 2 output: file istruzioni operative Copilot + standard coding/test.
- Fase 3 output: cartella template con almeno addon base, feature, i18n, test.
- Fase 4 output: prompt pack + skill cards + agent cards con input/output/limiti definiti.
- Fase 5 output: script bootstrap/validate/release-prep eseguibili localmente.
- Fase 6 output: flusso autonomo testato su addon pilota con report finale.
- Fase 7 output: dashboard KPI minima + cadenza retro + backlog miglioramenti.

## Gate di Convalida Obbligatori

- Gate G0 (allineamento): tutti i riferimenti path framework sono coerenti e risolti.
- Gate G1 (struttura): tutte le 7 fasi hanno almeno 1 output verificabile.
- Gate G2 (operativita): esistono comandi ripetibili per bootstrap e validate.
- Gate G3 (qualita): ogni modifica significativa passa lint e test applicabili.
- Gate G4 (tracciabilita): ogni task chiude con report sintetico standard.
- Gate G5 (maturita): almeno 1 ciclo completo validato su addon pilota.

Regola di passaggio complessiva:

- PASS se tutti i gate G0-G5 sono soddisfatti.
- FAIL se almeno un gate non e soddisfatto.

## Obiettivo

Costruire un mini framework semi-autonomo per sviluppo addon NVDA con Copilot, in grado di coprire il ciclo completo:

1. Generazione
2. Analisi
3. Progettazione
4. Pianificazione
5. Codifica
6. Implementazione
7. Revisione
8. Convalida

## Architettura Operativa

### Ruoli Agente

- Orchestratore: interpreta la richiesta, sceglie il flusso, crea piano e controlla avanzamento.
- Analista: valuta requisiti, vincoli NVDA, impatti tecnici e rischi.
- Implementatore: crea/modifica codice a patch incrementali e verificabili.
- Revisore: controlla bug, regressioni, rischi di compatibilita e debt tecnico.
- Tester/Validatore: esegue quality gate e produce report di conformita.

### Architettura Agenti Specializzati

Obiettivo: rendere gli agenti invocabili sia manualmente dall'utente sia automaticamente dall'orchestratore, con comportamento prevedibile e verificabile.

Catalogo minimo agenti (v1):

- Agent-Requisiti: chiarisce obiettivi, vincoli NVDA, criteri di accettazione.
- Agent-Architettura: definisce design tecnico, impatti e strategia di modifica minima.
- Agent-Implementazione: applica patch incrementali e tracciabili.
- Agent-Review: analizza bug/rischi/regressioni e copertura test.
- Agent-Validazione: esegue script di quality gate e produce esito PASS/FAIL.
- Agent-Release: prepara versione/changelog/pacchetto quando i gate sono verdi.

Contratto agente standard:

- Input: richiesta normalizzata + contesto file + vincoli + gate target.
- Output: artefatto atteso + log azioni + file toccati + rischi residui.
- Stop condition: ambiguita requisito critica, impatto non sicuro, gate rosso non mitigabile.
- Handoff: ogni agente produce payload strutturato per il successivo.

Regole di invocazione:

- Modalita manuale: l'utente richiama un agente specifico per task mirato.
- Modalita autonoma: l'orchestratore seleziona e concatena agenti in base al tipo task.
- Priorita sicurezza: in caso di conflitto vince la policy di rischio minima.

Compatibilita toolchain per ogni agente:

- skills: obbligatorie per analisi/review/validazione contestuale.
- istruzioni: obbligatorie per policy NVDA, coding standard e DoR/DoD.
- scripts: obbligatori per bootstrap/validate/release-prep quando applicabili.

Governance agenti:

- versione agente (`agent_version`) con changelog dedicato
- owner per ogni agente e SLA minimo di manutenzione
- test di regressione agente su casi campione
- deprecazione controllata con finestra di compatibilita

### Regole di Esecuzione

- Ogni task parte da analisi minima obbligatoria.
- Modifiche piccole e progressive, con verifica dopo ogni step.
- Nessuna modifica distruttiva senza conferma esplicita.
- Ogni task termina con report sintetico: fatto, test eseguiti, rischi residui.
- Ogni task deve indicare esplicitamente file toccati e impatto atteso.

## Standard di Qualita

### Definition of Ready (DoR)

Un task e pronto quando:

- requisito espresso chiaramente
- contesto file/cartelle identificato
- impatto previsto su API o comportamento noto
- criterio di accettazione presente

### Definition of Done (DoD)

Un task e completato quando:

- codice implementato e coerente con standard
- test minimi eseguiti (o motivazione del non-eseguibile)
- review tecnica effettuata
- nessun errore bloccante aperto
- report finale prodotto
- evidenze salvate (log test o motivazione tecnica del non-eseguibile)

## Pacchetto Deliverable del Framework

### 1) Istruzioni e policy

- regole Copilot globali per addon NVDA
- policy coding Python e naming
- policy logging e gestione eccezioni
- policy test e convalida

### 2) Libreria template

- addon base
- feature ricorrenti (gesture/script/settings)
- i18n/localizzazione
- test base + regressione

### 3) Skill/Prompt pack

- prompt operativo per scenari standard
- skill per analisi/generazione/review/validazione
- schema input/output uniforme

### 4) Automazione script

- bootstrap nuovo addon
- quality gate locale
- pre-release e packaging

### 5) Agent pack

- agent cards con missione, limiti e criteri di successo
- registry agenti con mapping task -> agente consigliato
- policy di routing orchestratore (manuale/autonomo)
- playbook handoff e fallback multi-agente

## Automazione Consigliata

### Comandi target

- bootstrap: crea struttura da template con variabili (nome addon, autore, versione, descrizione)
- validate: lint + test + check manifest/config
- release-prep: aggiornamento versione + changelog + bundle

Requisito minimo di affidabilita script:

- ogni script deve restituire exit code 0 in caso di successo
- ogni script deve stampare riepilogo finale con esito PASS/FAIL
- ogni script deve fallire in modo esplicito su prerequisiti mancanti

### Risultato atteso

Un flusso one-command per i task ricorrenti, con riduzione errori manuali e maggiore prevedibilita.

## Workflow Autonomo Tipo

1. Input requisito
2. Analisi impatti
3. Piano tecnico breve
4. Implementazione incrementale
5. Self-review
6. Esecuzione quality gate
7. Report finale con rischi residui

Routing consigliato (autonomo):

1. Orchestratore classifica il task
2. Chiama Agent-Requisiti e Agent-Architettura
3. Chiama Agent-Implementazione
4. Chiama Agent-Review
5. Chiama Agent-Validazione
6. Se PASS e richiesto, chiama Agent-Release
7. Consegna report unico all'utente

Stop condition obbligatorie:

- API NVDA non documentata o ambiguamente interpretabile
- test falliti su comportamento core senza fix sicuro entro 2 iterazioni
- impatto regressivo su funzioni esistenti senza mitigazione pronta

Fallback operativo:

- passaggio da flusso autonomo a flusso assistito con approvazione umana
- riduzione dello scope al minimo cambiamento sicuro
- apertura task tecnico dedicato per debito o incertezza residua

## Registro Rischi e Mitigazioni

- Rischio: template troppo generici.
  Mitigazione: aggiungere esempi concreti per script command, gesture e settings.
- Rischio: automazione fragile su ambienti diversi.
  Mitigazione: validare script su almeno 2 setup locali prima di consolidare.
- Rischio: eccesso di autonomia su task critici.
  Mitigazione: introdurre stop condition obbligatorie e review umana mirata.
- Rischio: regressioni non rilevate.
  Mitigazione: quality gate obbligatorio + test addon pilota end-to-end.

## KPI e Governance

### KPI minimi

- tempo medio idea -> addon scaffold
- tempo medio feature -> validazione
- percentuale task risolti al primo ciclo
- regressioni rilevate dopo merge

### Cadenza miglioramento

- retro ogni 2 settimane
- aggiornamento template/skill in base ai failure pattern
- consolidamento delle pratiche che riducono regressioni

## Roadmap in 4 settimane

### Settimana 1

- definire processo, ruoli, DoR/DoD, checklist

### Settimana 2

- creare template core e scaffold iniziale

### Settimana 3

- creare prompt/skill pack, catalogo agenti v1 e quality gate locale

### Settimana 4

- test end-to-end su addon pilota + tuning finale + prova routing multi-agente

## Criteri di Successo

- nuovo addon creato in meno di 15 minuti
- feature standard implementata e validata in meno di 1 ora
- quality gate eseguito su ogni modifica significativa
- report finale sempre disponibile

Soglia di affidabilita del framework:

- almeno 90% dei task standard deve chiudersi senza rilavorazioni maggiori
