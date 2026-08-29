# -*- coding: UTF-8 -*-
"""Overlay class template for ck3."""

from NVDAObjects.IAccessible import IAccessible
from scriptHandler import script
import ui


class ck3Overlay(IAccessible):
    """Example overlay class for custom control behavior."""

    @script(gesture="kb:NVDA+shift+o", description="Overlay test script")
    def script_overlayAnnounce(self, gesture):
        ui.message("Overlay active")
