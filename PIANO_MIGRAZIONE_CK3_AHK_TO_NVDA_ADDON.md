# Piano Migrazione CK3 da AHK a Addon NVDA

## Obiettivo

Usare il sistema AutoHotkey storico per CK3 come fonte di analisi e trasformarlo in un addon NVDA nativo, in modo da eliminare la dipendenza operativa da AHK e ridurre conflitti con gesture e comandi di NVDA.

Vincolo architetturale non negoziabile: tutti i comandi del nuovo addon devono essere specifici per CK3. Non va introdotto alcun set di comandi globali attivo fuori dal contesto `ck3.exe`.

Questo piano e basato su analisi incrociata di:

- sorgente AHK esterna in `Documents\Paradox Interactive\autohotkey scripts` (sola lettura)
- API NVDA nel repository locale `nvda` (sola lettura)
- stato attuale del progetto addon/framework in questo repository

## Risultati dell'analisi incrociata

### 1. Cosa fa davvero oggi il sistema AHK

Le aree funzionali emerse dai file `GlobalHotkeys.ahk`, `ck3_script/HOTKEYS.ahk`, `Utils.ahk`, `Speech.ahk` e `NVDA.ahk` sono queste:

1. toggle runtime e stato script: attivo/disattivo, debug, suoni, voce, modalita intensa
2. annunci vocali e feedback sonori
3. uso del cursore NVDA come ancora operativa per routing mouse e OCR
4. click sinistro/destro, click al centro, dismiss del mouse, utility cursore
5. macro CK3 specifiche basate su tasti e coordinate schermo
6. bridge esterno verso NVDA tramite `nvdaControllerClient.dll` con fallback SAPI

### 2. Cosa puo diventare addon NVDA nativo

Le seguenti capacita sono gia coperte bene dalle API NVDA locali e non richiedono piu il bridge AHK + DLL:

1. annunci e feedback: `ui.message`, `speech`, `braille`, `tones`
2. navigator object e review cursor: `api.getNavigatorObject`, `api.getReviewPosition`, `api.setNavigatorObject`
3. movimento mouse verso oggetto NVDA: `api.moveMouseToNVDAObject` e script NVDA equivalente
4. click mouse: `mouseHandler.doPrimaryClick`, `mouseHandler.doSecondaryClick`, `mouseHandler.executeMouseEvent`
5. OCR nativo: `contentRecog.recogUi.recognizeNavigatorObject` con `contentRecog.uwpOcr.UwpOcr`
6. emulazione tasti verso applicazione: `keyboardHandler.KeyboardInputGesture.fromName(...).send()` oppure `gesture.send()`

Conferma API NVDA rilevante emersa dalla validazione:

1. il Developer Guide conferma che per un'app specifica la collocazione corretta e `appModules/<exeName>.py`
2. NVDA usa davvero `contentRecog.uwpOcr.UwpOcr` e `contentRecog.recogUi.recognizeNavigatorObject` nel proprio `globalCommands.py`
3. NVDA aggiunge automaticamente ai package path addon solo directory come `appModules` e `globalPlugins`, non un generico `lib/` addon

### 3. Cosa non va copiato 1:1 dal sistema AHK

1. `nvdaControllerClient.dll`: inutile dentro un addon, perche l'addon gira gia nel processo NVDA
2. fallback SAPI separato: non e il modello corretto per un addon NVDA nativo
3. scelta dinamica del tasto NVDA (`Insert`, `CapsLock`, `NumpadIns`): dentro l'addon va sostituita con chiamate API dirette, non con simulazione del tasto NVDA
4. parcheggio mouse off-screen come comportamento generale: puo restare opzionale, ma non deve guidare l'architettura
5. hotkey globali aggressive: vanno ridotte o rese app-specifiche per evitare conflitti con NVDA e con altri contesti

### 4. Vincolo architetturale chiave

Per CK3, il modello corretto non e un global plugin puro ma un addon di tipo `app` centrato su `ck3.exe`, con logica primaria in `appModules/ck3.py`.

Motivo:

1. i comandi sono utili quasi solo nel contesto del gioco
2. riduce il rischio di gesture in conflitto fuori dal gioco
3. consente regole condizionali piu semplici su focus, finestra attiva e stato UI
4. e piu coerente con la richiesta di sostituire AHK senza introdurre un layer globale invasivo

Corollario operativo:

1. nessuna gesture del nuovo addon deve essere registrata come comando globale pensato per uso cross-app
2. anche i toggle di stato, help, info e debug devono esistere solo nel contesto CK3
3. eventuali utility riusabili possono essere implementate come moduli interni, ma non come feature utente globali

## Mappa funzionale AHK -> addon NVDA

### Blocco A - Stato addon e feedback

Comandi AHK coinvolti:

- toggle script
- toggle suoni
- toggle voce
- toggle debug
- modalita intensa
- help e info

Strategia addon:

1. creare un modulo config dedicato con sezione `config.conf["paradoxCK3"]`, ma solo dopo registrazione esplicita della config spec custom
2. esporre script NVDA con `@script` per toggle e riepilogo stato
3. usare `ui.message` per feedback breve e `tones.beep` per conferme sonore opzionali
4. aggiungere un piccolo settings panel solo dopo aver stabilizzato i primi script

Nota di validazione:

`config.conf["paradoxCK3"]` non va trattata come disponibile implicitamente. Il piano deve prevedere inizializzazione e registrazione esplicita della sezione/config spec prima del primo accesso.

Snippet operativo consigliato (pattern NVDA consolidato):

```python
import config

_PARADOX_CK3_SPEC = {
   "enabled": "boolean(default=true)",
   "beeps": "boolean(default=true)",
   "speech": "boolean(default=true)",
   "debug": "boolean(default=false)",
   "intenseMode": "boolean(default=false)",
   "ocrDelayMs": "integer(default=180,min=0,max=2000)",
}


def ensureConfigSpec():
   if "paradoxCK3" not in config.conf.spec:
      config.conf.spec["paradoxCK3"] = _PARADOX_CK3_SPEC


def getSection():
   ensureConfigSpec()
   return config.conf["paradoxCK3"]
```

Esito atteso:

- sostituzione completa delle funzioni AHK di stato, ma solo quando CK3 e il contesto attivo

### Blocco B - Routing mouse e click speculari

Comandi AHK coinvolti:

- `-`
- `,`
- `^,`
- `+,`
- `.`
- `^Enter`
- utility cursore correlate

Strategia addon:

1. implementare un adapter interno `mouse_ops.py` che incapsuli:
   - move mouse to navigator/review target
   - click sinistro
   - click destro
   - eventuale invio `enter`
   - ritorno esito e logging
2. usare API NVDA, non simulazione del tasto NVDA
3. separare chiaramente le azioni pure NVDA (navigator/review/click) da quelle di automazione generica Windows

Esito atteso:

- primo nucleo di comandi speculari affidabili rispetto all'AHK storico

### Blocco C - OCR speculare nativo

Comandi AHK coinvolti:

- `\`
- tutte le combo click + OCR
- pausa + OCR

Strategia addon:

1. creare un servizio `ocr_ops.py`
2. usare `recognizeNavigatorObject(UwpOcr())` come punto di partenza
3. definire una pipeline chiara:
   - prepara target NVDA/navigator object
   - opzionale azione mouse/tasto
   - attende delay minimo configurabile
   - avvia OCR nativo NVDA
4. prevedere error handling esplicito per:
   - oggetto senza location
   - contenuto non visibile
   - OCR non disponibile o fallito
   - Windows OCR non disponibile nel sistema
   - screen curtain attivo: da trattare come rischio osservazionale, non come guardia implementabile via API pubblica stabile

Esito atteso:

- sostituzione della scorciatoia AHK che preme il tasto OCR di NVDA con chiamata API nativa piu robusta

### Blocco D - Navigazione e macro leggere CK3

Comandi AHK coinvolti:

- `+F1`, `+F2`
- `^+p`
- comandi help/riassunto CK3

Strategia addon:

1. per PageUp/PageDown e simili usare `KeyboardInputGesture.fromName(...).send()`
2. per macro semplici composte da pochi tasti usare un layer `game_actions.py`
3. ogni macro deve essere atomica, con logging e feedback minimo

Esito atteso:

- replica dei comandi di navigazione senza usare AHK come orchestratore esterno

### Blocco E - Macro coordinate CK3 ad alto rischio

Comandi AHK coinvolti:

- `^g` selezione armate
- click al centro e varianti
- dismiss/center basati su coordinate schermo

Strategia addon:

1. trattarli come fase separata e non come prerequisito del primo rilascio
2. introdurre un `coordinate_actions.py` con profili risoluzione e fallback disabilitato di default
3. usare coordinate solo quando non esiste un target accessibile NVDA o una sequenza tasti stabile
4. richiedere validazione manuale per ogni macro e ogni risoluzione supportata

Esito atteso:

- migrazione controllata delle parti piu fragili del vecchio sistema

## Architettura addon consigliata

Struttura consigliata per il primo addon reale:

1. `appModules/ck3.py`
2. `appModules/paradox_ck3/__init__.py`
3. `appModules/paradox_ck3/config.py`
4. `appModules/paradox_ck3/state.py`
5. `appModules/paradox_ck3/mouse_ops.py`
6. `appModules/paradox_ck3/ocr_ops.py`
7. `appModules/paradox_ck3/game_actions.py`
8. `appModules/paradox_ck3/help_text.py`

Ruoli:

1. `ck3.py`: binding script NVDA, gating sul contesto gioco, announce finale
2. `state.py`: toggle runtime e profilo operativo
3. `mouse_ops.py`: move/click/right click/enter/dismiss opzionale
4. `ocr_ops.py`: OCR nativo NVDA e gestione esiti
5. `game_actions.py`: macro tastiera e macro coordinate
6. `config.py`: default, persistenza, feature flags

Correzione strutturale derivata dalla validazione NVDA:

il layout precedente con `lib/paradox_ck3/...` non e considerato supportato in modo implicito dal loader addon di NVDA. Per ridurre rischio di import path instabili, i moduli di supporto vanno collocati sotto `appModules/paradox_ck3/` oppure nello stesso package gia caricato da NVDA.

## Strategia gesture

Principio guida: non clonare alla cieca tutte le hotkey AHK.

Vincolo aggiuntivo: tutte le gesture del progetto devono essere CK3-scoped. Se CK3 non e la finestra attiva, il modulo non deve esporre comandi operativi all'utente.

Regole:

1. mantenere come default solo un set minimo e non distruttivo
2. esporre tutte le azioni nel dialogo gesture di NVDA con `scriptCategory = "Paradox CK3"`
3. evitare di occupare gesture NVDA gia molto note se non strettamente necessario
4. privilegiare script con nomi stabili e rimappabili dall'utente
5. non definire un global plugin parallelo per duplicare i comandi CK3

Set iniziale consigliato:

1. OCR sul target corrente
2. click sinistro sul target NVDA
3. click destro sul target NVDA
4. routing mouse al target NVDA
5. toggle modalita intensa
6. riepilogo stato addon
7. help rapido CK3

## Piano di azione generale

Pre-flight obbligatorio prima della Fase 0 CK3:

1. correggere `buildVars.py` dell'addon pilota e del template framework usando tuple per `addon_minimumNVDAVersion` e `addon_lastTestedNVDAVersion`
2. confermare esclusione `__pycache__` e `*.pyc` via `.gitignore` root
3. completare test manuale NVDA reale su `helloNVDA` (gesture `NVDA+Shift+H` e presenza categoria nel dialogo Gesti)
4. solo dopo questi controlli, procedere con la baseline CK3 reale

### Fase 0 - Baseline addon CK3

1. generare un addon di tipo `app` per `ck3.exe`
2. definire manifest, versione target NVDA e struttura moduli interni sotto `appModules/`
3. aggiungere logging dedicato
4. registrare la config spec custom `paradoxCK3` prima di leggere o scrivere stato addon
5. predisporre packaging iniziale con `buildVars.py` e `sconstruct` per build `.nvda-addon` ripetibile

Output:

- addon caricabile da NVDA senza feature CK3 ancora attive

### Fase 1 - Comandi speculari a basso rischio

1. portare toggle stato, help e info
2. introdurre feedback nativo NVDA
3. verificare che ogni script sia esposto solo dentro `appModules/ck3.py` e non come comando globale
4. verificare assenza conflitti gesture principali

Output:

- equivalente addon delle funzioni di stato CK3 senza introdurre comandi globali

### Fase 2 - Mouse e OCR nativi

1. portare routing mouse, click sinistro/destro, enter su target
2. implementare OCR nativo via contentRecog con controlli preliminari coerenti al comando OCR nativo di NVDA
3. aggiungere combinazioni sequenziali tipo click + OCR

Output:

- primo set realmente utile per sostituire AHK durante il gioco

### Fase 3 - Macro tastiera CK3

1. portare pagina su/giu e pause o altre macro a bassa complessita
2. modellare le azioni come operazioni riusabili, non script monolitici

Output:

- set di comandi speculari per gameplay base

### Fase 4 - Macro coordinate e automazioni fragili

1. portare solo le macro che non hanno alternativa accessibile
2. introdurre profili di risoluzione e feature flag
3. test manuale obbligatorio su CK3 reale

Output:

- migrazione selettiva delle automazioni piu delicate

### Fase 5 - Consolidamento e deprecazione AHK

1. confrontare copertura addon vs AHK
2. classificare i comandi AHK in:
   - sostituiti al 100 percento
   - sostituiti con variante NVDA nativa
   - ancora da mantenere fuori addon
3. preparare guida utente di transizione

Output:

- roadmap concreta per dismissione del supporto AHK esterno

## Backlog prioritizzato per la prima iterazione

Priorita alta:

1. addon app-specific `ck3`
2. config runtime con config spec esplicita
3. help/info/toggle stato
4. package di supporto sotto `appModules/paradox_ck3`
5. route mouse to navigator target
6. left click, right click, enter on target
7. OCR nativo NVDA su target corrente
8. click + OCR e right click + OCR

Priorita media:

1. page up / page down speculari
2. pausa + OCR
3. dismiss e center come utility opzionali

Priorita bassa:

1. selezione armate via coordinate
2. click al centro e varianti coordinate
3. emulazione completa di tutti i vecchi beep/suoni AHK

## Criteri di accettazione

Il primo rilascio dell'addon puo dirsi riuscito quando:

1. l'utente non ha piu bisogno di AHK per OCR, routing mouse e click principali in CK3
2. i comandi sono rimappabili dal dialogo gesture di NVDA
3. l'addon funziona solo in contesto CK3 e non introduce alcun comando operativo globale fuori dal gioco
4. non usa `nvdaControllerClient.dll` ne fallback SAPI esterni
5. i log consentono di capire con precisione dove falliscono OCR, location e macro

## Decisione esplicita sul perimetro dei comandi

Per evitare ambiguita future:

1. il progetto target e un addon CK3-specifico, non una suite globale Paradox
2. i comandi storicamente classificati come globali in AHK vanno reinterpretati come comandi disponibili solo dentro CK3, se ancora utili
3. nessun comando deve restare attivo come scorciatoia utente fuori da CK3
4. se in futuro servissero funzioni cross-game, andranno progettate in un piano separato e non derivate automaticamente da questo addon

## Rischi da gestire

1. CK3 potrebbe esporre pochi oggetti accessibili utili; in questi casi le macro coordinate resteranno necessarie
2. OCR su elementi dinamici del gioco puo richiedere timing e refresh dedicati
3. alcune gesture AHK storiche potrebbero confliggere con gesture NVDA o Windows gia esistenti
4. le macro dipendenti dalla risoluzione non vanno promosse a default senza profili testati
5. stato screen curtain non interrogabile in modo affidabile da API pubbliche addon: verificare solo comportamento end-to-end dei comandi OCR

## Decisione strategica finale

La migrazione va affrontata come conversione per livelli:

1. prima portare nell'addon tutto cio che NVDA fa gia bene in modo nativo
2. poi isolare in moduli separati le automazioni di gioco che dipendono da coordinate e timing
3. infine lasciare AHK come sorgente storica di riferimento, non come runtime parallelo

Questo approccio massimizza compatibilita con NVDA, riduce conflitti con gesture esistenti e permette di sostituire AHK in modo incrementale ma concreto.

## Esito della validazione NVDA

Stato: validazione parziale con correzioni applicate al piano.

Punti confermati:

1. scelta `appModules/ck3.py` coerente con Developer Guide e perimetro CK3-only
2. uso di OCR nativo NVDA fondato su API e pattern presenti nel sorgente NVDA
3. uso di navigator object, review position, click mouse ed emulazione tasti coerente con API pubbliche o pattern consolidati

Punti corretti durante la validazione:

1. layout interno spostato da `lib/...` a `appModules/paradox_ck3/...`
2. gestione configurazione resa esplicita: serve registrazione della config spec custom, non semplice accesso diretto a `config.conf["paradoxCK3"]`
3. OCR reso dipendente da guardie preliminari coerenti con il comportamento del comando OCR nativo di NVDA

Conclusione:

il piano e ora sufficientemente convalidato come base di implementazione, a condizione di seguire le correzioni sopra come parte integrante della Fase 0 e della Fase 2.