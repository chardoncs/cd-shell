pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Singleton {
    id: root
    property bool available: PowerProfiles.hasPerformanceProfile
    property string profile: {
        switch (PowerProfiles.profile) {
        case PowerProfile.PowerSaver:
            return "power-saver";
        case PowerProfiles.Balanced:
            return "balanced";
        case PowerProfiles.Performance:
            return "performance";
        }
    }

    function setProfile(profile: string) {
        proc.exec({
            command: ["powerprofilesctl", "set", profile],
        });
    }

    function cycleProfile() {
        switch (PowerProfileService.profile) {
        case "balanced":
            setProfile("performance");
            break;
        case "performance":
            setProfile("power-saver");
            break;
        default:
            setProfile("balanced");
            break;
        }
    }

    Process {
        id: proc
    }
}
