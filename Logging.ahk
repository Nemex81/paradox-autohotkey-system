; ========================================
; LOGGING MODULE
; Path: autohotkey scripts\Logging.ahk
; ========================================

; Gestisce logging e debug con supporto per file log, debug mode,
; messaggi categorizzati e integrazione con sistema di feedback.

; GLOBALI USATE (dichiarate in globals.ahk):
; DebugMode, GameIntenseMode

; GLOBALI USATE (da config.ini):
; ConfigFile - percorso del file config.ini

; FUNCTION: LogError(message)
; Registra errori in debug.log, solo se DebugMode attivo
; Opzionalmente annuncia se non in modalità intensa
LogError(message) {
    global DebugMode, GameIntenseMode

    if (!DebugMode)
        return false

    ; Scrivi nel file di log errori
    FileAppend, %A_Now%: ERRORE - %message%`n, %A_ScriptDir%\debug.log

    ; Annuncia solo se non in modalità intensa
    if (!GameIntenseMode) {
        Announce("Errore loggato per debug.")
    }

    return true
}

; FUNCTION: LogMessage(message, level)
; Registra messaggi categorizzati nel log principale
; level può essere: "INFO", "DEBUG", "WARNING", "ERROR", "SUCCESS"
; DEBUG messages vengono scritti solo se DebugMode è attivo
LogMessage(message, level := "INFO") {
    global DebugMode

    ; Se è DEBUG e DebugMode non attivo, salta
    if (!DebugMode && level = "DEBUG")
        return false

    ; Formatta timestamp
    formatTime, timestamp,, yyyy-MM-dd HH:mm:ss

    ; Crea entry formattata
    logEntry := timestamp . " [" . level . "] " . message . "`n"

    ; Scrivi nel file log principale
    FileAppend, %logEntry%, %A_ScriptDir%\paradox_script.log

    return true
}

; FUNCTION: LogDebug(message)
; Shortcut per logging di debug messages
LogDebug(message) {
    return LogMessage(message, "DEBUG")
}

; FUNCTION: LogWarning(message)
; Shortcut per logging di warning messages
LogWarning(message) {
    return LogMessage(message, "WARNING")
}

; FUNCTION: LogSuccess(message)
; Shortcut per logging di success messages
LogSuccess(message) {
    return LogMessage(message, "SUCCESS")
}

; FUNCTION: ClearDebugLog()
; Pulisce il file debug.log, utile per session di debug pulita
ClearDebugLog() {
    global DebugMode

    if (!DebugMode)
        return false

    ; Cancella il file o lo ricrea vuoto
    FileDelete, %A_ScriptDir%\debug.log
    LogMessage("Debug log ripulito.", "INFO")
    return true
}

; FUNCTION: ClearMainLog()
; Pulisce il file log principale, utile per reset session
ClearMainLog() {
    ; Cancella il file o lo ricrea vuoto
    FileDelete, %A_ScriptDir%\paradox_script.log
    ; Rilog il reset
    LogMessage("Log principale ripulito.", "INFO")
    return true
}

; FUNCTION: LogScriptStart()
; Logga l'avvio dello script, utile per tracciamento sessioni
LogScriptStart() {
    global A_ScriptVersion

    logEntry := "`n" . "="  . 50 . "`n"
    logEntry .= "SCRIPT AVVIATO: " . A_Now . "`n"
    logEntry .= "Versione AHK: " . A_AhkVersion . "`n"
    logEntry .= "Risoluzione: " . A_ScreenWidth . "x" . A_ScreenHeight . "`n"
    logEntry .= "="  . 50 . "`n`n"

    FileAppend, %logEntry%, %A_ScriptDir%\paradox_script.log

    return true
}

; FUNCTION: LogScriptStop()
; Logga l'arresto dello script, utile per tracciamento sessioni
LogScriptStop() {
    logEntry := "`n" . "="  . 50 . "`n"
    logEntry .= "SCRIPT FERMATO: " . A_Now . "`n"
    logEntry .= "="  . 50 . "`n`n"

    FileAppend, %logEntry%, %A_ScriptDir%\paradox_script.log

    return true
}

; FUNCTION: LogHotkey(hotkeyName, result)
; Logga l'esecuzione di un hotkey con risultato
LogHotkey(hotkeyName, result := "OK") {
    return LogDebug("Hotkey: " . hotkeyName . " -> " . result)
}

; FUNCTION: LogNvdaStatus()
; Logga lo stato NVDA corrente per debugging
LogNvdaStatus() {
    global UseNVDA, nvdaControllerClient

    nvdaRunning := nvdaRunning() ? "In esecuzione" : "Non attivo"
    dllLoaded := nvdaControllerClient ? "Caricata" : "Non trovata"
    mode := UseNVDA ? "NVDA" : "SAPI"

    msg := "NVDA Status - Mode: " . mode . " | Running: " . nvdaRunning . " | DLL: " . dllLoaded
    return LogDebug(msg)
}

; FUNCTION: LogGameStatus(gameName)
; Logga lo stato di un gioco (es. CK3 aperto/chiuso)
LogGameStatus(gameName) {
    gameWindow := "ahk_exe " . gameName . ".exe"
    if (WinExist(gameWindow)) {
        return LogDebug(gameName . " window found - Game is active")
    } else {
        return LogDebug(gameName . " window NOT found - Game is inactive")
    }
}

; FUNCTION: GetLogFilePath(logType)
; Ritorna il percorso completo del file log richiesto
GetLogFilePath(logType := "main") {
    if (logType = "debug")
        return A_ScriptDir . "\debug.log"
    else if (logType = "main")
        return A_ScriptDir . "\paradox_script.log"
    else
        return ""
}

; FUNCTION: OpenLogFile(logType)
; Apre il file log nel editor di default
OpenLogFile(logType := "main") {
    logPath := GetLogFilePath(logType)
    if (logPath != "" && FileExist(logPath)) {
        Run, %logPath%
        return true
    } else {
        LogError("File log non trovato: " . logPath)
        return false
    }
}
