# -*- coding: UTF-8 -*-
"""In-memory runtime state for CK3 app module."""

from dataclasses import dataclass


def _asBool(value, default):
    if value is None:
        return bool(default)
    if isinstance(value, str):
        return value.strip().lower() in ("1", "true", "yes", "on")
    return bool(value)


@dataclass
class RuntimeState:
    enabled: bool = True
    beeps: bool = True
    speech: bool = True
    debug: bool = False
    intenseMode: bool = False

    @classmethod
    def fromSettings(cls, settings):
        return cls(
            enabled=_asBool(settings.get("enabled"), True),
            beeps=_asBool(settings.get("beeps"), True),
            speech=_asBool(settings.get("speech"), True),
            debug=_asBool(settings.get("debug"), False),
            intenseMode=_asBool(settings.get("intenseMode"), False),
        )

    def applyToSettings(self, settings):
        settings["enabled"] = self.enabled
        settings["beeps"] = self.beeps
        settings["speech"] = self.speech
        settings["debug"] = self.debug
        settings["intenseMode"] = self.intenseMode

    def toDict(self):
        return {
            "enabled": self.enabled,
            "beeps": self.beeps,
            "speech": self.speech,
            "debug": self.debug,
            "intenseMode": self.intenseMode,
        }
