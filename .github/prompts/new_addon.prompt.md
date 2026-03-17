# Prompt: New NVDA Addon

Goal: scaffold a new NVDA addon from templates with minimal manual edits.

NVDA note:
- For NVDA-specific generation, prefer `.github/prompts/nvda_new_addon.prompt.md`.
- Always consult `.github/skills/nvda_addon_development.skill.md` before code generation.

Input:
- addon_id
- addon_name
- author
- version
- description
- output_dir

Optional:
- addon_type (global|app)
- target_app (required when addon_type=app)
- nvda_version_range

Expected output:
- Generated addon folder
- Manifest populated
- Global plugin created
- Next steps checklist
