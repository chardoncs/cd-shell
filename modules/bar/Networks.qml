import QtQuick
import Quickshell.Networking

import qs.modules.components
import qs.modules.windows
import qs.utils

// A single icon whose glyph follows the current connection, opening the
// network window when clicked.
Rectangle {
    id: root

    readonly property var wifiDevice: {
        const devices = Networking.devices.values;

        for (var i = 0; i < devices.length; i++) {
            if (devices[i].type === DeviceType.Wifi) {
                return devices[i];
            }
        }

        return null;
    }

    readonly property var wiredDevice: {
        const devices = Networking.devices.values;

        for (var i = 0; i < devices.length; i++) {
            if (devices[i].type === DeviceType.Wired && devices[i].hasLink) {
                return devices[i];
            }
        }

        return null;
    }

    readonly property var connectedNetwork: {
        if (root.wifiDevice === null) {
            return null;
        }

        const networks = root.wifiDevice.networks.values;

        for (var i = 0; i < networks.length; i++) {
            if (networks[i].connected) {
                return networks[i];
            }
        }

        return null;
    }

    readonly property bool connected: root.wiredDevice !== null || root.connectedNetwork !== null

    implicitWidth: icon.implicitWidth + 8
    implicitHeight: 20
    radius: 6
    color: hover.containsMouse ? "#1affffff" : "transparent"

    Icon {
        id: icon
        anchors.centerIn: parent

        text: {
            if (root.wiredDevice !== null) {
                return "󰈀";
            }
            if (root.wifiDevice === null) {
                return "󰛵";
            }
            if (!Networking.wifiEnabled || !Networking.wifiHardwareEnabled) {
                return "󰖪";
            }
            if (root.connectedNetwork === null) {
                return "󰤯";
            }
            return Wifi.signalGlyph(root.connectedNetwork.signalStrength);
        }
        color: root.connected ? "white" : "#99ffffff"
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: popup.visible = !popup.visible
    }

    NetworkWindow {
        id: popup
        anchorItem: root
    }
}
