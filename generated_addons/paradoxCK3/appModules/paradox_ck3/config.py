# -*- coding: UTF-8 -*-
"""Configuration helpers for Paradox CK3 addon runtime."""

import config

SECTION_NAME = "paradoxCK3"
CONFIG_SPEC = {
    "enabled": "boolean(default=true)",
    "beeps": "boolean(default=true)",
    "speech": "boolean(default=true)",
    "debug": "boolean(default=false)",
    "intenseMode": "boolean(default=false)",
    "ocrDelayMs": "integer(default=180,min=0,max=2000)",
}


def ensureConfigSpec():
    """Register custom config spec before any section access."""
    if SECTION_NAME not in config.conf.spec:
        config.conf.spec[SECTION_NAME] = CONFIG_SPEC


def getSection():
    """Get live config section for the addon, creating schema on demand."""
    ensureConfigSpec()
    return config.conf[SECTION_NAME]
