; ========================================
; HOTKEY GLOBALI FRAMEWORK PARADOX
; Path: autohotkey scripts\GlobalHotkeys.ahk
; Scopo: hotkey indipendenti dal gioco attivo
; ========================================

; Nota: questo file assume che siano già stati inclusi:
; - globals.ahk (dichiarazione variabili globali)
; - Utils.ahk (ClickAtNvdaCursor, EnterAtNvdaCursor, Announce, etc.)
; - NVDA.ahk (nvdaRunning, nvdaSpeak, etc.)

; ========================================
; HOTKEY: Toggle script (default ^+F1)
; ========================================
^+F1::
global ScriptEnabled, Hotkey_Toggle
ScriptEnabled := !ScriptEnabled
if (ScriptEnabled) {
    SoundPlay, C:\Windows\media\Windows Navigation Start.wav
    AnnouncePriority("Script Paradox attivato")
    ToolTip, ✓ Script Paradox ATTIVO, 10, 10, 1
} else {
    SoundPlay, C:\Windows\media\Windows Navigation Stop.wav
    AnnouncePriority("Script Paradox disattivato")
    ToolTip, ✗ Script Paradox DISATTIVO, 10, 10, 1
}
SetTimer, RemoveStatusTooltip, -2000
return

RemoveStatusTooltip:
ToolTip,,, 1
return

; ========================================
; HOTKEY: Toggle modalità intensa globale
; ========================================
^+I::
global GameIntenseMode, ScriptEnabled, ConfigFile
if (!ScriptEnabled)
    return
GameIntenseMode := !GameIntenseMode
status := GameIntenseMode ? "attivata" : "disattivata"
AnnouncePriority("Modalità gameplay intenso " . status . ". Annunci vocali " . (GameIntenseMode ? "ridotti" : "abilitati"))
if (GameIntenseMode)
    SoundPlay, C:\Windows\media\Windows Navigation Start.wav
IniWrite, %GameIntenseMode%, %ConfigFile%, Settings, GameIntenseMode
return

; ========================================
; HOTKEY: Reload script
; ========================================
^F5::
    Announce("Ricarico script...")
    Reload
return

+F5::
    Announce("Ricaricando script...")
    Reload
return

; ========================================
; HOTKEY: Toggle suoni globali
; ========================================
+F12::
global SoundEnabled, ScriptEnabled
if (!ScriptEnabled)
    return
SoundEnabled := !SoundEnabled
status := SoundEnabled ? "attivati" : "disattivati"
if (SoundEnabled)
    SoundPlay, C:\Windows\media\Windows Ding.wav
AnnouncePriority("Suoni " . status)
return

; ========================================
; HOTKEY: Toggle voce globale
; ========================================

^+F12::
global SpeechEnabled, ScriptEnabled
if (!ScriptEnabled)
    return
SpeechEnabled := !SpeechEnabled
status := SpeechEnabled ? "attivati" : "disattivati"
if (SpeechEnabled) {
    AnnouncePriority("Annunci vocali " . status)
} else {
    SoundPlay, C:\Windows\media\Windows Ding.wav
}
return

; ========================================
; HOTKEY: Toggle debug globale
; ========================================
^+F10::
global DebugMode, ScriptEnabled
if (!ScriptEnabled)
    return
DebugMode := !DebugMode
AnnouncePriority("Debug " . (DebugMode ? "attivo" : "disattivo"))
return

; ========================================
; HOTKEY: Switch NVDA / SAPI globali
; ========================================
^+F9::
global UseNVDA, ScriptEnabled
if (!ScriptEnabled)
    return
UseNVDA := !UseNVDA
if (UseNVDA) {
    if (nvdaRunning()) {
        nvdaSpeak("Modalità NVDA attivata")
    } else {
        UseNVDA := false
        AnnouncePriority("NVDA non disponibile. Uso SAPI.")
    }
} else {
    AnnouncePriority("Modalità SAPI attivata")
}
return

; ========================================
; HOTKEY: Help e sintesi globali
; ========================================

+H::
global ScriptEnabled, Hotkey_Toggle
if (!ScriptEnabled)
    return
AnnouncePriority("Aiuto script Paradox Games.")
Sleep, 1000
Announce("Comandi globali principali. " 
    . Hotkey_Toggle . " attiva o disattiva lo script. "
    . "Control F5 o Shift F5 ricaricano lo script. "
    . "Control Shift I attiva la modalità intensa. "
    . "Shift F12 attiva o disattiva i suoni. "
    . "Control Shift F12 attiva o disattiva la voce. "
    . "Control Shift F10 attiva o disattiva il debug. "
    . "Control Shift F9 cambia tra NVDA e SAPI. "
    . "Control Shift F8 mostra le informazioni sullo script.")
Sleep, 2000
Announce("Per l'aiuto dettagliato del gioco, porta in primo piano il gioco e usa la combinazione specifica per quel titolo.")
return

^H::
global ScriptEnabled, Hotkey_Toggle
if (!ScriptEnabled)
    return
AnnouncePriority("Sintesi rapida comandi globali.")
Sleep, 800
Announce("Toggle script: " . Hotkey_Toggle . ". Reload: Control F5 o Shift F5. Modalità intensa: Control Shift I. Info: Control Shift F8.")
return

^+H::
global ScriptEnabled
if (!ScriptEnabled)
    return
ShowHelpGUI()
return

!H::
global ScriptEnabled
if (!ScriptEnabled)
    return
AnnouncePriority("Sintesi comandi Script Paradox Games.")
Sleep, 1500
Announce("Comandi globali: " . Hotkey_Toggle . " on off script, Ctrl F5 o Shift F5 ricarica, Ctrl Shift H aiuto, Ctrl H sintesi, Ctrl Shift F8 info.")
Sleep, 3000
Announce("Per CK3, apri il gioco e usa help dettagliato con Ctrl Shift H.")
Announce("Fine sintesi.")
return

; ========================================
; HOTKEY: Info script globale (GUI)
; ========================================

^+F8::
global ScriptEnabled, UseNVDA, nvdaControllerClient
global OCR, SoundEnabled, SpeechEnabled, DebugMode, GameIntenseMode

if (!ScriptEnabled)
    return

speechMode := UseNVDA ? "NVDA" : "SAPI"
nvdaStatus := nvdaRunning() ? "In esecuzione" : "Non attivo"
dllStatus := nvdaControllerClient ? "Caricata" : "Non trovata"
intenseStatus := GameIntenseMode ? "Attiva (annunci ridotti)" : "Disattiva"

Gui, InfoGUI:New, +Resize +MinSize500x300, Informazioni Script Paradox
Gui, Font, s10 cDefault Charset0, Segoe UI

infoText =
(
STATO SCRIPT:
• Script: %ScriptEnabled%
• Suoni: %SoundEnabled%
• Voce: %SpeechEnabled%
• Modalità intensa: %intenseStatus%
• Modalità: %speechMode%
• Debug: %DebugMode%
• Tasto NVDA: %OCR%

STATO NVDA:
• NVDA: %nvdaStatus%
• DLL Client: %dllStatus%

SISTEMA:
• Risoluzione: %A_ScreenWidth%x%A_ScreenHeight%
• Versione AHK: %A_AhkVersion%
)

Gui, Add, Edit, x10 y10 w480 h240 +ReadOnly +HScroll +VScroll, %infoText%
Gui, Add, Button, x200 h260 w100 gInfoGUIClose Default, &OK
Gui, Show, Center w500 h290

AnnouncePriority("Finestra informazioni aperta. Usa frecce per scorrere il testo.")
ControlFocus, Edit1, Informazioni Script Paradox
return

InfoGUIClose:
InfoGUIGuiEscape:
InfoGUIGuiClose:
Gui, InfoGUI:Destroy
Announce("Finestra aiuto chiusa.")
return





