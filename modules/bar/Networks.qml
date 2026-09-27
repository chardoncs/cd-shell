import QtQuick
import Quickshell
import Quickshell.Networking
import qs.modules.components
import qs.utils

Row {
    spacing: 6

    Repeater {
        model: Networking.devices

        Row {
            id: deviceItem 
            spacing: 6
            required property NetworkDevice modelData

            Icon {
                text: {
                    switch (deviceItem.modelData.type) {
                    case DeviceType.Wifi:
                        return "";
                    case DeviceType.Wired:
                        return "󰈀";
                    default:
                        return "󰛵";
                    }
                }
            }

            Text {
                text: `${deviceItem.modelData.name}:`
                color: "white"
            }

            Repeater {
                model: deviceItem.modelData.networks

                Row {
                    id: item
                    spacing: 6
                    required property Network modelData

                    Text {
                        text: {
                            switch (item.modelData.state) {
                            case ConnectionState.Connecting:
                                return "Connecting...";
                            case ConnectionState.Disconnecting:
                                return "Disconnecting...";
                            case ConnectionState.Disconnected:
                                return "Disconnected"
                            case ConnectionState.Connected:
                                if (deviceItem.modelData.type === DeviceType.Wifi) {
                                    return Percentage.toPercentage((item.modelData as WifiNetwork).signalStrength);
                                }
                                return item.modelData.name;
                            default:
                                return "Unknown"
                            }
                        }
                        color: "white"
                    }
                }
            }
        }
    }
}
