import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth

import qs.modules.components
import qs.utils

Popup {
    id: root

    readonly property var adapter: Bluetooth.defaultAdapter

    readonly property var devices: {
        const available = Bluetooth.devices.values;
        const devices = [];

        for (var i = 0; i < available.length; i++) {
            const device = available[i];

            if (device.name === "" && device.deviceName === "") {
                continue;
            }

            devices.push(device);
        }

        // Connected devices first, then paired ones, then the rest.
        devices.sort((a, b) => root.deviceRank(b) - root.deviceRank(a));

        return devices;
    }

    function deviceRank(device) {
        if (device.connected) {
            return 3;
        }
        if (device.bonded || device.paired) {
            return 2;
        }
        return 1;
    }

    function deviceGlyph(device) {
        switch (device.icon) {
        case "audio-card":
        case "audio-headset":
        case "audio-headphones":
            return "󰋋";
        case "audio-speakers":
            return "󰓃";
        case "input-keyboard":
            return "󰌌";
        case "input-mouse":
            return "󰍽";
        case "input-gaming":
            return "󰊗";
        case "phone":
            return "󰄜";
        case "computer":
            return "󰌢";
        default:
            return "󰂯";
        }
    }

    function deviceStateText(device) {
        if (device.pairing) {
            return "Pairing…";
        }

        if (device.connected) {
            return "Connected";
        }

        switch (device.state) {
        case BluetoothDeviceState.Connecting:
            return "Connecting…";
        case BluetoothDeviceState.Disconnecting:
            return "Disconnecting…";
        }

        if (device.bonded || device.paired) {
            return "Paired";
        }

        return "Available";
    }

    // BlueZ reports battery as 0-100 while Quickshell normalizes it to 0-1,
    // so accept either shape.
    function batteryText(device) {
        const level = device.battery > 1 ? device.battery / 100 : device.battery;
        return Percentage.toPercentage(level);
    }

    function toggleDevice(device) {
        if (!device) {
            return;
        }

        if (device.connected) {
            device.disconnect();
            return;
        }

        if (device.pairing) {
            device.cancelPair();
            return;
        }

        if (device.bonded || device.paired) {
            device.connect();
            return;
        }

        device.pair();
    }

    onVisibleChanged: {
        // Scanning only makes sense while the window is open.
        if (!root.visible && root.adapter !== null && root.adapter.discovering) {
            root.adapter.discovering = false;
        }
    }

    Text {
        width: parent.width
        text: "Bluetooth"
        color: "white"
        font.pixelSize: 14
        font.bold: true
    }

    Text {
        visible: root.adapter === null
        width: parent.width
        text: "No Bluetooth adapter found"
        color: "#99ffffff"
        font.pixelSize: 11
    }

    RowLayout {
        visible: root.adapter !== null
        width: parent.width
        spacing: 8

        Icon {
            text: root.adapter !== null && root.adapter.enabled ? "󰂯" : "󰂲"
            color: root.adapter !== null && root.adapter.enabled ? "#b3ffffff" : "#66ffffff"
        }

        Text {
            text: "Bluetooth"
            color: "white"
            font.pixelSize: 13
        }

        Item {
            Layout.fillWidth: true
        }

        Switch {
            checked: root.adapter !== null && root.adapter.enabled
            enabled: root.adapter !== null
            onToggled: (checked) => {
                if (root.adapter !== null) {
                    root.adapter.enabled = checked;
                }
            }
        }
    }

    RowLayout {
        visible: root.adapter !== null && root.adapter.enabled
        width: parent.width
        spacing: 6

        TextButton {
            text: root.adapter !== null && root.adapter.discovering ? "Scanning…" : "Scan for devices"
            primary: root.adapter !== null && root.adapter.discovering
            onClicked: {
                if (root.adapter !== null) {
                    root.adapter.discovering = !root.adapter.discovering;
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }
    }

    ListView {
        id: deviceList

        visible: root.adapter !== null && root.adapter.enabled && count > 0
        width: parent.width
        height: Math.min(contentHeight, 320)
        clip: true
        spacing: 2
        model: root.devices

        delegate: Rectangle {
            id: deviceRow

            required property var modelData

            width: ListView.view ? ListView.view.width : 0
            implicitHeight: 40
            radius: 8
            color: deviceMouse.containsMouse ? "#1affffff" : (deviceRow.modelData.connected ? "#26ac1756b5" : "transparent")

            RowLayout {
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: 8
                    rightMargin: deviceRow.modelData.bonded ? 28 : 8
                }
                spacing: 8

                Icon {
                    text: root.deviceGlyph(deviceRow.modelData)
                    color: deviceRow.modelData.connected ? "white" : "#b3ffffff"
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Text {
                        Layout.fillWidth: true
                        text: deviceRow.modelData.name !== "" ? deviceRow.modelData.name : deviceRow.modelData.deviceName
                        color: "white"
                        font.pixelSize: 13
                        elide: Text.ElideRight
                    }

                    Text {
                        Layout.fillWidth: true
                        text: root.deviceStateText(deviceRow.modelData)
                        color: deviceRow.modelData.connected ? "#ac1756b5" : "#99ffffff"
                        font.pixelSize: 11
                        elide: Text.ElideRight
                    }
                }

                Text {
                    visible: deviceRow.modelData.batteryAvailable
                    text: root.batteryText(deviceRow.modelData)
                    color: "#99ffffff"
                    font.pixelSize: 11
                }
            }

            MouseArea {
                id: deviceMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.toggleDevice(deviceRow.modelData)
            }

            Icon {
                id: forgetIcon

                anchors {
                    right: parent.right
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                visible: deviceRow.modelData.bonded
                text: "󰅖"
                color: forgetMouse.containsMouse ? "#e05a5a" : "#66ffffff"
                font.pixelSize: 11

                MouseArea {
                    id: forgetMouse

                    anchors.fill: parent
                    anchors.margins: -6
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: deviceRow.modelData.forget()
                }
            }
        }
    }

    Text {
        visible: root.adapter !== null && root.adapter.enabled && root.devices.length === 0
        width: parent.width
        text: "No devices found"
        color: "#99ffffff"
        font.pixelSize: 11
    }
}
