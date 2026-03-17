# Framework Runtime (.github)

Questa cartella contiene il runtime del framework operativo per sviluppo e validazione addon NVDA.

## Panoramica componenti

- agents: ruoli specializzati per requisiti, architettura, implementazione, review, validazione, release e documentazione.
- config: registry agenti e manifesto dei path obbligatori.
- instructions: regole operative globali per esecuzione autonoma.
- prompts: prompt pronti per flussi operativi standard e scenari NVDA.
- scripts: automazioni CLI per bootstrap, validazione, pipeline e changelog.
- skills: base di conoscenza operativa per agenti e policy.
- templates: scaffold addon e frammenti riusabili.
- workflows: quality gate CI.
- reports: output delle validazioni e pipeline.

## Flusso tipico

1. Definire task e vincoli.
2. Generare o modificare artefatti con script/template.
3. Eseguire validate + selftest.
4. Aggiornare changelog e documentazione.
