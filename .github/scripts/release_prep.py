#!/usr/bin/env python3
"""Prepare next patch release version for generated addon manifest."""

from __future__ import annotations

import argparse
from pathlib import Path


def bump_patch(version: str) -> str:
    parts = version.strip().split(".")
    if len(parts) != 3 or not all(p.isdigit() for p in parts):
        raise ValueError("version must be semver like X.Y.Z")
    major, minor, patch = map(int, parts)
    return f"{major}.{minor}.{patch + 1}"


def _unquote(value: str) -> tuple[str, str]:
    text = value.strip()
    if len(text) >= 2 and text[0] == '"' and text[-1] == '"':
        return text[1:-1], '"'
    if len(text) >= 2 and text[0] == "'" and text[-1] == "'":
        return text[1:-1], "'"
    return text, ""


def update_manifest(manifest_path: Path) -> tuple[str, str]:
    lines = manifest_path.read_text(encoding="utf-8").splitlines()
    old = None
    new_lines = []
    for line in lines:
        if line.startswith("version = "):
            raw = line.split("=", 1)[1].strip()
            old, quote = _unquote(raw)
            new = bump_patch(old)
            if quote:
                new_lines.append(f"version = {quote}{new}{quote}")
            else:
                new_lines.append(f"version = {new}")
        else:
            new_lines.append(line)

    if old is None:
        raise ValueError("manifest version field not found")

    manifest_path.write_text("\n".join(new_lines) + "\n", encoding="utf-8")
    return old, bump_patch(old)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Bump patch version in manifest.ini")
    parser.add_argument("--manifest", required=True, help="Path to manifest.ini")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    manifest_path = Path(args.manifest)
    if not manifest_path.exists():
        print(f"FAIL: manifest not found: {manifest_path}")
        return 2

    old, new = update_manifest(manifest_path)
    print("PASS: release prep")
    print(f"old_version={old}")
    print(f"new_version={new}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
