import QtQuick
import Quickshell
import Quickshell.Services.UPower
import qs.services

Rectangle {
    visible: PowerProfileService.isAvailable

    implicitWidth: 20
    implicitHeight: 20
    color: {
        switch (PowerProfileService.profile) {
        case "balanced":
            return "#ac1756b5";
        case "performance":
            return "#acb51726";
        case "power-saver":
            return "#ac17b526";
        default:
            return "transparent";
        }
    }
    radius: 10

    Text {
        text: {
            switch (PowerProfileService.profile) {
            case "balanced":
                return "";
            case "performance":
                return "";
            case "power-saver":
                return "";
            default:
                return "";
            }
        }
        color: "white"
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: PowerProfileService.cycleProfile()
    }
}
