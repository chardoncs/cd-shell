import QtQuick
import Quickshell.Services.UPower
import qs.modules.components
import qs.utils

Loader {
    active: UPower.displayDevice.isLaptopBattery && UPower.displayDevice.ready && UPower.displayDevice.isPresent
    sourceComponent: Component {
        Row {
            Icon {
                text: {
                    switch (UPower.displayDevice.state) {
                    case UPowerDeviceState.Charging:
                        return getChargingIcon(UPower.displayDevice.percentage);
                    case UPowerDeviceState.FullyCharged:
                        return "󱐥";
                    case UPowerDeviceState.Discharging:
                        return getDischargingIcon(UPower.displayDevice.percentage);
                    case UPowerDeviceState.Empty:
                        return "󱉞";
                    default:
                        return "󰂑";
                    }
                }

                function getChargingIcon(percentage) {
                    if (percentage >= 0.95) {
                        return "󰂅";
                    }
                    if (percentage >= 0.9) {
                        return "󰂋";
                    }
                    if (percentage >= 0.8) {
                        return "󰂊";
                    }
                    if (percentage >= 0.7) {
                        return "󰢞";
                    }
                    if (percentage >= 0.6) {
                        return "󰂉";
                    }
                    if (percentage >= 0.5) {
                        return "󰢝";
                    }
                    if (percentage >= 0.4) {
                        return "󰂈";
                    }
                    if (percentage >= 0.3) {
                        return "󰂇";
                    }
                    if (percentage >= 0.2) {
                        return "󰂆";
                    }
                    if (percentage >= 0.1) {
                        return "󰢜";
                    }
                    return "󰢟";
                }

                function getDischargingIcon(percentage) {
                    if (percentage >= 0.95) {
                        return "󰁹";
                    }
                    if (percentage >= 0.9) {
                        return "󰂂";
                    }
                    if (percentage >= 0.8) {
                        return "󰂁";
                    }
                    if (percentage >= 0.7) {
                        return "󰂀";
                    }
                    if (percentage >= 0.6) {
                        return "󰁿";
                    }
                    if (percentage >= 0.5) {
                        return "󰁾";
                    }
                    if (percentage >= 0.4) {
                        return "󰁽";
                    }
                    if (percentage >= 0.3) {
                        return "󰁼";
                    }
                    if (percentage >= 0.2) {
                        return "󰁻";
                    }
                    if (percentage >= 0.1) {
                        return "󰁺";
                    }
                    return "󰂎";
                }
            }

            Text {
                text: Percentage.toPercentage(UPower.displayDevice.percentage)
                color: "white"
            }
        }
    }
}
