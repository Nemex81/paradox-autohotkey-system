#!/usr/bin/env python3
"""Resolve agent pipelines for manual or autonomous execution."""

from __future__ import annotations

import argparse
import json
from datetime import datetime, timezone
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Resolve specialized agent pipeline")
    parser.add_argument("--task-type", required=True, choices=["new-addon", "feature", "bugfix", "refactor", "docs", "release"])
    parser.add_argument("--mode", default="auto", choices=["auto", "manual"])
    parser.add_argument("--agent", help="Agent id or manual alias (required for manual mode)")
    parser.add_argument("--registry", default=".github/config/agent_registry.json")
    parser.add_argument("--report", default=".github/reports/last_agent_pipeline_report.json")
    return parser.parse_args()


def load_registry(path: Path) -> dict:
    if not path.exists():
        raise FileNotFoundError(f"Registry not found: {path}")
    return json.loads(path.read_text(encoding="utf-8"))


def resolve_manual_agent(registry: dict, raw_name: str | None) -> str:
    if not raw_name:
        raise ValueError("--agent is required in manual mode")

    agents = registry.get("agents", {})
    aliases = registry.get("manual_aliases", {})
    normalized = raw_name.strip().lower()

    if normalized in agents:
        return normalized
    if normalized in aliases:
        return aliases[normalized]

    raise ValueError(f"Unknown agent or alias: {raw_name}")


def resolve_pipeline(registry: dict, task_type: str, mode: str, manual_agent: str | None) -> list[str]:
    if mode == "manual":
        return [resolve_manual_agent(registry, manual_agent)]

    pipelines = registry.get("pipelines", {})
    selected = pipelines.get(task_type)
    if not selected:
        raise ValueError(f"No pipeline configured for task_type={task_type}")
    return selected


def main() -> int:
    args = parse_args()
    root = Path(__file__).resolve().parents[2]
    registry_path = root / args.registry
    report_path = root / args.report

    registry = load_registry(registry_path)
    pipeline = resolve_pipeline(registry, args.task_type, args.mode, args.agent)

    result = {
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "task_type": args.task_type,
        "mode": args.mode,
        "selected_pipeline": pipeline,
        "agent_cards": {agent_id: registry.get("agents", {}).get(agent_id) for agent_id in pipeline},
        "status": "PASS"
    }

    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")

    print("PASS: agent pipeline resolved")
    print(f"task_type={args.task_type}")
    print(f"mode={args.mode}")
    print(f"pipeline={','.join(pipeline)}")
    print(f"report={report_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
