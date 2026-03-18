# Fonti utili per sviluppo addon NVDA

Questa pagina raccoglie fonti affidabili da usare durante progettazione, implementazione, debug e review degli addon NVDA.

## Priorita di consultazione

1. Guida sviluppatori NVDA (fonte primaria API)
2. Codice sorgente NVDA (pattern reali e comportamenti effettivi)
3. Documentazione Python standard library (logging, i18n, ecc.)
4. Documentazione accessibilita piattaforma (UIA/ARIA)
5. Community addon e best practice operative

## Fonti NVDA ufficiali

- Developer Guide: https://github.com/nvaccess/nvda/blob/master/projectDocs/dev/developerGuide/developerGuide.md
- Sorgente NVDA: https://github.com/nvaccess/nvda
- Sito NV Access: https://www.nvaccess.org/

## Community e addon ecosystem

- Catalogo community addon: https://addons.nvda-project.org/
- Community addon (gruppo): https://nvda-addons.groups.io/g/nvda-addons

## Python (fondamentali pratici)

- Python docs: https://docs.python.org/3/
- Logging: https://docs.python.org/3/library/logging.html
- Gettext / localizzazione: https://docs.python.org/3/library/gettext.html

## Accessibilita e interoperabilita UI

- Microsoft UI Automation: https://learn.microsoft.com/windows/win32/winauto/entry-uiauto-win32
- WAI-ARIA Authoring Practices: https://www.w3.org/WAI/ARIA/apg/

## Qualita e rilascio

- pytest: https://docs.pytest.org/
- Semantic Versioning: https://semver.org/

## Nota operativa per questo workspace

Quando un task tocca API NVDA, la fonte principale resta il repository NVDA locale (se disponibile), con verifica in:

- nvda/source
- nvda/projectDocs/dev/developerGuide/developerGuide.md
