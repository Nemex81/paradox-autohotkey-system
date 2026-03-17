# -*- coding: UTF-8 -*-
"""Global plugin template for helloNVDA."""

import addonHandler
import globalPluginHandler
from scriptHandler import script
import ui

addonHandler.initTranslation()


class GlobalPlugin(globalPluginHandler.GlobalPlugin):
    scriptCategory = "helloNVDA"

    def __init__(self):
        super().__init__()

    @script(
        gesture="kb:NVDA+shift+h",
        description="Announce addon active status",
    )
    def script_announceHello(self, gesture):
        ui.message("helloNVDA active")

    def terminate(self):
        """Release resources when NVDA unloads this plugin."""
        return
