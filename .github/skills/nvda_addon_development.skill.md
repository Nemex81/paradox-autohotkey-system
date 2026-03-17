# NVDA Addon Development Skill

## Scope

Questa skill definisce regole operative e riferimenti API per sviluppare addon NVDA senza inventare moduli o pattern.

Fonte di verita usata per questa skill:
- repository locale: nvda
- branch: master
- commit: be350b052
- documenti: projectDocs/dev/developerGuide/developerGuide.md

## Struttura minima addon

Un addon NVDA deve includere almeno:
- manifest.ini
- globalPlugins/ oppure appModules/ (in base al tipo addon)

Componenti tipiche consigliate:
- buildVars.py (se si usa toolchain scons per packaging)
- locale/<lang>/LC_MESSAGES/nvda.po e nvda.mo
- doc/ per documentazione addon

## Moduli NVDA fondamentali

Moduli comuni verificati nel codice/documentazione NVDA:
- globalPluginHandler
- appModuleHandler
- NVDAObjects
- scriptHandler
- ui
- speech
- tones
- braille
- config
- gui
- logHandler (log)
- addonHandler (initTranslation)

## Pattern GlobalPlugin

Regole:
- classe GlobalPlugin che eredita da globalPluginHandler.GlobalPlugin
- script con prefisso script_
- binding gesture con decoratore @script oppure mappa __gestures
- scriptCategory valorizzata per categorizzare gli script nel dialogo gesti

Pattern base:
- from scriptHandler import script
- @script(gesture="kb:NVDA+shift+v")
- def script_nomeAzione(self, gesture): ...

## Pattern AppModule

Regole:
- classe AppModule che eredita da appModuleHandler.AppModule
- supporto a event_NVDAObject_init(self, obj)
- supporto a chooseNVDAObjectOverlayClasses(self, obj, clsList)
- overlay class dedicate per comportamenti specifici su controlli

## Ciclo di vita addon

Per moduli addon Python:
- inizializzazione in __init__ con super().__init__()
- cleanup in terminate quando necessario
- eventuale registrazione extension point (es. addonHandler.isCLIParamKnown)
- gestione configurazione tramite config.conf con chiavi dedicate addon

## Compatibilita versioni

manifest.ini usa stringhe, non tuple Python:
- minimumNVDAVersion = "YYYY.M" oppure "YYYY.M.m"
- lastTestedNVDAVersion = "YYYY.M" oppure "YYYY.M.m"

Vincoli:
- minimumNVDAVersion <= lastTestedNVDAVersion
- versioni devono corrispondere a API version valide per Add-on Store

## Convenzioni naming

- script_<azione> per script NVDA
- event_<evento> per handler eventi
- NomeClasseOverlay per classi overlay
- addon id corto e stabile (consigliato lowerCamelCase)

## Error handling e logging

Usare log da logHandler:
- log.debug per diagnostica
- log.warning per condizioni anomale non bloccanti
- log.error per errori operativi

Regola:
- non silenziare eccezioni critiche senza logging contestuale

## Internazionalizzazione

Regole:
- inizializzare traduzioni con addonHandler.initTranslation() nei moduli addon
- usare _(), ngettext(), npgettext(), pgettext() dopo initTranslation
- mantenere file gettext in locale/<lang>/LC_MESSAGES/

## Packaging

- pacchetto finale: archivio .nvda-addon
- contenuto minimo: manifest.ini + moduli addon
- con toolchain scons, usare buildVars.py e script di build coerenti

## Checklist rapida pre-merge

- API importate esistono davvero nella versione NVDA target
- gesture non in conflitto con comandi NVDA noti
- nessuna call bloccante nel thread UI
- manifest.ini completo e valido
- validate_framework.py PASS
- selftest.py PASS
