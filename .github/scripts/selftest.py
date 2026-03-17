#!/usr/bin/env python3
"""Tiny self-test for framework scripts."""

from __future__ import annotations

import os
import shutil
import subprocess
import time
from pathlib import Path


def run(cmd: list[str], cwd: Path) -> None:
    result = subprocess.run(cmd, cwd=str(cwd), check=False, capture_output=True, text=True)
    print(result.stdout.strip())
    if result.returncode != 0:
        print(result.stderr.strip())
        raise RuntimeError(f"Command failed: {' '.join(cmd)}")


def _force_remove_tree(path: Path) -> None:
    # Some synced folders on Windows can transiently lock files.
    def _onerror(func, target, exc_info):
        try:
            os.chmod(target, 0o700)
        except OSError:
            pass
        func(target)

    for _ in range(3):
        try:
            shutil.rmtree(path, onerror=_onerror)
            return
        except PermissionError:
            time.sleep(0.2)

    shutil.rmtree(path, ignore_errors=True)


def main() -> int:
    root = Path(__file__).resolve().parents[2]
    temp_out = root / ".github/.tmp_selftest"
    if temp_out.exists():
        _force_remove_tree(temp_out)
    temp_out.mkdir(parents=True, exist_ok=True)

    run([
        "python",
        ".github/scripts/bootstrap_addon.py",
        "--addon-id", "demoaddon",
        "--addon-name", "Demo Addon",
        "--author", "Framework Bot",
        "--version", "0.1.0",
        "--description", "Demo addon from selftest",
        "--output-dir", str(temp_out),
        "--templates-dir", ".github/templates",
    ], cwd=root)

    manifest = temp_out / "demoaddon/manifest.ini"
    if not manifest.exists():
        raise RuntimeError("manifest.ini not generated")

    run([
        "python",
        ".github/scripts/release_prep.py",
        "--manifest", str(manifest),
    ], cwd=root)

    run([
        "python",
        ".github/scripts/run_agent_pipeline.py",
        "--task-type", "feature",
        "--mode", "auto",
    ], cwd=root)

    run([
        "python",
        ".github/scripts/run_agent_pipeline.py",
        "--task-type", "docs",
        "--mode", "manual",
        "--agent", "documentazione",
    ], cwd=root)

    temp_changelog = temp_out / "CHANGELOG_TEST.md"
    temp_changelog.write_text("# Changelog\n\n", encoding="utf-8")
    run([
        "python",
        ".github/scripts/update_changelog.py",
        "--changelog", str(temp_changelog),
        "--title", "Selftest changelog update",
        "--category", "Docs",
        "--details", "Validated changelog automation",
    ], cwd=root)

    run(["python", ".github/scripts/validate_framework.py"], cwd=root)

    print("PASS: selftest complete")
    _force_remove_tree(temp_out)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
