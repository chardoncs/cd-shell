import QtQuick
import QtQuick.Layouts

Rectangle {
    color: "transparent"

    RowLayout {
        anchors {
            fill: parent
            verticalCenter: parent.verticalCenter
        }
        layoutDirection: Qt.RightToLeft

        Tray {}
    }
}
