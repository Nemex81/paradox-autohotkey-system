; ========================================
; SCRIPT PRINCIPALE PARADOX GAMES
; Path: autohotkey scripts\main.ahk
; ========================================

#NoEnv
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%


; ========================================
; INCLUSIONE GLOBALS
; ========================================
#Include globals.ahk
#Include NVDA_DLLWrapper.ahk


; ========================================
; CARICAMENTO NVDA 
; ========================================

; Percorso del file config
ConfigFile := A_ScriptDir . "\config.ini"

; Carica SOLO le impostazioni necessarie per NVDA
IniRead, DLL_Path, %ConfigFile%, Settings, DLL_Path, nvdaControllerClient.dll

; Costruisci percorso completo DLL
dllPath := A_ScriptDir . "\" . DLL_Path

; Prova a caricare la DLL tramite wrapper
if (!NVDA_DLL_Load(dllPath)) {
    UseNVDA := false
} else {
    ; DLL caricata: verifica se NVDA è in esecuzione
    if (nvdaRunning()) {
        nvdaAvailable := true
        UseNVDA := true
        
        ; FEEDBACK SONORO DI SUCCESSO (NVDA AGGANCIATO)
        SoundPlay, C:\Windows\Media\Windows Logon.wav
        
    } else {
        UseNVDA := false
    }
}

; DEBUG: Verifica stato NVDA (tooltip informativo)
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
; FEEDBACK DI AVVIO FINALE
; ========================================
Sleep, 500
; Suono finale che conferma: "tutto caricato, config applicata, pronto a giocare"
SoundPlay, C:\Windows\media\Windows Notify System Generic.wav
return
