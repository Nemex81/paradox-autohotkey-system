# paradox autohotkey system
sistema accessibile per giocatori non vedenti di script per interagire con l'interfaccia utente dei giochi paradox



**Script AutoHotkey per migliorare l'accessibilità dei giochi Paradox per giocatori non vedenti**

[![AutoHotkey Version](https://img.shields.io/badge/AutoHotkey-v1.1.37.02-blue.svg)](https://www.autohotkey.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📋 Descrizione

Sistema di script sviluppato per rendere i giochi Paradox (in particolare **Crusader Kings 3**) più accessibili ai giocatori non vedenti tramite:
- **Supporto NVDA** integrato per feedback vocale
- **Funzioni OCR** per leggere testo dal gioco
- **Hotkey ottimizzate** per navigazione non visiva
- **Feedback sonoro** e tattile

## ✨ Caratteristiche Principali

### 🎯 Supporto Giochi
- ✅ Crusader Kings 3 (completo)
- 🔄 Estendibile ad altri giochi Paradox

### 🗣️ Sintesi Vocale
- **NVDA**: Integrazione nativa con annunci prioritari
- **SAPI**: Fallback con sintetizzatore Windows
- **Modalità intensa**: Riduce annunci durante gameplay

### 🎮 Controlli Accessibili
- **Click guidati** dal cursore NVDA
- **Routing mouse** automatico
- **Scansione OCR** con tasto dedicato
- **Navigazione** pagine e scroll semplificata

### ⚙️ Configurazione
- File `config.ini` per personalizzazione
- Hotkey completamente configurabili
- Toggle rapido funzionalità

## 🚀 Installazione

### Prerequisiti
- **Windows 10** o superiore
- **AutoHotkey v1.1.37.02** [Scarica qui](https://www.autohotkey.com/download/1.1/)
- **NVDA** (opzionale ma raccomandato) [Scarica qui](https://www.nvaccess.org/download/)

### Download e Setup
1. **Scarica l'ultima release** dalla sezione [Releases](https://github.com/tuoprogetto/releases)
2. **Estrai i file** in una cartella a tua scelta
3. **Assicurati di avere** `nvdaControllerClient.dll` nella stessa cartella dell'eseguibile
4. **Avvia** `ParadoxScript.exe`

### File Necessari

ParadoxScript.exe # Eseguibile principale
nvdaControllerClient.dll # Libreria NVDA (inclusa)
config.ini # Configurazione (creato automaticamente)




## 🎮 Utilizzo

### Avvio
1. Avvia `ParadoxScript.exe` (icona nella system tray)
2. Avvia il gioco (es. Crusader Kings 3)
3. Lo script rileverà automaticamente il gioco attivo

### Comandi Globali Principali

| Comando | Azione |
|---------|--------|
| `Ctrl + Shift + F1` | Attiva/Disattiva script |
| `Ctrl + F5` | Ricarica script |
| `Ctrl + Shift + I` | Modalità intensa (riduci annunci) |
| `Ctrl + Shift + H` | Aiuto completo |
| `-` (trattino) | Click nel punto cursore NVDA |
| `Ctrl + -` | Routing mouse a cursore NVDA |

### Comandi Specifici CK3

| Comando | Azione |
|---------|--------|
| `\` | Scansione OCR rapida |
| `,` | Click sinistro + OCR |
| `.` | Click destro |
| `Shift + F1/F2` | Navigazione pagine |
| `Ctrl + G` | Selezione armate |
| `Ctrl + Shift + P` | Pausa gioco |

## ⚙️ Configurazione

Modifica `config.ini` per personalizzare:

```ini
[Settings]
Hotkey_Toggle=^+F1
DLL_Path=nvdaControllerClient.dll
GameIntenseMode=false
MaxInterval=300
OCR_Default=Insert
SoundEnabled=true
SpeechEnabled=true
DebugMode=false


📁 paradox-games-accessibility/
├── 📄 main.ahk                    # Script principale
├── 📄 globals.ahk                 # Variabili globali
├── 📄 NVDA.ahk                    # Funzioni NVDA
├── 📄 Speech.ahk                  # Sintesi vocale
├── 📄 Logging.ahk                 # Sistema logging
├── 📄 Utils.ahk                   # Utility varie
├── 📄 GlobalHotkeys.ahk           # Hotkey globali
├── 📄 Help_GUI.ahk                # Sistema aiuto
├── 📁 ck3_script/                 # Modulo CK3
│   ├── 📄 HOTKEYS.ahk            # Hotkey CK3
│   └── 📄 Help_ck3.ahk           # Aiuto CK3
└── 📄 README.md                   # Questo file



# Usa Ahk2Exe incluso in AutoHotkey
Ahk2Exe.exe /in "main.ahk" /out "ParadoxScript.exe"



Segnalazione Problemi
Per bug o richieste, usa le GitHub Issues.
📄 Licenza
Distribuito sotto licenza MIT - vedi LICENSE per dettagli.
👥 Ringraziamenti
• 
NV Access per NVDA e libreria client
• 
Comunità AutoHotkey per supporto e esempi
• 
Giocatori non vedenti che hanno testato e fornito feedback
🔗 Link Utili
• 
Documentazione AutoHotkey
• 
Sito NVDA
• 
Wiki Paradox Interactive
 
Nota: Questo progetto è sviluppato e mantenuto dalla comunità per la comunità. Non affiliato con Paradox Interactive.