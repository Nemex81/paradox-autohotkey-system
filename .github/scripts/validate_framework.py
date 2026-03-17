#!/usr/bin/env python3
"""Validate required framework files and write a report."""

from __future__ import annotations

import json
from pathlib import Path


def main() -> int:
    root = Path(__file__).resolve().parents[2]
    cfg_path = root / ".github/config/framework.json"
    if not cfg_path.exists():
        print(f"FAIL: missing config {cfg_path}")
        return 2

    cfg = json.loads(cfg_path.read_text(encoding="utf-8"))
    required_paths = cfg.get("required_paths", [])
    report_file = root / cfg.get("report_file", ".github/reports/last_validation_report.txt")
    report_file.parent.mkdir(parents=True, exist_ok=True)

    duplicates = []
    seen = set()
    for rel in required_paths:
        if rel in seen:
            duplicates.append(rel)
        seen.add(rel)

    missing = []
    for rel in required_paths:
        path = root / rel
        if not path.exists():
            missing.append(rel)

    lines = []
    lines.append("Framework validation report")
    lines.append(f"required_paths={len(required_paths)}")
    lines.append(f"duplicate_paths={len(duplicates)}")

    if missing or duplicates:
        lines.append("status=FAIL")
        if missing:
            lines.append("missing:")
            lines.extend(f"- {item}" for item in missing)
        if duplicates:
            lines.append("duplicates:")
            lines.extend(f"- {item}" for item in duplicates)
        report_file.write_text("\n".join(lines) + "\n", encoding="utf-8")
        print("FAIL: framework validation")
        for item in missing:
            print(f"missing: {item}")
        for item in duplicates:
            print(f"duplicate: {item}")
        print(f"report={report_file}")
        return 1

    lines.append("status=PASS")
    report_file.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print("PASS: framework validation")
    print(f"report={report_file}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
