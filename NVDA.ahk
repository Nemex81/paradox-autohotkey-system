; ========================================
; NVDA CONTROLLER CLIENT FUNCTIONS
; Path: autohotkey scripts\NVDA.ahk
; ========================================

; FUNCTION: nvdaSpeak(text) - Fa parlare NVDA con testo (UTF-16), ritorna true se OK
nvdaSpeak(text) {
    global nvdaControllerClient, UseNVDA
    
    if (!nvdaControllerClient || !UseNVDA)
        return false
    
    ; Converte testo in Unicode (UTF-16)
    VarSetCapacity(wText, StrLen(text) * 2 + 2, 0)
    StrPut(text, &wText, "UTF-16")
    
    ; Chiama funzione DLL
    result := DllCall("nvdaControllerClient.dll\nvdaController_speakText", "Ptr", &wText)
    return (result = 0)
}

; FUNCTION: nvdaCancel() - Interrompe parlato NVDA corrente, ritorna true se OK
nvdaCancel() {
    global nvdaControllerClient, UseNVDA
    
    if (!nvdaControllerClient || !UseNVDA)
        return false
    
    result := DllCall("nvdaControllerClient.dll\nvdaController_cancelSpeech")
    return (result = 0)
}

; FUNCTION: nvdaRunning() - Verifica se NVDA è in esecuzione, ritorna true se OK
nvdaRunning() {
    global nvdaControllerClient, UseNVDA
    
    if (!nvdaControllerClient || !UseNVDA)
        return false
    
    result := DllCall("nvdaControllerClient.dll\nvdaController_testIfRunning")
    return (result = 0)
}

; FUNCTION: nvdaBraille(text) - Invia messaggio a display Braille (UTF-16), ritorna true se OK
nvdaBraille(text) {
    global nvdaControllerClient, UseNVDA
    
    if (!nvdaControllerClient || !UseNVDA)
        return false
    
    VarSetCapacity(wText, StrLen(text) * 2 + 2, 0)
    StrPut(text, &wText, "UTF-16")
    
    result := DllCall("nvdaControllerClient.dll\nvdaController_brailleMessage", "Ptr", &wText)
    return (result = 0)
}