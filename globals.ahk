; ========================================
; Globals
; Path: autohotkey scripts\globals.ahk
; ========================================

; variabili globali di sistema - SOLO DICHIARAZIONI, nessun valore di default per NVDA
global nvdaControllerClient
global nvdaAvailable
global UseNVDA
global ScriptEnabled
global SoundEnabled
global SpeechEnabled
global DebugMode
global OCR
global GameIntenseMode
global MaxInterval

; Imposta solo i valori che non dipendono da NVDA
ScriptEnabled := true
SoundEnabled := true
SpeechEnabled := true
DebugMode := false
OCR := "Insert"
GameIntenseMode := false
MaxInterval := 300

; Lock azioni gioco (CK3) per evitare sovrapposizioni durante lag
global CK3_ActionInProgress
CK3_ActionInProgress := false
