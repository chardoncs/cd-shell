import QtQuick
import QtQuick.Layouts
import Quickshell.Networking

import qs.modules.components
import qs.utils

Popup {
    id: root

    property var pendingNetwork: null
    property string psk: ""

    readonly property var wifiDevice: {
        const devices = Networking.devices.values;

        for (var i = 0; i < devices.length; i++) {
            if (devices[i].type === DeviceType.Wifi) {
                return devices[i];
            }
        }

        return null;
    }

    readonly property var wiredDevices: {
        const devices = Networking.devices.values;
        const wired = [];

        for (var i = 0; i < devices.length; i++) {
            if (devices[i].type === DeviceType.Wired) {
                wired.push(devices[i]);
            }
        }

        return wired;
    }

    readonly property var wifiNetworks: {
        const networks = [];

        if (root.wifiDevice !== null) {
            const available = root.wifiDevice.networks.values;

            for (var i = 0; i < available.length; i++) {
                if (available[i].name !== "") {
                    networks.push(available[i]);
                }
            }

            // Connected network first, everything else in scan order.
            networks.sort((a, b) => (b.connected ? 1 : 0) - (a.connected ? 1 : 0));
        }

        return networks;
    }

    function signalGlyph(strength) {
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

    function stateText(network) {
        switch (network.state) {
        case ConnectionState.Connecting:
            return "Connecting…";
        case ConnectionState.Disconnecting:
            return "Disconnecting…";
        case ConnectionState.Connected:
            return "Connected";
        }

        if (network.connected) {
            return "Connected";
        }

        return Percentage.toPercentage(network.signalStrength);
    }

    function requestConnect(network) {
        if (!network) {
            return;
        }

        if (network.state === ConnectionState.Connecting || network.state === ConnectionState.Disconnecting) {
            return;
        }

        if (network.connected) {
            network.disconnect();
            return;
        }

        // Known networks and open networks connect without a password.
        if (network.known || network.security === WifiSecurityType.Open) {
            network.connect();
            return;
        }

        root.pendingNetwork = network;
        root.psk = "";
    }

    function submitPsk() {
        if (root.pendingNetwork === null) {
            return;
        }

        root.pendingNetwork.connectWithPsk(root.psk);
        root.cancelPsk();
    }

    function cancelPsk() {
        root.pendingNetwork = null;
        root.psk = "";
    }

    onVisibleChanged: {
        if (!root.visible) {
            root.cancelPsk();
        }
    }

    Text {
        width: parent.width
        text: "Network"
        color: "white"
        font.pixelSize: 14
        font.bold: true
    }

    RowLayout {
        visible: root.wifiDevice !== null
        width: parent.width
        spacing: 8

        Icon {
            text: Networking.wifiEnabled ? "󰖩" : "󰖪"
            color: Networking.wifiEnabled ? "#b3ffffff" : "#66ffffff"
        }

        Text {
            text: "Wi-Fi"
            color: "white"
            font.pixelSize: 13
        }

        Item {
            Layout.fillWidth: true
        }

        Switch {
            checked: Networking.wifiEnabled
            enabled: Networking.wifiHardwareEnabled
            onToggled: (checked) => Networking.wifiEnabled = checked
        }
    }

    Text {
        visible: root.wifiDevice === null
        width: parent.width
        text: "No Wi-Fi device found"
        color: "#99ffffff"
        font.pixelSize: 11
    }

    Text {
        visible: root.wifiDevice !== null && !Networking.wifiEnabled
        width: parent.width
        text: "Wi-Fi is turned off"
        color: "#99ffffff"
        font.pixelSize: 11
    }

    ListView {
        id: wifiList

        visible: root.wifiDevice !== null && Networking.wifiEnabled && count > 0
        width: parent.width
        height: Math.min(contentHeight, 320)
        clip: true
        spacing: 2
        model: root.wifiNetworks

        delegate: Rectangle {
            id: netRow

            required property var modelData

            width: ListView.view ? ListView.view.width : 0
            implicitHeight: 36
            radius: 8
            color: netMouse.containsMouse ? "#1affffff" : (netRow.modelData.connected ? "#26ac1756b5" : "transparent")

            RowLayout {
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: 8
                    rightMargin: 8
                }
                spacing: 8

                Icon {
                    text: root.signalGlyph(netRow.modelData.signalStrength)
                    color: netRow.modelData.connected ? "white" : "#b3ffffff"
                }

                Text {
                    Layout.fillWidth: true
                    text: netRow.modelData.name
                    color: "white"
                    font.pixelSize: 13
                    elide: Text.ElideRight
                }

                Icon {
                    visible: netRow.modelData.security !== WifiSecurityType.Open && netRow.modelData.security !== WifiSecurityType.Unknown
                    text: "󰌾"
                    color: "#99ffffff"
                    font.pixelSize: 11
                }

                Text {
                    text: root.stateText(netRow.modelData)
                    color: "#99ffffff"
                    font.pixelSize: 11
                }
            }

            MouseArea {
                id: netMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.requestConnect(netRow.modelData)
            }
        }
    }

    Text {
        visible: root.wifiDevice !== null && Networking.wifiEnabled && root.wifiNetworks.length === 0
        width: parent.width
        text: "No networks found"
        color: "#99ffffff"
        font.pixelSize: 11
    }

    Rectangle {
        visible: root.pendingNetwork !== null
        width: parent.width
        implicitHeight: pskColumn.implicitHeight + 16
        radius: 8
        color: "#1affffff"

        Column {
            id: pskColumn

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 8
            }
            spacing: 6

            Text {
                width: parent.width
                text: root.pendingNetwork !== null ? `Password for ${root.pendingNetwork.name}` : ""
                color: "#b3ffffff"
                font.pixelSize: 11
                elide: Text.ElideRight
            }

            Rectangle {
                width: parent.width
                height: 28
                radius: 6
                color: "#33000000"
                border.width: 1
                border.color: pskInput.activeFocus ? "#ac1756b5" : "#26ffffff"

                TextInput {
                    id: pskInput

                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        leftMargin: 8
                        rightMargin: 8
                    }
                    focus: root.pendingNetwork !== null
                    echoMode: TextInput.Password
                    color: "white"
                    font.pixelSize: 13
                    selectByMouse: true

                    onAccepted: root.submitPsk()
                    Keys.onEscapePressed: root.cancelPsk()
                }
            }

            RowLayout {
                width: parent.width
                spacing: 6

                Item {
                    Layout.fillWidth: true
                }

                TextButton {
                    text: "Cancel"
                    onClicked: root.cancelPsk()
                }

                TextButton {
                    text: "Connect"
                    primary: true
                    onClicked: root.submitPsk()
                }
            }
        }
    }

    Rectangle {
        visible: root.wiredDevices.length > 0
        width: parent.width
        height: 1
        color: "#1affffff"
    }

    Repeater {
        model: root.wiredDevices

        delegate: RowLayout {
            required property var modelData

            width: parent.width
            spacing: 8

            Icon {
                text: "󰈀"
                color: modelData.connected ? "#b3ffffff" : "#66ffffff"
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                Text {
                    text: modelData.name
                    color: "white"
                    font.pixelSize: 13
                }

                Text {
                    Layout.fillWidth: true
                    text: modelData.address !== "" ? modelData.address : "No address"
                    color: "#99ffffff"
                    font.pixelSize: 11
                    elide: Text.ElideRight
                }
            }

            Text {
                text: modelData.hasLink ? `${modelData.linkSpeed} Mb/s` : "Disconnected"
                color: modelData.hasLink ? "#b3ffffff" : "#99ffffff"
                font.pixelSize: 11
            }
        }
    }
}
