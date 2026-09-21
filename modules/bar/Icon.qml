import QtQuick

Text {
    text: "󰣇"
    color: "white"
    leftPadding: 10

    MouseArea {
        anchors.fill: parent
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                niri.toggleOverview()
            }
        }
    }
}
