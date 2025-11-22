; ========================================
; HELP E INFORMAZIONI SCRIPT - GUI GENERALE
; Path: autohotkey scripts\Help_GUI.ahk
; ========================================

; Questo file gestisce SOLO la GUI e l'integrazione
; tra help globale e help per-gioco (es. CK3).
; I testi specifici del gioco sono in:
;   ck3_script\Help_ck3.ahk
;

; FUNCTION: GenerateGlobalHelpText() - testo dei comandi globali framework
GenerateGlobalHelpText() {
    global Hotkey_Toggle

    text =
    (
COMANDI GLOBALI FRAMEWORK
=========================

Toggle script
    %Hotkey_Toggle%    Attiva/Disattiva lo script Paradox

Ricarica script
    Ctrl+F5           Ricarica semplice
    Shift+F5          Ricarica per debug

Modalità e flag globali
    Ctrl+Shift+I      Modalità intensa (riduce annunci vocali)
    Shift+F12         Attiva/Disattiva suoni
    Ctrl+Shift+F12    Attiva/Disattiva voce
    Ctrl+Shift+F10    Attiva/Disattiva debug
    Ctrl+Shift+F9     Alterna NVDA / SAPI
    Ctrl+Shift+F8     Informazioni script


HELP E SINTESI GLOBALI
    Ctrl+Shift+H      Aiuto globale framework (questa finestra)
    Ctrl+H            Sintesi rapida comandi globali
    Alt+H             Sintesi estesa globale
    )

    return text
}

; FUNCTION: GenerateCombinedHelpText() - unisce globale + gioco corrente
GenerateCombinedHelpText() {
    full := GenerateGlobalHelpText()

    ; Se CK3 è disponibile e attivo, aggiungi sezione CK3
    if (IsFunc("CK3_GenerateHelpText") && WinExist("ahk_exe ck3.exe")) {
        full .= "`n`n"
        full .= "COMANDI SPECIFICI CRUSADER KINGS 3`n"
        full .= "==================================`n`n"
        full .= CK3_GenerateHelpText()
    } else {
        full .= "`n`n"
        full .= "COMANDI SPECIFICI GIOCO`n"
        full .= "======================`n"
        full .= "Nessun gioco specifico rilevato al momento.`n"
        full .= "Porta in primo piano il gioco (es. Crusader Kings 3)`n"
        full .= "per visualizzare i comandi dedicati."
    }

    return full
}

; FUNCTION: ShowHelpGUI() - GUI unica con help globale + gioco
ShowHelpGUI() {
    global HelpText  ; <--- AGGIUNTA: dichiarazione globale necessaria per VHelpText
    
    Gui, HelpGUI:New, +Resize +MinSize700x450, Aiuto Script Paradox - Navigabile
    Gui, Font, s10, Segoe UI

    ; Titolo
    Gui, Add, Text, x10 y10 w680 h30 Center, === AIUTO SCRIPT PARADOX GAMES ===
    Gui, Font, s9

    ; Area testo scrollabile
    Gui, Add, Text, x10 y45 w680 h25, Contenuto help (freccia su/giù, PageUp/PageDown per scorrere):
    combinedText := GenerateCombinedHelpText()
    Gui, Add, Edit, x10 y70 w680 h300 +HScroll +VScroll +ReadOnly VHelpText, %combinedText%

    ; Pulsanti
    ; Chiudi
    Gui, Add, Button, x200 y380 w100 gHelpGUIClose, &Chiudi
    ; Leggi help completo (globale + gioco)
    Gui, Add, Button, x310 y380 w140 gReadFullHelpAloud, &Leggi help completo
    ; Sommario breve (globale + gioco)
    Gui, Add, Button, x460 y380 w140 gShowFullShortSummary, &Sommario breve

    Gui, Show, Center w700 h430

    AnnouncePriority("Finestra aiuto Paradox aperta. Usa i tasti freccia per scorrere il testo. Tab per spostarti tra i pulsanti. F1 per istruzioni di navigazione.")
    ControlFocus, Edit1, Aiuto Script Paradox - Navigabile
    return
}

; LABEL: ReadFullHelpAloud - legge sia globale sia gioco se disponibile
ReadFullHelpAloud:
AnnouncePriority("Inizio lettura completa help globale.")
Sleep, 800
ReadGlobalHelpAloud()

; Se c'è help CK3 e CK3 è aperto, legge anche quello
if (IsFunc("CK3_ReadHelpAloud") && WinExist("ahk_exe ck3.exe")) {
    Sleep, 1000
    AnnouncePriority("Ora verranno letti i comandi specifici di Crusader Kings 3.")
    Sleep, 800
    CK3_ReadHelpAloud()
} else {
    Sleep, 800
    Announce("Nessun help specifico di gioco disponibile o gioco non attivo.")
}
Announce("Fine lettura help.")
return

; LABEL: ShowFullShortSummary - sommario globale + gioco (se presente)
ShowFullShortSummary:
AnnouncePriority("Sommario breve dei comandi globali.")
Sleep, 600
ShowGlobalShortSummary()

if (IsFunc("CK3_ShowShortSummary") && WinExist("ahk_exe ck3.exe")) {
    Sleep, 800
    AnnouncePriority("Segue il sommario breve dei comandi di Crusader Kings 3.")
    Sleep, 600
    CK3_ShowShortSummary()
} else {
    Sleep, 600
    Announce("Nessun sommario specifico di gioco disponibile o gioco non attivo.")
}
return

; FUNCTION: ReadGlobalHelpAloud() - lettura vocale solo parte globale
ReadGlobalHelpAloud() {
    Announce("Sezione: comandi globali framework.")
    Sleep, 1200

    Announce("Toggle script con Control Shift F1, o il tasto configurato in config punto ini.")
    Sleep, 800
    Announce("Control F5 oppure Shift F5 ricaricano lo script.")
    Sleep, 800
    Announce("Control Shift I attiva la modalità intensa con annunci ridotti.")
    Sleep, 800
    Announce("Shift F12 attiva o disattiva i suoni.")
    Sleep, 800
    Announce("Control Shift F12 attiva o disattiva gli annunci vocali.")
    Sleep, 800
    Announce("Control Shift F10 attiva o disattiva il debug.")
    Sleep, 800
    Announce("Control Shift F9 cambia tra NVDA e SAPI.")
    Sleep, 800
    Announce("Control Shift F8 mostra una finestra con le informazioni sullo script.")
    Sleep, 800
    Announce("Control Shift H apre questa finestra di aiuto. Control H dà una sintesi rapida globale. Alt H dà una sintesi estesa.")
    Sleep, 800
    Announce("Il tasto meno, sulla riga principale, esegue un click sinistro nel punto del cursore di NVDA, con un breve suono e spostando il mouse fuori schermo.")
    Sleep, 800
    Announce("Control Invio invia il tasto Invio nel punto del cursore di NVDA, con un breve suono e spostando il mouse fuori schermo.")
    return
}

; FUNCTION: ShowGlobalShortSummary() - sommario brevissimo solo globale
ShowGlobalShortSummary() {
    global Hotkey_Toggle
    Announce("Comandi globali essenziali.")
    Sleep, 600
    Announce("Toggle script: " . Hotkey_Toggle . ". Reload: Control F5 o Shift F5.")
    Sleep, 600
    Announce("Modalità intensa: Control Shift I. Suoni: Shift F12. Voce: Control Shift F12.")
    Sleep, 600
    Announce("Debug: Control Shift F10. NVDA o SAPI: Control Shift F9. Info script: Control Shift F8.")
    return
}

; Gestione chiusura GUI
HelpGUIClose:
HelpGUIGuiEscape:
HelpGUIGuiClose:
Gui, HelpGUI:Destroy
Announce("Finestra aiuto chiusa.")
return

; Hotkey F1 SOLO nella finestra di help globale
#IfWinActive, Aiuto Script Paradox - Navigabile
F1::
Announce("Istruzioni navigazione help: freccia su e giù per scorrere riga per riga. Page Up e Page Down per scorrere rapidamente. Home e End per inizio e fine testo. Tab per navigare tra i pulsanti. Invio per attivare un pulsante. Escape per chiudere la finestra.")
return
#IfWinActive
