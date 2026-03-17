# Prompt: Run Agent Pipeline

Goal: select and execute the right specialized agent flow for the request.

Input:
- task_type (new-addon|feature|bugfix|refactor|docs|release)
- mode (auto|manual)
- optional agent alias for manual mode

Process:
1. Load `.github/config/agent_registry.json`.
2. Resolve pipeline from task_type and mode.
3. Execute selected steps in order.
4. Produce one final report.
