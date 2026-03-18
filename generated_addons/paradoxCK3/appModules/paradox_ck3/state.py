# -*- coding: UTF-8 -*-
"""In-memory runtime state for CK3 app module."""

from dataclasses import dataclass


@dataclass
class RuntimeState:
    enabled: bool = True
    beeps: bool = True
    speech: bool = True
    debug: bool = False
    intenseMode: bool = False
