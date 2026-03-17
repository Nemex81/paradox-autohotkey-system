# Legacy Recycle Matrix

Questa matrice definisce la strategia di integrazione dei file del vecchio sistema AHK nel framework attuale.

## Decisioni

| File legacy | Stato | Azione | Motivazione |
| --- | --- | --- | --- |
| `main.ahk` | obsoleto | eliminato dal runtime | entrypoint monolitico non compatibile con pipeline framework |
| `globals.ahk` | obsoleto | eliminato dal runtime | variabili globali AHK non riusabili direttamente |
| `NVDA_DLLWrapper.ahk` | parzialmente utile | riciclo concettuale | utile come riferimento per fallback e gestione errori |
| `NVDA.ahk` | obsoleto | eliminato dal runtime | wrapper AHK legato a DLL legacy |
| `Speech.ahk` | parzialmente utile | riciclo concettuale | pattern annunci/priority utili per guideline |
| `Logging.ahk` | parzialmente utile | riciclo concettuale | pattern logging utili per policy script |
| `Utils.ahk` | parzialmente utile | riciclo concettuale | pattern coordinate/routing utili per template e test |
| `GlobalHotkeys.ahk` | utile | riciclato in reference | mappa comandi globali mantenuta in docs |
| `Help_GUI.ahk` | utile | riciclo contenutistico | struttura help riutilizzabile in documentazione |
| `ck3_script/HOTKEYS.ahk` | utile | riciclato in reference | mappa CK3 utile come base migrazione feature |
| `ck3_script/Help_ck3.ahk` | utile | riciclo contenutistico | testo aiuto riusabile per prompt e guide |
| `config.ini` | obsoleto | eliminato dal runtime | configurazione AHK non allineata al framework |
| `nvdaControllerClient.dll` | obsoleto | eliminato dal runtime | dipendenza binaria legacy non usata nel framework |

## Output di riciclo implementati

- reference hotkey legacy: `docs/legacy_hotkeys_reference.md`
- automazione moderna: pipeline agenti e quality gate in `.github/`

## Prossimo riuso consigliato

- creare template feature NVDA a partire dai pattern storici di interazione
- creare guida migrazione per eventuale reintroduzione controllata di moduli AHK in addon dedicati
