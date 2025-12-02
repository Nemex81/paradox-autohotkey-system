; ========================================
; HOTKEYS PER CRUSADER KINGS 3 (solo specifici CK3)
; Path: autohotkey scripts\ck3_script\HOTKEYS.ahk
; ========================================

; Configurazione coordinate per multi-monitor (per CK3)
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
CoordMode, ToolTip, Screen

#IfWinActive, ahk_exe ck3.exe

; ----------------------------------------
; Toggle impostazioni (solo in CK3)
; ----------------------------------------

+F12::
global SoundEnabled
SoundEnabled := !SoundEnabled
status := SoundEnabled ? "attivati" : "disattivati"
if (SoundEnabled)
    SoundPlay, C:\Windows\media\Windows Ding.wav
AnnouncePriority("Suoni " . status)
return

^+F12::
global SpeechEnabled
SpeechEnabled := !SpeechEnabled
status := SpeechEnabled ? "attivati" : "disattivati"
if (SpeechEnabled) {
    AnnouncePriority("Annunci vocali " . status)
} else {
    SoundPlay, C:\Windows\media\Windows Ding.wav
}
return

^+F10::
global DebugMode
DebugMode := !DebugMode
AnnouncePriority("Debug " . (DebugMode ? "attivo" : "disattivo"))
return

^+F9::
global UseNVDA
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

; ----------------------------------------
; Imposta tasto NVDA (solo in CK3)
; ----------------------------------------

^CapsLock::
global OCR
OCR := "CAPS"
AnnouncePriority("Tasto NVDA impostato su Bloc Maiusc")
return

^Insert::
global OCR
OCR := "Insert"
AnnouncePriority("Tasto NVDA impostato su Insert")
return

^NumpadIns::
global OCR
OCR := "Num"
AnnouncePriority("Tasto NVDA impostato su Insert tastierino numerico")
return

; ----------------------------------------
; Navigazione Base (pagine/scroll)
; ----------------------------------------

+F1::
global ScriptEnabled
if (!ScriptEnabled)
    return
SendInput, {Shift up}{PgUp}
Announce("Pagina su")
return

+F2::
global ScriptEnabled
if (!ScriptEnabled)
    return
SendInput, {Shift up}{PgDn}
Announce("Pagina giù")
return

; ----------------------------------------
; Interazioni OCR / Click / Routing
; ----------------------------------------

; HOTKEY: \ - Attiva OCR semplice
\::
global ScriptEnabled
if (!ScriptEnabled)
    return

if (OCR()) {
    Announce("O C R attivato")
} else {
    LogError("OCR fallito in hotkey Backslash")
    Announce("O C R fallito")
}
return

; HOTKEY: , - Click sinistro + OCR
,:: 
global ScriptEnabled, CK3_ActionInProgress
if (!ScriptEnabled)
    return
if (CK3_ActionInProgress)
    return
CK3_ActionInProgress := true
CK3_ResetInputState()

Announce("Click sinistro")
if (ClickAtNvdaCursor()) {
    Sleep, 300
    DismissMouse()
    SendInput, {Escape}
    Sleep, 50
    if (!OCR()) {
        LogWarning("OCR non riuscito dopo click sinistro in hotkey Comma")
    }
} else {
    LogError("ClickAtNvdaCursor fallito in hotkey Comma")
}
CK3_ActionInProgress := false
return


; HOTKEY: ^, - Control + click sinistro + OCR
^,:: 
global ScriptEnabled, CK3_ActionInProgress
if (!ScriptEnabled)
    return
if (CK3_ActionInProgress)
    return
CK3_ActionInProgress := true
CK3_ResetInputState()

Announce("Control click")
if (RouteMouse()) {
    ControlClick
    Sleep, 300
    if (DismissMouse()) {
        SendInput, {Escape}
        Sleep, 50
        OCR()
    }
} else {
    LogError("RouteMouse fallito in hotkey Ctrl+Comma")
}
CK3_ActionInProgress := false
return

; HOTKEY: +, - Routing mouse + OCR
+,:: 
global ScriptEnabled, CK3_ActionInProgress
if (!ScriptEnabled)
    return
if (CK3_ActionInProgress)
    return
CK3_ActionInProgress := true
CK3_ResetInputState()

Announce("Routing mouse")
if (RouteMouse()) {
    Sleep, 300
    SendInput, {Escape}
    if (!OCR()) {
        LogWarning("OCR non riuscito dopo routing mouse in hotkey Shift+Comma")
    }
} else {
    LogError("RouteMouse fallito in hotkey Shift+Comma")
}
CK3_ActionInProgress := false
return

; HOTKEY: . - Click destro + OCR
.:: 
global ScriptEnabled, CK3_ActionInProgress
if (!ScriptEnabled)
    return
if (CK3_ActionInProgress)
    return
CK3_ActionInProgress := true
CK3_ResetInputState()

Announce("Click destro")
if (RouteMouse()) {
    Click, Right
    Sleep, 300
    if (DismissMouse()) {
        SendInput, {Escape}
        Sleep, 50
        if (!OCR()) {
            LogWarning("OCR fallito dopo click destro in hotkey Punto")
        }
    }
} else {
    LogError("RouteMouse fallito in hotkey Punto")
}
CK3_ActionInProgress := false
return

; ----------------------------------------
; Utility cursore (movimenti / tooltip)
; ----------------------------------------

^+c::
global ScriptEnabled
if (!ScriptEnabled)
    return
CenterMouse()
return

^+d::
global ScriptEnabled
if (!ScriptEnabled)
    return
if (DismissMouse(true)) {
    Sleep, 300
    SendInput, {Escape}
    Sleep, 50
    if (!OCR()) {
        LogWarning("OCR non riuscito dopo dismiss in hotkey Ctrl+Shift+D")
    }
} else {
    LogError("DismissMouse fallito in hotkey Ctrl+Shift+D")
}
return

^d::
global ScriptEnabled
if (!ScriptEnabled)
    return
DismissMouse(true)
return

; ----------------------------------------
; Azioni rapide (click al centro)
; ----------------------------------------

+1:: 
global ScriptEnabled, CK3_ActionInProgress
if (!ScriptEnabled)
    return
if (CK3_ActionInProgress)
    return
CK3_ActionInProgress := true
CK3_ResetInputState()

Announce("Click al centro")
if (CenterMouse()) {
    Click
    Sleep, 100
    DismissMouse()
}
CK3_ActionInProgress := false
return

^2:: 
global ScriptEnabled, CK3_ActionInProgress
if (!ScriptEnabled)
    return
if (CK3_ActionInProgress)
    return
CK3_ActionInProgress := true
CK3_ResetInputState()

Announce("Click destro al centro")
if (CenterMouse()) {
    Click, Right
    Sleep, 100
    DismissMouse()
}
CK3_ActionInProgress := false
return

+3:: 
global ScriptEnabled, CK3_ActionInProgress
if (!ScriptEnabled)
    return
if (CK3_ActionInProgress)
    return
CK3_ActionInProgress := true
CK3_ResetInputState()

Announce("Shift click destro")
if (CenterMouse()) {
    SendInput, {Shift Down}
    Click, Right
    SendInput, {Shift Up}
    Sleep, 100
    DismissMouse()
}
CK3_ActionInProgress := false
return

; ========================================
; HOTKEY: "-" - Click nel punto del cursore NVDA
; ========================================
-::
global ScriptEnabled
if (!ScriptEnabled)
    return

ClickAtNvdaCursor()
return

; ========================================
; HOTKEY: Ctrl+\ - Routing mouse al cursore NVDA + suono
; ========================================
^\::
global ScriptEnabled
if (!ScriptEnabled)
    return

if (RouteMouse()) {
    SoundPlay, %A_WinDir%\Media\Windows Pop-up Blocked.wav
} else {
    LogError("RouteMouse fallito in hotkey Ctrl+\")
    Announce("Routing NVDA fallito")
}
return

; ========================================
; HOTKEY: Ctrl+Enter - Invio nel punto del cursore NVDA
; ========================================
^Enter::
global ScriptEnabled
if (!ScriptEnabled)
    return

EnterAtNvdaCursor()
return

; ----------------------------------------
; Macro gioco specifiche CK3
; ----------------------------------------

^g:: 
global ScriptEnabled, CK3_ActionInProgress
if (!ScriptEnabled)
    return
if (CK3_ActionInProgress)
    return
CK3_ActionInProgress := true
CK3_ResetInputState()

Announce("Selezione armate")
mousemove, % ScaleX(700), % ScaleY(300), 0
SendInput, {LButton Down}
Sleep, 150
mousemove, % ScaleX(1200), % ScaleY(800), 0
Sleep, 150
SendInput, {LButton Up}
Sleep, 150
DismissMouse()
CK3_ActionInProgress := false
return

; ----------------------------------------
; Pausa gioco + OCR
; ----------------------------------------

^+p:: 
global ScriptEnabled, CK3_ActionInProgress
if (!ScriptEnabled)
    return
if (CK3_ActionInProgress)
    return
CK3_ActionInProgress := true
CK3_ResetInputState()

SendInput, {Escape}
Sleep, 100
SendInput, {Space}
AccessibleFeedback("Pausa", "C:\Windows\media\Windows Navigation Start.wav")
Sleep, 200
Announce("Pausa gioco")
Sleep, 200
if (!OCR()) {
    LogWarning("OCR non riuscito dopo pausa in hotkey Ctrl+Shift+P")
}
CK3_ActionInProgress := false
return

#IfWinActive  ; Fine blocco CK3
