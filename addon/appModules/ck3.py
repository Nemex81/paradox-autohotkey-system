# -*- coding: UTF-8 -*-
"""CK3 app-module entrypoint (flat layout) for NVDA loader compatibility."""

import appModuleHandler
import config
from logHandler import log
from scriptHandler import script
import ui

from appModules.paradox_ck3 import config as ck3Config
from appModules.paradox_ck3.help_text import QUICK_HELP, formatStatusMessage
from appModules.paradox_ck3.state import RuntimeState


class AppModule(appModuleHandler.AppModule):
    """CK3 app module baseline scripts and runtime wiring."""

    scriptCategory = "Paradox CK3"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        ck3Config.ensureConfigSpec()
        self._settings = ck3Config.getSection()
        self._state = RuntimeState.fromSettings(self._settings)
        log.debug("paradoxCK3: baseline app module loaded")

    def _saveSettings(self):
        self._state.applyToSettings(self._settings)
        try:
            config.conf.save()
        except Exception:
            log.warning("paradoxCK3: unable to persist settings", exc_info=True)

    def event_NVDAObject_init(self, obj):
        return

    def chooseNVDAObjectOverlayClasses(self, obj, clsList):
        return

    def terminate(self):
        log.debug("paradoxCK3: app module terminated")
        super().terminate()

    @script(gesture="kb:NVDA+shift+e", description="Toggle Paradox CK3 addon enabled state")
    def script_toggleEnabled(self, gesture):
        self._state.enabled = not self._state.enabled
        self._saveSettings()
        ui.message("Paradox CK3 attivato" if self._state.enabled else "Paradox CK3 disattivato")

    @script(gesture="kb:NVDA+shift+s", description="Report Paradox CK3 addon status")
    def script_reportStatus(self, gesture):
        ui.message(formatStatusMessage(self._state.toDict()))

    @script(gesture="kb:NVDA+shift+h", description="Paradox CK3 quick help")
    def script_quickHelp(self, gesture):
        ui.message(QUICK_HELP)
