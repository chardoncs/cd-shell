pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Networking

import qs.utils

// Reports network and bluetooth connections and disconnections as toasts.
// Instanced once from shell.qml so changes are reported even when no bar
// window is open.
Singleton {
    id: root

    // True once the initial state has been captured. The backends fill their
    // device lists asynchronously, so anything seen during startup is part of
    // the current state rather than a connection the user just made.
    property bool ready: false

    property string lastWifiNetwork: ""
    property string lastWiredDevice: ""
    property var lastBluetoothDevices: []

    readonly property var wifiNetwork: {
        const devices = Networking.devices.values;

        for (var i = 0; i < devices.length; i++) {
            const device = devices[i];

            if (device.type !== DeviceType.Wifi) {
                continue;
            }

            const networks = device.networks.values;

            for (var j = 0; j < networks.length; j++) {
                if (networks[j].connected) {
                    return networks[j];
                }
            }
        }

        return null;
    }

    readonly property var wiredDevice: {
        const devices = Networking.devices.values;

        for (var i = 0; i < devices.length; i++) {
            if (devices[i].type === DeviceType.Wired && devices[i].connected) {
                return devices[i];
            }
        }

        return null;
    }

    readonly property var connectedBluetoothDevices: {
        const devices = Bluetooth.devices.values;
        const connected = [];

        for (var i = 0; i < devices.length; i++) {
            if (devices[i].connected) {
                connected.push(devices[i]);
            }
        }

        return connected;
    }

    Timer {
        interval: 4000
        running: true

        onTriggered: {
            root.lastWifiNetwork = root.wifiNetwork !== null ? root.wifiNetwork.name : "";
            root.lastWiredDevice = root.wiredDevice !== null ? root.wiredDevice.name : "";
            root.lastBluetoothDevices = root.connectedBluetoothDevices.map(device => device.name);
            root.ready = true;
        }
    }

    onWifiNetworkChanged: {
        const network = root.wifiNetwork;
        const name = network !== null ? network.name : "";
        const previous = root.lastWifiNetwork;

        root.lastWifiNetwork = name;

        if (!root.ready || previous === name) {
            return;
        }

        if (previous !== "") {
            root.report("Network", `Disconnected from ${previous}`, "", "󰤯");
        }

        if (name !== "") {
            root.report("Network", `Connected to ${name}`,
                `Wi-Fi, ${Percentage.toPercentage(network.signalStrength)}`,
                Wifi.signalGlyph(network.signalStrength));
        }
    }

    onWiredDeviceChanged: {
        const device = root.wiredDevice;
        const name = device !== null ? device.name : "";
        const previous = root.lastWiredDevice;

        root.lastWiredDevice = name;

        if (!root.ready || previous === name) {
            return;
        }

        if (previous !== "") {
            root.report("Network", `Disconnected from ${previous}`, "", "󰈀");
        }

        if (name !== "") {
            root.report("Network", `Connected to ${name}`,
                device.linkSpeed > 0 ? `Ethernet, ${device.linkSpeed} Mb/s` : "Ethernet",
                "󰈀");
        }
    }

    onConnectedBluetoothDevicesChanged: {
        const devices = root.connectedBluetoothDevices;
        const names = devices.map(device => device.name);
        const previous = root.lastBluetoothDevices;

        root.lastBluetoothDevices = names;

        if (!root.ready) {
            return;
        }

        for (var i = 0; i < devices.length; i++) {
            const device = devices[i];

            if (previous.indexOf(device.name) !== -1) {
                continue;
            }

            // The friendly name is worth showing when it differs from the
            // advertised one.
            const body = device.deviceName !== "" && device.deviceName !== device.name ? device.deviceName : "";
            root.report("Bluetooth", `Connected to ${device.name}`, body, "󰂱");
        }

        for (var j = 0; j < previous.length; j++) {
            if (names.indexOf(previous[j]) === -1) {
                root.report("Bluetooth", `Disconnected from ${previous[j]}`, "", "󰂲");
            }
        }
    }

    function report(appName: string, summary: string, body: string, glyph: string): void {
        Notifications.notify({
            appName: appName,
            summary: summary,
            body: body,
            glyph: glyph,
        });
    }
}
