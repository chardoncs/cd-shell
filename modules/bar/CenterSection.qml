import QtQuick
import QtQuick.Layouts

Rectangle {
    color: "transparent"

    Layout.preferredWidth: 120

    RowLayout {
        anchors.centerIn: parent

        Clock {
            color: "white"
        }
    }
}
