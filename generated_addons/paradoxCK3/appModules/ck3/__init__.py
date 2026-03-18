# -*- coding: UTF-8 -*-
"""App module template for ck3."""

import appModuleHandler
import config
from logHandler import log
from scriptHandler import script
import ui

from appModules.paradox_ck3 import config as ck3Config
from appModules.paradox_ck3.help_text import QUICK_HELP, formatStatusMessage


class AppModule(appModuleHandler.AppModule):
    """Example app module with init hook and overlay selection."""

    scriptCategory = "Paradox CK3"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        ck3Config.ensureConfigSpec()
        self._settings = ck3Config.getSection()
        log.debug("paradoxCK3: baseline app module loaded")

    def _getBoolSetting(self, key, default):
        value = self._settings.get(key, default)
        if isinstance(value, str):
            return value.strip().lower() in ("1", "true", "yes", "on")
        return bool(value)

    def _saveSettings(self):
        try:
            config.conf.save()
        except Exception:
            log.warning("paradoxCK3: unable to persist settings", exc_info=True)

    def event_NVDAObject_init(self, obj):
        # Override object properties here when needed.
        return

    def chooseNVDAObjectOverlayClasses(self, obj, clsList):
        # Insert overlay classes conditionally, usually at index 0.
        return

    def terminate(self):
        # Release resources (timers, caches, handles) when NVDA unloads this module.
        log.debug("paradoxCK3: app module terminated")
        super().terminate()

    @script(gesture="kb:NVDA+shift+e", description="Toggle Paradox CK3 addon enabled state")
    def script_toggleEnabled(self, gesture):
        enabled = self._getBoolSetting("enabled", True)
        self._settings["enabled"] = (not enabled)
        self._saveSettings()
        ui.message("Paradox CK3 attivato" if self._settings["enabled"] else "Paradox CK3 disattivato")

    @script(gesture="kb:NVDA+shift+s", description="Report Paradox CK3 addon status")
    def script_reportStatus(self, gesture):
        ui.message(formatStatusMessage(self._settings))

    @script(gesture="kb:NVDA+shift+h", description="Paradox CK3 quick help")
    def script_quickHelp(self, gesture):
        ui.message(QUICK_HELP)
