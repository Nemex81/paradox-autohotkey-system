# Config

Configurazione centrale del framework.

## File principali

- agent_registry.json: mapping task-type -> pipeline agenti.
- framework.json: lista required_paths e posizione report validazione.

## Ruolo operativo

Questi file governano routing e integrita strutturale. Ogni modifica richiede rerun di validate_framework.py.
