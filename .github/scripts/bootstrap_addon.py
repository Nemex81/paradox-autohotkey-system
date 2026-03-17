#!/usr/bin/env python3
"""Scaffold an NVDA addon from local templates."""

from __future__ import annotations

import argparse
from pathlib import Path

TOKENS = {
    "__ADDON_ID__": "addon_id",
    "__ADDON_NAME__": "addon_name",
    "__AUTHOR__": "author",
    "__VERSION__": "version",
    "__ADDON_DESCRIPTION__": "description",
    "__APP_NAME__": "app_name",
}


def _replace_tokens(content: str, values: dict[str, str]) -> str:
    result = content
    for token, key in TOKENS.items():
        result = result.replace(token, values[key])
    return result


def generate_addon(
    templates_root: Path,
    output_root: Path,
    addon_id: str,
    addon_name: str,
    addon_type: str,
    app_name: str,
    author: str,
    version: str,
    description: str,
) -> Path:
    values = {
        "addon_id": addon_id,
        "addon_name": addon_name,
        "app_name": app_name,
        "author": author,
        "version": version,
        "description": description,
    }

    source = templates_root / "addon_base"
    if not source.exists():
        raise FileNotFoundError(f"Missing template path: {source}")

    addon_dir = output_root / addon_id
    if addon_dir.exists():
        raise FileExistsError(f"Output already exists: {addon_dir}")

    for path in source.rglob("*"):
        relative = path.relative_to(source)
        if relative.parts and relative.parts[0] == "globalPlugins" and addon_type == "app":
            continue
        if relative.parts and relative.parts[0] == "appModules" and addon_type == "global":
            continue

        rel_str = _replace_tokens(str(relative).replace("\\", "/"), values)
        target = addon_dir / Path(rel_str)

        if path.is_dir():
            target.mkdir(parents=True, exist_ok=True)
            continue

        target.parent.mkdir(parents=True, exist_ok=True)
        if path.suffix == ".template":
            out_name = target.with_suffix("")
        else:
            out_name = target

        raw = path.read_text(encoding="utf-8")
        rendered = _replace_tokens(raw, values)
        out_name.write_text(rendered, encoding="utf-8")

    return addon_dir


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate NVDA addon scaffold")
    parser.add_argument("--addon-id", required=True)
    parser.add_argument("--addon-name", "--name", dest="addon_name", required=True)
    parser.add_argument(
        "--addon-type",
        "--type",
        dest="addon_type",
        choices=("global", "app"),
        default="global",
    )
    parser.add_argument("--app-name", default="sampleApp")
    parser.add_argument("--author", required=True)
    parser.add_argument("--version", default="0.1.0")
    parser.add_argument("--description", default="NVDA addon")
    parser.add_argument("--output-dir", default="generated_addons")
    parser.add_argument("--templates-dir", default=".github/templates")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if args.addon_type == "app" and not args.app_name.strip():
        raise ValueError("--app-name is required when --addon-type app")

    templates_root = Path(args.templates_dir)
    output_root = Path(args.output_dir)
    output_root.mkdir(parents=True, exist_ok=True)

    addon_dir = generate_addon(
        templates_root=templates_root,
        output_root=output_root,
        addon_id=args.addon_id,
        addon_name=args.addon_name,
        addon_type=args.addon_type,
        app_name=args.app_name,
        author=args.author,
        version=args.version,
        description=args.description,
    )

    print("PASS: scaffold created")
    print(f"addon_dir={addon_dir}")
    print(f"addon_type={args.addon_type}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
