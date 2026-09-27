import QtQuick
import qs.services
import qs.modules.components

Icon {
    text: "󰣇"
    leftPadding: 10
    rightPadding: 4

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                Niri.toggleOverview()
            }
        }
    }
}
