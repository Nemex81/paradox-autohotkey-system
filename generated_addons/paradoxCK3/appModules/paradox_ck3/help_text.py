# -*- coding: UTF-8 -*-
"""User-facing static help text for CK3 module."""

QUICK_HELP = (
	"Paradox CK3 pronto. Comandi base: "
	"NVDA+Shift+E toggle modulo, NVDA+Shift+S stato, NVDA+Shift+H aiuto rapido."
)


def _asOnOff(value):
	return "on" if bool(value) else "off"


def formatStatusMessage(settings):
	"""Build a concise state summary for voice feedback."""
	return (
		"CK3 stato: "
		f"enabled {_asOnOff(settings.get('enabled', True))}, "
		f"beeps {_asOnOff(settings.get('beeps', True))}, "
		f"speech {_asOnOff(settings.get('speech', True))}, "
		f"intense {_asOnOff(settings.get('intenseMode', False))}."
	)
