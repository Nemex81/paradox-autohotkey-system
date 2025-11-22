; ========================================
; SPEECH MODULE
; Path: autohotkey scripts\Speech.ahk
; ========================================

; Gestisce annunci vocali con NVDA Controller Client o fallback SAPI,
; comprende gestione modalità intensa, gestione errori e fallback.

; GLOBALI USATE (dichiarate in globals.ahk):
; UseNVDA, SpeechEnabled, GameIntenseMode
; nvdaControllerClient - handle DLL NVDA

; FUNCTION: AnnounceFallback(message)
; Fallback se SAPI fallisce - beep, tooltip e logging
AnnounceFallback(message) {
    global DebugMode
    SoundPlay, *-1  ; Beep breve

    if (DebugMode) {
        ToolTip, %message%, 0, 0
        SetTimer, RemoveToolTipFallback, -3000
    }

    LogError("Fallback usato per annuncio: " . message)
}

RemoveToolTipFallback:
ToolTip
return


; FUNCTION: Announce(message)
; Annuncio vocale principale (NVDA o SAPI), salta se GameIntenseMode o disattivato
Announce(message) {
    global UseNVDA, SpeechEnabled, GameIntenseMode, nvdaControllerClient

    if (GameIntenseMode || !SpeechEnabled)
        return

    if (UseNVDA) {
        if (nvdaControllerClient && nvdaRunning()) {
            nvdaSpeak(message)
            return
        } else {
            UseNVDA := false
        }
    }

    try {
        static speaker := ComObjCreate("SAPI.SpVoice")
        speaker.Rate := 1
        speaker.Speak(message, 1)  ; SVSFlagsAsync
    } catch e {
        AnnounceFallback(message)
    }
}


; FUNCTION: AnnouncePriority(message)
; Annuncio prioritario (interrompe parlato in corso), beep se disattivato o intensa
AnnouncePriority(message) {
    global UseNVDA, SpeechEnabled, GameIntenseMode, nvdaControllerClient

    if (GameIntenseMode || !SpeechEnabled) {
        SoundPlay, *-1  ; Beep breve per feedback
        return
    }

    if (UseNVDA && nvdaControllerClient && nvdaRunning()) {
        nvdaCancel()
        Sleep, 50
        nvdaSpeak(message)
        return
    }

    try {
        static speaker := ComObjCreate("SAPI.SpVoice")
        speaker.Speak("", 2)  ; Cancella coda
        Sleep, 50
        speaker.Speak(message, 1)
    } catch e {
        AnnounceFallback(message)
    }
}


; FUNCTION: CancelSpeech()
; Cancella parlato corrente (NVDA o SAPI), silenzia se modalità intensa
CancelSpeech() {
    global UseNVDA, GameIntenseMode, nvdaControllerClient

    if (GameIntenseMode)
        return

    if (UseNVDA && nvdaControllerClient && nvdaRunning()) {
        nvdaCancel()
        return
    }

    try {
        static speaker := ComObjCreate("SAPI.SpVoice")
        speaker.Speak("", 2)
    } catch e {
        ; Ignora errori se SAPI non disponibile
    }
}
