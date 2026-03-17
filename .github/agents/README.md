# Agents

Questa cartella contiene le definizioni degli agenti specializzati del framework.

## Contenuto

- orchestrator.agent.md: classifica task e coordina handoff.
- requirements.agent.md: formalizza requisiti e acceptance criteria.
- architecture.agent.md: definisce strategia tecnica e impatti file/API.
- implementation.agent.md: applica patch incrementali sicure.
- review.agent.md: analizza bug, regressioni e rischi.
- validation.agent.md: esegue quality gate e produce esito.
- release.agent.md: prepara rilascio solo su gate verdi.
- docs_maintenance.agent.md: allinea docs/commenti/changelog.

## Uso

Gli agenti sono richiamati dal registry in config e possono operare in modalita manuale o autonoma.
