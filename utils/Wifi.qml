pragma Singleton

import QtQuick
import Quickshell

Singleton {
    // Maps a network's signal strength (0..1) to the matching Nerd Font glyph.
    function signalGlyph(strength: double): string {
        if (strength >= 0.75) {
            return "󰤨";
        }
        if (strength >= 0.5) {
            return "󰤥";
        }
        if (strength >= 0.25) {
            return "󰤢";
        }
        if (strength > 0) {
            return "󰤟";
        }
        return "󰤯";
    }
}
