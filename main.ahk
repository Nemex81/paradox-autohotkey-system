; ========================================
; SCRIPT PRINCIPALE PARADOX GAMES
; Path: autohotkey scripts\main.ahk
; ========================================

#NoEnv
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%


; ========================================
; INCLUSIONE GLOBALS (PRIMA DI TUTTO)
; ========================================
#Include globals.ahk

; ========================================
; CARICAMENTO NVDA 
; ========================================

; Percorso del file config
ConfigFile := A_ScriptDir . "\config.ini"

; Carica SOLO le impostazioni necessarie per NVDA
IniRead, DLL_Path, %ConfigFile%, Settings, DLL_Path, nvdaControllerClient.dll

; DEBUG: Verifica percorso DLL
if (!FileExist(A_ScriptDir . "\" . DLL_Path)) {
    MsgBox, 16, Errore DLL, DLL non trovata: %A_ScriptDir%\%DLL_Path%
}

; Carica NVDA con percorso dalla config
dllPath := A_ScriptDir . "\" . DLL_Path
nvdaControllerClient := DllCall("LoadLibrary", "Str", dllPath, "Ptr")

if (nvdaControllerClient) {
    result := DllCall("nvdaControllerClient.dll\nvdaController_testIfRunning")
    if (result = 0) {
        nvdaAvailable := true
        UseNVDA := true
        
        ; Test vocale diretto immediato (conferma NVDA)
        DllCall("nvdaControllerClient.dll\nvdaController_speakText", "Str", "Script Paradox Games caricato. NVDA rilevato.")
        Sleep, 500  ; Pausa più lunga per l'output
    } else {
        UseNVDA := false
        MsgBox, 48, Avviso NVDA, DLL NVDA trovata ma NVDA non è in esecuzione.`n`nAvvia NVDA per usare gli annunci vocali,`naltrimenti verrà usato SAPI (voce Windows).
    }
} else {
    UseNVDA := false
    MsgBox, 48, Avviso Speech, nvdaControllerClient.dll non trovata nella cartella:`n`n%A_ScriptDir%`n`nVerrà usato il sintetizzatore Windows (SAPI).`n`nPer usare NVDA, posiziona la DLL qui.
}

; DEBUG: Verifica stato NVDA
if (UseNVDA) {
    ToolTip, NVDA ATTIVO, 10, 10, 2
} else {
    ToolTip, NVDA DISATTIVO - Usando SAPI, 10, 10, 2
}
SetTimer, RemoveDebugTooltip, -3000

RemoveDebugTooltip:
ToolTip, , , , 2
return


; ========================================
; INCLUSIONE ALTRI FILE (dopo inizializzazione NVDA)
; ========================================

#Include NVDA.ahk
#Include Speech.ahk
#Include Logging.ahk
#Include Utils.ahk
#Include GlobalHotkeys.ahk
#Include ck3_script\Help_ck3.ahk
#Include Help_GUI.ahk
#Include ck3_script\HOTKEYS.ahk


; ========================================
; CARICAMENTO COMPLETO CONFIG.INI
; ========================================

; Carica impostazioni da config.ini
if FileExist(ConfigFile) {
    IniRead, Hotkey_Toggle, %ConfigFile%, Settings, Hotkey_Toggle, ^+F1
    IniRead, GameIntenseMode_Init, %ConfigFile%, Settings, GameIntenseMode, false
    IniRead, MaxInterval, %ConfigFile%, Settings, MaxInterval, 200
    IniRead, OCR_Default, %ConfigFile%, Settings, OCR_Default, Insert
    IniRead, SoundEnabled_Init, %ConfigFile%, Settings, SoundEnabled, true
    IniRead, SpeechEnabled_Init, %ConfigFile%, Settings, SpeechEnabled, true
    IniRead, DebugMode_Init, %ConfigFile%, Settings, DebugMode, false
    
    ; Applica valori caricati
    SoundEnabled := SoundEnabled_Init
    SpeechEnabled := SpeechEnabled_Init
    DebugMode := DebugMode_Init
    OCR := OCR_Default
    GameIntenseMode := (GameIntenseMode_Init = "true") ? true : false
} else {
    ; Crea config.ini di default se non esiste
    DefaultConfig =
    (
[Settings]
Hotkey_Toggle=^+F1
DLL_Path=nvdaControllerClient.dll
GameIntenseMode=false
MaxInterval=200
OCR_Default=Insert
SoundEnabled=true
SpeechEnabled=true
DebugMode=false
    )
    FileAppend, %DefaultConfig%, %ConfigFile%
    GameIntenseMode := false
}


; Usa valori config per DLL e altri
#MaxHotkeysPerInterval %MaxInterval%
#MaxThreadsPerHotkey 1
SetBatchLines, -1


; Configurazione coordinate per multi-monitor
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
CoordMode, ToolTip, Screen


; ========================================
; MESSAGGIO DI AVVIO FINALE
; ========================================
Sleep, 1000  ; Pausa più lunga per inizializzazione
if (!GameIntenseMode) {
    if (UseNVDA && nvdaRunning()) {
        AnnouncePriority("Script Paradox Games caricato. NVDA attivo. Modulo CK3 pronto.")
    } else {
        AnnouncePriority("Script Paradox Games caricato. SAPI attivo. Modulo CK3 pronto.")
    }
} else {
    SoundPlay, *-1
}
SoundPlay, C:\Windows\media\Windows Notify System Generic.wav
return
