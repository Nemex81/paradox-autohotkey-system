# -*- coding: UTF-8 -*-
"""App module template for ck3."""

import appModuleHandler
from logHandler import log
from scriptHandler import script
import ui

from appModules.paradox_ck3 import config as ck3Config
from appModules.paradox_ck3.help_text import QUICK_HELP


class AppModule(appModuleHandler.AppModule):
    """Example app module with init hook and overlay selection."""

    scriptCategory = "Paradox CK3"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        ck3Config.ensureConfigSpec()
        self._settings = ck3Config.getSection()
        log.debug("paradoxCK3: baseline app module loaded")

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

    @script(gesture="kb:NVDA+shift+h", description="Announce addon status")
    def script_announceHello(self, gesture):
        ui.message(QUICK_HELP)
