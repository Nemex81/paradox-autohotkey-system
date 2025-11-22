; ========================================
; HELP E INFORMAZIONI SCRIPT - COMANDI CK3
; Path: autohotkey scripts\ck3_script\Help_ck3.ahk
; ========================================

; Tutte le funzioni qui sono pensate per essere
; richiamate dalla GUI generale in Help_GUI.ahk.

; FUNCTION: CK3_GenerateHelpText() - ritorna il testo CK3 da mostrare
CK3_GenerateHelpText() {

    navigationText =
    (
NAVIGAZIONE PRINCIPALE
======================
Shift+F1           Pagina Su
Shift+F2           Pagina Giù
Shift+Freccia Su   Scroll Su (10 passi)
Shift+Freccia Giù  Scroll Giù (10 passi)
)

    clickInteractionText =
    (
CLICK E INTERAZIONE
===================
ControbarrA (\)    scansione ocr rapida
VIRGOLA (,)        Click sinistro e scansione ocr
PUNTO (.)          Click destro
Ctrl+VIRGOLA       Control click
Shift+VIRGOLA      Routing mouse al cursore nvda
- (trattino)       Click sinistro nel punto del cursore NVDA
Ctrl+- (trattino)  Sposta il puntatore del mouse nella posizione del cursore ocr
Ctrl+Enter         Invio sul punto del cursore NVDA
)

    quickActionsText =
    (
AZIONI RAPIDE
=============
Shift+1           Click al centro schermo
Ctrl+2            Click destro al centro
Shift+3           Shift + click destro centro
)

    cursorUtilitiesText =
    (
UTILITÀ CURSORE
==============
controbarra (\)         Attiva OCR
Ctrl+Shift+C            Centra cursore
Ctrl+D                  Nascondi tooltip
Ctrl+Shift+D            Tooltip + OCR
)

    gameCommandsText =
    (
COMANDI DI GIOCO
================
Ctrl+G                 Selezione armate
Ctrl+Shift+P           Pausa gioco
)

    configText =
    (
CONFIGURAZIONE CK3
==================
Toggle script (config, default Ctrl+Shift+F1)  Attiva/Disattiva
Ctrl+F5                 Ricarica semplice
Shift+F5                Ricarica debug
Shift+F12               Attiva/Disattiva suoni
Ctrl+Shift+F12          Attiva/Disattiva voce
Ctrl+Shift+F10          Toggle debug
Ctrl+Shift+F9           Alterna NVDA/SAPI
Ctrl+Shift+F8           Informazioni script
Ctrl+Shift+I            Toggle modalità intensa (riduce annunci)
Ctrl+Shift+H            Aiuto CK3
Ctrl+H                  Aiuto rapido CK3
)

    nvdKeySettingsText =
    (
IMPOSTAZIONI TASTO NVDA
=======================
Ctrl+CapsLock           Tasto NVDA = Bloc Maiusc
Ctrl+Insert             Tasto NVDA = Insert
Ctrl+NumPadIns          Tasto NVDA = Insert tastierino
)

    suggestionsText =
    (
SUGGERIMENTI CK3
================
• Assicurati che il gioco sia attivo per usare questi comandi.
• Usa sempre l'OCR dopo i click per verificare i risultati.
• In modalità intensa (Ctrl+Shift+I), annunci ridotti per prestazioni.
    )

    ; Concatenazione finale (sintassi compatibile AHK v1)
    fullText := navigationText . "`n`n"
        . clickInteractionText . "`n`n"
        . quickActionsText . "`n`n"
        . cursorUtilitiesText . "`n`n"
        . gameCommandsText . "`n`n"
        . configText . "`n`n"
        . nvdKeySettingsText . "`n`n"
        . suggestionsText

    return fullText
}

; FUNCTION: AnnounceSection - helper per lettura vocale delle sezioni
AnnounceSection(title, message) {
    Announce(title)
    Sleep, 1500
    Announce(message)
    Sleep, 2000
}

; FUNCTION: CK3_ReadHelpAloud() - lettura vocale dell'help CK3
CK3_ReadHelpAloud() {
    navMsg =
    (
Shift F1 pagina su. Shift F2 pagina giù. Shift freccia su scroll su. Shift freccia giù scroll giù.
    )
    AnnounceSection("Sezione CK3: navigazione principale.", navMsg)

    clickMsg =
    (
Virgola click sinistro. Punto click destro. Control virgola control click. Shift virgola routing mouse.
    )
    AnnounceSection("Sezione CK3: click e interazione.", clickMsg)

    actionMsg =
    (
Shift 1 click al centro. Control 2 click destro al centro. Shift 3 shift click destro al centro.
    )
    AnnounceSection("Sezione CK3: azioni rapide.", actionMsg)

    cursorMsg =
    (
Punto e virgola O C R. Control Shift C centra cursore. Control D nascondi tooltip. Control Shift D tooltip più O C R.
    )
    AnnounceSection("Sezione CK3: utilità cursore.", cursorMsg)

    gameCmdMsg =
    (
Control G selezione armate. Control Shift P pausa gioco.
    )
    AnnounceSection("Sezione CK3: comandi di gioco.", gameCmdMsg)

    configMsg =
    (
Toggle script da config, default Control Shift F1 on off. Control F5 ricarica semplice. Shift F5 ricarica debug. Shift F12 suoni. Control Shift F12 voce. Control Shift F10 debug. Control Shift F9 cambia tra NVDA e SAPI. Control Shift I modalità intensa. Control Shift H help CK3. Control H aiuto rapido CK3.
    )
    AnnounceSection("Sezione CK3: configurazione e modalità.", configMsg)

    nvdaKeyMsg =
    (
Control Bloc Maiusc imposta tasto NVDA su Bloc Maiusc. Control Insert imposta Insert. Control Insert tastierino imposta Insert tastierino.
    )
    AnnounceSection("Sezione CK3: impostazioni tasto NVDA.", nvdaKeyMsg)

    suggestionMsg =
    (
Assicurati che CK3 sia attivo. Usa sempre O C R dopo i click. In modalità intensa, annunci ridotti.
    )
    AnnounceSection("Sezione CK3: suggerimenti.", suggestionMsg)

    return
}

; FUNCTION: CK3_ShowShortSummary() - sommario breve CK3 (anche con MsgBox)
CK3_ShowShortSummary() {
    shortHelp =
    (
COMANDI ESSENZIALI CK3:

NAVIGAZIONE: Shift+F1/F2, Shift+Freccia su/giù
CLICK: , (sinistro) . (destro) Ctrl+, (control) Shift+, (routing)
AZIONI: Shift+1 (centro) ; (OCR)
UTILITÀ: Ctrl+Shift+C (centra) Ctrl+D (tooltip)
GIOCO: Ctrl+G (armate) Ctrl+Shift+P (pausa)
CONFIG: Ctrl+Shift+F1 (on/off, default) Ctrl+Shift+I (intensa) Ctrl+F5 (ricarica) Shift+F5 (debug) Ctrl+Shift+H (help CK3)
    )

    MsgBox, 64, Sommario Comandi CK3, %shortHelp%
    AnnouncePriority("Sommario breve CK3 mostrato. Comandi essenziali Crusader Kings 3.")
    return
}
