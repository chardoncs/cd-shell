import QtQuick
import qs.services

Text {
    text: "󰣇"
    color: "white"
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
