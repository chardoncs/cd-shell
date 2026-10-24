import QtQuick
import Quickshell.Bluetooth

import qs.modules.components
import qs.modules.windows

// Shows up only when an adapter exists, opening the bluetooth window when
// clicked.
Loader {
    id: root

    active: Bluetooth.adapters.values.length > 0

    sourceComponent: Component {
        Rectangle {
            id: bluetoothItem

            readonly property var adapter: Bluetooth.defaultAdapter
            readonly property bool anyConnected: {
                const devices = Bluetooth.devices.values;

                for (var i = 0; i < devices.length; i++) {
                    if (devices[i].connected) {
                        return true;
                    }
                }

                return false;
            }

            implicitWidth: icon.implicitWidth + 8
            implicitHeight: 20
            radius: 6
            color: hover.containsMouse ? "#1affffff" : "transparent"

            Icon {
                id: icon
                anchors.centerIn: parent

                text: {
                    if (bluetoothItem.adapter === null || !bluetoothItem.adapter.enabled) {
                        return "󰂲";
                    }
                    if (bluetoothItem.anyConnected) {
                        return "󰂱";
                    }
                    return "󰂯";
                }
                color: bluetoothItem.adapter !== null && bluetoothItem.adapter.enabled ? "white" : "#99ffffff"
            }

            MouseArea {
                id: hover
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: popup.visible = !popup.visible
            }

            BluetoothWindow {
                id: popup
                anchorItem: bluetoothItem
            }
        }
    }
}
