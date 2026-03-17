# Prompt: NVDA Addon Review

Goal: revisionare un addon NVDA con focus su regressioni e compatibilita.

Checklist:
- compatibilita versioni minimumNVDAVersion/lastTestedNVDAVersion
- conflitti gesture
- thread safety (uso wx nel thread UI)
- memory leak in handler eventi
- internazionalizzazione (_(), file locale)

Output atteso:
- BLOCCANTE: problemi da risolvere prima del merge
- ATTENZIONE: rischi medi o debito tecnico
- SUGGERIMENTO: miglioramenti opzionali
