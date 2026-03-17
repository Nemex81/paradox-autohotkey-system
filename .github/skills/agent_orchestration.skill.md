# Skill Card: Agent Orchestration

Input:
- task_type (new-addon|feature|bugfix|refactor|docs|release)
- mode (auto|manual)
- optional_agent (for manual mode)

Output:
- ordered agent pipeline
- selected agent cards
- orchestration report path

Command:
- `python .github/scripts/run_agent_pipeline.py --task-type <task_type> --mode <mode> [--agent <agent>]`
