# -*- coding: UTF-8 -*-

addon_info = {
    "addon_name": "helloNVDA",
    "addon_summary": "helloNVDA",
    "addon_description": "helloNVDA pilot addon",
    "addon_version": "1.0.0",
    "addon_author": "Nemex81",
    "addon_url": "https://example.invalid/helloNVDA",
    "addon_docFileName": "readme.html",
    "addon_minimumNVDAVersion": (2023, 1, 0),
    "addon_lastTestedNVDAVersion": (2025, 1, 0),
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
