# -*- coding: UTF-8 -*-

addon_info = {
    "addon_name": "paradoxCK3",
    "addon_summary": "Paradox CK3",
    "addon_description": "CK3 app module baseline",
    "addon_version": "0.1.0",
    "addon_author": "Nemex81",
    "addon_url": "https://example.invalid/paradoxCK3",
    "addon_docFileName": "readme.html",
    "addon_minimumNVDAVersion": "2023.1",
    "addon_lastTestedNVDAVersion": "2025.1",
    "addon_updateChannel": None,
}

pythonSources = [
    "globalPlugins\\*.py",
    "globalPlugins\\*\\*.py",
    "appModules\\*.py",
    "appModules\\*\\*.py",
]

i18nSources = pythonSources

excludedFiles = []
