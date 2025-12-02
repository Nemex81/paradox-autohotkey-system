; ========================================
; NVDA DLL WRAPPER - CENTRALIZZATO
; Path: autohotkey scripts\NVDA_DLLWrapper.ahk
; ========================================
; Gestisce TUTTE le chiamate DLL a nvdaControllerClient.dll
; Funzioni esposte:
;   NVDA_DLL_Load(dllPath)
;   NVDA_DLL_TestIfRunning()
;   NVDA_DLL_SpeakText(text)
;   NVDA_DLL_CancelSpeech()
; ========================================

; GLOBALI USATE:
; - nvdaControllerClient (handle DLL, dichiarata in globals.ahk)
; - DebugMode (per logging opzionale)

; ========================================
; FUNZIONE INTERNA: NVDA_DLL_Log(msg, level)
; Usa Logging.ahk se disponibile e DebugMode = true
; ========================================
NVDA_DLL_Log(msg, level := "DEBUG") {
    global DebugMode

    if (!DebugMode)
        return

    ; Se esistono funzioni di logging, usale, altrimenti ignora
    if (IsFunc("LogMessage")) {
        LogMessage(msg, level)
    }
}

; ========================================
; FUNZIONE: NVDA_DLL_Load(dllPath)
; Carica nvdaControllerClient.dll e salva handle globale
; Ritorna true se ok, false se fallito
; ========================================
NVDA_DLL_Load(dllPath) {
    global nvdaControllerClient

    ; Verifica esistenza file
    if (!FileExist(dllPath)) {
        NVDA_DLL_Log("NVDA_DLL_Load: DLL non trovata: " . dllPath, "ERROR")
        nvdaControllerClient := ""
        return false
    }

    ; Carica DLL
    hDll := DllCall("LoadLibrary", "Str", dllPath, "Ptr")
    if (!hDll) {
        NVDA_DLL_Log("NVDA_DLL_Load: LoadLibrary fallito per: " . dllPath . " (A_LastError=" . A_LastError . ")", "ERROR")
        nvdaControllerClient := ""
        return false
    }

    nvdaControllerClient := hDll
    NVDA_DLL_Log("NVDA_DLL_Load: DLL caricata con successo. Handle=" . hDll, "DEBUG")
    return true
}

; ========================================
; FUNZIONE INTERNA: NVDA_DLL_StringToUTF16(text, ByRef wText)
; Converte stringa AHK (UTF-8) in UTF-16 (wide char) usando MultiByteToWideChar
; Ritorna lunghezza in caratteri, 0 se errore
; ========================================
NVDA_DLL_StringToUTF16(text, ByRef wText) {
    ; Prima chiamata per sapere lunghezza necessaria
    len := DllCall("MultiByteToWideChar"
        , "UInt", 65001        ; CP_UTF8
        , "UInt", 0
        , "Ptr",  &text
        , "Int",  -1
        , "Ptr",  0
        , "Int",  0)

    if (len = 0) {
        NVDA_DLL_Log("NVDA_DLL_StringToUTF16: query size fallita (A_LastError=" . A_LastError . ")", "ERROR")
        return 0
    }

    ; Alloca buffer (len wide char = len*2 byte)
    VarSetCapacity(wText, len * 2, 0)

    ; Seconda chiamata: conversione effettiva
    result := DllCall("MultiByteToWideChar"
        , "UInt", 65001        ; CP_UTF8
        , "UInt", 0
        , "Ptr",  &text
        , "Int",  -1
        , "Ptr",  &wText
        , "Int",  len)

    if (result = 0) {
        NVDA_DLL_Log("NVDA_DLL_StringToUTF16: conversione fallita (A_LastError=" . A_LastError . ")", "ERROR")
        return 0
    }

    return result
}

; ========================================
; FUNZIONE: NVDA_DLL_TestIfRunning()
; Verifica se NVDA è in esecuzione
; Ritorna true se NVDA attivo, false altrimenti
; ========================================
NVDA_DLL_TestIfRunning() {
    global nvdaControllerClient

    if (!nvdaControllerClient) {
        NVDA_DLL_Log("NVDA_DLL_TestIfRunning: DLL non caricata", "DEBUG")
        return false
    }

    ; 0 = NVDA running, 5 = not running, altri = errore
    result := DllCall("nvdaControllerClient.dll\nvdaController_testIfRunning", "Int")
    if (result = 0) {
        NVDA_DLL_Log("NVDA_DLL_TestIfRunning: NVDA in esecuzione", "DEBUG")
        return true
    } else {
        NVDA_DLL_Log("NVDA_DLL_TestIfRunning: NVDA non attivo o errore (result=" . result . ")", "WARNING")
        return false
    }
}

; ========================================
; FUNZIONE: NVDA_DLL_SpeakText(text)
; Fa parlare NVDA tramite nvdaController_speakText
; Ritorna true se ok, false se fallito
; ========================================
NVDA_DLL_SpeakText(text) {
    global nvdaControllerClient

    if (!nvdaControllerClient) {
        NVDA_DLL_Log("NVDA_DLL_SpeakText: DLL non caricata, impossibile parlare", "WARNING")
        return false
    }

    if (text = "")  ; niente da dire
        return true

    ; Conversione a UTF-16
    len := NVDA_DLL_StringToUTF16(text, wText)
    if (len = 0) {
        NVDA_DLL_Log("NVDA_DLL_SpeakText: conversione UTF-16 fallita per testo: " . text, "ERROR")
        return false
    }

    ; Chiamata a nvdaController_speakText
    result := DllCall("nvdaControllerClient.dll\nvdaController_speakText", "Ptr", &wText, "Int")

    if (result != 0) {
        NVDA_DLL_Log("NVDA_DLL_SpeakText: nvdaController_speakText ha restituito " . result, "ERROR")
        return false
    }

    NVDA_DLL_Log("NVDA_DLL_SpeakText: OK -> " . text, "DEBUG")
    return true
}

; ========================================
; FUNZIONE: NVDA_DLL_CancelSpeech()
; Interrompe il parlato corrente di NVDA
; Ritorna true se ok, false se fallito
; ========================================
NVDA_DLL_CancelSpeech() {
    global nvdaControllerClient

    if (!nvdaControllerClient) {
        NVDA_DLL_Log("NVDA_DLL_CancelSpeech: DLL non caricata", "DEBUG")
        return false
    }

    result := DllCall("nvdaControllerClient.dll\nvdaController_cancelSpeech", "Int")

    if (result != 0) {
        NVDA_DLL_Log("NVDA_DLL_CancelSpeech: nvdaController_cancelSpeech ha restituito " . result, "ERROR")
        return false
    }

    NVDA_DLL_Log("NVDA_DLL_CancelSpeech: OK", "DEBUG")
    return true
}
