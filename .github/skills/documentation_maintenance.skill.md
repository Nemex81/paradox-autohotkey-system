# Skill Card: Documentation Maintenance

Input:
- change summary title
- category (Added|Changed|Fixed|Docs)
- bullet details

Output:
- updated docs/comments checklist
- updated changelog entry

Commands:
- `python .github/scripts/update_changelog.py --title "<title>" --category <category> --details "<detail>"`
- `python .github/scripts/validate_framework.py`
