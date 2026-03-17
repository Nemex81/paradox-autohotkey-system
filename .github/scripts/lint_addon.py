#!/usr/bin/env python3
"""Lint generated NVDA addons via syntax checks and manifest validation."""

from __future__ import annotations

import argparse
import configparser
import py_compile
from pathlib import Path

REQUIRED_MANIFEST_KEYS = (
    "name",
    "summary",
    "author",
    "version",
    "minimumNVDAVersion",
    "lastTestedNVDAVersion",
)


def _iter_addon_dirs(root: Path) -> list[Path]:
    addons: list[Path] = []
    for manifest in root.rglob("manifest.ini"):
        addons.append(manifest.parent)
    return sorted(set(addons))


def _check_manifest(manifest_path: Path) -> list[str]:
    parser = configparser.ConfigParser()
    parser.optionxform = str
    text = "[addon]\n" + manifest_path.read_text(encoding="utf-8")
    parser.read_string(text)

    missing: list[str] = []
    for key in REQUIRED_MANIFEST_KEYS:
        if not parser.has_option("addon", key):
            missing.append(key)

    if parser.has_option("addon", "minimumNVDAVersion") and parser.has_option("addon", "lastTestedNVDAVersion"):
        minimum = parser.get("addon", "minimumNVDAVersion").strip().strip('"')
        last_tested = parser.get("addon", "lastTestedNVDAVersion").strip().strip('"')
        if minimum > last_tested:
            missing.append("minimumNVDAVersion<=lastTestedNVDAVersion")

    return missing


def lint_addon(addon_dir: Path) -> list[str]:
    errors: list[str] = []

    manifest = addon_dir / "manifest.ini"
    if not manifest.exists():
        errors.append(f"{addon_dir}: missing manifest.ini")
        return errors

    manifest_errors = _check_manifest(manifest)
    for err in manifest_errors:
        errors.append(f"{manifest}: invalid {err}")

    sconstruct = addon_dir / "sconstruct"
    build_vars = addon_dir / "buildVars.py"
    if sconstruct.exists() and not build_vars.exists():
        errors.append(f"{addon_dir}: sconstruct present but buildVars.py missing")

    for py_file in addon_dir.rglob("*.py"):
        try:
            py_compile.compile(str(py_file), doraise=True)
            print(f"PASS: {py_file}")
        except py_compile.PyCompileError as e:
            errors.append(f"{py_file}: {e.msg}")

    return errors


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Lint generated NVDA addons")
    parser.add_argument("--root", default="generated_addons", help="Root directory containing generated addon folders")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    root = Path(args.root)
    if not root.exists():
        print(f"FAIL: addons root not found: {root}")
        return 2

    addon_dirs = _iter_addon_dirs(root)
    if not addon_dirs:
        print(f"FAIL: no addons found under {root}")
        return 2

    all_errors: list[str] = []
    for addon_dir in addon_dirs:
        print(f"Checking addon: {addon_dir}")
        all_errors.extend(lint_addon(addon_dir))

    if all_errors:
        print("FAIL: lint_addon")
        for err in all_errors:
            print(err)
        return 1

    print("PASS: lint_addon")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
