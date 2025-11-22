; ========================================
; UTILITIES - FUNZIONI DI SUPPORTO
; Path: autohotkey scripts\Utils.ahk
; ========================================

; --- UTILITY COORDINATE E SCHERMO ---

ScaleX(x) {
    return Round(x * (A_ScreenWidth / 1920))
}

ScaleY(y) {
    return Round(y * (A_ScreenHeight / 1080))
}

ValidateCoords(x, y) {
    return (x >= 0 && x < A_ScreenWidth && y >= 0 && y < A_ScreenHeight)
}

GetScreenCenter(ByRef centerX, ByRef centerY) {
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
}

GetDismissCorner(ByRef dismissX, ByRef dismissY) {
    dismissX := A_ScreenWidth - 1
    dismissY := 0
}

; --- UTILITY NVDA: PRESSIONE E RILASCIO TASTO NVDA ---

PressNvdaKey() {
    global OCR
    if (OCR = "Num")
        SendInput, {NumpadIns down}
    else if (OCR = "CAPS")
        SendInput, {CapsLock down}
    else
        SendInput, {Insert down}
}

ReleaseNvdaKey() {
    global OCR
    if (OCR = "Num")
        SendInput, {NumpadIns up}
    else if (OCR = "CAPS")
        SendInput, {CapsLock up}
    else
        SendInput, {Insert up}
}

; --- ROUTING CURSORE NVDA ---

RouteMouse() {
    global ScriptEnabled

    if (!ScriptEnabled)
        return false

    ; Assicura NumLock spento
    if (GetKeyState("NumLock", "T"))
        SetNumLockState, Off

    PressNvdaKey()
    SendInput, {NumpadDiv}
    SendInput, {Shift M}
    Sleep, 80
    ReleaseNvdaKey()

    return true
}

; --- AZIONI AD ALTO LIVELLO CON CURSORE NVDA ---

ClickAtNvdaCursor(playSound := true, parkMouse := true) {
    if (!RouteMouse())
        return false

    Click

    if (playSound)
        SoundPlay, %A_WinDir%\Media\Windows Pop-up Blocked.wav

    if (parkMouse)
        MouseMove, % A_ScreenWidth + 50, -50, 0

    return true
}

EnterAtNvdaCursor(playSound := true, parkMouse := true) {
    if (!RouteMouse())
        return false

    SendInput, {Enter}

    if (playSound)
        SoundPlay, %A_WinDir%\Media\Windows Pop-up Blocked.wav

    if (parkMouse)
        MouseMove, % A_ScreenWidth + 50, -50, 0

    return true
}

; --- UTILITY FEEDBACK E ACCESSIBILITÀ ---

AccessibleFeedback(action, soundFile := "") {
    global SoundEnabled, DebugMode

    if (!SoundEnabled)
        return

    if (soundFile != "")
        SoundPlay, %soundFile%

    if (DebugMode) {
        MouseGetPos, mx, my
        ToolTip, %action% @ %mx%`, %my%, 0, 0
        SetTimer, RemoveToolTip, -1500
    }
}

RemoveToolTip:
ToolTip
return

; --- UTILITY MOUSE ---

CenterMouse() {
    GetScreenCenter(cx, cy)
    mousemove, %cx%, %cy%, 0

    MouseGetPos, xpos, ypos
    success := (Abs(xpos - cx) <= 2 && Abs(ypos - cy) <= 2)
    if (success) {
        AccessibleFeedback("Centro", "C:\Windows\media\Windows Ding.wav")
        Announce("Cursore centrato")
        return true
    } else {
        LogError("CenterMouse fallito (x:" . xpos . ", y:" . ypos . ")")
        return false
    }
}

DismissMouse(withSound := false) {
    GetDismissCorner(dx, dy)
    mousemove, %dx%, %dy%, 0

    MouseGetPos, xpos, ypos
    success := (xpos == dx && ypos == dy)
    if (success && withSound) {
        AccessibleFeedback("Dismiss", "C:\Windows\media\Windows Recycle.wav")
        Announce("Tooltip nascosto")
    }
    if (!success)
        LogError("DismissMouse fallito (x:" . xpos . ", y:" . ypos . ")")
    return success
}

; --- UTILITY NVDA/OCR ---

OCR() {
    global ScriptEnabled

    if (!ScriptEnabled)
        return false

    if (GetKeyState("NumLock", "T"))
        SetNumLockState, Off

    PressNvdaKey()
    SendInput, r
    ReleaseNvdaKey()

    return true
}
