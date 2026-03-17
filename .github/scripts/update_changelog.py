#!/usr/bin/env python3
"""Update changelog.md with an Unreleased entry."""

from __future__ import annotations

import argparse
from pathlib import Path

UNRELEASED_HEADER = "## [Unreleased]"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Update changelog with implementation notes")
    parser.add_argument("--changelog", default="changelog.md", help="Path to changelog file")
    parser.add_argument("--title", required=True, help="Implementation title")
    parser.add_argument("--category", default="Changed", choices=["Added", "Changed", "Fixed", "Docs"])
    parser.add_argument("--details", action="append", default=[], help="Bullet detail (repeatable)")
    return parser.parse_args()


def ensure_unreleased(lines: list[str]) -> list[str]:
    if any(line.strip() == UNRELEASED_HEADER for line in lines):
        return lines

    if not lines:
        return ["# Changelog", "", UNRELEASED_HEADER, ""]

    if lines[0].strip() != "# Changelog":
        lines.insert(0, "# Changelog")
        lines.insert(1, "")

    insert_at = 2 if len(lines) >= 2 else len(lines)
    lines[insert_at:insert_at] = [UNRELEASED_HEADER, ""]
    return lines


def add_category_entry(lines: list[str], category: str, bullet_lines: list[str]) -> list[str]:
    category_header = f"### {category}"
    try:
        unreleased_index = lines.index(UNRELEASED_HEADER)
    except ValueError as exc:
        raise RuntimeError("Unreleased section missing") from exc

    next_section_index = len(lines)
    for i in range(unreleased_index + 1, len(lines)):
        if lines[i].startswith("## "):
            next_section_index = i
            break

    category_index = None
    for i in range(unreleased_index + 1, next_section_index):
        if lines[i].strip() == category_header:
            category_index = i
            break

    if category_index is None:
        insertion = [category_header, ""] + bullet_lines + [""]
        lines[next_section_index:next_section_index] = insertion
        return lines

    if category_index + 1 >= len(lines) or lines[category_index + 1].strip() != "":
        lines.insert(category_index + 1, "")
        next_section_index += 1

    insert_pos = category_index + 2
    while insert_pos < next_section_index and (lines[insert_pos].startswith("- ") or lines[insert_pos].strip() == ""):
        insert_pos += 1

    for bullet in bullet_lines:
        if bullet not in lines[category_index:insert_pos]:
            lines.insert(insert_pos, bullet)
            insert_pos += 1
    return lines


def main() -> int:
    args = parse_args()
    root = Path(__file__).resolve().parents[2]
    changelog_path = root / args.changelog

    if changelog_path.exists():
        lines = changelog_path.read_text(encoding="utf-8").splitlines()
    else:
        lines = ["# Changelog", ""]

    lines = ensure_unreleased(lines)

    detail_items = args.details if args.details else [args.title]
    bullets = [f"- {item}" for item in detail_items]

    lines = add_category_entry(lines, args.category, bullets)
    # Normalize accidental triple blank lines from previous manual edits.
    normalized: list[str] = []
    for line in lines:
        if line == "" and len(normalized) >= 2 and normalized[-1] == "" and normalized[-2] == "":
            continue
        normalized.append(line)

    changelog_path.write_text("\n".join(normalized).rstrip() + "\n", encoding="utf-8")

    print("PASS: changelog updated")
    print(f"changelog={changelog_path}")
    print(f"category={args.category}")
    print(f"items={len(bullets)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
