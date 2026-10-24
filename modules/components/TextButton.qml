import QtQuick

Rectangle {
    id: root

    property string text: ""
    property bool primary: false
    property color accentColor: "#ac1756b5"

    signal clicked()

    implicitWidth: label.implicitWidth + 20
    implicitHeight: 24
    radius: 6
    color: {
        if (root.primary) {
            return area.containsMouse ? Qt.lighter(root.accentColor, 1.25) : root.accentColor;
        }
        return area.containsMouse ? "#33ffffff" : "#1affffff";
    }
    opacity: enabled ? 1 : 0.4

    Text {
        id: label
        anchors.centerIn: parent

        text: root.text
        color: "white"
        font.pixelSize: 11
    }

    MouseArea {
        id: area
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
