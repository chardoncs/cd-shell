import QtQuick
import Quickshell

Scope {
    id: root

    property var delay: 500
    required property var anchorItem
    property var text: ""

    function open() {
        timer.start();
    }

    function close() {
        timer.stop();
        tooltipWindow.visible = false;
    }

    Timer {
        id: timer
        interval: root.delay
        onTriggered: tooltipWindow.visible = true
    }

    PopupWindow {
        id: tooltipWindow
        color: "#1a1a1a"

        anchor {
            item: root.anchorItem
            rect {
                x: tooltipWindow.width
                y: tooltipWindow.height
            }
        }
        implicitWidth: tooltipText.width + 20
        implicitHeight: 24

        Text {
            id: tooltipText
            anchors.centerIn: parent

            text: root.text
            color: "white"
        }
    }
}
