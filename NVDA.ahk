; ========================================
; NVDA CONTROLLER CLIENT FUNCTIONS (WRAPPER LOGICO)
; Path: autohotkey scripts\NVDA.ahk
; ========================================
; Questo file delega tutte le chiamate a NVDA_DLLWrapper.ahk
; Funzioni esposte:
;   nvdaSpeak(text)
;   nvdaCancel()
;   nvdaRunning()
; ========================================

; FUNCTION: nvdaSpeak(text)
; Fa parlare NVDA con il testo indicato.
; Ritorna true se la DLL ha accettato il testo (result=0), false altrimenti.
nvdaSpeak(text) {
    return NVDA_DLL_SpeakText(text)
}

; FUNCTION: nvdaCancel()
; Interrompe il parlato corrente di NVDA.
; Ritorna true se la cancellazione è andata a buon fine, false altrimenti.
nvdaCancel() {
    return NVDA_DLL_CancelSpeech()
}

; FUNCTION: nvdaRunning()
; Verifica se NVDA è in esecuzione tramite nvdaController_testIfRunning.
; Ritorna true se NVDA è attivo, false altrimenti.
nvdaRunning() {
    return NVDA_DLL_TestIfRunning()
}
