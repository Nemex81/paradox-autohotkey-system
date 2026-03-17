# Test Manuale Addon Pilota helloNVDA

## Prerequisiti
- NVDA installato e in esecuzione
- Addon generato in generated_addons/helloNVDA

## Procedura
1. Creare pacchetto addon (o copiare la struttura addon nel profilo NVDA per test locale).
2. Copiare la cartella addon in %APPDATA%/nvda/addons/
3. Riavviare NVDA.
4. Premere NVDA+Shift+H.
5. Verificare annuncio vocale: "helloNVDA active".
6. Aprire NVDA -> Preferenze -> Gesti di immissione.
7. Verificare presenza script nella categoria helloNVDA.

## Esito atteso
- Lo script risponde al gesto senza errori.
- Nessun conflitto evidente con gesti NVDA comuni.
- Addon caricato correttamente all'avvio.
