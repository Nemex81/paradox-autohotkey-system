# Prompt: NVDA Bugfix

Goal: applicare fix minimo a un bug addon/framework senza refactor fuori scope.

Input:
- descrizione bug
- traceback o log NVDA
- comportamento atteso
- contesto file/moduli

Regole:
- fix minimo e localizzato
- non refactorizzare oltre lo scope del bug
- validare con gate applicabili

Output atteso:
- patch minima proposta
- file modificati
- esito test/validazione
- rischi residui
