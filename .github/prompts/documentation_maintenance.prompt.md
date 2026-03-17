# Prompt: Documentation And Changelog Maintenance

Goal: update docs, code comments and changelog after each implementation.

Input:
- implementation summary
- affected files
- key behavior changes

Process:
1. Update impacted documentation sections.
2. Improve comments only where logic is non-trivial.
3. Append changelog entry using `.github/scripts/update_changelog.py`.
4. Validate framework gates.
